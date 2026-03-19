package controllers;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import dal.DiscountDAO;
import dal.InvoiceDAO;
import dal.MenuDAO;
import dal.OrderDAO;
import dal.RestaurantDAO;
import dal.RestaurantTableDAO;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Discount;
import models.MenuItem;
import models.Order;
import models.OrderItem;
import models.Restaurant;

@WebServlet(name = "StaffOrderController", urlPatterns = {"/staff/order/create"})
public class StaffOrderController extends HttpServlet {

    // DTO for cart items from frontend
    static class CartItemDTO {
        int itemId;
        String itemName;
        double unitPrice;
        int quantity;
        String note;
        double lineTotal;
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");

        if (restaurantId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get form parameters
            String tableIdParam = request.getParameter("tableId");
            String orderType = request.getParameter("orderType");
            String deliveryAddress = request.getParameter("deliveryAddress");
            String discountCode = request.getParameter("discountCode");
            String paymentMethod = request.getParameter("paymentMethod");
            String cartItemsJson = request.getParameter("cartItems");

            // Validate required fields
            if (orderType == null || orderType.trim().isEmpty()) {
                setErrorAndRedirect(request, response, "Vui lòng chọn loại đơn hàng");
                return;
            }

            // Validate delivery address for Online orders
            if ("Online".equals(orderType) && (deliveryAddress == null || deliveryAddress.trim().isEmpty())) {
                setErrorAndRedirect(request, response, "Vui lòng nhập địa chỉ giao hàng");
                return;
            }

            // Parse cart items
            Gson gson = new Gson();
            List<CartItemDTO> cartItems = gson.fromJson(cartItemsJson, new TypeToken<List<CartItemDTO>>(){}.getType());

            if (cartItems == null || cartItems.isEmpty()) {
                setErrorAndRedirect(request, response, "Giỏ hàng trống, vui lòng chọn món ăn");
                return;
            }

            // Validate all menu items are still available
            MenuDAO menuDAO = new MenuDAO();
            for (CartItemDTO item : cartItems) {
                MenuItem menuItem = menuDAO.getMenuItemById(item.itemId);
                if (menuItem == null || !menuItem.isIsAvailable()) {
                    setErrorAndRedirect(request, response, "Món " + item.itemName + " hiện không còn phục vụ");
                    return;
                }
            }

            // Calculate TotalAmount
            double totalAmount = 0;
            for (CartItemDTO item : cartItems) {
                totalAmount += item.quantity * item.unitPrice;
            }

            // Validate and apply discount
            double discountAmount = 0;
            Integer discountId = null;
            if (discountCode != null && !discountCode.trim().isEmpty()) {
                DiscountDAO discountDAO = new DiscountDAO();
                Discount discount = discountDAO.findValidDiscount(discountCode.trim(), restaurantId);
                
                if (discount == null) {
                    setErrorAndRedirect(request, response, "Mã giảm giá không hợp lệ hoặc đã hết hạn");
                    return;
                }

                discountId = discount.getDiscountID();
                
                // Calculate discount amount
                if ("Percentage".equals(discount.getDiscountType())) {
                    discountAmount = totalAmount * discount.getDiscountValue() / 100;
                    // Apply max discount cap if set
                    if (discount.getMaxDiscountAmount() != null && discountAmount > discount.getMaxDiscountAmount()) {
                        discountAmount = discount.getMaxDiscountAmount();
                    }
                } else if ("Fixed".equals(discount.getDiscountType())) {
                    discountAmount = discount.getDiscountValue();
                }
            }

            // Get delivery fee for Online orders
            double deliveryFee = 0;
            if ("Online".equals(orderType)) {
                RestaurantDAO restaurantDAO = new RestaurantDAO();
                Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);
                if (restaurant != null && restaurant.getDeliveryFee() != null) {
                    deliveryFee = restaurant.getDeliveryFee();
                }
            }

            // Calculate final amount
            double finalAmount = totalAmount - discountAmount + deliveryFee;

            // Create Order object
            Order order = new Order();
            order.setRestaurantID(restaurantId);
            order.setOrderType(orderType);
            order.setOrderStatus("Preparing");
            order.setTotalAmount(totalAmount);
            order.setDiscountAmount(discountAmount);
            order.setDeliveryFee(deliveryFee);
            order.setFinalAmount(finalAmount);
            order.setPaymentMethod(paymentMethod);
            
            // Luôn set payment status là Pending khi tạo order
            // Staff sẽ xác nhận thanh toán sau
            order.setPaymentStatus("Pending");

            if (discountId != null) {
                order.setDiscountID(discountId);
            }

            // Set table ID for DineIn orders
            Integer tableId = null;
            if ("DineIn".equals(orderType) && tableIdParam != null && !tableIdParam.trim().isEmpty()) {
                try {
                    tableId = Integer.parseInt(tableIdParam);
                    order.setTableID(tableId);
                } catch (NumberFormatException e) {
                    // Ignore invalid table ID
                }
            }

            // Create order with default customer info (Walk-in customer)
            OrderDAO orderDAO = new OrderDAO();
            int orderId = orderDAO.createOrderForStaff(order, "Khách lẻ", "0000000000", 
                                                       "Online".equals(orderType) ? deliveryAddress : null);

            if (orderId <= 0) {
                setErrorAndRedirect(request, response, "Lỗi hệ thống, vui lòng thử lại");
                return;
            }

            // Create OrderItems
            for (CartItemDTO item : cartItems) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderID(orderId);
                orderItem.setItemID(item.itemId);
                orderItem.setQuantity(item.quantity);
                orderItem.setUnitPrice(item.unitPrice);
                orderItem.setNote(item.note);
                
                orderDAO.createOrderItem(orderItem);
            }

            // Update table status to Occupied for DineIn orders
            if ("DineIn".equals(orderType) && tableId != null) {
                RestaurantTableDAO tableDAO = new RestaurantTableDAO();
                tableDAO.updateTableStatus(tableId, "Occupied");
            }

            // Create Invoice
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            invoiceDAO.createInvoiceForOrder(orderId);

            // Clear cart from session
            session.removeAttribute("cart");

            // Redirect về trang xem order của bàn (để có thể thêm món hoặc thanh toán)
            if ("DineIn".equals(orderType) && tableId != null) {
                response.sendRedirect(request.getContextPath() + "/staff/table/order?tableId=" + tableId);
            } else {
                // Với Pickup/Online, redirect về danh sách đơn hàng
                response.sendRedirect(request.getContextPath() + "/staff/home");
            }

        } catch (Exception e) {
            e.printStackTrace();
            setErrorAndRedirect(request, response, "Lỗi hệ thống, vui lòng thử lại");
        }
    }

    private void setErrorAndRedirect(HttpServletRequest request, HttpServletResponse response, String errorMessage) 
            throws IOException {
        HttpSession session = request.getSession();
        session.setAttribute("orderError", errorMessage);
        
        // Get tableId to redirect back to POS
        String tableId = request.getParameter("tableId");
        if (tableId != null && !tableId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/pos?tableId=" + tableId);
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/tables");
        }
    }
}
