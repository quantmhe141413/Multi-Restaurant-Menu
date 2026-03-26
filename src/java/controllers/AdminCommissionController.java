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
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import models.Restaurant;
import models.User;

/**
 * AdminCommissionController
 * 
 * This servlet handles commission configuration for restaurants.
 * Only ADMIN users (roleID = 1) are allowed to access this controller.
 * 
 * Main responsibilities:
 * - Display restaurant list with commission info
 * - Edit commission rate
 * - Update commission rate and log history
 */
@WebServlet(name = "AdminCommissionController", urlPatterns = {"/admin/commission"})
public class AdminCommissionController extends HttpServlet {

    /**
     * Handle GET requests
     * 
     * Actions:
     * - list (default): show restaurant list
     * - edit: open edit form for a restaurant
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current session (do not create new one if not exists)
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

        // Route to appropriate handler
        switch (action) {
            case "edit":
                handleEdit(request, response);
                break;
            case "list":
            default:
                handleList(request, response);
                break;
        }
    }

    /**
     * Handle POST requests
     * 
     * Actions:
     * - update: update commission rate
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");

        // Authorization check
        if (currentUser == null || currentUser.getRoleID() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        // If no action → redirect to list
        if (action == null || action.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
            return;
        }

        switch (action) {
            case "update":
                handleUpdate(request, response, currentUser);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
                break;
        }
    }

    /**
     * Display restaurant list with pagination and search
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String statusFilter = "Approved"; // Only approved restaurants
        String searchFilter = request.getParameter("search");

        // Pagination logic
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

        // Fetch data from DAO
        RestaurantDAO restaurantDAO = new RestaurantDAO();
        List<Restaurant> restaurants =
                restaurantDAO.findRestaurantsForCommissionConfig(statusFilter, searchFilter, page, pageSize);

        int total = restaurantDAO.getTotalFilteredRestaurants(statusFilter, searchFilter);

        // Calculate total pages
        int totalPages = (int) Math.ceil((double) total / pageSize);

        // Set attributes for JSP
        request.setAttribute("restaurants", restaurants);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRestaurants", total);

        // Forward to view
        request.getRequestDispatcher("/views/admin/commission-config.jsp")
               .forward(request, response);
    }

    /**
     * Handle edit action
     * - Validate restaurant ID
     * - Ensure restaurant exists and is approved
     * - Pass data to JSP
     */
    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String idStr = request.getParameter("id");

        // Validate ID
        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Missing restaurant ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());

            RestaurantDAO restaurantDAO = new RestaurantDAO();
            Restaurant r = restaurantDAO.findByIdWithOwner(id);

            // Check existence
            if (r == null) {
                session.setAttribute("toastMessage", "Restaurant not found");
                response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
                return;
            }

            // Only approved restaurants allowed
            if (r.getStatus() == null || !"Approved".equalsIgnoreCase(r.getStatus().trim())) {
                session.setAttribute("toastMessage", "Only approved restaurants can be configured");
                response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
                return;
            }

            // Send data to view
            request.setAttribute("editRestaurant", r);

            // Reuse list logic to display alongside edit form
            handleList(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid restaurant ID");
            response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
        }
    }

    /**
     * Handle update commission
     * 
     * Steps:
     * 1. Validate input
     * 2. Check restaurant status
     * 3. Update commission
     * 4. Save history
     * 5. Redirect with filters preserved
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {

        HttpSession session = request.getSession();

        String idStr = request.getParameter("id");
        String rateStr = request.getParameter("commissionRate");
        String reason = request.getParameter("reason");

        // Validate required fields
        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Missing restaurant ID");
            response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
            return;
        }

        if (rateStr == null || rateStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Commission rate is required");
            response.sendRedirect(request.getContextPath() + "/admin/commission?action=edit&id=" +
                    URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
            return;
        }

        if (reason == null || reason.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Reason is required");
            response.sendRedirect(request.getContextPath() + "/admin/commission?action=edit&id=" +
                    URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
            return;
        }

        try {
            int restaurantId = Integer.parseInt(idStr.trim());
            BigDecimal newRate = new BigDecimal(rateStr.trim());

            // Validate commission range (0–100%)
            if (newRate.compareTo(BigDecimal.ZERO) < 0 ||
                newRate.compareTo(new BigDecimal("100")) > 0) {

                session.setAttribute("toastMessage", "Commission rate must be between 0 and 100");
                response.sendRedirect(request.getContextPath() + "/admin/commission?action=edit&id=" +
                        URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
                return;
            }

            RestaurantDAO restaurantDAO = new RestaurantDAO();
            Restaurant before = restaurantDAO.findByIdWithOwner(restaurantId);

            if (before == null) {
                session.setAttribute("toastMessage", "Restaurant not found");
                response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
                return;
            }

            // Check approved status
            if (before.getStatus() == null || !"Approved".equalsIgnoreCase(before.getStatus().trim())) {
                session.setAttribute("toastMessage", "Only approved restaurants can be configured");
                response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
                return;
            }

            // Save old rate for history tracking
            BigDecimal oldRate = before.getCommissionRate() == null
                    ? null
                    : BigDecimal.valueOf(before.getCommissionRate());

            // Update database
            boolean ok = restaurantDAO.updateCommissionRate(restaurantId, newRate);

            if (ok) {
                // Insert history record
                CommissionHistoryDAO historyDAO = new CommissionHistoryDAO();
                historyDAO.insertHistory(
                        restaurantId,
                        oldRate,
                        newRate,
                        currentUser.getUserID(),
                        reason.trim()
                );

                session.setAttribute("toastMessage", "Commission rate updated successfully");
                session.setAttribute("toastType", "success");

            } else {
                session.setAttribute("toastMessage", "Failed to update commission rate");
                session.setAttribute("toastType", "error");
            }

        } catch (NumberFormatException ex) {
            session.setAttribute("toastMessage", "Invalid input");
            session.setAttribute("toastType", "error");
        }

        /**
         * Preserve filters after update (UX improvement)
         */
        String status = request.getParameter("status");
        String search = request.getParameter("search");
        String page = request.getParameter("page");

        StringBuilder redirect = new StringBuilder();
        redirect.append(request.getContextPath()).append("/admin/commission?action=list");

        if (status != null && !status.trim().isEmpty()) {
            redirect.append("&status=").append(URLEncoder.encode(status.trim(), StandardCharsets.UTF_8));
        }
        if (search != null && !search.trim().isEmpty()) {
            redirect.append("&search=").append(URLEncoder.encode(search.trim(), StandardCharsets.UTF_8));
        }
        if (page != null && !page.trim().isEmpty()) {
            redirect.append("&page=").append(URLEncoder.encode(page.trim(), StandardCharsets.UTF_8));
        }

        // Redirect to updated list
        response.sendRedirect(redirect.toString());
    }
}