package controllers;

import dal.InvoiceDAO;
import dal.OrderDAO;
import dal.RestaurantDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Invoice;
import models.Order;
import models.OrderItem;
import models.Restaurant;

@WebServlet(name = "StaffInvoiceController", urlPatterns = {"/staff/invoice"})
public class StaffInvoiceController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");

        if (restaurantId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get orderId parameter
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Không tìm thấy đơn hàng");
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Mã đơn hàng không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }

        // Retrieve order and verify it belongs to restaurant
        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderDetailForRestaurant(orderId, restaurantId);

        if (order == null) {
            request.setAttribute("error", "Đơn hàng không tồn tại hoặc không thuộc nhà hàng này");
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
            return;
        }

        // Retrieve invoice
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        Invoice invoice = invoiceDAO.findByOrderId(orderId);

        // Retrieve order items
        List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(orderId);

        // Retrieve restaurant information
        RestaurantDAO restaurantDAO = new RestaurantDAO();
        Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);

        // Set attributes for JSP
        request.setAttribute("order", order);
        request.setAttribute("invoice", invoice);
        request.setAttribute("orderItems", orderItems);
        request.setAttribute("restaurant", restaurant);

        // Forward to invoice JSP
        request.getRequestDispatcher("/views/staff/staff-invoice.jsp").forward(request, response);
    }
}
