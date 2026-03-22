package controllers;

// DAO classes for database interaction
import dal.CommissionHistoryDAO;
import dal.RestaurantDAO;

// Servlet libraries
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

// Model classes
import models.CommissionHistory;
import models.Restaurant;
import models.User;

// Map URL: /admin/commission-history
@WebServlet(name = "AdminCommissionHistoryController", urlPatterns = {"/admin/commission-history"})
public class AdminCommissionHistoryController extends HttpServlet {

    /**
     * Handle GET requests (view commission history list)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get existing session (do not create new)
        HttpSession session = request.getSession(false);

        // Get logged-in user
        User currentUser = session == null ? null : (User) session.getAttribute("user");

        // Authorization: only admin (roleID = 1)
        if (currentUser == null || currentUser.getRoleID() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get action parameter
        String action = request.getParameter("action");

        // Default action = list
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        // Route action
        switch (action) {
            case "list":
            default:
                handleList(request, response); // Show history list
                break;
        }
    }

    /**
     * Handle displaying commission history with filters + pagination
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get restaurant filter (optional)
        String restaurantStr = request.getParameter("restaurant");
        Integer restaurantId = null;

        if (restaurantStr != null && !restaurantStr.trim().isEmpty()) {
            try {
                restaurantId = Integer.parseInt(restaurantStr.trim());
            } catch (NumberFormatException e) {
                // Invalid input → ignore filter
                restaurantId = null;
            }
        }

        // Search keyword filter
        String searchFilter = request.getParameter("search");

        // Pagination setup
        int page = 1;
        int pageSize = 10;

        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        CommissionHistoryDAO historyDAO = new CommissionHistoryDAO();

        // Check if history table exists (useful for first-time setup)
        boolean historyTableExists = historyDAO.historyTableExists();

        // Get filtered history list
        List<CommissionHistory> history = historyDAO
                .findHistoryWithFilters(restaurantId, searchFilter, page, pageSize);

        // Get total records count
        int total = historyDAO.getTotalFilteredHistory(restaurantId, searchFilter);

        // Calculate total pages
        int totalPages = (int) Math.ceil((double) total / pageSize);

        // Get all restaurants for dropdown filter
        RestaurantDAO restaurantDAO = new RestaurantDAO();
        List<Restaurant> restaurants = restaurantDAO.getAllRestaurantsForDropdown();

        // Set attributes for JSP
        request.setAttribute("historyTableExists", historyTableExists);
        request.setAttribute("history", history);
        request.setAttribute("restaurants", restaurants);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalHistory", total);

        // Forward to JSP view
        request.getRequestDispatcher("/views/admin/commission-history.jsp")
                .forward(request, response);
    }
}