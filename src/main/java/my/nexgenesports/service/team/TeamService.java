package my.nexgenesports.service.team;

import my.nexgenesports.dao.team.*;
import my.nexgenesports.model.*;
import my.nexgenesports.service.general.ServiceException;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
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
            String creatorUserID,
            int capacity) {
        if (capacity < 2) {
            throw new ServiceException("Capacity must be at least 2.");
        }
        try {
            Team t = new Team();
            t.setTeamName(name);
            t.setDescription(description);
            t.setLogoURL(logoURL);
            t.setCreatedBy(creatorUserID);
            t.setCreatedAt(LocalDateTime.now());
            t.setStatus("Active");
            t.setCapacity(capacity);

            Team inserted = teamDao.insert(t);

            TeamMember leader = new TeamMember();
            leader.setTeamID(inserted.getTeamID());
            leader.setUserID(creatorUserID);
            leader.setStatus("Active");
            leader.setTeamRole("Leader");
            leader.setJoinedAt(LocalDateTime.now());
            leader.setRoleAssignedAt(LocalDateTime.now());
            memberDao.insert(leader);

            AuditLog log = new AuditLog();
            log.setEntityType("Team");
            log.setEntityID(String.valueOf(inserted.getTeamID()));
            log.setActionType("Created");
            log.setPerformedBy(creatorUserID);
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
            // 1) Only the active Leader may change roles
            List<TeamMember> members = memberDao.listByTeam(teamID);
            boolean isLeader = members.stream().anyMatch(m
                    -> m.getUserID().equals(performedBy)
                    && m.getStatus().equals("Active")
                    && m.getTeamRole().equals("Leader")
            );
            if (!isLeader) {
                throw new ServiceException("Only the Active Leader may change roles.");
            }

            // 2) Enforce at most one Co-Leader
            if ("Co-Leader".equals(newRole)) {
                int coCount = memberDao.countActiveRole(teamID, "Co-Leader");
                boolean alreadyCo = members.stream().anyMatch(m
                        -> m.getUserID().equals(targetUserID)
                        && "Co-Leader".equals(m.getTeamRole())
                );
                if (coCount >= 1 && !alreadyCo) {
                    throw new ServiceException("There is already an Active Co-Leader.");
                }
            }

            // 3) If promoting to Leader, demote the old one
            if ("Leader".equals(newRole)) {
                for (TeamMember m : members) {
                    if ("Leader".equals(m.getTeamRole()) && "Active".equals(m.getStatus())) {
                        memberDao.updateRole(teamID, m.getUserID(), "Member");
                        break;
                    }
                }
            }

            // 4) Apply the requested change
            memberDao.updateRole(teamID, targetUserID, newRole);

            // 5) Audit the change
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
            if (!jr.getStatus().equals("Pending")) {
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
                    .filter(m -> m.getUserID().equals(targetUserID)).findFirst();
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
                    .findFirst().orElseThrow(() -> new ServiceException("Not a member."));
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
            List<TeamMember> members = memberDao.listByTeam(teamID);
            TeamMember me = members.stream()
                    .filter(m -> m.getUserID().equals(userID))
                    .findFirst().orElseThrow(() -> new ServiceException("Not a member."));
            if ("Leader".equals(me.getTeamRole()) && "Active".equals(me.getStatus())) {
                throw new ServiceException("Leader must transfer leadership before leaving.");
            }

            memberDao.updateStatus(teamID, userID, "Declined");

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
            List<TeamMember> members = memberDao.listByTeam(teamID);
            boolean isLeader = members.stream().anyMatch(m
                    -> m.getUserID().equals(performedBy)
                    && "Active".equals(m.getStatus())
                    && "Leader".equals(m.getTeamRole())
            );
            if (!isLeader) {
                throw new ServiceException("Only Leader may disband the team.");
            }

            Team t = teamDao.findById(teamID);
            if (t == null) {
                throw new ServiceException("Team not found.");
            }

            ArchivedTeam at = new ArchivedTeam();
            at.setTeamID(t.getTeamID());
            at.setTeamName(t.getTeamName());
            at.setDescription(t.getDescription());
            at.setLogoURL(t.getLogoURL());
            at.setCreatedBy(t.getCreatedBy());
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
            // for each team, count its active members and set it on the model
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
}
