package controllers;

import dal.RestaurantDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import models.Restaurant;
import models.User;

@WebServlet(name = "AdminRestaurantApplicationsController", urlPatterns = {"/admin/restaurant-applications"})
public class AdminRestaurantApplicationsController extends HttpServlet {

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
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "detail":
                handleDetail(request, response);
                break;
            case "list":
            default:
                handleList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");
        if (currentUser == null || currentUser.getRoleID() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=list");
            return;
        }

        switch (action) {
            case "approve":
                handleUpdateStatus(request, response, "Approved");
                break;
            case "reject":
                handleUpdateStatus(request, response, "Rejected");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=list");
                break;
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusFilter = request.getParameter("status");
        String searchFilter = request.getParameter("search");

        if (statusFilter == null || statusFilter.trim().isEmpty()) {
            statusFilter = "Pending";
        }

        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        RestaurantDAO restaurantDAO = new RestaurantDAO();
        List<Restaurant> restaurants = restaurantDAO.findRestaurantsWithFilters(statusFilter, searchFilter, page, pageSize);
        int totalRestaurants = restaurantDAO.getTotalFilteredRestaurants(statusFilter, searchFilter);
        int totalPages = (int) Math.ceil((double) totalRestaurants / pageSize);

        request.setAttribute("restaurants", restaurants);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRestaurants", totalRestaurants);

        request.getRequestDispatcher("/views/admin/restaurant-application-list.jsp").forward(request, response);
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response, String newStatus)
            throws IOException {
        HttpSession session = request.getSession();
        String idStr = request.getParameter("id");
        String reason = request.getParameter("reason");

        if (idStr == null || idStr.isEmpty()) {
            session.setAttribute("toastMessage", "Missing restaurant ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=list");
            return;
        }

        if (reason == null || reason.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Reason is required");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=detail&id=" + URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
            return;
        }

        try {
            int restaurantId = Integer.parseInt(idStr);
            RestaurantDAO restaurantDAO = new RestaurantDAO();
            boolean ok = restaurantDAO.updateRestaurantStatus(restaurantId, newStatus, reason);

            if (ok) {
                session.setAttribute("toastMessage", "Restaurant status updated successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to update restaurant status");
                session.setAttribute("toastType", "error");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid restaurant ID");
            session.setAttribute("toastType", "error");
        }

        String status = request.getParameter("status");
        String search = request.getParameter("search");
        String page = request.getParameter("page");
        String returnTo = request.getParameter("returnTo");

        StringBuilder redirect = new StringBuilder();
        if (returnTo != null && returnTo.equals("detail")) {
            redirect.append(request.getContextPath()).append("/admin/restaurant-applications?action=detail&id=")
                    .append(URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
        } else {
            redirect.append(request.getContextPath()).append("/admin/restaurant-applications?action=list");
        }

        if (status != null && !status.trim().isEmpty()) {
            redirect.append("&status=").append(URLEncoder.encode(status.trim(), StandardCharsets.UTF_8));
        }
        if (search != null && !search.trim().isEmpty()) {
            redirect.append("&search=").append(URLEncoder.encode(search.trim(), StandardCharsets.UTF_8));
        }
        if (page != null && !page.trim().isEmpty()) {
            redirect.append("&page=").append(URLEncoder.encode(page.trim(), StandardCharsets.UTF_8));
        }

        response.sendRedirect(redirect.toString());
    }

    private void handleDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String idStr = request.getParameter("id");

        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Missing restaurant ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=list");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(idStr.trim());
            RestaurantDAO restaurantDAO = new RestaurantDAO();
            Restaurant restaurant = restaurantDAO.findByIdWithOwner(restaurantId);
            if (restaurant == null) {
                session.setAttribute("toastMessage", "Restaurant not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=list");
                return;
            }

            request.setAttribute("restaurant", restaurant);
            request.getRequestDispatcher("/views/admin/restaurant-application-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid restaurant ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications?action=list");
        }
    }
}
