// src/main/java/my/nexgenesports/controller/programTournament/PreviewRegistrationServlet.java
package my.nexgenesports.controller.programTournament;

import my.nexgenesports.model.ProgramTournament;
import my.nexgenesports.service.programTournament.ProgramTournamentService;
import my.nexgenesports.service.memberships.MembershipService;
import my.nexgenesports.service.memberships.PassService;
import my.nexgenesports.model.UserClubMembership;
import my.nexgenesports.model.UserGamingPass;
import my.nexgenesports.util.PricingEngine;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/programs/previewRegistration")
public class PreviewRegistrationServlet extends HttpServlet {
    private final ProgramTournamentService progSvc = new ProgramTournamentService();
    private final MembershipService memSvc = new MembershipService();
    private final PassService passSvc = new PassService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) auth + CSRF (omitted)
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 2) parse selections
        int progId = Integer.parseInt(req.getParameter("progId"));
        String teamParam = req.getParameter("teamId");
        Integer teamId = (teamParam == null || teamParam.isBlank())
                       ? null
                       : Integer.valueOf(teamParam);

        String[] mainPlayers = req.getParameterValues("mainPlayers");
        String[] subPlayers  = req.getParameterValues("subPlayers");
        mainPlayers = mainPlayers != null ? mainPlayers : new String[0];
        subPlayers  = subPlayers  != null ? subPlayers  : new String[0];

        // 3) load program & fee
        ProgramTournament program = progSvc.getProgramById(progId);
        BigDecimal amount = program.getProgFee();

        // 4) prepare parallel lists
        List<String> users = new java.util.ArrayList<>();
        List<String> roles = new java.util.ArrayList<>();
        for (String u : mainPlayers) {
            users.add(u); roles.add("MAIN");
        }
        for (String u : subPlayers) {
            users.add(u); roles.add("SUB");
        }

        // 5) forward to checkout.jsp
        req.setAttribute("isSolo", false);
        req.setAttribute("program", program);
        req.setAttribute("amount", amount);
        req.setAttribute("teamId", teamId);
        req.setAttribute("users", users);
        req.setAttribute("roles", roles);

        String userID = (String) session.getAttribute("username");
        try {
            UserClubMembership mem = memSvc.getCurrentMembership(userID);
            UserGamingPass pass = passSvc.getCurrentPass(userID);
            int memDiscount = (mem != null) ? mem.getSession().getDiscountRate() : 0;
            int passDiscount = (pass != null) ? pass.getTier().getDiscountRate() : 0;
            PricingEngine.PricingResult pricing = PricingEngine.calculate(amount, memDiscount, passDiscount);

            req.setAttribute("activeMem", mem);
            req.setAttribute("activePass", pass);
            req.setAttribute("pricing", pricing);
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.getRequestDispatcher("/checkout.jsp")
           .forward(req, resp);
    }
}
