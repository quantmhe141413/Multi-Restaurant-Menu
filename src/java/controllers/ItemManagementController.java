package controllers;

import dal.MenuDAO;
import dal.RestaurantDAO;
import models.MenuCategory;
import models.MenuItem;
import models.Restaurant;
import models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ItemManagementController", urlPatterns = { "/items" })
public class ItemManagementController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listItems(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteItem(request, response);
                break;
            default:
                listItems(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "add":
                addItem(request, response);
                break;
            case "edit":
                editItem(request, response);
                break;
            default:
                listItems(request, response);
        }
    }

    private void listItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Restaurant restaurant = getRestaurantFromSession(request);
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        MenuDAO menuDAO = new MenuDAO();
        List<MenuItem> items = menuDAO.getMenuItemsByRestaurant(restaurant.getRestaurantId());
        List<MenuCategory> categories = menuDAO.getCategoriesByRestaurant(restaurant.getRestaurantId());

        request.setAttribute("items", items);
        request.setAttribute("categories", categories); // Map ID to Name in JSP
        request.getRequestDispatcher("/views/owner/item-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Restaurant restaurant = getRestaurantFromSession(request);
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        MenuDAO menuDAO = new MenuDAO();
        List<MenuCategory> categories = menuDAO.getCategoriesByRestaurant(restaurant.getRestaurantId());
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/views/owner/item-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Restaurant restaurant = getRestaurantFromSession(request);
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int itemId = Integer.parseInt(request.getParameter("id"));
        MenuDAO menuDAO = new MenuDAO();
        MenuItem item = menuDAO.getMenuItemById(itemId);

        if (item != null && item.getRestaurantID() == restaurant.getRestaurantId()) {
            List<MenuCategory> categories = menuDAO.getCategoriesByRestaurant(restaurant.getRestaurantId());
            request.setAttribute("categories", categories);
            request.setAttribute("item", item);
            request.getRequestDispatcher("/views/owner/item-form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/items?error=Unauthorized");
        }
    }

    private void addItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Restaurant restaurant = getRestaurantFromSession(request);
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String sku = request.getParameter("sku");
        String name = request.getParameter("itemName");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        boolean isAvailable = request.getParameter("isAvailable") != null;

        MenuItem item = new MenuItem();
        item.setRestaurantID(restaurant.getRestaurantId());
        item.setCategoryID(categoryId);
        item.setSku(sku);
        item.setItemName(name);
        item.setDescription(description);
        item.setPrice(price);
        item.setIsAvailable(isAvailable);

        MenuDAO menuDAO = new MenuDAO();
        if (menuDAO.insertMenuItem(item)) {
            request.getSession().setAttribute("message", "Item added successfully!");
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", "Failed to add item.");
            request.getSession().setAttribute("messageType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/items");
    }

    private void editItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Restaurant restaurant = getRestaurantFromSession(request);
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int itemId = Integer.parseInt(request.getParameter("itemId"));
        String sku = request.getParameter("sku");
        String name = request.getParameter("itemName");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        boolean isAvailable = request.getParameter("isAvailable") != null;

        MenuDAO menuDAO = new MenuDAO();
        MenuItem item = menuDAO.getMenuItemById(itemId);

        if (item != null && item.getRestaurantID() == restaurant.getRestaurantId()) {
            item.setCategoryID(categoryId);
            item.setSku(sku);
            item.setItemName(name);
            item.setDescription(description);
            item.setPrice(price);
            item.setIsAvailable(isAvailable);

            if (menuDAO.updateMenuItem(item)) {
                request.getSession().setAttribute("message", "Item updated successfully!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to update item.");
                request.getSession().setAttribute("messageType", "error");
            }
        } else {
            request.getSession().setAttribute("message", "Unauthorized to edit this item.");
            request.getSession().setAttribute("messageType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/items");
    }

    private void deleteItem(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Restaurant restaurant = getRestaurantFromSession(request);
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int itemId = Integer.parseInt(request.getParameter("id"));
        MenuDAO menuDAO = new MenuDAO();
        MenuItem item = menuDAO.getMenuItemById(itemId);

        if (item != null && item.getRestaurantID() == restaurant.getRestaurantId()) {
            if (menuDAO.deleteMenuItem(itemId)) {
                request.getSession().setAttribute("message", "Item deleted successfully!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to delete item.");
                request.getSession().setAttribute("messageType", "error");
            }
        } else {
            request.getSession().setAttribute("message", "Unauthorized action.");
            request.getSession().setAttribute("messageType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/items");
    }

    private Restaurant getRestaurantFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            return null;
        }
        User user = (User) session.getAttribute("user");
        RestaurantDAO restaurantDAO = new RestaurantDAO();
        return restaurantDAO.getRestaurantByOwnerId(user.getUserID());
    }
}
