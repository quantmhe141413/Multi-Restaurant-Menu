package controllers;

// DAO for database operations related to restaurants
import dal.RestaurantDAO;

// Servlet libraries
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

// Model classes
import models.Restaurant;
import models.User;

// Utility class for sending email notifications
import utils.EmailService;

// Map URL: /admin/restaurant-applications
@WebServlet(name = "AdminRestaurantApplicationsController", urlPatterns = {"/admin/restaurant-applications"})
public class AdminRestaurantApplicationsController extends HttpServlet {

    /**
     * Handle GET requests (list applications or view detail)
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

        // Get action parameter
        String action = request.getParameter("action");

        // Default action = list
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        // Route request
        switch (action) {
            case "detail":
                handleDetail(request, response); // Show application detail
                break;
            case "list":
            default:
                handleList(request, response); // Show application list
                break;
        }
    }

    /**
     * Handle POST requests (approve or reject application)
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
            response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=list");
            return;
        }

        // Handle approve / reject actions
        switch (action) {
            case "approve":
                handleUpdateStatus(request, response, "Approved");
                break;
            case "reject":
                handleUpdateStatus(request, response, "Rejected");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=list");
                break;
        }
    }

    /**
     * Display list of restaurant applications with filters and pagination
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String statusFilter = request.getParameter("status");
        String searchFilter = request.getParameter("search");

        // Default filter: show only pending applications
        if (statusFilter == null || statusFilter.trim().isEmpty()) {
            statusFilter = "Pending";
        }

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

        RestaurantDAO restaurantDAO = new RestaurantDAO();

        // Fetch filtered restaurant applications
        List<Restaurant> restaurants =
                restaurantDAO.findRestaurantsWithFilters(statusFilter, searchFilter, page, pageSize);

        // Get total count
        int totalRestaurants =
                restaurantDAO.getTotalFilteredRestaurants(statusFilter, searchFilter);

        // Calculate total pages
        int totalPages = (int) Math.ceil((double) totalRestaurants / pageSize);

        // Set attributes for view
        request.setAttribute("restaurants", restaurants);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRestaurants", totalRestaurants);

        // Forward to JSP
        request.getRequestDispatcher("/views/admin/restaurant-application-list.jsp")
                .forward(request, response);
    }

    /**
     * Handle approve/reject logic and send notification email
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response, String newStatus)
            throws IOException {

        HttpSession session = request.getSession();

        String idStr = request.getParameter("id");
        String reason = request.getParameter("reason");

        // Validate input
        if (idStr == null || idStr.isEmpty()) {
            session.setAttribute("toastMessage", "Missing restaurant ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=list");
            return;
        }

        if (reason == null || reason.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Reason is required");
            session.setAttribute("toastType", "error");

            response.sendRedirect(request.getContextPath()
                    + "/admin/restaurant-applications?action=detail&id="
                    + URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
            return;
        }

        try {
            int restaurantId = Integer.parseInt(idStr);

            RestaurantDAO restaurantDAO = new RestaurantDAO();

            // Get restaurant with owner information
            Restaurant restaurant = restaurantDAO.findByIdWithOwner(restaurantId);

            if (restaurant == null) {
                session.setAttribute("toastMessage", "Restaurant not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=list");
                return;
            }

            // Update status in database
            boolean ok = restaurantDAO.updateRestaurantStatus(restaurantId, newStatus, reason);

            if (ok) {
                boolean emailSent = false;
                String emailError = null;

                try {
                    // Validate required email data
                    if (restaurant.getOwnerEmail() == null || restaurant.getOwnerEmail().trim().isEmpty()) {
                        emailError = "Owner email is missing";
                    } else if (restaurant.getOwnerName() == null || restaurant.getOwnerName().trim().isEmpty()) {
                        emailError = "Owner name is missing";
                    } else if (restaurant.getName() == null || restaurant.getName().trim().isEmpty()) {
                        emailError = "Restaurant name is missing";
                    } else {
                        // Send appropriate email based on status
                        if ("Approved".equalsIgnoreCase(newStatus)) {
                            emailSent = EmailService.sendRestaurantApprovalEmail(
                                    restaurant.getOwnerEmail().trim(),
                                    restaurant.getOwnerName().trim(),
                                    restaurant.getName().trim()
                            );
                        } else if ("Rejected".equalsIgnoreCase(newStatus)) {
                            emailSent = EmailService.sendRestaurantRejectionEmail(
                                    restaurant.getOwnerEmail().trim(),
                                    restaurant.getOwnerName().trim(),
                                    restaurant.getName().trim(),
                                    reason.trim()
                            );
                        }

                        if (!emailSent) {
                            emailError = "Email service failed";
                        }
                    }

                } catch (Exception e) {
                    emailError = "Unexpected email error: " + e.getMessage();
                }

                // Build feedback message
                String message = "Restaurant status updated successfully";

                if (emailSent) {
                    message += " and notification email sent";
                } else if (emailError != null) {
                    message += " but email failed: " + emailError;
                }

                session.setAttribute("toastMessage", message);
                session.setAttribute("toastType", emailSent ? "success" : "warning");

            } else {
                session.setAttribute("toastMessage", "Failed to update restaurant status");
                session.setAttribute("toastType", "error");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid restaurant ID");
            session.setAttribute("toastType", "error");
        }

        // Preserve filters when redirecting
        String status = request.getParameter("status");
        String search = request.getParameter("search");
        String page = request.getParameter("page");
        String returnTo = request.getParameter("returnTo");

        StringBuilder redirect = new StringBuilder();

        // Decide redirect target
        if ("detail".equals(returnTo)) {
            redirect.append(request.getContextPath())
                    .append("/admin/restaurant-applications?action=detail&id=")
                    .append(URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
        } else {
            redirect.append(request.getContextPath())
                    .append("/admin/restaurant-applications?action=list");
        }

        // Append filters
        if (status != null && !status.trim().isEmpty()) {
            redirect.append("&status=").append(URLEncoder.encode(status.trim(), StandardCharsets.UTF_8));
        }
        if (search != null && !search.trim().isEmpty()) {
            redirect.append("&search=").append(URLEncoder.encode(search.trim(), StandardCharsets.UTF_8));
        }
        if (page != null && !page.trim().isEmpty()) {
            redirect.append("&page=").append(URLEncoder.encode(page.trim(), StandardCharsets.UTF_8));
        }

        response.sendRedirect(redirect.toString());
    }

    /**
     * Display detail of a restaurant application
     */
    private void handleDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String idStr = request.getParameter("id");

        // Validate ID
        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Missing restaurant ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=list");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(idStr.trim());

            RestaurantDAO restaurantDAO = new RestaurantDAO();
            Restaurant restaurant = restaurantDAO.findByIdWithOwner(restaurantId);

            if (restaurant == null) {
                session.setAttribute("toastMessage", "Restaurant not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=list");
                return;
            }

            // Pass data to view
            request.setAttribute("restaurant", restaurant);

            request.getRequestDispatcher("/views/admin/restaurant-application-detail.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid restaurant ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=list");
        }
    }
}