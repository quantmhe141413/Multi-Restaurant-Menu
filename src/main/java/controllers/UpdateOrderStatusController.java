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
import java.io.PrintWriter;

@WebServlet(name = "UpdateOrderStatusController", urlPatterns = {"/update-order-status"})
public class UpdateOrderStatusController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);

        try (PrintWriter out = response.getWriter()) {
            User user = session != null ? (User) session.getAttribute("user") : null;

            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.write("{\"success\":false,\"message\":\"Not authenticated\"}");
                return;
            }

            if (user.getRoleID() != 3) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.write("{\"success\":false,\"message\":\"Access denied\"}");
                return;
            }

            Integer restaurantId = (Integer) session.getAttribute("restaurantId");
            if (restaurantId == null) {
                out.write("{\"success\":false,\"message\":\"Restaurant not assigned\"}");
                return;
            }

            String orderIdStr = request.getParameter("orderId");
            String newStatus = request.getParameter("status");

            if (orderIdStr == null || newStatus == null || newStatus.isEmpty()) {
                out.write("{\"success\":false,\"message\":\"Missing parameters\"}");
                return;
            }

            // Validate status
            if (!newStatus.equals("Preparing") && !newStatus.equals("Delivering")
                    && !newStatus.equals("Completed") && !newStatus.equals("Cancelled")) {
                out.write("{\"success\":false,\"message\":\"Invalid status\"}");
                return;
            }

            try {
                int orderId = Integer.parseInt(orderIdStr);
                OrderDAO orderDAO = new OrderDAO();

                // Security check: verify order belongs to this restaurant
                Order order = orderDAO.getOrderDetailForRestaurant(orderId, restaurantId);
                if (order == null) {
                    out.write("{\"success\":false,\"message\":\"Order not found or access denied\"}");
                    return;
                }

                // Update status
                boolean updated = orderDAO.updateOrderStatus(orderId, newStatus);
                if (updated) {
                    out.write("{\"success\":true,\"message\":\"Order status updated\"}");
                } else {
                    out.write("{\"success\":false,\"message\":\"Failed to update status\"}");
                }

            } catch (NumberFormatException e) {
                out.write("{\"success\":false,\"message\":\"Invalid order ID\"}");
            }

        } catch (Exception ex) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"success\":false,\"message\":\"Server error\"}");
            }
        }
    }
}
