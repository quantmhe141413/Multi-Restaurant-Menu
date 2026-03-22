package controllers;

import com.google.gson.Gson;
import dal.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;

@WebServlet(name = "StaffMarkPaidController", urlPatterns = {"/staff/order/mark-paid"})
public class StaffMarkPaidController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");

        if (restaurantId == null) {
            result.put("success", false);
            result.put("message", "Phiên đăng nhập hết hạn");
            out.print(gson.toJson(result));
            return;
        }

        // Get orderId parameter
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "Thiếu thông tin đơn hàng");
            out.print(gson.toJson(result));
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Mã đơn hàng không hợp lệ");
            out.print(gson.toJson(result));
            return;
        }

        OrderDAO orderDAO = new OrderDAO();

        // Verify order belongs to restaurant
        Order order = orderDAO.getOrderById(orderId);
        if (order == null || order.getRestaurantID() != restaurantId) {
            result.put("success", false);
            result.put("message", "Đơn hàng không tồn tại hoặc không thuộc nhà hàng này");
            out.print(gson.toJson(result));
            return;
        }

        // Check if already paid
        if ("Success".equals(order.getPaymentStatus())) {
            result.put("success", false);
            result.put("message", "Đơn hàng đã được thanh toán");
            out.print(gson.toJson(result));
            return;
        }

        // Update payment status
        try {
            boolean success = orderDAO.updateOrderPaymentStatus(
                orderId, 
                "Success", 
                new Timestamp(System.currentTimeMillis())
            );

            if (success) {
                result.put("success", true);
                result.put("message", "Đã cập nhật trạng thái thanh toán");
            } else {
                result.put("success", false);
                result.put("message", "Không thể cập nhật trạng thái thanh toán");
            }
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi hệ thống: " + e.getMessage());
        }

        out.print(gson.toJson(result));
    }
}
