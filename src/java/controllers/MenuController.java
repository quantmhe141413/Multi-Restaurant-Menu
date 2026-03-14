package controllers;

import dal.MenuDAO;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.MenuCategory;
import models.MenuItem;
import models.Restaurant;

@WebServlet(name = "MenuController", urlPatterns = { "/menu" })
public class MenuController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String restaurantIdParam = request.getParameter("restaurantId");

        if (restaurantIdParam == null || restaurantIdParam.trim().isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(restaurantIdParam);
            MenuDAO dao = new MenuDAO();

            // Lấy thông tin nhà hàng
            Restaurant restaurant = dao.getRestaurantById(restaurantId);
            if (restaurant == null) {
                response.sendRedirect("home");
                return;
            }

            // Lấy danh mục và món ăn
            List<MenuCategory> categories = dao.getCategoriesByRestaurant(restaurantId);
            List<MenuItem> menuItems = dao.getMenuItemsByRestaurant(restaurantId);

            // Debug logging
            System.out.println("===== MENU DEBUG =====");
            System.out.println("Restaurant ID: " + restaurantId);
            System.out.println("Restaurant: " + restaurant.getName());
            System.out.println("Categories found: " + categories.size());
            for (MenuCategory cat : categories) {
                System.out.println("  - Category " + cat.getCategoryID() + ": " + cat.getCategoryName());
            }
            System.out.println("Menu Items found: " + menuItems.size());
            for (MenuItem item : menuItems) {
                System.out.println("  - Item " + item.getItemID() + ": " + item.getItemName() + " (CategoryID: "
                        + item.getCategoryID() + ")");
            }

            // Nhóm món ăn theo danh mục
            Map<Integer, List<MenuItem>> itemsByCategory = new HashMap<>();
            for (MenuCategory category : categories) {
                List<MenuItem> categoryItems = new java.util.ArrayList<>();
                for (MenuItem item : menuItems) {
                    if (item.getCategoryID() == category.getCategoryID()) {
                        categoryItems.add(item);
                    }
                }
                itemsByCategory.put(category.getCategoryID(), categoryItems);
                System.out.println("Category " + category.getCategoryID() + " has " + categoryItems.size() + " items");
            }
            System.out.println("======================");

            // Gửi dữ liệu đến JSP
            request.setAttribute("restaurant", restaurant);
            request.setAttribute("categories", categories);
            request.setAttribute("itemsByCategory", itemsByCategory);

            request.getRequestDispatcher("views/menu.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
