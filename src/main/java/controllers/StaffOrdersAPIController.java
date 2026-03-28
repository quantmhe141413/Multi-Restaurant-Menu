package controllers;

import dal.OrderDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;

@WebServlet(name = "StaffOrdersAPIController", urlPatterns = {"/staff/orders"})
public class StaffOrdersAPIController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");

        System.out.println("StaffOrdersAPIController - restaurantId from session: " + restaurantId);

        if (restaurantId == null) {
            System.out.println("StaffOrdersAPIController - restaurantId is null, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if viewing orders for a specific table
        String tableIdParam = request.getParameter("tableId");
        if (tableIdParam != null && !tableIdParam.trim().isEmpty()) {
            try {
                int tableId = Integer.parseInt(tableIdParam);
                showTableOrders(request, response, tableId, restaurantId);
                return;
            } catch (NumberFormatException e) {
                // Invalid tableId, continue with normal order history
            }
        }

        // Get filter parameters
        String fromDateParam = request.getParameter("fromDate");
        String toDateParam = request.getParameter("toDate");
        String orderTypeFilter = request.getParameter("orderType");
        String pageParam = request.getParameter("page");

        // Default values
        if (orderTypeFilter == null || orderTypeFilter.trim().isEmpty()) {
            orderTypeFilter = "All";
        }
        
        // Parse dates
        String fromDate = null;
        String toDate = null;
        if (fromDateParam != null && !fromDateParam.trim().isEmpty()) {
            fromDate = fromDateParam;
        }
        if (toDateParam != null && !toDateParam.trim().isEmpty()) {
            toDate = toDateParam;
        }

        int currentPage = 1;
        try {
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        // Prepare filter values for DAO
        String orderTypeForQuery = "All".equals(orderTypeFilter) ? null : orderTypeFilter;

        // Get orders with filters
        OrderDAO orderDAO = new OrderDAO();

        int totalCheck = orderDAO.countOrdersWithFilters(restaurantId, fromDate, toDate, null);
        System.out.println("[StaffOrders] restaurantId=" + restaurantId + " fromDate=" + fromDate + " toDate=" + toDate + " totalCount=" + totalCheck);

        List<Order> orders = orderDAO.getOrdersWithFilters(
            restaurantId,
            fromDate,
            toDate,
            null, // status - không filter theo status nữa
            currentPage,
            PAGE_SIZE
        );
        System.out.println("[StaffOrders] orders returned=" + orders.size());

        // Apply orderType filter manually if needed
        if (orderTypeForQuery != null) {
            orders = orders.stream()
                .filter(o -> orderTypeForQuery.equals(o.getOrderType()))
                .toList();
        }

        // Get total count for pagination
        int totalOrders = orderDAO.countOrdersWithFilters(restaurantId, fromDate, toDate, null);
        int totalPages = (int) Math.ceil((double) totalOrders / PAGE_SIZE);

        // Set attributes
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("orderTypeFilter", orderTypeFilter);

        // Forward to JSP fragment
        request.getRequestDispatcher("/views/staff/staff-orders-table.jsp").forward(request, response);
    }

    private void showTableOrders(HttpServletRequest request, HttpServletResponse response, 
                                 int tableId, int restaurantId) 
            throws ServletException, IOException {
        
        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = orderDAO.getOrdersByTable(tableId);
        
        // Filter to only show orders from this restaurant
        orders = orders.stream()
            .filter(o -> o.getRestaurantID() == restaurantId)
            .toList();

        // Set attributes
        request.setAttribute("orders", orders);
        request.setAttribute("tableId", tableId);
        request.setAttribute("isTableView", true);
        request.setAttribute("currentPage", 1);
        request.setAttribute("totalPages", 1);
        request.setAttribute("statusFilter", "All");
        request.setAttribute("orderTypeFilter", "All");

        // Forward to JSP fragment
        request.getRequestDispatcher("/views/staff/staff-orders-table.jsp").forward(request, response);
    }
}
