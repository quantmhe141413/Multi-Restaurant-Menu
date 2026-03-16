package controllers;

import dal.OrderDAO;
import models.Order;
import models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OwnerOrderHistoryController", urlPatterns = {"/owner/order-history"})
public class OwnerOrderHistoryController extends HttpServlet {

    private static final int PAGE_SIZE = 15;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Only owner (roleID 2) can access
        if (user.getRoleID() != 2) {
            session.setAttribute("toastMessage", "You don't have permission to view order history");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Owner can see all restaurants, Staff only sees their assigned restaurant
        Integer restaurantId = null;
        if (user.getRoleID() == 3) {
            // Staff: must be assigned to a restaurant
            restaurantId = (Integer) session.getAttribute("restaurantId");
            if (restaurantId == null) {
                session.setAttribute("toastMessage", "You must be assigned to a restaurant");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
        }
        // Owner (roleID 2): restaurantId stays null → sees all restaurants

        // Get filter parameters
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String status = request.getParameter("status");
        if (status == null || status.isEmpty()) {
            status = "All";
        }

        // Get pagination
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        OrderDAO orderDAO = new OrderDAO();

        // Get revenue statistics
        Map<String, Object> stats = orderDAO.getRevenueStatistics(restaurantId, fromDate, toDate);

        // Get orders with filters
        List<Order> orders = orderDAO.getOrdersWithFilters(restaurantId, fromDate, toDate, status, page, PAGE_SIZE);
        int totalOrders = orderDAO.countOrdersWithFilters(restaurantId, fromDate, toDate, status);
        int totalPages = (int) Math.ceil((double) totalOrders / PAGE_SIZE);

        // Set attributes
        request.setAttribute("orders", orders);
        request.setAttribute("stats", stats);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("selectedStatus", status);

        request.getRequestDispatcher("/views/owner/owner-order-history.jsp").forward(request, response);
    }
}
