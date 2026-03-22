package controllers;

import dal.MenuDAO;
import dal.OrderDAO;
import dal.RestaurantTableDAO;
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
import models.MenuCategory;
import models.MenuItem;
import models.Order;
import models.OrderItem;
import models.RestaurantTable;

@WebServlet(name = "StaffTableOrderController", urlPatterns = {"/staff/table/order"})
public class StaffTableOrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");

        if (restaurantId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String tableIdParam = request.getParameter("tableId");
        if (tableIdParam == null || tableIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/home");
            return;
        }

        try {
            int tableId = Integer.parseInt(tableIdParam);

            // Get table info
            RestaurantTableDAO tableDAO = new RestaurantTableDAO();
            RestaurantTable table = tableDAO.getTableById(tableId, restaurantId);

            if (table == null || table.getRestaurantID() != restaurantId) {
                response.sendRedirect(request.getContextPath() + "/staff/home");
                return;
            }

            // Get orders for this table (chưa thanh toán)
            OrderDAO orderDAO = new OrderDAO();
            List<Order> orders = orderDAO.getOrdersByTable(tableId);
            
            // Filter unpaid orders
            orders = orders.stream()
                .filter(o -> o.getRestaurantID() == restaurantId && !"Success".equals(o.getPaymentStatus()))
                .toList();

            // Get order items for each order
            Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();
            for (Order order : orders) {
                List<OrderItem> items = orderDAO.getOrderItemsByOrderId(order.getOrderID());
                orderItemsMap.put(order.getOrderID(), items);
            }

            // Get menu categories
            MenuDAO menuDAO = new MenuDAO();
            List<MenuCategory> categories = menuDAO.getCategoriesByRestaurant(restaurantId);
            
            // Get menu items for each category
            Map<Integer, List<MenuItem>> categoryItemsMap = new HashMap<>();
            for (MenuCategory category : categories) {
                List<MenuItem> items = menuDAO.getMenuItemsByCategory(category.getCategoryID());
                categoryItemsMap.put(category.getCategoryID(), items);
            }

            request.setAttribute("table", table);
            request.setAttribute("orders", orders);
            request.setAttribute("orderItemsMap", orderItemsMap);
            request.setAttribute("categories", categories);
            request.setAttribute("categoryItemsMap", categoryItemsMap);

            request.getRequestDispatcher("/views/staff/staff-table-order.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/home");
        }
    }
}
