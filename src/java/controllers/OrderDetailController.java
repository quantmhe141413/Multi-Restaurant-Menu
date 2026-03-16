package controllers;

import dal.OrderDAO;
import dal.MenuDAO;
import models.Order;
import models.OrderItem;
import models.MenuItem;
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
import java.util.HashMap;

@WebServlet(name = "OrderDetailController", urlPatterns = {"/order-detail"})
public class OrderDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (user.getRoleID() != 3) {
            session.setAttribute("toastMessage", "You don't have permission to view order details");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Integer restaurantId = (Integer) session.getAttribute("restaurantId");
        if (restaurantId == null) {
            session.setAttribute("toastMessage", "You must be assigned to a restaurant");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String orderIdStr = request.getParameter("id");
        if (orderIdStr == null || orderIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/order-management");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO = new OrderDAO();
            
            // Get order with security check
            Order order = orderDAO.getOrderDetailForRestaurant(orderId, restaurantId);
            if (order == null) {
                session.setAttribute("toastMessage", "Order not found or access denied");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/order-management");
                return;
            }

            // Get order items
            List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(orderId);
            
            // Fetch menu item details
            MenuDAO menuDAO = new MenuDAO();
            Map<Integer, MenuItem> menuItemsMap = new HashMap<>();
            for (OrderItem item : orderItems) {
                MenuItem menuItem = menuDAO.getMenuItemById(item.getItemID());
                if (menuItem != null) {
                    menuItemsMap.put(item.getItemID(), menuItem);
                }
            }

            request.setAttribute("order", order);
            request.setAttribute("orderItems", orderItems);
            request.setAttribute("menuItems", menuItemsMap);

            request.getRequestDispatcher("/views/owner/order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/order-management");
        }
    }
}
