package controllers;

import dal.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "PeakHoursAnalysisController", urlPatterns = { "/peak-hours-analysis" })
public class PeakHoursAnalysisController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer restaurantId = (session != null) ? (Integer) session.getAttribute("restaurantId") : null;
        
        if (restaurantId == null) {
            response.sendRedirect("login");
            return;
        }

        OrderDAO dao = new OrderDAO();
        Map<Integer, Integer> peakHours = dao.getPeakHoursStats(restaurantId);
        
        request.setAttribute("peakHours", peakHours);
        request.getRequestDispatcher("views/peak-hours-analysis.jsp").forward(request, response);
    }
}
