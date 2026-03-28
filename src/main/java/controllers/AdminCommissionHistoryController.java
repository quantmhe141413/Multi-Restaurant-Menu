package controllers;

import dal.CommissionHistoryDAO;
import dal.RestaurantDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import models.CommissionHistory;
import models.Restaurant;
import models.User;

/**
 * AdminCommissionHistoryController
 * 
 * This servlet handles viewing commission history records.
 * Only ADMIN users (roleID = 1) are allowed to access this controller.
 * 
 * Main responsibilities:
 * - Display commission change history
 * - Filter by restaurant and search keyword
 * - Support pagination
 */
@WebServlet(name = "AdminCommissionHistoryController", urlPatterns = {"/admin/commission-history"})
public class AdminCommissionHistoryController extends HttpServlet {

    /**
     * Handle GET request
     * 
     * Only supports "list" action (view history)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current session (do not create new session if none exists)
        HttpSession session = request.getSession(false);

        // Get logged-in user
        User currentUser = session == null ? null : (User) session.getAttribute("user");

        // Authorization check (only admin allowed)
        if (currentUser == null || currentUser.getRoleID() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get action parameter (default = list)
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        // Currently only supports "list"
        switch (action) {
            case "list":
            default:
                handleList(request, response);
                break;
        }
    }

    /**
     * Handle displaying commission history list
     * 
     * Features:
     * - Filter by restaurant
     * - Search keyword
     * - Pagination
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        /**
         * 1. Get filter: restaurant ID
         */
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

        /**
         * 2. Get search keyword (e.g., reason, admin name, etc.)
         */
        String searchFilter = request.getParameter("search");

        /**
         * 3. Pagination setup
         */
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

        /**
         * 4. Fetch commission history data from DAO
         */
        CommissionHistoryDAO historyDAO = new CommissionHistoryDAO();

        // Check if history table exists (useful for first-time setup)
        boolean historyTableExists = historyDAO.historyTableExists();

        // Get filtered history list
        List<CommissionHistory> history =
                historyDAO.findHistoryWithFilters(restaurantId, searchFilter, page, pageSize);

        // Get total number of filtered records
        int total = historyDAO.getTotalFilteredHistory(restaurantId, searchFilter);

        // Calculate total pages
        int totalPages = (int) Math.ceil((double) total / pageSize);

        /**
         * 5. Load restaurant list for dropdown filter
         */
        RestaurantDAO restaurantDAO = new RestaurantDAO();
        List<Restaurant> restaurants = restaurantDAO.getAllRestaurantsForDropdown();

        /**
         * 6. Set attributes for JSP view
         */
        request.setAttribute("historyTableExists", historyTableExists);
        request.setAttribute("history", history);
        request.setAttribute("restaurants", restaurants);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalHistory", total);

        /**
         * 7. Forward to JSP view
         */
        request.getRequestDispatcher("/views/admin/commission-history.jsp")
               .forward(request, response);
    }
}