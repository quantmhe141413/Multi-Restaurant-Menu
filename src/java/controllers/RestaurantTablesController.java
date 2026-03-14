package controllers;

import dal.RestaurantDAO;
import models.RestaurantTable;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "RestaurantTablesController", urlPatterns = { "/restaurant-tables" })
public class RestaurantTablesController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");
        if (restaurantId == null) {
            response.sendRedirect("login");
            return;
        }
        RestaurantDAO dao = new RestaurantDAO();
        List<RestaurantTable> tables = dao.getTablesByRestaurant(restaurantId);
        request.setAttribute("tables", tables);
        request.getRequestDispatcher("views/restaurant-tables-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");
        if (restaurantId == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        RestaurantDAO dao = new RestaurantDAO();

        if ("create".equals(action)) {
            String tableNumber = request.getParameter("tableNumber");
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            String status = request.getParameter("tableStatus");
            RestaurantTable t = new RestaurantTable();
            t.setRestaurantID(restaurantId);
            t.setTableNumber(tableNumber);
            t.setCapacity(capacity);
            t.setTableStatus(status);
            dao.insertRestaurantTable(t);
        } else if ("update".equals(action)) {
            int tableId = Integer.parseInt(request.getParameter("tableId"));
            String tableNumber = request.getParameter("tableNumber");
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            String status = request.getParameter("tableStatus");
            RestaurantTable t = new RestaurantTable();
            t.setTableID(tableId);
            t.setTableNumber(tableNumber);
            t.setCapacity(capacity);
            t.setTableStatus(status);
            dao.updateRestaurantTable(t);
        } else if ("toggle".equals(action)) {
            int tableId = Integer.parseInt(request.getParameter("tableId"));
            boolean active = "1".equals(request.getParameter("active"));
            dao.setTableActive(tableId, active);
        }

        response.sendRedirect("restaurant-tables");
    }
}
