// src/main/java/my/nexgenesports/controller/DeleteStationServlet.java
package my.nexgenesports.controller;

import my.nexgenesports.service.StationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/stations/delete")
public class DeleteStationServlet extends HttpServlet {
  private final StationService svc = new StationService();

  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp)
      throws ServletException, IOException {
    String id = req.getParameter("stationID");
    try {
      svc.delete(id);
      resp.sendRedirect(req.getContextPath() + "/manageStations");
    } catch (IOException e) {
      throw new ServletException(e);
    }
  }
}
