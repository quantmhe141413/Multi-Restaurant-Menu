package controllers;

// DAO for analytics and aggregated data
import dal.RestaurantAnalyticsDAO;

// Servlet libraries
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

// Model classes
import models.RestaurantAnalytics;
import models.User;

// Map URL: /admin/dashboard
@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    /**
     * Handle GET request to load admin dashboard data
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current session (do not create new)
        HttpSession session = request.getSession(false);

        // Get logged-in user
        User currentUser = session == null ? null : (User) session.getAttribute("user");

        // Authorization check: only admin (roleID = 1)
        if (currentUser == null || currentUser.getRoleID() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Initialize DAO to fetch analytics data
        RestaurantAnalyticsDAO analyticsDAO = new RestaurantAnalyticsDAO();

        // ===== Restaurant statistics =====
        int totalRestaurants = analyticsDAO.countAllRestaurants();
        int pendingRestaurants = analyticsDAO.countRestaurantsByStatus("Pending");
        int approvedRestaurants = analyticsDAO.countRestaurantsByStatus("Approved");
        int rejectedRestaurants = analyticsDAO.countRestaurantsByStatus("Rejected");

        // ===== Order & revenue statistics =====
        int totalOrders = analyticsDAO.getTotalOrdersAllRestaurants();
        BigDecimal totalRevenue = analyticsDAO.getTotalRevenueAllRestaurants();

        // ===== Top restaurants by revenue =====
        List<RestaurantAnalytics> topRestaurants =
                analyticsDAO.getTopRestaurantsByRevenue(10);

        // Set attributes for JSP view
        request.setAttribute("totalRestaurants", totalRestaurants);
        request.setAttribute("pendingRestaurants", pendingRestaurants);
        request.setAttribute("approvedRestaurants", approvedRestaurants);
        request.setAttribute("rejectedRestaurants", rejectedRestaurants);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("topRestaurants", topRestaurants);

        // Forward to dashboard page
        request.getRequestDispatcher("/views/admin/admin-dashboard.jsp")
                .forward(request, response);
    }
}