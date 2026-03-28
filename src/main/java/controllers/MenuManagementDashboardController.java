package controllers;

import dal.MenuDAO;
import models.MenuItemStat;
import models.TopDish;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "MenuManagementDashboardController", urlPatterns = { "/menu-management-dashboard" })
public class MenuManagementDashboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");
        
        if (restaurantId == null) {
            models.User user = (models.User) session.getAttribute("user");
            if (user != null && (user.getRoleID() == 2 || user.getRoleID() == 3)) {
                dal.UserDAO udao = new dal.UserDAO();
                restaurantId = udao.getRestaurantIdByUserId(user.getUserID());
                if (restaurantId != null) {
                    session.setAttribute("restaurantId", restaurantId);
                }
            }
        }

        if (restaurantId == null) {
            response.sendRedirect("login");
            return;
        }

        MenuDAO dao = new MenuDAO();
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String catParam = request.getParameter("categoryId");
        Integer categoryId = null;
        try {
            if (catParam != null && !catParam.isEmpty())
                categoryId = Integer.parseInt(catParam);
        } catch (NumberFormatException ignored) {
        }

        List<MenuItemStat> stats = dao.getMenuItemStatsByRestaurant(restaurantId, startDate, endDate, categoryId);
        List<TopDish> topDishes = dao.getTopDishesByRestaurant(restaurantId);

        // categories for filter
        List<?> models = dao.getCategoriesByRestaurant(restaurantId);
        request.setAttribute("categories", models);

        request.setAttribute("stats", stats);
        request.setAttribute("topDishes", topDishes);
        request.getRequestDispatcher("views/menu-management-dashboard.jsp").forward(request, response);
    }
}
