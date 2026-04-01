// File: src/main/java/my/nexgenesports/controller/programTournament/ProgramSelectTeamServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.dao.programTournament.TournamentParticipantDao;
import my.nexgenesports.dao.programTournament.TournamentParticipantDaoImpl;
import my.nexgenesports.model.TournamentParticipant;
import my.nexgenesports.model.Team;
import my.nexgenesports.model.TeamMember;
import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.service.team.TeamService;
import my.nexgenesports.service.programTournament.ProgramTournamentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/programs/selectTeam")
public class ProgramSelectTeamServlet extends HttpServlet {

    private final TeamService teamService = new TeamService();
    private final ProgramTournamentService programService = new ProgramTournamentService();
    private final TournamentParticipantDao tpDao = new TournamentParticipantDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String me = (session == null)
                ? null
                : (String) session.getAttribute("username");
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 1) Load tournament
        int progId = Integer.parseInt(req.getParameter("progId"));
        ProgramTournament prog = programService.getProgramById(progId);

        // 2) Compute quotas
        Integer min = prog.getMinTeamMember();
        Integer max = prog.getMaxTeamMember();
        int subQuota = (min != null && max != null)
                ? (max - min)
                : 0;

        // 3) Only teams this user leads
        List<Team> leadTeams = teamService.listTeamsForUser(me).stream()
                .filter(t -> teamService.listMembers(t.getTeamID()).stream()
                .anyMatch(m
                        -> m.getUserID().equals(me)
                && "Leader".equals(m.getTeamRole())
                )
                )
                .collect(Collectors.toList());

        // 4) Expose to JSP
        req.setAttribute("program", prog);
        req.setAttribute("teams", leadTeams);
        req.setAttribute("minQuota", min == null ? 0 : min);
        req.setAttribute("subQuota", subQuota);
        req.setAttribute("csrfToken", session.getAttribute("csrfToken"));

        // 5) If they've already picked a team, load its members
        String teamParam = req.getParameter("teamId");
        if (teamParam != null && !teamParam.isBlank()) {
            int teamId = Integer.parseInt(teamParam);
            List<TeamMember> members = teamService.listMembers(teamId);
            req.setAttribute("selectedTeamId", teamId);
            req.setAttribute("members", members);
        }

        // 6) Render the JSP
        req.getRequestDispatcher("/selectTeam.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String me = (session == null)
                ? null
                : (String) session.getAttribute("username");
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // CSRF (if you have it)
        if (!session.getAttribute("csrfToken")
                .equals(req.getParameter("csrfToken"))) {
            resp.sendError(403);
            return;
        }

        // 1) parse IDs
        int progId = Integer.parseInt(req.getParameter("progId"));
        int teamId = Integer.parseInt(req.getParameter("teamId"));

        // 2) load quotas
        ProgramTournament prog = programService.getProgramById(progId);
        int minMain = prog.getMinTeamMember();
        int maxTeam = prog.getMaxTeamMember();
        int subQuota = maxTeam - minMain;

        // 3) grab selections
        String[] mains = req.getParameterValues("mainPlayers");
        String[] subs = req.getParameterValues("subPlayers");

        int mainCount = (mains == null ? 0 : mains.length);
        int subCount = (subs == null ? 0 : subs.length);

        // 4) validate mains (exact match)
        if (mainCount != minMain) {
            throw new ServletException(
                    "Must select exactly " + minMain
                    + " main player" + (minMain == 1 ? "" : "s")
            );
        }
        // 5) validate subs (only an upper bound)
        if (subCount > subQuota) {
            throw new ServletException(
                    "Cannot select more than " + subQuota
                    + " sub–player" + (subQuota == 1 ? "" : "s")
            );
        }

        // 6) persist
        TournamentParticipantDao tpDao = new TournamentParticipantDaoImpl();
        LocalDateTime now = LocalDateTime.now();

        // mains
        for (String userId : mains) {
            TournamentParticipant tp = new TournamentParticipant();
            tp.setProgId(progId);
            tp.setUserId(userId);
            tp.setTeamId(teamId);
            tp.setRole("MAIN");
            tp.setStatus("PENDING");
            tp.setJoinedAt(now);
            try {
                tpDao.insert(tp);
            } catch (SQLException e) {
                throw new ServletException("Failed to register main player", e);
            }
        }

        // subs (if any)
        if (subs != null) {
            for (String userId : subs) {
                TournamentParticipant tp = new TournamentParticipant();
                tp.setProgId(progId);
                tp.setUserId(userId);
                tp.setTeamId(teamId);
                tp.setRole("SUB");
                tp.setStatus("PENDING");
                tp.setJoinedAt(now);
                try {
                    tpDao.insert(tp);
                } catch (SQLException e) {
                    throw new ServletException("Failed to register sub player", e);
                }
            }
        }

        // 7) done → preview
        resp.sendRedirect(
                req.getContextPath()
                + "/programs/" + progId + "/previewRegistration"
        );
    }

}
