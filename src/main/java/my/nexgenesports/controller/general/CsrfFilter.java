package my.nexgenesports.controller.general;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import javax.servlet.http.Part;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.Collection;
import java.util.UUID;

/**
 * CSRF protection filter that supports multipart/form-data.
 */
@WebFilter("/*")
public class CsrfFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // no‐op
    }

    @Override
    public void doFilter(ServletRequest rq, ServletResponse rs, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  req  = (HttpServletRequest) rq;
        HttpServletResponse res  = (HttpServletResponse) rs;
        String path   = req.getRequestURI()
                           .substring(req.getContextPath().length());
        String method = req.getMethod();

        // Ensure session has a CSRF token
        HttpSession session = req.getSession(true);
        if (session.getAttribute("csrfToken") == null) {
            session.setAttribute("csrfToken", UUID.randomUUID().toString());
        }

        // Skip non‐POSTs and login/register
        if (!"POST".equalsIgnoreCase(method)
         || path.equals("/LoginServlet")
         || path.equals("/RegisterServlet")
         || path.equals("/login.jsp")
         || path.equals("/register.jsp")) {
            chain.doFilter(rq, rs);
            return;
        }

        // Extract submitted token
        String submitted;
        String contentType = req.getContentType();
        if (contentType != null
         && contentType.toLowerCase().startsWith("multipart/")) {
            submitted = extractPartValue(req, "csrfToken");
        } else {
            submitted = req.getParameter("csrfToken");
        }

        String sessionTok = (String) session.getAttribute("csrfToken");
        if (sessionTok == null
         || submitted == null
         || !sessionTok.equals(submitted)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token");
            return;
        }

        chain.doFilter(rq, rs);
    }

    @Override
    public void destroy() {
        // no‐op
    }

    private String extractPartValue(HttpServletRequest req, String name)
            throws IOException, ServletException {
        Collection<Part> parts = req.getParts();
        for (Part part : parts) {
            if (name.equals(part.getName())) {
                try (BufferedReader reader = new BufferedReader(
                        new InputStreamReader(part.getInputStream(), StandardCharsets.UTF_8))) {
                    return reader.readLine();
                }
            }
        }
        return null;
    }
}
