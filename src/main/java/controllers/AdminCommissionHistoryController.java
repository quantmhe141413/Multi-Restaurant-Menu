package controllers;

import dal.CommissionHistoryDAO;
import dal.RestaurantDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import models.CommissionHistory;
import models.Restaurant;
import models.User;

@WebServlet(name = "AdminCommissionHistoryController", urlPatterns = {"/admin/commission-history"})
public class AdminCommissionHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRoleID() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "list":
            default:
                handleList(request, response);
                break;
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String restaurantStr = request.getParameter("restaurant");
        Integer restaurantId = null;
        if (restaurantStr != null && !restaurantStr.trim().isEmpty()) {
            try {
                restaurantId = Integer.parseInt(restaurantStr.trim());
            } catch (NumberFormatException e) {
                restaurantId = null;
            }
        }

        String searchFilter = request.getParameter("search");

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        CommissionHistoryDAO historyDAO = new CommissionHistoryDAO();
        boolean historyTableExists = historyDAO.historyTableExists();

        List<CommissionHistory> history = historyDAO.findHistoryWithFilters(restaurantId, searchFilter, page, pageSize);
        int total = historyDAO.getTotalFilteredHistory(restaurantId, searchFilter);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        RestaurantDAO restaurantDAO = new RestaurantDAO();
        List<Restaurant> restaurants = restaurantDAO.getAllRestaurantsForDropdown();

        request.setAttribute("historyTableExists", historyTableExists);
        request.setAttribute("history", history);
        request.setAttribute("restaurants", restaurants);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalHistory", total);

        request.getRequestDispatcher("/views/admin/commission-history.jsp").forward(request, response);
    }
}
