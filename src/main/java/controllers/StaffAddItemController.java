package controllers;

import dal.MenuDAO;
import dal.OrderDAO;
import dal.RestaurantTableDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.MenuItem;
import models.Order;
import models.RestaurantTable;
import org.json.JSONObject;

@WebServlet(name = "StaffAddItemController", urlPatterns = {"/staff/order/add-item"})
public class StaffAddItemController extends HttpServlet {

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
                json.put("message", "Vui lòng đăng nhập");
                out.print(json.toString());
                return;
            }

            // Get parameters
            String tableIdParam = request.getParameter("tableId");
            String itemIdParam = request.getParameter("itemId");
            String quantityParam = request.getParameter("quantity");
            String note = request.getParameter("note");

            if (tableIdParam == null || itemIdParam == null || quantityParam == null) {
                json.put("success", false);
                json.put("message", "Thiếu thông tin");
                out.print(json.toString());
                return;
            }

            int tableId = Integer.parseInt(tableIdParam);
            int itemId = Integer.parseInt(itemIdParam);
            int quantity = Integer.parseInt(quantityParam);

            // Verify table belongs to restaurant
            RestaurantTableDAO tableDAO = new RestaurantTableDAO();
            RestaurantTable table = tableDAO.getTableById(tableId, restaurantId);

            if (table == null || table.getRestaurantID() != restaurantId) {
                json.put("success", false);
                json.put("message", "Bàn không hợp lệ");
                out.print(json.toString());
                return;
            }

            // Get menu item info
            MenuDAO menuDAO = new MenuDAO();
            MenuItem menuItem = menuDAO.getMenuItemById(itemId);

            if (menuItem == null) {
                json.put("success", false);
                json.put("message", "Món ăn không tồn tại");
                out.print(json.toString());
                return;
            }

            // Get or create order for this table
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getActiveOrderByTable(tableId, restaurantId);

            if (order == null) {
                // Create new order
                order = new Order();
                order.setRestaurantID(restaurantId);
                order.setTableID(tableId);
                order.setOrderType("DineIn");
                order.setPaymentMethod("Cash");
                order.setPaymentStatus("Pending");
                order.setOrderStatus("Pending");
                
                int orderId = orderDAO.createOrder(order);
                if (orderId <= 0) {
                    json.put("success", false);
                    json.put("message", "Lỗi tạo đơn hàng");
                    out.print(json.toString());
                    return;
                }
                order.setOrderID(orderId);
            }

            // Add item to order
            boolean added = orderDAO.addOrderItem(
                order.getOrderID(),
                itemId,
                quantity,
                menuItem.getPrice(),
                note != null ? note : ""
            );

            if (added) {
                // Update order total
                orderDAO.updateOrderTotal(order.getOrderID());
                
                json.put("success", true);
                json.put("message", "Thêm món thành công");
            } else {
                json.put("success", false);
                json.put("message", "Lỗi thêm món");
            }

        } catch (NumberFormatException e) {
            json.put("success", false);
            json.put("message", "Dữ liệu không hợp lệ");
        } catch (Exception e) {
            json.put("success", false);
            json.put("message", "Lỗi hệ thống: " + e.getMessage());
            e.printStackTrace();
        }

        out.print(json.toString());
        out.flush();
    }
}
