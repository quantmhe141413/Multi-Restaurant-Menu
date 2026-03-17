package controllers;

import dal.RestaurantAnalyticsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import models.RestaurantAnalytics;
import models.User;

@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRoleID() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        RestaurantAnalyticsDAO analyticsDAO = new RestaurantAnalyticsDAO();

        int totalRestaurants = analyticsDAO.countAllRestaurants();
        int pendingRestaurants = analyticsDAO.countRestaurantsByStatus("Pending");
        int approvedRestaurants = analyticsDAO.countRestaurantsByStatus("Approved");
        int rejectedRestaurants = analyticsDAO.countRestaurantsByStatus("Rejected");

        int totalOrders = analyticsDAO.getTotalOrdersAllRestaurants();
        BigDecimal totalRevenue = analyticsDAO.getTotalRevenueAllRestaurants();

        List<RestaurantAnalytics> topRestaurants = analyticsDAO.getTopRestaurantsByRevenue(10);

        request.setAttribute("totalRestaurants", totalRestaurants);
        request.setAttribute("pendingRestaurants", pendingRestaurants);
        request.setAttribute("approvedRestaurants", approvedRestaurants);
        request.setAttribute("rejectedRestaurants", rejectedRestaurants);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("topRestaurants", topRestaurants);

        request.getRequestDispatcher("/views/admin/admin-dashboard.jsp").forward(request, response);
    }
}
