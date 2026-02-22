package controllers;

import dal.SystemReportDAO;
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
import models.SystemReportRow;
import models.User;

@WebServlet(name = "AdminSystemReportController", urlPatterns = {"/admin/system-report"})
public class AdminSystemReportController extends HttpServlet {

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
            action = "view";
        }

        LocalDate today = LocalDate.now();
        LocalDate defaultFrom = today.minusDays(6);
        LocalDate defaultTo = today;

        LocalDate from = defaultFrom;
        LocalDate to = defaultTo;

        String fromStr = request.getParameter("from");
        String toStr = request.getParameter("to");

        try {
            if (fromStr != null && !fromStr.trim().isEmpty()) {
                from = LocalDate.parse(fromStr.trim());
            }
            if (toStr != null && !toStr.trim().isEmpty()) {
                to = LocalDate.parse(toStr.trim());
            }
        } catch (DateTimeParseException ex) {
            from = defaultFrom;
            to = defaultTo;
        }

        if (to.isBefore(from)) {
            LocalDate tmp = from;
            from = to;
            to = tmp;
        }

        SystemReportDAO dao = new SystemReportDAO();
        List<SystemReportRow> rows = dao.getDailyReport(Date.valueOf(from), Date.valueOf(to));

        int totalOrders = 0;
        int completedOrders = 0;
        BigDecimal revenue = BigDecimal.ZERO;
        int newRestaurants = 0;
        int newUsers = 0;
        int newComplaints = 0;

        for (SystemReportRow r : rows) {
            totalOrders += r.getTotalOrders();
            completedOrders += r.getCompletedOrders();
            revenue = revenue.add(r.getRevenue() == null ? BigDecimal.ZERO : r.getRevenue());
            newRestaurants += r.getNewRestaurants();
            newUsers += r.getNewUsers();
            newComplaints += r.getNewComplaints();
        }

        if ("export".equalsIgnoreCase(action)) {
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=system-report.csv");

            try (PrintWriter out = response.getWriter()) {
                out.println("Date,TotalOrders,CompletedOrders,Revenue,NewRestaurants,NewUsers,NewComplaints");
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

        request.setAttribute("rows", rows);
        request.setAttribute("from", from.toString());
        request.setAttribute("to", to.toString());

        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("completedOrders", completedOrders);
        request.setAttribute("revenue", revenue);
        request.setAttribute("newRestaurants", newRestaurants);
        request.setAttribute("newUsers", newUsers);
        request.setAttribute("newComplaints", newComplaints);

        request.getRequestDispatcher("/views/admin/system-report.jsp").forward(request, response);
    }
}
