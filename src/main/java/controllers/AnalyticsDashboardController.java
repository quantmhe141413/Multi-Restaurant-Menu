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
        HttpSession session = request.getSession();
        Integer restaurantId = (session != null) ? (Integer) session.getAttribute("restaurantId") : null;
        
        if (restaurantId == null && session != null) {
            models.User user = (models.User) session.getAttribute("user");
            if (user != null && (user.getRoleID() == 2 || user.getRoleID() == 3)) {
                dal.UserDAO udao = new dal.UserDAO();
                restaurantId = udao.getRestaurantIdByUserId(user.getUserID());
                if (restaurantId != null) {
                    session.setAttribute("restaurantId", restaurantId);
                }
            }
        }

        if (restaurantId == null) {
            response.sendRedirect("login");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        RestaurantDAO restaurantDAO = new RestaurantDAO();
        
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        
        List<Map<String, Object>> dailyStats = orderDAO.getDailyRevenueStats(restaurantId, startDate, endDate);
        Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);
        
        double totalRevenue = 0;
        int totalOrders = 0;
        for (Map<String, Object> stat : dailyStats) {
            totalRevenue += (Double) stat.get("revenue");
            totalOrders += (Integer) stat.get("count");
        }
        
        request.setAttribute("dailyStats", dailyStats);
        request.setAttribute("restaurant", restaurant);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        
        request.getRequestDispatcher("views/analytics-dashboard.jsp").forward(request, response);
    }
}
