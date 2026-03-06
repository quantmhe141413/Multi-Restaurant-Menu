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
import dal.DiscountDAO;
import models.Discount;

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
        if (user.getRoleID() != 4) {
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

        // Lấy restaurantId và paymentMethod từ request
        String restaurantIdStr = request.getParameter("restaurantId");
        String paymentMethod = request.getParameter("paymentMethod");
        
        if (restaurantIdStr == null || restaurantIdStr.trim().isEmpty()) {
            session.setAttribute("error", "Thông tin nhà hàng không hợp lệ!");
            response.sendRedirect("cart");
            return;
        }
        
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "COD"; // Default to COD
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

            // Read discount info from request (optional)
            String discountIdStr = request.getParameter("discountId");
            String discountAmountStr = request.getParameter("discountAmount");
            String finalAmountStr = request.getParameter("finalAmount");

            Integer discountId = null;
            double discountAmount = 0;
            double finalAmount = totalAmount;

            if (discountIdStr != null && !discountIdStr.trim().isEmpty()) {
                try {
                    discountId = Integer.parseInt(discountIdStr);
                } catch (NumberFormatException ex) {
                    // ignore invalid discount id, treat as no discount
                    discountId = null;
                }
            }

            if (discountAmountStr != null && !discountAmountStr.trim().isEmpty()) {
                try {
                    discountAmount = Double.parseDouble(discountAmountStr);
                } catch (NumberFormatException ex) {
                    discountAmount = 0;
                }
            }

            if (finalAmountStr != null && !finalAmountStr.trim().isEmpty()) {
                try {
                    finalAmount = Double.parseDouble(finalAmountStr);
                } catch (NumberFormatException ex) {
                    finalAmount = totalAmount - discountAmount;
                }
            } else {
                finalAmount = totalAmount - discountAmount;
            }

            if (finalAmount < 0) {
                finalAmount = 0;
            }

            // check constraints and apply discount if any
            if (discountId != null) {
                DiscountDAO dDao = new DiscountDAO();
                Discount discount = dDao.findDiscountById(discountId);
                if (discount == null || !discount.isIsActive() || discount.getQuantity() <= 0) {
                    session.setAttribute("error", "Mã giảm giá không hợp lệ hoặc đã hết lượt sử dụng!");
                    response.sendRedirect("cart");
                    return;
                }
                if (discount.getMinOrderAmount() != null && totalAmount < discount.getMinOrderAmount()) {
                    session.setAttribute("error", "Đơn hàng chưa đạt giá trị tối thiểu để dùng mã giảm giá này!");
                    response.sendRedirect("cart");
                    return;
                }
                if (discount.getUsageLimitPerUser() > 0) {
                    int usageCount = dDao.countUserUsage(discountId, user.getUserID());
                    if (usageCount >= discount.getUsageLimitPerUser()) {
                        session.setAttribute("error", "Bạn đã hết lượt dùng mã giảm giá này!");
                        response.sendRedirect("cart");
                        return;
                    }
                }
                
                // attempt to reduce quantity
                boolean reduced = dDao.decreaseQuantity(discountId);
                if (!reduced) {
                    session.setAttribute("error", "Mã giảm giá vừa hết lượt sử dụng!");
                    response.sendRedirect("cart");
                    return;
                }
            }

            // Tạo đơn hàng
            Order order = new Order();
            order.setRestaurantID(restaurantId);
            order.setCustomerID(user.getUserID());
            order.setOrderType("Online");
            order.setOrderStatus("Preparing");
            order.setTotalAmount(totalAmount);
            order.setDiscountID(discountId);
            order.setDiscountAmount(discountAmount);
            order.setFinalAmount(finalAmount);
            order.setPaymentMethod(paymentMethod);
            order.setPaymentStatus("Pending");

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
                // Check payment method
                if ("VNPay".equalsIgnoreCase(paymentMethod)) {
                    // Redirect to payment gateway
                    response.sendRedirect("payment?orderId=" + orderID);
                } else {
                        // COD payment - clear cart and show success
                        cart.clear();
                        session.setAttribute("cart", cart);
                        session.setAttribute("success", "Đặt hàng thành công! Mã đơn hàng: #" + orderID + ". Bạn sẽ thanh toán khi nhận hàng.");
                        response.sendRedirect("order-history");
                    }
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
