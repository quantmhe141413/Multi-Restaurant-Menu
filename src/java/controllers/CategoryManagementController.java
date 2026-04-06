package controllers;

import dal.MenuDAO;
import dal.RestaurantDAO;
import models.MenuCategory;
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

@WebServlet(name = "CategoryManagementController", urlPatterns = { "/categories" })
public class CategoryManagementController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                listCategories(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                listCategories(request, response);
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
                addCategory(request, response);
                break;
            case "edit":
                editCategory(request, response);
                break;
            default:
                listCategories(request, response);
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Restaurant restaurant = getRestaurantFromSession(request);
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String search = request.getParameter("search");
        String statusStr = request.getParameter("status");
        Boolean isActive = null;
        if ("active".equals(statusStr))
            isActive = true;
        else if ("inactive".equals(statusStr))
            isActive = false;

        int page = 1;
        int pageSize = 5; // Default page size for categories
        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        MenuDAO menuDAO = new MenuDAO();
        List<MenuCategory> categories = menuDAO.getCategoriesByRestaurant(restaurant.getRestaurantId(), search,
                isActive, sortBy, sortOrder, page, pageSize);
        int totalCategories = menuDAO.countCategoriesByRestaurant(restaurant.getRestaurantId(), search, isActive);
        int totalPages = (int) Math.ceil((double) totalCategories / pageSize);

        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);

        request.setAttribute("categories", categories);
        request.setAttribute("currentSearch", search);
        request.setAttribute("currentStatus", statusStr);
        request.setAttribute("currentSortBy", sortBy);
        request.setAttribute("currentSortOrder", sortOrder);

        request.getRequestDispatcher("/views/owner/category-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (getRestaurantFromSession(request) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/views/owner/category-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (getRestaurantFromSession(request) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int categoryId = Integer.parseInt(request.getParameter("id"));
        MenuDAO menuDAO = new MenuDAO();
        MenuCategory category = menuDAO.getCategoryById(categoryId);

        // Security check: Ensure category belongs to owner's restaurant
        Restaurant restaurant = getRestaurantFromSession(request);
        if (category != null && category.getRestaurantID() == restaurant.getRestaurantId()) {
            request.setAttribute("category", category);
            request.getRequestDispatcher("/views/owner/category-form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/categories?error=Unauthorized");
        }
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Restaurant restaurant = getRestaurantFromSession(request);
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String name = request.getParameter("categoryName");
        String displayOrderStr = request.getParameter("displayOrder");
        
        if (name == null || name.trim().isEmpty()) {
            request.getSession().setAttribute("message", "Category name is required!");
            request.getSession().setAttribute("messageType", "error");
            showAddForm(request, response);
            return;
        }

        Integer displayOrder = null;
        if (displayOrderStr != null && !displayOrderStr.isEmpty()) {
            try {
                displayOrder = Integer.parseInt(displayOrderStr);
                if (displayOrder < 0) {
                    request.getSession().setAttribute("message", "Display order cannot be negative.");
                    request.getSession().setAttribute("messageType", "error");
                    showAddForm(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("message", "Invalid display order.");
                request.getSession().setAttribute("messageType", "error");
                showAddForm(request, response);
                return;
            }
        }
        boolean isActive = request.getParameter("isActive") != null;

        MenuCategory category = new MenuCategory();
        category.setRestaurantID(restaurant.getRestaurantId());
        category.setCategoryName(name.trim());
        category.setDisplayOrder(displayOrder);
        category.setIsActive(isActive);

        MenuDAO menuDAO = new MenuDAO();
        if (menuDAO.insertCategory(category)) {
            request.getSession().setAttribute("message", "Category added successfully!");
            request.getSession().setAttribute("messageType", "success");
        } else {
            request.getSession().setAttribute("message", "Failed to add category.");
            request.getSession().setAttribute("messageType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/categories");
    }

    private void editCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Restaurant restaurant = getRestaurantFromSession(request);
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String categoryIdStr = request.getParameter("categoryId");
        String name = request.getParameter("categoryName");
        String displayOrderStr = request.getParameter("displayOrder");
        
        if (categoryIdStr == null || name == null || name.trim().isEmpty()) {
            request.getSession().setAttribute("message", "Category name is required!");
            request.getSession().setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/categories");
            return;
        }

        try {
            int categoryId = Integer.parseInt(categoryIdStr);
            Integer displayOrder = null;
            if (displayOrderStr != null && !displayOrderStr.isEmpty()) {
                displayOrder = Integer.parseInt(displayOrderStr);
                if (displayOrder < 0) {
                    request.getSession().setAttribute("message", "Display order cannot be negative.");
                    request.getSession().setAttribute("messageType", "error");
                    response.sendRedirect(request.getContextPath() + "/categories?action=edit&id=" + categoryId);
                    return;
                }
            }
            boolean isActive = request.getParameter("isActive") != null;

            MenuDAO menuDAO = new MenuDAO();
            MenuCategory category = menuDAO.getCategoryById(categoryId);

            if (category != null && category.getRestaurantID() == restaurant.getRestaurantId()) {
                category.setCategoryName(name.trim());
                category.setDisplayOrder(displayOrder);
                category.setIsActive(isActive);
                if (menuDAO.updateCategory(category)) {
                    request.getSession().setAttribute("message", "Category updated successfully!");
                    request.getSession().setAttribute("messageType", "success");
                } else {
                    request.getSession().setAttribute("message", "Failed to update category.");
                    request.getSession().setAttribute("messageType", "error");
                }
            } else {
                request.getSession().setAttribute("message", "Unauthorized to edit this category.");
                request.getSession().setAttribute("messageType", "error");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("message", "Invalid numeric data provided.");
            request.getSession().setAttribute("messageType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/categories");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Restaurant restaurant = getRestaurantFromSession(request);
        if (restaurant == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int categoryId = Integer.parseInt(request.getParameter("id"));
        MenuDAO menuDAO = new MenuDAO();
        MenuCategory category = menuDAO.getCategoryById(categoryId);

        if (category != null && category.getRestaurantID() == restaurant.getRestaurantId()) {
            // Check for dependencies or use DB constraints.
            // For now, simple delete.
            if (menuDAO.deleteCategory(categoryId)) {
                request.getSession().setAttribute("message", "Category deleted successfully!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message",
                        "Failed to delete category. It might be used by some items.");
                request.getSession().setAttribute("messageType", "error");
            }
        } else {
            request.getSession().setAttribute("message", "Unauthorized action.");
            request.getSession().setAttribute("messageType", "error");
        }
        response.sendRedirect(request.getContextPath() + "/categories");
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
