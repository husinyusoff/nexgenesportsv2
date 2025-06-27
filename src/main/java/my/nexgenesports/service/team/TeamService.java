// File: src/main/java/my/nexgenesports/service/team/TeamService.java
package my.nexgenesports.service.team;

import my.nexgenesports.dao.team.*;
import my.nexgenesports.model.*;
import my.nexgenesports.service.general.ServiceException;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.stream.Collectors;

public class TeamService {

    private final TeamDao teamDao;
    private final ArchivedTeamDao archivedDao;
    private final TeamMemberDao memberDao;
    private final JoinRequestDao joinRequestDao;
    private final AuditLogDao auditDao;

    public TeamService() {
        this.teamDao = new TeamDaoImpl();
        this.archivedDao = new ArchivedTeamDaoImpl();
        this.memberDao = new TeamMemberDaoImpl();
        this.joinRequestDao = new JoinRequestDaoImpl();
        this.auditDao = new AuditLogDaoImpl();
    }

    public Team createTeam(String name,
            String description,
            String logoURL,
            String newLeader,
            int capacity) {
        if (capacity < 2) {
            throw new ServiceException("Capacity must be at least 2.");
        }
        try {
            Team t = new Team();
            t.setTeamName(name);
            t.setDescription(description);
            t.setLogoURL(logoURL);
            t.setLeader(newLeader);
            t.setCreatedAt(LocalDateTime.now());
            t.setStatus("Active");
            t.setCapacity(capacity);

            Team inserted = teamDao.insert(t);

            TeamMember leader = new TeamMember();
            leader.setTeamID(inserted.getTeamID());
            leader.setUserID(newLeader);
            leader.setStatus("Active");
            leader.setTeamRole("Leader");
            leader.setJoinedAt(LocalDateTime.now());
            leader.setRoleAssignedAt(LocalDateTime.now());
            memberDao.insert(leader);

            AuditLog log = new AuditLog();
            log.setEntityType("Team");
            log.setEntityID(String.valueOf(inserted.getTeamID()));
            log.setActionType("Created");
            log.setPerformedBy(newLeader);
            log.setTs(LocalDateTime.now());
            log.setDetails("{\"teamName\":\"" + name + "\",\"capacity\":" + capacity + "}");
            auditDao.insert(log);

            return inserted;
        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate entry")) {
                throw new ServiceException("Team name already in use.");
            }
            throw new ServiceException("Failed to create team", e);
        }
    }

    public void changeRole(int teamID,
            String targetUserID,
            String newRole,
            String performedBy) {
        try {
            List<TeamMember> active = memberDao.listByTeam(teamID).stream()
                    .filter(m -> "Active".equals(m.getStatus()))
                    .collect(Collectors.toList());

            boolean isLeader = active.stream().anyMatch(m
                    -> m.getUserID().equals(performedBy) && "Leader".equals(m.getTeamRole())
            );
            if (!isLeader) {
                throw new ServiceException("Only the Active Leader may change roles.");
            }

            if ("Co-Leader".equals(newRole)) {
                for (TeamMember m : active) {
                    if ("Co-Leader".equals(m.getTeamRole())
                            && !m.getUserID().equals(targetUserID)) {
                        memberDao.updateRole(teamID, m.getUserID(), "Member");
                        break;
                    }
                }
            }

            if ("Leader".equals(newRole)) {
                Optional<TeamMember> oldLeader = active.stream()
                        .filter(m -> "Leader".equals(m.getTeamRole()))
                        .findFirst();
                Optional<TeamMember> oldCo = active.stream()
                        .filter(m -> "Co-Leader".equals(m.getTeamRole()))
                        .findFirst();

                if (oldLeader.isPresent()
                        && !oldLeader.get().getUserID().equals(targetUserID)) {
                    memberDao.updateRole(teamID, oldLeader.get().getUserID(), "Co-Leader");
                }
                if (oldCo.isPresent()
                        && !oldCo.get().getUserID().equals(targetUserID)
                        && oldLeader.map(l -> !l.getUserID().equals(oldCo.get().getUserID()))
                                .orElse(true)) {
                    memberDao.updateRole(teamID, oldCo.get().getUserID(), "Member");
                }
            }

            memberDao.updateRole(teamID, targetUserID, newRole);

            if ("Leader".equals(newRole)) {
                teamDao.updateLeader(teamID, targetUserID);
            }

            AuditLog log = new AuditLog();
            log.setEntityType("TeamMember");
            log.setEntityID(teamID + ":" + targetUserID);
            log.setActionType("RoleChanged");
            log.setPerformedBy(performedBy);
            log.setTs(LocalDateTime.now());
            log.setDetails("{\"newRole\":\"" + newRole + "\"}");
            auditDao.insert(log);
        } catch (SQLException e) {
            throw new ServiceException("Failed to change role", e);
        }
    }

    public void submitJoinRequest(int teamID, String userID) {
        try {
            Team team = teamDao.findById(teamID);
            if (team == null || !"Active".equals(team.getStatus())) {
                throw new ServiceException("Team not found or inactive.");
            }
            int activeCount = memberDao.countActiveMembers(teamID);
            if (activeCount >= team.getCapacity()) {
                throw new ServiceException("Team is full.");
            }
            boolean already = memberDao.listByTeam(teamID).stream()
                    .anyMatch(m -> m.getUserID().equals(userID) && "Active".equals(m.getStatus()));
            if (already) {
                throw new ServiceException("You are already a member.");
            }
            JoinRequest existing = joinRequestDao.findPendingByTeamAndUser(teamID, userID);
            if (existing != null) {
                throw new ServiceException("You already have a pending request.");
            }

            JoinRequest jr = new JoinRequest();
            jr.setTeamID(teamID);
            jr.setUserID(userID);
            jr.setRequestedAt(LocalDateTime.now());
            jr.setStatus("Pending");
            joinRequestDao.insert(jr);

            AuditLog log = new AuditLog();
            log.setEntityType("JoinRequest");
            log.setEntityID(String.valueOf(jr.getRequestID()));
            log.setActionType("Submitted");
            log.setPerformedBy(userID);
            log.setTs(LocalDateTime.now());
            auditDao.insert(log);
        } catch (SQLException e) {
            throw new ServiceException("Failed to submit join request", e);
        }
    }

    public void respondToJoin(int teamID,
            int requestID,
            boolean accept,
            String performedBy) {
        try {
            List<TeamMember> officers = memberDao.listByTeam(teamID).stream()
                    .filter(m -> "Active".equals(m.getStatus()))
                    .collect(Collectors.toList());
            boolean canApprove = officers.stream().anyMatch(m
                    -> m.getUserID().equals(performedBy)
                    && (m.getTeamRole().equals("Leader") || m.getTeamRole().equals("Co-Leader"))
            );
            if (!canApprove) {
                throw new ServiceException("Only leader/co-leader can process requests.");
            }

            JoinRequest jr = joinRequestDao.findById(requestID);
            if (jr == null || jr.getTeamID() != teamID) {
                throw new ServiceException("Join request not found.");
            }
            if (!"Pending".equals(jr.getStatus())) {
                throw new ServiceException("Request already handled.");
            }

            Team team = teamDao.findById(teamID);
            int activeCount = memberDao.countActiveMembers(teamID);
            if (accept && activeCount >= team.getCapacity()) {
                throw new ServiceException("Team is at maximum capacity.");
            }

            joinRequestDao.updateStatus(requestID,
                    accept ? "Accepted" : "Rejected",
                    LocalDateTime.now());

            if (accept) {
                TeamMember m = new TeamMember();
                m.setTeamID(teamID);
                m.setUserID(jr.getUserID());
                m.setStatus("Active");
                m.setTeamRole("Member");
                m.setJoinedAt(LocalDateTime.now());
                m.setRoleAssignedAt(LocalDateTime.now());
                memberDao.insert(m);
            }

            AuditLog log = new AuditLog();
            log.setEntityType("JoinRequest");
            log.setEntityID(String.valueOf(requestID));
            log.setActionType(accept ? "Accepted" : "Rejected");
            log.setPerformedBy(performedBy);
            log.setTs(LocalDateTime.now());
            auditDao.insert(log);
        } catch (SQLException e) {
            throw new ServiceException("Failed to process join request", e);
        }
        
        System.out.println(">>> responding to join req " + requestID 
                   + " for team " + teamID 
                   + ", accept=" + accept);

    }

    public void removeMember(int teamID, String targetUserID, String performedBy) {
        try {
            List<TeamMember> actives = memberDao.listByTeam(teamID).stream()
                    .filter(m -> "Active".equals(m.getStatus()))
                    .collect(Collectors.toList());
            boolean isOfficer = actives.stream().anyMatch(m
                    -> m.getUserID().equals(performedBy)
                    && (m.getTeamRole().equals("Leader") || m.getTeamRole().equals("Co-Leader"))
            );
            if (!isOfficer) {
                throw new ServiceException("No permission to remove members.");
            }
            Optional<TeamMember> victim = actives.stream()
                    .filter(m -> m.getUserID().equals(targetUserID))
                    .findFirst();
            if (victim.isEmpty()) {
                throw new ServiceException("User is not an active member.");
            }
            if ("Leader".equals(victim.get().getTeamRole())) {
                throw new ServiceException("Cannot remove the Leader.");
            }

            memberDao.removeMember(teamID, targetUserID);

            AuditLog log = new AuditLog();
            log.setEntityType("TeamMember");
            log.setEntityID(teamID + ":" + targetUserID);
            log.setActionType("Removed");
            log.setPerformedBy(performedBy);
            log.setTs(LocalDateTime.now());
            auditDao.insert(log);
        } catch (SQLException e) {
            throw new ServiceException("Failed to remove member", e);
        }
    }

    public void setCapacity(int teamID, int capacity, String performedBy) {
        if (capacity < 2) {
            throw new ServiceException("Capacity must be at least 2.");
        }
        try {
            TeamMember me = memberDao.listByTeam(teamID).stream()
                    .filter(m -> m.getUserID().equals(performedBy) && "Active".equals(m.getStatus()))
                    .findFirst()
                    .orElseThrow(() -> new ServiceException("Not a member."));
            if (!"Leader".equals(me.getTeamRole())) {
                throw new ServiceException("Only Leader can change capacity.");
            }
            int activeCount = memberDao.countActiveMembers(teamID);
            if (capacity < activeCount) {
                throw new ServiceException("Capacity cannot be less than current members.");
            }

            teamDao.updateCapacity(teamID, capacity);

            AuditLog log = new AuditLog();
            log.setEntityType("Team");
            log.setEntityID(String.valueOf(teamID));
            log.setActionType("CapacityChanged");
            log.setPerformedBy(performedBy);
            log.setTs(LocalDateTime.now());
            log.setDetails("{\"newCapacity\":" + capacity + "}");
            auditDao.insert(log);
        } catch (SQLException e) {
            throw new ServiceException("Failed to set capacity", e);
        }
    }

    public void leaveTeam(int teamID, String userID) {
        try {
            // 1) load everybody and find “me”
            List<TeamMember> all = memberDao.listByTeam(teamID);
            TeamMember me = all.stream()
                    .filter(m -> m.getUserID().equals(userID))
                    .findFirst()
                    .orElseThrow(() -> new ServiceException("Not a member."));
            if (!"Active".equals(me.getStatus())) {
                throw new ServiceException("Cannot leave when not Active.");
            }

            // remember if I was leader
            boolean wasLeader = "Leader".equals(me.getTeamRole());

            // 2) archive me first (I get archived in whatever role I truly held)
            memberDao.archive(teamID, userID);
            // 3) remove me from the live table
            memberDao.removeMember(teamID, userID);

            // 4) if I was leader, pick a successor and promote *them* directly
            if (wasLeader) {
                // reload current active members
                List<TeamMember> remain = memberDao.listByTeam(teamID).stream()
                        .filter(m -> "Active".equals(m.getStatus()))
                        .collect(Collectors.toList());

                if (remain.isEmpty()) {
                    // nobody left → disband
                    disbandTeam(teamID, userID);
                } else {
                    // prefer an existing Co-Leader
                    Optional<TeamMember> co = remain.stream()
                            .filter(m -> "Co-Leader".equals(m.getTeamRole()))
                            .findFirst();

                    TeamMember successor = co.orElseGet(()
                            -> remain.stream()
                                    .min(Comparator.comparing(TeamMember::getJoinedAt))
                                    .get()
                    );

                    // promote them
                    memberDao.updateRole(teamID,
                            successor.getUserID(),
                            "Leader");
                    teamDao.updateLeader(teamID, successor.getUserID());

                    // audit that role change
                    AuditLog handoff = new AuditLog();
                    handoff.setEntityType("TeamMember");
                    handoff.setEntityID(teamID + ":" + successor.getUserID());
                    handoff.setActionType("RoleChanged");
                    handoff.setPerformedBy(userID);
                    handoff.setTs(LocalDateTime.now());
                    handoff.setDetails("{\"newRole\":\"Leader\"}");
                    auditDao.insert(handoff);
                }
            }

            // 5) finally, audit the leave
            AuditLog log = new AuditLog();
            log.setEntityType("TeamMember");
            log.setEntityID(teamID + ":" + userID);
            log.setActionType("LeftTeam");
            log.setPerformedBy(userID);
            log.setTs(LocalDateTime.now());
            auditDao.insert(log);

        } catch (SQLException e) {
            throw new ServiceException("Failed to leave team", e);
        }
    }

    public void disbandTeam(int teamID, String performedBy) {
        try {
            List<TeamMember> all = memberDao.listByTeam(teamID);
            boolean canDisband = all.stream().anyMatch(m
                    -> m.getUserID().equals(performedBy)
                    && "Active".equals(m.getStatus())
                    && "Leader".equals(m.getTeamRole())
            );
            if (!canDisband) {
                throw new ServiceException("Only Active Leader may disband.");
            }

            for (TeamMember m : all) {
                memberDao.archive(teamID, m.getUserID());
            }
            memberDao.removeAll(teamID);

            Team t = teamDao.findById(teamID);
            if (t == null) {
                throw new ServiceException("Team not found.");
            }
            ArchivedTeam at = new ArchivedTeam();
            at.setTeamID(t.getTeamID());
            at.setTeamName(t.getTeamName());
            at.setDescription(t.getDescription());
            at.setLogoURL(t.getLogoURL());
            at.setLeader(t.getLeader());
            at.setCreatedAt(t.getCreatedAt());
            at.setDisbandedAt(LocalDateTime.now());
            at.setStatus("Disbanded");
            at.setArchivedAt(LocalDateTime.now());
            archivedDao.insert(at);

            teamDao.delete(teamID);

            AuditLog log = new AuditLog();
            log.setEntityType("Team");
            log.setEntityID(String.valueOf(teamID));
            log.setActionType("Disbanded");
            log.setPerformedBy(performedBy);
            log.setTs(LocalDateTime.now());
            auditDao.insert(log);
        } catch (SQLException e) {
            throw new ServiceException("Failed to disband team", e);
        }
    }

    public Team getTeamById(int teamID) {
        try {
            Team t = teamDao.findById(teamID);
            if (t == null) {
                throw new ServiceException("Team not found.");
            }
            return t;
        } catch (SQLException e) {
            throw new ServiceException("Failed to load team", e);
        }
    }

    public List<TeamMember> listMembers(int teamID) {
        try {
            return memberDao.listByTeam(teamID).stream()
                    .filter(m -> "Active".equals(m.getStatus()))
                    .collect(Collectors.toList());
        } catch (SQLException e) {
            throw new ServiceException("Failed to list members", e);
        }
    }

    public List<JoinRequest> listJoinRequests(int teamID) {
        try {
            return joinRequestDao.listPendingByTeam(teamID);
        } catch (SQLException e) {
            throw new ServiceException("Failed to list join requests", e);
        }
    }

    public List<Team> listAllTeamsSorted(String sortBy, String direction) {
        try {
            List<Team> teams = teamDao.findAllActiveSorted(sortBy, direction);
            for (Team t : teams) {
                int cnt = memberDao.countActiveMembers(t.getTeamID());
                t.setActiveCount(cnt);
            }
            return teams;
        } catch (SQLException e) {
            throw new ServiceException("Failed to list teams", e);
        }
    }

    public List<Team> listTeamsForUser(String userID) {
        try {
            return teamDao.findByMember(userID);
        } catch (SQLException e) {
            throw new ServiceException("Failed to list teams", e);
        }
    }
    
     /**
     * Fetch all active teams sorted by the given column/direction, then apply a simple
     * case‐insensitive substring filter on teamName if q is nonempty.
     * @param q
     * @param sortBy
     * @param dir
     * @return 
     */
    public List<Team> searchAndSort(String q, String sortBy, String dir) {
        try {
            List<Team> teams = teamDao.findAllActiveSorted(sortBy, dir);
            // count members for each
            for (Team t : teams) {
                int cnt = memberDao.countActiveMembers(t.getTeamID());
                t.setActiveCount(cnt);
            }
            if (q != null && !q.trim().isEmpty()) {
                String lower = q.toLowerCase(Locale.ROOT);
                teams = teams.stream()
                             .filter(t -> t.getTeamName().toLowerCase(Locale.ROOT).contains(lower))
                             .collect(Collectors.toList());
            }
            return teams;
        } catch (SQLException e) {
            throw new ServiceException("Failed to list teams", e);
        }
    }
}
