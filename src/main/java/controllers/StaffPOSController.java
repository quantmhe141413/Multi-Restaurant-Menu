package controllers;

import dal.MenuDAO;
import dal.RestaurantTableDAO;
import java.io.IOException;
import java.util.ArrayList;
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
import models.RestaurantTable;

@WebServlet(name = "StaffPOSController", urlPatterns = {"/staff/pos"})
public class StaffPOSController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");

        if (restaurantId == null) {
            request.setAttribute("error", "Không tìm thấy thông tin nhà hàng");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        // Get tableId parameter
        String tableIdParam = request.getParameter("tableId");
        if (tableIdParam == null || tableIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn bàn");
            response.sendRedirect(request.getContextPath() + "/staff/tables");
            return;
        }

        int tableId;
        try {
            tableId = Integer.parseInt(tableIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Mã bàn không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/staff/tables");
            return;
        }

        // Validate table belongs to restaurant
        RestaurantTableDAO tableDAO = new RestaurantTableDAO();
        RestaurantTable table = tableDAO.getTableById(tableId, restaurantId);

        if (table == null) {
            request.setAttribute("error", "Bàn không tồn tại hoặc không thuộc nhà hàng này");
            response.sendRedirect(request.getContextPath() + "/staff/tables");
            return;
        }

        // Retrieve menu categories and items (IsActive = true, IsAvailable = true)
        MenuDAO menuDAO = new MenuDAO();
        List<MenuCategory> categories = menuDAO.getCategoriesByRestaurant(restaurantId, null, true, "DisplayOrder", "ASC");
        
        // Get menu items grouped by category
        Map<Integer, List<MenuItem>> itemsByCategory = new HashMap<>();
        for (MenuCategory category : categories) {
            List<MenuItem> items = menuDAO.getMenuItemsByRestaurant(restaurantId, null, category.getCategoryID(), true, null, null, "ItemName", "ASC");
            itemsByCategory.put(category.getCategoryID(), items);
        }

        // Initialize empty cart in session if not exists
        if (session.getAttribute("cart") == null) {
            session.setAttribute("cart", new ArrayList<>());
        }

        // Set attributes for JSP
        request.setAttribute("table", table);
        request.setAttribute("categories", categories);
        request.setAttribute("itemsByCategory", itemsByCategory);

        // Forward to staff-pos.jsp
        request.getRequestDispatcher("/views/staff/staff-pos.jsp").forward(request, response);
    }
}
