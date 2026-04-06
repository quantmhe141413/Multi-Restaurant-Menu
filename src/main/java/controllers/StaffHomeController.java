package controllers;

import dal.OrderDAO;
import dal.RestaurantDAO;
import dal.RestaurantTableDAO;
import models.Order;
import models.Restaurant;
import models.RestaurantTable;
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

@WebServlet(name = "StaffHomeController", urlPatterns = {"/staff/home"})
public class StaffHomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");

        if (restaurantId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        RestaurantDAO restaurantDAO = new RestaurantDAO();
        Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);
        
        RestaurantTableDAO tableDAO = new RestaurantTableDAO();
        List<RestaurantTable> tables = tableDAO.getTablesByRestaurant(restaurantId);
        
        // Check which tables have unpaid orders
        OrderDAO orderDAO = new OrderDAO();
        Map<Integer, Boolean> tableHasUnpaidOrders = new HashMap<>();
        
        for (RestaurantTable table : tables) {
            List<Order> orders = orderDAO.getOrdersByTable(table.getTableID());
            boolean hasUnpaid = orders.stream()
                .anyMatch(o -> o.getRestaurantID() == restaurantId && 
                              !"Success".equals(o.getPaymentStatus()));
            tableHasUnpaidOrders.put(table.getTableID(), hasUnpaid);
            
            // Update table status based on actual orders
            if (hasUnpaid && "Available".equals(table.getTableStatus())) {
                tableDAO.updateTableStatus(table.getTableID(), "Occupied");
                table.setTableStatus("Occupied");
            } else if (!hasUnpaid && "Occupied".equals(table.getTableStatus())) {
                tableDAO.updateTableStatus(table.getTableID(), "Available");
                table.setTableStatus("Available");
            }
        }

        // Get today's orders for the restaurant (first 50 orders)
        List<Order> orders = orderDAO.getOrdersByRestaurant(restaurantId, 1, 5);
        
        request.setAttribute("restaurant", restaurant);
        request.setAttribute("tables", tables);
        request.setAttribute("tableHasUnpaidOrders", tableHasUnpaidOrders);
        request.setAttribute("orders", orders);

        request.getRequestDispatcher("/views/staff/staff-home.jsp").forward(request, response);
    }
}
