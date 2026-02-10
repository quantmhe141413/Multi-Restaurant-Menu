package controllers;

import dal.MenuDAO;
import dal.OrderDAO;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.MenuItem;
import models.Order;
import models.OrderItem;
import models.User;

@WebServlet(name = "OrderController", urlPatterns = { "/order" })
public class OrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("cart");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Kiểm tra đăng nhập
        User user = (User) session.getAttribute("user");
        if (user == null) {
            session.setAttribute("error", "Vui lòng đăng nhập để đặt hàng!");
            response.sendRedirect("login");
            return;
        }

        // Kiểm tra role - chỉ customer mới được đặt hàng
        // Giả sử roleID = 3 là customer (cần kiểm tra lại trong database)
        if (user.getRoleID() != 3) {
            session.setAttribute("error", "Chỉ khách hàng mới có thể đặt hàng!");
            response.sendRedirect("home");
            return;
        }

        // Lấy giỏ hàng từ session
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            session.setAttribute("error", "Giỏ hàng trống!");
            response.sendRedirect("cart");
            return;
        }

        // Lấy restaurantId từ request
        String restaurantIdStr = request.getParameter("restaurantId");
        if (restaurantIdStr == null || restaurantIdStr.trim().isEmpty()) {
            session.setAttribute("error", "Thông tin nhà hàng không hợp lệ!");
            response.sendRedirect("cart");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(restaurantIdStr);
            
            // Lấy thông tin chi tiết các món ăn trong giỏ hàng
            MenuDAO menuDAO = new MenuDAO();
            double totalAmount = 0;
            
            // Kiểm tra tất cả món ăn có cùng restaurantId không
            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                MenuItem item = menuDAO.getMenuItemById(entry.getKey());
                if (item == null || !item.isIsAvailable()) {
                    session.setAttribute("error", "Một số món ăn không còn khả dụng!");
                    response.sendRedirect("cart");
                    return;
                }
                if (item.getRestaurantID() != restaurantId) {
                    session.setAttribute("error", "Tất cả món ăn phải từ cùng một nhà hàng!");
                    response.sendRedirect("cart");
                    return;
                }
                totalAmount += item.getPrice() * entry.getValue();
            }

            // Tạo đơn hàng
            Order order = new Order();
            order.setRestaurantID(restaurantId);
            order.setCustomerID(user.getUserID());
            order.setOrderType("Online"); // Mặc định là Online
            order.setOrderStatus("Pending"); // Trạng thái ban đầu
            order.setTotalAmount(totalAmount);
            order.setDiscountAmount(0); // Chưa có discount
            order.setFinalAmount(totalAmount); // Chưa có discount

            OrderDAO orderDAO = new OrderDAO();
            int orderID = orderDAO.createOrder(order);

            if (orderID > 0) {
                // Tạo các order items
                boolean allItemsCreated = true;
                for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                    MenuItem item = menuDAO.getMenuItemById(entry.getKey());
                    OrderItem orderItem = new OrderItem();
                    orderItem.setOrderID(orderID);
                    orderItem.setItemID(item.getItemID());
                    orderItem.setQuantity(entry.getValue());
                    orderItem.setUnitPrice(item.getPrice());
                    
                    if (!orderDAO.createOrderItem(orderItem)) {
                        allItemsCreated = false;
                        break;
                    }
                }

                if (allItemsCreated) {
                    // Xóa giỏ hàng sau khi đặt hàng thành công
                    cart.clear();
                    session.setAttribute("cart", cart);
                    session.setAttribute("success", "Đặt hàng thành công! Mã đơn hàng: #" + orderID);
                    response.sendRedirect("home");
                } else {
                    session.setAttribute("error", "Có lỗi xảy ra khi tạo đơn hàng!");
                    response.sendRedirect("cart");
                }
            } else {
                session.setAttribute("error", "Có lỗi xảy ra khi tạo đơn hàng!");
                response.sendRedirect("cart");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Thông tin không hợp lệ!");
            response.sendRedirect("cart");
        } catch (Exception e) {
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect("cart");
        }
    }
}
