package my.nexgenesports.controller.general;

import my.nexgenesports.util.PermissionChecker;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Set;

@WebFilter(urlPatterns = "/*", dispatcherTypes = { DispatcherType.REQUEST })
public class AuthFilter implements Filter {

    // Removed "/" from PUBLIC — we’ll handle it explicitly instead
    private static final Set<String> PUBLIC = Set.of(
            "/", // root
            "/index.jsp",
            "/login.jsp",
            "/register.jsp",
            "/forgotPassword.jsp",
            "/resetPassword.jsp",
            "/accessDenied.jsp",
            "/auth",
            "/logout",
            "/styles.css",
            "/LoginServlet",
            "/RegisterServlet"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // no‑op
    }

    @Override
    public void doFilter(ServletRequest rq, ServletResponse rs, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest) rq;
        HttpServletResponse res  = (HttpServletResponse) rs;
        String path = req.getServletPath(); // e.g. "/", "/login.jsp", etc.

        // 0) Intercept root ("/") or empty and redirect to dashboard.jsp
        if (path == null || path.isEmpty() || "/".equals(path)) {
            req.getRequestDispatcher("/login.jsp").forward(req, res);
            return;
        }

        // 1) Always allow public paths & static assets
        if (path == null
                || path.isEmpty()
                || PUBLIC.contains(path)
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.startsWith("/scripts/")
                || path.startsWith("/fonts/")) {
            chain.doFilter(rq, rs);
            return;
        }

        // 2) Must be logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 3) Dashboard + Profile pages are always allowed once you're in
        if ("/dashboard.jsp".equals(path)
                || "/DashboardServlet".equals(path)
                || "/manageProfile".equals(path)
                || "/inGameProfile".equals(path)) {
            chain.doFilter(rq, rs);
            return;
        }

        // 4) Role‑based access check for everything else
        @SuppressWarnings("unchecked")
        List<String> roles = (List<String>) session.getAttribute("effectiveRoles");
        String chosenRole = (String) session.getAttribute("role");
        String position   = (String) session.getAttribute("position");

        if (PermissionChecker.hasAccess(roles, chosenRole, position, path)) {
            chain.doFilter(rq, rs);
        } else {
            res.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
        }
    }

    @Override
    public void destroy() {
        // no‑op
    }
}
