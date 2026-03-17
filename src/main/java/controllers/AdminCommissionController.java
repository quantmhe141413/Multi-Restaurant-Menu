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
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import models.Restaurant;
import models.User;

@WebServlet(name = "AdminCommissionController", urlPatterns = {"/admin/commission"})
public class AdminCommissionController extends HttpServlet {

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
            case "edit":
                handleEdit(request, response);
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
            response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
            return;
        }

        switch (action) {
            case "update":
                handleUpdate(request, response, currentUser);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
                break;
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String statusFilter = "Approved";
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

        RestaurantDAO restaurantDAO = new RestaurantDAO();
        List<Restaurant> restaurants = restaurantDAO.findRestaurantsForCommissionConfig(statusFilter, searchFilter, page, pageSize);
        int total = restaurantDAO.getTotalFilteredRestaurants(statusFilter, searchFilter);
        int totalPages = (int) Math.ceil((double) total / pageSize);

        request.setAttribute("restaurants", restaurants);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRestaurants", total);

        request.getRequestDispatcher("/views/admin/commission-config.jsp").forward(request, response);
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Missing restaurant ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            RestaurantDAO restaurantDAO = new RestaurantDAO();
            Restaurant r = restaurantDAO.findByIdWithOwner(id);
            if (r == null) {
                session.setAttribute("toastMessage", "Restaurant not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
                return;
            }

            if (r.getStatus() == null || !"Approved".equalsIgnoreCase(r.getStatus().trim())) {
                session.setAttribute("toastMessage", "Only approved restaurants can be configured");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
                return;
            }

            request.setAttribute("editRestaurant", r);
            handleList(request, response);
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid restaurant ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        HttpSession session = request.getSession();

        String idStr = request.getParameter("id");
        String rateStr = request.getParameter("commissionRate");
        String reason = request.getParameter("reason");

        if (idStr == null || idStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Missing restaurant ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
            return;
        }

        if (rateStr == null || rateStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Commission rate is required");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/commission?action=edit&id=" + URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
            return;
        }

        if (reason == null || reason.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Reason is required");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/admin/commission?action=edit&id=" + URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
            return;
        }

        try {
            int restaurantId = Integer.parseInt(idStr.trim());
            BigDecimal newRate = new BigDecimal(rateStr.trim());

            if (newRate.compareTo(BigDecimal.ZERO) < 0 || newRate.compareTo(new BigDecimal("100")) > 0) {
                session.setAttribute("toastMessage", "Commission rate must be between 0 and 100");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/commission?action=edit&id=" + URLEncoder.encode(idStr.trim(), StandardCharsets.UTF_8));
                return;
            }

            RestaurantDAO restaurantDAO = new RestaurantDAO();
            Restaurant before = restaurantDAO.findByIdWithOwner(restaurantId);
            if (before == null) {
                session.setAttribute("toastMessage", "Restaurant not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
                return;
            }

            if (before.getStatus() == null || !"Approved".equalsIgnoreCase(before.getStatus().trim())) {
                session.setAttribute("toastMessage", "Only approved restaurants can be configured");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/admin/commission?action=list");
                return;
            }

            BigDecimal oldRate = before.getCommissionRate() == null ? null : BigDecimal.valueOf(before.getCommissionRate());
            boolean ok = restaurantDAO.updateCommissionRate(restaurantId, newRate);

            if (ok) {
                CommissionHistoryDAO historyDAO = new CommissionHistoryDAO();
                historyDAO.insertHistory(restaurantId, oldRate, newRate, currentUser.getUserID(), reason.trim());
                session.setAttribute("toastMessage", "Commission rate updated successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to update commission rate");
                session.setAttribute("toastType", "error");
            }

        } catch (NumberFormatException ex) {
            session.setAttribute("toastMessage", "Invalid input");
            session.setAttribute("toastType", "error");
        }

        String status = request.getParameter("status");
        String search = request.getParameter("search");
        String page = request.getParameter("page");

        StringBuilder redirect = new StringBuilder();
        redirect.append(request.getContextPath()).append("/admin/commission?action=list");

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
}
