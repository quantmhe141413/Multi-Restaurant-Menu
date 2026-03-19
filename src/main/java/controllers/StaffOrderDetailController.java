package controllers;

import com.google.gson.Gson;
import dal.OrderDAO;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;
import models.OrderItem;

@WebServlet(name = "StaffOrderDetailController", urlPatterns = {"/staff/order/detail"})
public class StaffOrderDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");

        if (restaurantId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized\"}");
            return;
        }

        // Get orderId parameter
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Missing orderId\"}");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"Invalid orderId\"}");
            return;
        }

        // Retrieve order and verify it belongs to restaurant
        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderDetailForRestaurant(orderId, restaurantId);

        if (order == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"error\": \"Order not found\"}");
            return;
        }

        // Retrieve order items
        List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(orderId);

        // Build response
        Map<String, Object> result = new HashMap<>();
        result.put("order", order);
        result.put("items", orderItems);

        // Convert to JSON
        Gson gson = new Gson();
        String json = gson.toJson(result);
        
        response.getWriter().write(json);
    }
}
