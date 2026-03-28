package controllers;

import dal.ComplaintDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Set;
import models.ComplaintView;
import models.User;
import utils.EmailService;

/**
 * AdminComplaintController
 * 
 * This servlet manages complaint handling for admin users.
 * Only ADMIN (roleID = 1) can access this controller.
 * 
 * Main features:
 * - View complaint list (with filters & pagination)
 * - View complaint detail
 * - Update complaint status
 */
@WebServlet(name = "AdminComplaintController", urlPatterns = {"/admin/complaints"})
public class AdminComplaintController extends HttpServlet {
    private static final Set<String> ALLOWED_STATUSES = Set.of("InProgress", "Completed");

    /**
     * Handle GET requests
     * 
     * Actions:
     * - list (default): display complaints list
     * - detail: display specific complaint details
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get existing session (do not create new)
        HttpSession session = request.getSession(false);

        // Get logged-in user
        User currentUser = session == null ? null : (User) session.getAttribute("user");

        // Authorization check (admin only)
        if (currentUser == null || currentUser.getRoleID() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Determine action (default = list)
        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "detail":
                handleDetail(request, response);
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
     * - update: update complaint status
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
            response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
            return;
        }

        switch (action) {
            case "update":
                handleUpdate(request, response, currentUser);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
                break;
        }
    }

    /**
     * Display complaint list with filters and pagination
     * 
     * Filters:
     * - status (Pending, Resolved, etc.)
     * - search keyword
     * - date range (from → to)
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get filters
        String statusFilter = request.getParameter("status");
        String searchFilter = request.getParameter("search");
        String fromStr = request.getParameter("from");
        String toStr = request.getParameter("to");

        /**
         * Convert date strings → Timestamp
         * 
         * fromTs = start of day
         * toExclusive = next day start (exclusive upper bound)
         * → helps query correctly using BETWEEN logic
         */
        Timestamp fromTs = null;
        Timestamp toExclusive = null;

        try {
            if (fromStr != null && !fromStr.trim().isEmpty()) {
                LocalDate fromDate = LocalDate.parse(fromStr.trim());
                fromTs = Timestamp.valueOf(fromDate.atStartOfDay());
            }

            if (toStr != null && !toStr.trim().isEmpty()) {
                LocalDate toDate = LocalDate.parse(toStr.trim());

                // Add 1 day → exclusive end boundary
                LocalDateTime endExclusive = toDate.plusDays(1).atStartOfDay();
                toExclusive = Timestamp.valueOf(endExclusive);
            }

        } catch (DateTimeParseException ex) {
            // Invalid date → ignore filter
            fromTs = null;
            toExclusive = null;
        }

        /**
         * Pagination logic
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
         * Fetch data from DAO
         */
        ComplaintDAO dao = new ComplaintDAO();

        List<ComplaintView> complaints =
                dao.findComplaintsWithFilters(statusFilter, searchFilter, fromTs, toExclusive, page, pageSize);

        int total =
                dao.getTotalComplaints(statusFilter, searchFilter, fromTs, toExclusive);

        int totalPages = (int) Math.ceil((double) total / pageSize);

        /**
         * Pass data to JSP
         */
        request.setAttribute("complaints", complaints);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalComplaints", total);

        // Forward to list view
        request.getRequestDispatcher("/views/admin/complaint-list.jsp")
               .forward(request, response);
    }

    /**
     * Display detail of a specific complaint
     */
    private void handleDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String idStr = request.getParameter("id");

        // Validate ID
        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Missing complaint ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());

            ComplaintDAO dao = new ComplaintDAO();
            ComplaintView complaint = dao.findById(id);

            // Check existence
            if (complaint == null) {
                session.setAttribute("toastMessage", "Complaint not found");
                response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
                return;
            }

            // Pass data to view
            request.setAttribute("complaint", complaint);

            // Forward to detail page
            request.getRequestDispatcher("/views/admin/complaint-detail.jsp")
                   .forward(request, response);

        } catch (NumberFormatException ex) {
            session.setAttribute("toastMessage", "Invalid complaint ID");
            response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
        }
    }

    /**
     * Handle updating complaint status
     * 
     * Steps:
     * 1. Validate input
     * 2. Update status in DB
     * 3. Show result message
     * 4. Redirect back to detail page
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {

        HttpSession session = request.getSession();

        String idStr = request.getParameter("id");
        String status = request.getParameter("status");
        String note = request.getParameter("note");
        String noteTrimmed = note == null ? "" : note.trim();

        // Validate ID
        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Missing complaint ID");
            response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
            return;
        }

        // Validate status
        if (status == null || status.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Status is required");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/complaints?action=detail&id=" +
                    URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
            return;
        }
        status = status.trim();
        if (!ALLOWED_STATUSES.contains(status)) {
            session.setAttribute("toastMessage", "Invalid complaint status");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/complaints?action=detail&id=" +
                    URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
            return;
        }
        if (noteTrimmed.isEmpty()) {
            session.setAttribute("toastMessage", "Admin note is required");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/complaints?action=detail&id=" +
                    URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());

            ComplaintDAO dao = new ComplaintDAO();
            ComplaintView complaint = dao.findById(id);
            if (complaint == null) {
                session.setAttribute("toastMessage", "Complaint not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
                return;
            }

            String ownerEmail = complaint.getRestaurantOwnerEmail();
            String ownerName = complaint.getRestaurantOwnerName();
            String restaurantName = complaint.getRestaurantName();

            if (ownerEmail == null || ownerEmail.trim().isEmpty()) {
                session.setAttribute("toastMessage", "Cannot send email because restaurant owner email is missing");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/complaints?action=detail&id=" +
                        URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
                return;
            }

            boolean emailSent = EmailService.sendComplaintStatusEmail(
                    ownerEmail.trim(),
                    ownerName,
                    restaurantName,
                    complaint.getComplaintID(),
                    status,
                    noteTrimmed
            );
            if (!emailSent) {
                session.setAttribute("toastMessage", "Failed to send email to restaurant owner. Complaint status was not updated.");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/complaints?action=detail&id=" +
                        URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
                return;
            }

            // Update complaint status
            boolean ok = dao.updateComplaintStatus(id, status);

            if (ok) {
                session.setAttribute("toastMessage", "Complaint updated successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to update complaint");
                session.setAttribute("toastType", "error");
            }

        } catch (NumberFormatException ex) {
            session.setAttribute("toastMessage", "Invalid complaint ID");
            session.setAttribute("toastType", "error");
        }

        // Redirect back to detail page
        response.sendRedirect(
                request.getContextPath() +
                "/admin/complaints?action=detail&id=" +
                URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8)
        );
    }
}