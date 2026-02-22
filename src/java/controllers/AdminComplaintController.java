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
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import models.ComplaintView;
import models.User;

@WebServlet(name = "AdminComplaintController", urlPatterns = {"/admin/complaints"})
public class AdminComplaintController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRoleID() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRoleID() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
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

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusFilter = request.getParameter("status");
        String searchFilter = request.getParameter("search");
        String fromStr = request.getParameter("from");
        String toStr = request.getParameter("to");

        Timestamp fromTs = null;
        Timestamp toExclusive = null;
        try {
            if (fromStr != null && !fromStr.trim().isEmpty()) {
                LocalDate fromDate = LocalDate.parse(fromStr.trim());
                fromTs = Timestamp.valueOf(fromDate.atStartOfDay());
            }
            if (toStr != null && !toStr.trim().isEmpty()) {
                LocalDate toDate = LocalDate.parse(toStr.trim());
                LocalDateTime endExclusive = toDate.plusDays(1).atStartOfDay();
                toExclusive = Timestamp.valueOf(endExclusive);
            }
        } catch (DateTimeParseException ex) {
            fromTs = null;
            toExclusive = null;
        }

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
        List<ComplaintView> complaints = dao.findComplaintsWithFilters(statusFilter, searchFilter, fromTs, toExclusive, page, pageSize);
        int total = dao.getTotalComplaints(statusFilter, searchFilter, fromTs, toExclusive);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("complaints", complaints);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalComplaints", total);

        request.getRequestDispatcher("/views/admin/complaint-list.jsp").forward(request, response);
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String idStr = request.getParameter("id");
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
            if (complaint == null) {
                session.setAttribute("toastMessage", "Complaint not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
                return;
            }

            request.setAttribute("complaint", complaint);
            request.getRequestDispatcher("/views/admin/complaint-detail.jsp").forward(request, response);
        } catch (NumberFormatException ex) {
            session.setAttribute("toastMessage", "Invalid complaint ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        HttpSession session = request.getSession();

        String idStr = request.getParameter("id");
        String status = request.getParameter("status");

        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Missing complaint ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/complaints?action=list");
            return;
        }

        if (status == null || status.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Status is required");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/complaints?action=detail&id=" + URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            ComplaintDAO dao = new ComplaintDAO();
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

        response.sendRedirect(request.getContextPath() + "/admin/complaints?action=detail&id=" + URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
    }
}
