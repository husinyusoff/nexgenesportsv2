package my.nexgenesports.controller.team;

import my.nexgenesports.service.general.ServiceException;
import my.nexgenesports.service.team.TeamService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@WebServlet("/team/create")
@MultipartConfig(maxFileSize = 5_000_000, fileSizeThreshold = 1_000_000)
public class TeamCreateServlet extends HttpServlet {

    private final TeamService teamService = new TeamService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("capacity", 2);
        req.getRequestDispatcher("/teamCreate.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String leader = (String) session.getAttribute("username");

        String name = req.getParameter("teamName");
        String description = req.getParameter("description");
        int capacity = Integer.parseInt(req.getParameter("capacity"));

        Part logoPart = req.getPart("logoFile");
        String logoUrl = null;
        if (logoPart != null && logoPart.getSize() > 0) {
            String fileName = Paths.get(logoPart.getSubmittedFileName())
                    .getFileName().toString();
            File uploads = new File(getServletContext().getRealPath("/uploads"));
            if (!uploads.exists()) {
                uploads.mkdirs();
            }
            File file = new File(uploads, fileName);
            try (InputStream in = logoPart.getInputStream()) {
                Files.copy(in, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
            logoUrl = req.getContextPath() + "/uploads/" + fileName;
        }

        try {
            teamService.createTeam(name, description, logoUrl, leader, capacity);
            resp.sendRedirect(req.getContextPath() + "/team/manage");
        } catch (ServiceException e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("teamName", name);
            req.setAttribute("description", description);
            req.setAttribute("capacity", capacity);
            req.getRequestDispatcher("/teamCreate.jsp").forward(req, resp);
        }
    }
}
