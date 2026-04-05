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

        // Basic Search & Category
        String search = request.getParameter("search");
        String categoryIdStr = request.getParameter("categoryId");
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
            }
        }

        // Status Filter
        String statusStr = request.getParameter("status");
        Boolean isAvailable = null;
        if ("available".equals(statusStr))
            isAvailable = true;
        else if ("unavailable".equals(statusStr))
            isAvailable = false;

        // Price Filter
        String minPriceStr = request.getParameter("minPrice");
        Double minPrice = null;
        if (minPriceStr != null && !minPriceStr.isEmpty()) {
            try {
                minPrice = Double.parseDouble(minPriceStr);
            } catch (Exception e) {
            }
        }

        String maxPriceStr = request.getParameter("maxPrice");
        Double maxPrice = null;
        if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
            try {
                maxPrice = Double.parseDouble(maxPriceStr);
            } catch (Exception e) {
            }
        }

        // Sorting
        int page = 1;
        int pageSize = 10; // Default page size for items
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        MenuDAO menuDAO = new MenuDAO();
        List<MenuItem> items = menuDAO.getMenuItemsByRestaurant(restaurant.getRestaurantId(), search, categoryId,
                isAvailable, minPrice, maxPrice, sortBy, sortOrder, page, pageSize);
        int totalItems = menuDAO.countMenuItemsByRestaurant(restaurant.getRestaurantId(), search, categoryId, isAvailable, minPrice, maxPrice);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);

        request.setAttribute("items", items);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        List<MenuCategory> categories = menuDAO.getCategoriesByRestaurant(restaurant.getRestaurantId());

        request.setAttribute("items", items);
        request.setAttribute("categories", categories);
        request.setAttribute("currentSearch", search);
        request.setAttribute("currentCategoryId", categoryId);
        request.setAttribute("currentStatus", statusStr);
        request.setAttribute("currentMinPrice", minPrice);
        request.setAttribute("currentMaxPrice", maxPrice);
        request.setAttribute("currentSortBy", sortBy);
        request.setAttribute("currentSortOrder", sortOrder);

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
        String imageUrl = request.getParameter("imageUrl");
        String priceStr = request.getParameter("price");
        String categoryIdStr = request.getParameter("categoryId");
        boolean isAvailable = request.getParameter("isAvailable") != null;

        // Validation
        if (name == null || name.trim().isEmpty() || priceStr == null || categoryIdStr == null) {
            request.getSession().setAttribute("message", "Item name, price, and category are required!");
            request.getSession().setAttribute("messageType", "error");
            showAddForm(request, response);
            return;
        }

        try {
            double price = Double.parseDouble(priceStr);
            int categoryId = Integer.parseInt(categoryIdStr);

            if (price < 0) {
                request.getSession().setAttribute("message", "Price cannot be negative.");
                request.getSession().setAttribute("messageType", "error");
                showAddForm(request, response);
                return;
            }

            MenuItem item = new MenuItem();
            item.setRestaurantID(restaurant.getRestaurantId());
            item.setCategoryID(categoryId);
            item.setSku(sku != null ? sku.trim() : "");
            item.setItemName(name.trim());
            item.setDescription(description != null ? description.trim() : "");
            item.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
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
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "Invalid price or category.");
            request.getSession().setAttribute("messageType", "error");
            showAddForm(request, response);
            return;
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

        String itemIdStr = request.getParameter("itemId");
        String sku = request.getParameter("sku");
        String name = request.getParameter("itemName");
        String description = request.getParameter("description");
        String imageUrl = request.getParameter("imageUrl");
        String priceStr = request.getParameter("price");
        String categoryIdStr = request.getParameter("categoryId");
        boolean isAvailable = request.getParameter("isAvailable") != null;

        if (itemIdStr == null || name == null || name.trim().isEmpty() || priceStr == null || categoryIdStr == null) {
            request.getSession().setAttribute("message", "Missing required fields.");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/items");
            return;
        }

        try {
            int itemId = Integer.parseInt(itemIdStr);
            double price = Double.parseDouble(priceStr);
            int categoryId = Integer.parseInt(categoryIdStr);

            if (price < 0) {
                request.getSession().setAttribute("message", "Price cannot be negative.");
                request.getSession().setAttribute("messageType", "error");
                response.sendRedirect(request.getContextPath() + "/items?action=edit&id=" + itemId);
                return;
            }

            MenuDAO menuDAO = new MenuDAO();
            MenuItem item = menuDAO.getMenuItemById(itemId);

            if (item != null && item.getRestaurantID() == restaurant.getRestaurantId()) {
                item.setCategoryID(categoryId);
                item.setSku(sku != null ? sku.trim() : "");
                item.setItemName(name.trim());
                item.setDescription(description != null ? description.trim() : "");
                item.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
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
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "Invalid numeric data provided.");
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
        // Try owner lookup first
        Restaurant restaurant = restaurantDAO.getRestaurantByOwnerId(user.getUserID());
        if (restaurant == null) {
            // Fall back to searching RestaurantUsers (for managers/staff)
            dal.UserDAO userDAO = new dal.UserDAO();
            Integer restaurantId = userDAO.getRestaurantIdByUserId(user.getUserID());
            if (restaurantId != null) {
                restaurant = restaurantDAO.getRestaurantById(restaurantId);
            }
        }
        return restaurant;
    }
}
