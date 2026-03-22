package controllers;

import dal.InvoiceDAO;
import dal.OrderDAO;
import dal.RestaurantTableDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;
import org.json.JSONObject;

@WebServlet(name = "StaffProcessPaymentController", urlPatterns = {"/staff/table/payment"})
public class StaffProcessPaymentController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();

        try {
            HttpSession session = request.getSession();
            Integer restaurantId = (Integer) session.getAttribute("restaurantId");

            if (restaurantId == null) {
                json.put("success", false);
                json.put("message", "Phiên đăng nhập hết hạn");
                out.print(json.toString());
                return;
            }

            String tableIdParam = request.getParameter("tableId");
            String paymentMethod = request.getParameter("paymentMethod");

            if (tableIdParam == null || paymentMethod == null) {
                json.put("success", false);
                json.put("message", "Thiếu thông tin");
                out.print(json.toString());
                return;
            }

            int tableId = Integer.parseInt(tableIdParam);

            // Get all unpaid orders for this table
            OrderDAO orderDAO = new OrderDAO();
            List<Order> orders = orderDAO.getOrdersByTable(tableId);
            
            orders = orders.stream()
                .filter(o -> o.getRestaurantID() == restaurantId && "Pending".equals(o.getPaymentStatus()))
                .toList();

            if (orders.isEmpty()) {
                json.put("success", false);
                json.put("message", "Không có đơn hàng nào cần thanh toán");
                out.print(json.toString());
                return;
            }

            // Update payment status for all orders
            Timestamp paidAt = new Timestamp(System.currentTimeMillis());
            for (Order order : orders) {
                orderDAO.updateOrderPaymentStatus(order.getOrderID(), "Success", paidAt);
                orderDAO.updateOrderStatus(order.getOrderID(), "Completed");
                
                // Create invoice if not exists
                InvoiceDAO invoiceDAO = new InvoiceDAO();
                invoiceDAO.createInvoiceForOrder(order.getOrderID());
            }

            // Update table status to Available
            RestaurantTableDAO tableDAO = new RestaurantTableDAO();
            tableDAO.updateTableStatus(tableId, "Available");

            json.put("success", true);
            json.put("message", "Thanh toán thành công");

        } catch (Exception e) {
            e.printStackTrace();
            json.put("success", false);
            json.put("message", "Lỗi hệ thống: " + e.getMessage());
        }

        out.print(json.toString());
        out.flush();
    }
}
