package controllers;

// DAO for fetching system report data
import dal.SystemReportDAO;

// Servlet libraries
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

// Model classes
import models.SystemReportRow;
import models.User;

// Map URL: /admin/system-report
@WebServlet(name = "AdminSystemReportController", urlPatterns = {"/admin/system-report"})
public class AdminSystemReportController extends HttpServlet {

    /**
     * Handle GET requests:
     * - View system report (default)
     * - Export report as CSV
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get current session (do not create new)
        HttpSession session = request.getSession(false);

        // Get logged-in user
        User currentUser = session == null ? null : (User) session.getAttribute("user");

        // Authorization check: only admin
        if (currentUser == null || currentUser.getRoleID() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get action parameter (view or export)
        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            action = "view";
        }

        // Default date range: last 7 days
        LocalDate today = LocalDate.now();
        LocalDate defaultFrom = today.minusDays(6);
        LocalDate defaultTo = today;

        LocalDate from = defaultFrom;
        LocalDate to = defaultTo;

        String fromStr = request.getParameter("from");
        String toStr = request.getParameter("to");

        // Parse date input safely
        try {
            if (fromStr != null && !fromStr.trim().isEmpty()) {
                from = LocalDate.parse(fromStr.trim());
            }
            if (toStr != null && !toStr.trim().isEmpty()) {
                to = LocalDate.parse(toStr.trim());
            }
        } catch (DateTimeParseException ex) {
            // Fallback to default range if invalid input
            from = defaultFrom;
            to = defaultTo;
        }

        // Ensure from <= to
        if (to.isBefore(from)) {
            LocalDate tmp = from;
            from = to;
            to = tmp;
        }

        SystemReportDAO dao = new SystemReportDAO();

        // Fetch report data from database
        List<SystemReportRow> rows =
                dao.getDailyReport(Date.valueOf(from), Date.valueOf(to));

        // Aggregate summary values
        int totalOrders = 0;
        int completedOrders = 0;
        BigDecimal revenue = BigDecimal.ZERO;
        int newRestaurants = 0;
        int newUsers = 0;
        int newComplaints = 0;

        for (SystemReportRow r : rows) {
            totalOrders += r.getTotalOrders();
            completedOrders += r.getCompletedOrders();

            // Null-safe revenue calculation
            revenue = revenue.add(
                    r.getRevenue() == null ? BigDecimal.ZERO : r.getRevenue()
            );

            newRestaurants += r.getNewRestaurants();
            newUsers += r.getNewUsers();
            newComplaints += r.getNewComplaints();
        }

        /**
         * Export report as CSV file
         */
        if ("export".equalsIgnoreCase(action)) {

            // Set response headers for file download
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=system-report.csv");

            try (PrintWriter out = response.getWriter()) {

                // CSV header
                out.println("Date,TotalOrders,CompletedOrders,Revenue,NewRestaurants,NewUsers,NewComplaints");

                // Write each row
                for (SystemReportRow r : rows) {
                    out.print(r.getReportDate());
                    out.print(",");
                    out.print(r.getTotalOrders());
                    out.print(",");
                    out.print(r.getCompletedOrders());
                    out.print(",");
                    out.print(r.getRevenue() == null ? BigDecimal.ZERO : r.getRevenue());
                    out.print(",");
                    out.print(r.getNewRestaurants());
                    out.print(",");
                    out.print(r.getNewUsers());
                    out.print(",");
                    out.print(r.getNewComplaints());
                    out.println();
                }

                out.flush();
            }
            return;
        }

        // Set data for JSP view
        request.setAttribute("rows", rows);
        request.setAttribute("from", from.toString());
        request.setAttribute("to", to.toString());

        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("completedOrders", completedOrders);
        request.setAttribute("revenue", revenue);
        request.setAttribute("newRestaurants", newRestaurants);
        request.setAttribute("newUsers", newUsers);
        request.setAttribute("newComplaints", newComplaints);

        // Forward to JSP page
        request.getRequestDispatcher("/views/admin/system-report.jsp")
                .forward(request, response);
    }
}