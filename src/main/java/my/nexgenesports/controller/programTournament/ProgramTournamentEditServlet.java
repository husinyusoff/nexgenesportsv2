// File: ProgramTournamentEditServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.service.programTournament.ProgramTournamentService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet("/programs/edit")
public class ProgramTournamentEditServlet extends HttpServlet {
    private final ProgramTournamentService service = new ProgramTournamentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String progId = req.getParameter("progId");
        ProgramTournament pt = service.findById(progId);
        if (pt == null) {
            resp.sendError(404);
            return;
        }
        req.setAttribute("program", pt);
        req.setAttribute("games",   service.listAllGames());
        req.setAttribute("merits",  service.listAllMeritLevels());
        req.setAttribute("ctx",     req.getContextPath());
        req.getRequestDispatcher("/programEdit.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        ProgramTournament pt = new ProgramTournament();
        pt.setProgId       (req.getParameter("progId").trim());
        pt.setCreatorId    (req.getParameter("creatorId"));
        pt.setGameId       (Integer.valueOf(req.getParameter("gameId")));
        pt.setProgramName  (req.getParameter("programName"));
        pt.setProgramType  (req.getParameter("programType"));
        pt.setMeritId      (Integer.valueOf(req.getParameter("meritId")));
        pt.setPlace        (req.getParameter("place"));
        pt.setDescription  (req.getParameter("description"));
        pt.setProgFee      (new BigDecimal(req.getParameter("progFee")));
        pt.setStartDate    (LocalDate.parse(req.getParameter("startDate")));
        pt.setEndDate      (LocalDate.parse(req.getParameter("endDate")));
        pt.setStartTime    (LocalTime.parse(req.getParameter("startTime")));
        pt.setEndTime      (LocalTime.parse(req.getParameter("endTime")));
        pt.setPrizePool    (new BigDecimal(req.getParameter("prizePool")));
        pt.setMaxCapacity  (Integer.parseInt(req.getParameter("maxCapacity")));
        String mtm = req.getParameter("maxTeamMember");
        pt.setMaxTeamMember(mtm != null && !mtm.isBlank()
                            ? Integer.valueOf(mtm) : null);
        pt.setStatus       (req.getParameter("status"));
        pt.setDeletedFlag (false);

        try {
            service.updateProgramTournament(pt);
            resp.sendRedirect(req.getContextPath() + "/programs/detail?progId=" + pt.getProgId());
        } catch (IOException e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("program", pt);
            req.setAttribute("games",  service.listAllGames());
            req.setAttribute("merits", service.listAllMeritLevels());
            req.getRequestDispatcher("/programEdit.jsp")
               .forward(req, resp);
        }
    }
}
