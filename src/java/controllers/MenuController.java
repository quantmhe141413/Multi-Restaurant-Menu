package controllers;

import dal.MenuDAO;
import dal.ReviewDAO;
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
import models.Review;

@WebServlet(name = "MenuController", urlPatterns = { "/menu", "/menu-item-detail" })
public class MenuController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();

        if ("/menu-item-detail".equals(path)) {
            handleItemDetail(request, response);
            return;
        }

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

            // Lấy danh mục và món ăn (chỉ lấy món available)
            List<MenuCategory> categories = dao.getCategoriesByRestaurant(restaurantId);
            List<MenuItem> menuItems = dao.getMenuItemsByRestaurant(restaurantId, null, null, true,
                    null, null, "ItemName", "ASC");

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
            }

            // Lấy đánh giá của nhà hàng
            List<Review> reviews = new java.util.ArrayList<>();
            Map<Integer, String> reviewerNames = new HashMap<>();
            Double avgRating = null;
            int reviewCount = 0;
            try {
                ReviewDAO reviewDAO = new ReviewDAO();
                reviews = reviewDAO.getReviewsByRestaurantId(restaurantId);
                reviewerNames = reviewDAO.getCustomerNamesForReviews(reviews);
                avgRating = reviewDAO.getAverageRating(restaurantId);
                reviewCount = reviewDAO.getReviewCount(restaurantId);
            } catch (Exception ex) {
                System.out.println("Warning: Could not load reviews - " + ex.getMessage());
            }

            // Gửi dữ liệu đến JSP
            request.setAttribute("restaurant", restaurant);
            request.setAttribute("categories", categories);
            request.setAttribute("itemsByCategory", itemsByCategory);
            request.setAttribute("reviews", reviews);
            request.setAttribute("reviewerNames", reviewerNames);
            request.setAttribute("avgRating", avgRating);
            request.setAttribute("reviewCount", reviewCount);

            request.getRequestDispatcher("views/menu.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }

    private void handleItemDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String itemIdParam = request.getParameter("itemId");
        if (itemIdParam == null || itemIdParam.trim().isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        try {
            int itemId = Integer.parseInt(itemIdParam);
            MenuDAO dao = new MenuDAO();

            MenuItem item = dao.getMenuItemById(itemId);
            if (item == null) {
                response.sendRedirect("home");
                return;
            }

            // Lấy thông tin nhà hàng và danh mục
            Restaurant restaurant = dao.getRestaurantById(item.getRestaurantID());
            MenuCategory category = dao.getCategoryById(item.getCategoryID());

            request.setAttribute("item", item);
            request.setAttribute("restaurant", restaurant);
            request.setAttribute("category", category);

            request.getRequestDispatcher("views/item-detail.jsp").forward(request, response);
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
