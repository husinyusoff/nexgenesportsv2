package my.nexgenesports.controller;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

/**
 * CSRF protection filter.
 */
@WebFilter("/*")
public class CsrfFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization needed
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String path   = request.getRequestURI()
                               .substring(request.getContextPath().length());
        String method = request.getMethod();

        // Ensure we always have a CSRF token in session
        HttpSession session = request.getSession(true);
        if (session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", UUID.randomUUID().toString());
        }

        // Skip CSRF check on GETs and on login/register endpoints
        boolean isPost = "POST".equalsIgnoreCase(method);
        if (!isPost
         || path.equals("/LoginServlet")
         || path.equals("/RegisterServlet")
         || path.equals("/login.jsp")
         || path.equals("/register.jsp")) {
            chain.doFilter(req, res);
            return;
        }

        // Validate submitted token
        String submitted  = request.getParameter("csrfToken");
        String sessionTok = (String) session.getAttribute("csrfToken");
        if (sessionTok == null
         || submitted == null
         || !sessionTok.equals(submitted)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
            return;
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
        // No cleanup needed
    }
}
