package controllers;

// DAO for database operations
import dal.ComplaintDAO;

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
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

// Model classes
import models.ComplaintView;
import models.User;

// Map URL: /admin/complaints
@WebServlet(name = "AdminComplaintController", urlPatterns = {"/admin/complaints"})
public class AdminComplaintController extends HttpServlet {

    /**
     * Handle GET requests (list complaints, view detail)
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
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        // Route request
        switch (action) {
            case "detail":
                handleDetail(request, response); // Show complaint detail
                break;
            case "list":
            default:
                handleList(request, response); // Show complaint list
                break;
        }
    }

    /**
     * Handle POST requests (update complaint status)
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
                handleUpdate(request, response, currentUser); // Update status
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
                break;
        }
    }

    /**
     * Display complaint list with filters and pagination
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Filters
        String statusFilter = request.getParameter("status");
        String searchFilter = request.getParameter("search");
        String fromStr = request.getParameter("from");
        String toStr = request.getParameter("to");

        // Convert date filters to Timestamp
        Timestamp fromTs = null;
        Timestamp toExclusive = null;

        try {
            if (fromStr != null && !fromStr.trim().isEmpty()) {
                LocalDate fromDate = LocalDate.parse(fromStr.trim());
                fromTs = Timestamp.valueOf(fromDate.atStartOfDay());
            }

            if (toStr != null && !toStr.trim().isEmpty()) {
                LocalDate toDate = LocalDate.parse(toStr.trim());

                // Use exclusive end (next day at 00:00)
                LocalDateTime endExclusive = toDate.plusDays(1).atStartOfDay();
                toExclusive = Timestamp.valueOf(endExclusive);
            }
        } catch (DateTimeParseException ex) {
            // Invalid date input → ignore filters
            fromTs = null;
            toExclusive = null;
        }

        // Pagination
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

        ComplaintDAO dao = new ComplaintDAO();

        // Get filtered complaints
        List<ComplaintView> complaints = dao
                .findComplaintsWithFilters(statusFilter, searchFilter, fromTs, toExclusive, page, pageSize);

        // Get total count
        int total = dao.getTotalComplaints(statusFilter, searchFilter, fromTs, toExclusive);

        // Calculate total pages
        int totalPages = (int) Math.ceil((double) total / pageSize);

        // Set attributes for view
        request.setAttribute("complaints", complaints);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalComplaints", total);

        // Forward to JSP
        request.getRequestDispatcher("/views/admin/complaint-list.jsp")
                .forward(request, response);
    }

    /**
     * Show detail of a specific complaint
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
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
                return;
            }

            // Pass data to view
            request.setAttribute("complaint", complaint);

            request.getRequestDispatcher("/views/admin/complaint-detail.jsp")
                    .forward(request, response);

        } catch (NumberFormatException ex) {
            session.setAttribute("toastMessage", "Invalid complaint ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
        }
    }

    /**
     * Update complaint status
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {

        HttpSession session = request.getSession();

        String idStr = request.getParameter("id");
        String status = request.getParameter("status");

        // Validate input
        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Missing complaint ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
            return;
        }

        if (status == null || status.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Status is required");
            session.setAttribute("toastType", "error");

            response.sendRedirect(request.getContextPath()
                    + "/admin/complaints?action=detail&id="
                    + URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());

            ComplaintDAO dao = new ComplaintDAO();

            // Update status in database
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
        response.sendRedirect(request.getContextPath()
                + "/admin/complaints?action=detail&id="
                + URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
    }
}