package controllers;

import dal.OrderDAO;
import dal.RestaurantDAO;
import models.Restaurant;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AnalyticsDashboardController", urlPatterns = { "/restaurant-analytics-dashboard" })
public class AnalyticsDashboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer restaurantId = (session != null) ? (Integer) session.getAttribute("restaurantId") : null;
        
        if (restaurantId == null) {
            response.sendRedirect("login");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        RestaurantDAO restaurantDAO = new RestaurantDAO();
        
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        // Pagination logic
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Map<String, Object>> dailyStats = orderDAO.getDailyRevenueStatsPaginated(restaurantId, startDate, endDate, page, pageSize);
        int totalRecords = orderDAO.countDailyRevenueDays(restaurantId, startDate, endDate);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Get overview stats (non-paginated)
        Map<String, Object> overviewStats = orderDAO.getRevenueStatistics(restaurantId, startDate, endDate);
        Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);
        
        request.setAttribute("dailyStats", dailyStats);
        request.setAttribute("restaurant", restaurant);
        request.setAttribute("totalRevenue", overviewStats.get("totalRevenue"));
        request.setAttribute("totalOrders", overviewStats.get("totalOrders"));
        request.setAttribute("avgOrderValue", overviewStats.get("avgOrderValue"));
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("views/analytics-dashboard.jsp").forward(request, response);
    }
}
