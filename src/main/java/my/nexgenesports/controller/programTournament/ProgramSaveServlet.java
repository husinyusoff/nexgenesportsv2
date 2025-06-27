// src/main/java/my/nexgenesports/controller/ProgramSaveServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.model.ProgramType;
import my.nexgenesports.model.TournamentMode;
import my.nexgenesports.service.programTournament.ProgramTournamentService;
import my.nexgenesports.service.general.ServiceException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;

@WebServlet("/programs/save")
public class ProgramSaveServlet extends HttpServlet {

    private final ProgramTournamentService svc = new ProgramTournamentService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            ProgramTournament t = new ProgramTournament();
            t.setProgID(req.getParameter("progID"));  // blank for new
            t.setCreatorId((String) req.getSession().getAttribute("userId"));
            t.setProgramName(req.getParameter("programName"));
            t.setDescription(req.getParameter("description"));
            t.setProgramType(ProgramType.valueOf(req.getParameter("programType")));

            // shared date fields
            t.setStartDate(LocalDate.parse(req.getParameter("startDate")));
            t.setEndDate(LocalDate.parse(req.getParameter("endDate")));

            if (t.getProgramType() == ProgramType.TOURNAMENT) {
                t.setGameID(req.getParameter("gameID"));
                t.setCapacity(Integer.parseInt(req.getParameter("capacity")));
                t.setTournamentMode(TournamentMode.valueOf(req.getParameter("tournamentMode")));
                t.setMaxTeamMember(Integer.parseInt(req.getParameter("maxTeamMember")));
                t.setOpenSignup(req.getParameter("openSignup") != null);
            }

            // fees / pool
            if (req.getParameter("progFee") != null) {
                t.setProgFee(new BigDecimal(req.getParameter("progFee")));
            }
            if (req.getParameter("prizePool") != null) {
                t.setPrizePool(new BigDecimal(req.getParameter("prizePool")));
            }

            // times
            if (req.getParameter("startTime") != null) {
                t.setStartTime(LocalTime.parse(req.getParameter("startTime")));
            }
            if (req.getParameter("endTime") != null) {
                t.setEndTime(LocalTime.parse(req.getParameter("endTime")));
            }

            if (t.getProgID() == null || t.getProgID().isEmpty()) {
                svc.createProgram(t);
            } else {
                svc.updateTournament(t);
            }

            resp.sendRedirect(req.getContextPath() + "/programs");

        } catch (SQLException | ServiceException e) {
            throw new ServletException(e);
        }
    }
}
