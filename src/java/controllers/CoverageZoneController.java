package controllers;

import dal.RestaurantDeliveryZoneDAO;
import models.RestaurantDeliveryZone;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CoverageZoneController", urlPatterns = {"/coverage-zone"})
public class CoverageZoneController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                handleList(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "toggle":
                handleToggleStatus(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            default:
                handleList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
            return;
        }
        
        switch (action) {
            case "add":
                handleAdd(request, response);
                break;
            case "edit":
                handleEdit(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
                break;
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get filter parameters
        String statusFilter = request.getParameter("status");
        String searchFilter = request.getParameter("search");
        String restaurantFilter = request.getParameter("restaurant");
        
        // Parse restaurant filter (if any)
        Integer restaurantId = null;
        if (restaurantFilter != null && !restaurantFilter.trim().isEmpty()) {
            try {
                restaurantId = Integer.parseInt(restaurantFilter);
            } catch (NumberFormatException e) {
                // Invalid restaurant filter, ignore it
            }
        }
        
        // Get pagination parameters
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
        
        RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
        
        // Get all zones (pass null to get all restaurants)
        List<RestaurantDeliveryZone> zones = zoneDAO.findZonesWithFilters(
                restaurantId, statusFilter, searchFilter, page, pageSize);
        
        int totalZones = zoneDAO.getTotalFilteredZones(restaurantId, statusFilter, searchFilter);
        int totalPages = (int) Math.ceil((double) totalZones / pageSize);
        
        // Get all restaurants for filter dropdown
        request.setAttribute("restaurants", zoneDAO.getAllApprovedRestaurants());
        
        // Set attributes for JSP
        request.setAttribute("zones", zones);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalZones", totalZones);
        
        request.getRequestDispatcher("/views/owner/coverage-zone-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Load list of restaurants for selection
        RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
        request.setAttribute("restaurants", zoneDAO.getAllApprovedRestaurants());
        
        // Get current restaurant from session (if any) for pre-selection
        HttpSession session = request.getSession();
        Integer currentRestaurantId = (Integer) session.getAttribute("restaurantId");
        if (currentRestaurantId != null) {
            request.setAttribute("currentRestaurantId", currentRestaurantId);
        }
        
        request.getRequestDispatcher("/views/owner/coverage-zone-add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String zoneIdStr = request.getParameter("id");
        
        if (zoneIdStr == null || zoneIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
            return;
        }
        
        try {
            Integer zoneId = Integer.parseInt(zoneIdStr);
            RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
            RestaurantDeliveryZone zone = zoneDAO.findById(zoneId);
            
            if (zone == null) {
                HttpSession session = request.getSession();
                session.setAttribute("toastMessage", "Coverage zone not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
                return;
            }
            
            request.setAttribute("zone", zone);
            request.getRequestDispatcher("/views/owner/coverage-zone-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Get restaurant ID from form (user selection)
        String restaurantIdStr = request.getParameter("restaurantId");
        Integer restaurantId = null;
        
        if (restaurantIdStr != null && !restaurantIdStr.trim().isEmpty()) {
            try {
                restaurantId = Integer.parseInt(restaurantIdStr);
            } catch (NumberFormatException e) {
                session.setAttribute("toastMessage", "Invalid restaurant selection");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/coverage-zone?action=add");
                return;
            }
        }
        
        // Validation - Restaurant must be selected
        if (restaurantId == null) {
            session.setAttribute("toastMessage", "Please select a restaurant");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=add");
            return;
        }
        
        String zoneName = request.getParameter("zoneName");
        String zoneDefinition = request.getParameter("zoneDefinition");
        String isActiveStr = request.getParameter("isActive");
        
        RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
        
        // Validation
        if (zoneName == null || zoneName.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Zone name is required");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=add");
            return;
        }
        
        // Check for duplicate zone name in same restaurant
        if (zoneDAO.isZoneNameExists(restaurantId, zoneName, null)) {
            session.setAttribute("toastMessage", 
                "Zone name '" + zoneName + "' already exists in this restaurant. Please use a different name.");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=add");
            return;
        }
        
        Boolean isActive = isActiveStr != null && isActiveStr.equals("1");
        
        RestaurantDeliveryZone zone = new RestaurantDeliveryZone();
        zone.setRestaurantId(restaurantId);
        zone.setZoneName(zoneName.trim());
        zone.setZoneDefinition(zoneDefinition);
        zone.setIsActive(isActive);
        
        int result = zoneDAO.insert(zone);
        
        if (result > 0) {
            session.setAttribute("toastMessage", "Coverage zone added successfully");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Failed to add coverage zone");
            session.setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String zoneIdStr = request.getParameter("zoneId");
        
        if (zoneIdStr == null || zoneIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
            return;
        }
        
        try {
            Integer zoneId = Integer.parseInt(zoneIdStr);
            String zoneName = request.getParameter("zoneName");
            String zoneDefinition = request.getParameter("zoneDefinition");
            String isActiveStr = request.getParameter("isActive");
            
            RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
            RestaurantDeliveryZone zone = zoneDAO.findById(zoneId);
            
            if (zone == null) {
                session.setAttribute("toastMessage", "Coverage zone not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
                return;
            }
            
            // Validation
            if (zoneName == null || zoneName.trim().isEmpty()) {
                session.setAttribute("toastMessage", "Zone name is required");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/coverage-zone?action=edit&id=" + zoneId);
                return;
            }
            
            // Check for duplicate zone name in same restaurant (exclude current zone)
            if (zoneDAO.isZoneNameExists(zone.getRestaurantId(), zoneName, zoneId)) {
                session.setAttribute("toastMessage", 
                    "Zone name '" + zoneName + "' already exists in this restaurant. Please use a different name.");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/coverage-zone?action=edit&id=" + zoneId);
                return;
            }
            
            Boolean isActive = isActiveStr != null && isActiveStr.equals("1");
            
            zone.setZoneName(zoneName.trim());
            zone.setZoneDefinition(zoneDefinition);
            zone.setIsActive(isActive);
            
            boolean result = zoneDAO.update(zone);
            
            if (result) {
                session.setAttribute("toastMessage", "Coverage zone updated successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to update coverage zone");
                session.setAttribute("toastType", "error");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid zone ID");
            session.setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String zoneIdStr = request.getParameter("id");
        
        if (zoneIdStr == null || zoneIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
            return;
        }
        
        try {
            Integer zoneId = Integer.parseInt(zoneIdStr);
            RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
            boolean result = zoneDAO.toggleStatus(zoneId);
            
            if (result) {
                session.setAttribute("toastMessage", "Zone status updated successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to update zone status");
                session.setAttribute("toastType", "error");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid zone ID");
            session.setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String zoneIdStr = request.getParameter("id");
        
        if (zoneIdStr == null || zoneIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
            return;
        }
        
        try {
            Integer zoneId = Integer.parseInt(zoneIdStr);
            RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
            boolean result = zoneDAO.delete(zoneId);
            
            if (result) {
                session.setAttribute("toastMessage", "Coverage zone deleted successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Cannot delete zone: associated with active delivery fees");
                session.setAttribute("toastType", "error");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid zone ID");
            session.setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
    }
}
