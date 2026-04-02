/*
 * Decompiled with CFR 0.152.
 * 
 * Could not load the following classes:
 *  javax.servlet.ServletException
 *  javax.servlet.ServletRequest
 *  javax.servlet.ServletResponse
 *  javax.servlet.annotation.WebServlet
 *  javax.servlet.http.HttpServlet
 *  javax.servlet.http.HttpServletRequest
 *  javax.servlet.http.HttpServletResponse
 *  javax.servlet.http.HttpSession
 */
package my.nexgenesports.controller.memberships;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import my.nexgenesports.model.ClubBenefit;
import my.nexgenesports.model.MembershipSession;
import my.nexgenesports.model.PassBenefit;
import my.nexgenesports.model.PassTier;
import my.nexgenesports.model.UserClubMembership;
import my.nexgenesports.model.UserGamingPass;
import my.nexgenesports.service.memberships.MembershipService;
import my.nexgenesports.service.memberships.PassService;

@WebServlet(value={"/admin/memberships"})
public class AdminManageMembershipsServlet
extends HttpServlet {
    private final MembershipService ms = new MembershipService();
    private final PassService ps = new PassService();

    private LocalDateTime parseRobust(String dt) {
        if (dt == null || ((String)dt).trim().isEmpty()) {
            return LocalDateTime.now();
        }
        if (((String)(dt = ((String)dt).trim())).contains("T")) {
            if (((String)dt).length() == 16) {
                dt = (String)dt + ":00";
            }
            try {
                return LocalDateTime.parse((CharSequence)dt);
            }
            catch (Exception e) {
                return LocalDateTime.now();
            }
        }
        try {
            return LocalDate.parse((CharSequence)dt).atStartOfDay();
        }
        catch (Exception e) {
            try {
                return LocalDate.parse((CharSequence)dt, DateTimeFormatter.ofPattern("M/d/yyyy")).atStartOfDay();
            }
            catch (Exception exception) {
                return LocalDateTime.now();
            }
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        try {
            List<MembershipSession> sessions = this.ms.getAllSessions();
            HashMap<String, List<ClubBenefit>> sessionBenefitsMap = new HashMap<String, List<ClubBenefit>>();
            for (MembershipSession s : sessions) {
                sessionBenefitsMap.put(s.getSessionId(), this.ms.getSessionBenefits(s.getSessionId()));
            }
            List<PassTier> passTiers = this.ps.getAllTiers();
            HashMap<Integer, List<PassBenefit>> passBenefitsMap = new HashMap<Integer, List<PassBenefit>>();
            for (PassTier t : passTiers) {
                passBenefitsMap.put(t.getTierId(), this.ps.getTierBenefits(t.getTierId()));
            }
            List<UserClubMembership> userMemberships = this.ms.getAllUserMemberships();
            List<UserGamingPass> userPasses = this.ps.getAllUserPasses();
            req.setAttribute("sessions", sessions);
            req.setAttribute("sessionBenefitsMap", sessionBenefitsMap);
            req.setAttribute("passTiers", passTiers);
            req.setAttribute("passBenefitsMap", passBenefitsMap);
            req.setAttribute("userMemberships", userMemberships);
            req.setAttribute("userPasses", userPasses);
            req.getRequestDispatcher("/adminManageMemberships.jsp").forward((ServletRequest)req, (ServletResponse)resp);
        }
        catch (SQLException e) {
            throw new ServletException((Throwable)e);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/memberships");
            return;
        }
        try {
            switch (action) {
                case "add_session": {
                    MembershipSession s = new MembershipSession();
                    s.setSessionId(req.getParameter("sessionId"));
                    s.setSessionName(req.getParameter("sessionName"));
                    s.setStartMembershipDate(this.parseRobust(req.getParameter("startDate")));
                    s.setEndMembershipDate(this.parseRobust(req.getParameter("endDate")));
                    s.setFee(new BigDecimal(req.getParameter("fee")));
                    s.setActive(Boolean.parseBoolean(req.getParameter("isActive")));
                    String cap = req.getParameter("capacityLimit");
                    s.setCapacityLimit(cap != null && !cap.isEmpty() ? Integer.valueOf(Integer.parseInt(cap)) : null);
                    this.ms.createSession(s);
                    break;
                }
                case "update_session": {
                    MembershipSession s = new MembershipSession();
                    s.setSessionId(req.getParameter("sessionId"));
                    s.setSessionName(req.getParameter("sessionName"));
                    s.setStartMembershipDate(this.parseRobust(req.getParameter("startDate")));
                    s.setEndMembershipDate(this.parseRobust(req.getParameter("endDate")));
                    s.setFee(new BigDecimal(req.getParameter("fee")));
                    s.setActive(Boolean.parseBoolean(req.getParameter("isActive")));
                    String cap = req.getParameter("capacityLimit");
                    s.setCapacityLimit(cap != null && !cap.isEmpty() ? Integer.valueOf(Integer.parseInt(cap)) : null);
                    this.ms.updateSession(s);
                    break;
                }
                case "delete_session": {
                    this.ms.deleteSession(req.getParameter("sessionId"));
                    break;
                }
                case "add_club_benefit": {
                    this.ms.addSessionBenefit(req.getParameter("sessionId"), req.getParameter("benefitText"));
                    break;
                }
                case "delete_club_benefit": {
                    this.ms.deleteSessionBenefit(Integer.parseInt(req.getParameter("id")));
                    break;
                }
                case "add_tier": {
                    PassTier t = new PassTier();
                    t.setTierName(req.getParameter("tierName"));
                    t.setPrice(new BigDecimal(req.getParameter("price")));
                    this.ps.createTier(t);
                    break;
                }
                case "update_tier": {
                    PassTier t = new PassTier();
                    t.setTierId(Integer.parseInt(req.getParameter("tierId")));
                    t.setTierName(req.getParameter("tierName"));
                    t.setPrice(new BigDecimal(req.getParameter("price")));
                    this.ps.updateTier(t);
                    break;
                }
                case "delete_tier": {
                    this.ps.deleteTier(Integer.parseInt(req.getParameter("tierId")));
                    break;
                }
                case "add_pass_benefit": {
                    this.ps.addTierBenefit(Integer.parseInt(req.getParameter("tierId")), req.getParameter("benefitName"), req.getParameter("benefitText"));
                    break;
                }
                case "toggle_pass_benefit_avail": {
                    int bid = Integer.parseInt(req.getParameter("id"));
                    String newVal = req.getParameter("newVal");
                    this.ps.updateBenefitText(bid, newVal);
                    break;
                }
                case "delete_pass_benefit": {
                    this.ps.deleteTierBenefit(Integer.parseInt(req.getParameter("id")));
                    break;
                }
                case "add_user_membership": {
                    this.ms.adminGrantMembership(req.getParameter("userId"), req.getParameter("sessionId"), this.parseRobust(req.getParameter("expiryDate")), req.getParameter("paymentReference"));
                    break;
                }
                case "update_user_membership": {
                    this.ms.adminUpdateMembership(Integer.parseInt(req.getParameter("id")), req.getParameter("status"), this.parseRobust(req.getParameter("purchaseDate")), this.parseRobust(req.getParameter("expiryDate")), req.getParameter("paymentReference"));
                    break;
                }
                case "delete_user_membership": {
                    this.ms.adminDeleteMembership(Integer.parseInt(req.getParameter("id")));
                    break;
                }
                case "add_user_pass": {
                    this.ps.adminGrantPass(req.getParameter("userId"), Integer.parseInt(req.getParameter("tierId")), this.parseRobust(req.getParameter("expiryDate")), req.getParameter("paymentReference"));
                    break;
                }
                case "update_user_pass": {
                    this.ps.adminUpdatePass(Integer.parseInt(req.getParameter("id")), Integer.parseInt(req.getParameter("tierId")), req.getParameter("status"), this.parseRobust(req.getParameter("purchaseDate")), this.parseRobust(req.getParameter("expiryDate")), req.getParameter("paymentReference"));
                    break;
                }
                case "delete_user_pass": {
                    this.ps.adminDeletePass(Integer.parseInt(req.getParameter("id")));
                }
            }
            req.getSession().setAttribute("successMsg", (Object)"Operation completed successfully.");
        }
        catch (SQLIntegrityConstraintViolationException e) {
            req.getSession().setAttribute("errorMsg", (Object)"Deletion blocked: Record is still referenced by existing user plans. Please remove user associations first.");
        }
        catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("errorMsg", (Object)("An error occurred: " + e.getMessage()));
        }
        resp.sendRedirect(req.getContextPath() + "/admin/memberships");
    }
}