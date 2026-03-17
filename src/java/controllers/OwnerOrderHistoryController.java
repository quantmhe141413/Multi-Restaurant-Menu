package controllers;

import dal.OrderDAO;
import dal.RestaurantDAO;
import models.Order;
import models.Restaurant;
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

        // Load restaurants owned by this owner for filtering
        RestaurantDAO restaurantDAO = new RestaurantDAO();
        List<Restaurant> ownerRestaurants = restaurantDAO.getRestaurantsByOwnerId(user.getUserID());
        request.setAttribute("restaurants", ownerRestaurants);

        // Restaurant filter (owner can choose a specific restaurant or all)
        Integer restaurantId = null;
        String restaurantIdStr = request.getParameter("restaurantId");
        if (restaurantIdStr != null && !restaurantIdStr.trim().isEmpty() && !"All".equalsIgnoreCase(restaurantIdStr.trim())) {
            try {
                int parsed = Integer.parseInt(restaurantIdStr.trim());
                boolean owned = false;
                for (Restaurant r : ownerRestaurants) {
                    if (r.getRestaurantId() != null && r.getRestaurantId() == parsed) {
                        owned = true;
                        break;
                    }
                }
                if (owned) {
                    restaurantId = parsed;
                }
            } catch (NumberFormatException ignore) {
                restaurantId = null;
            }
        }
        request.setAttribute("selectedRestaurantId", restaurantId);
        request.setAttribute("isAllRestaurants", restaurantId == null);

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
