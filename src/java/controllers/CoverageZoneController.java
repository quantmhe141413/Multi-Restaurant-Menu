package controllers;

import dal.RestaurantDeliveryZoneDAO;
import dal.DeliveryFeeDAO;
import dal.RestaurantDAO;
import models.RestaurantDeliveryZone;
import models.DeliveryFee;
import models.DeliveryFeeHistory;
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
            case "fees":
                showZoneFees(request, response);
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
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");
        
        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get filter parameters
        String statusFilter = request.getParameter("status");
        String searchFilter = request.getParameter("search");
        String restaurantFilter = request.getParameter("restaurant");
        
        // Determine restaurant ID based on role
        Integer restaurantId = null;
        
        if (user.getRoleID() == 1) {
            // SuperAdmin - can view all restaurants or filter by specific restaurant
            if (restaurantFilter != null && !restaurantFilter.trim().isEmpty()) {
                try {
                    restaurantId = Integer.parseInt(restaurantFilter);
                } catch (NumberFormatException e) {
                    // Invalid restaurant filter, ignore it
                }
            }
            // If restaurantId is still null, it will show all restaurants
        } else if (user.getRoleID() == 2 || user.getRoleID() == 3) {
            // Owner or Staff - can only view their own restaurant
            restaurantId = (Integer) session.getAttribute("restaurantId");
            if (restaurantId == null) {
                session.setAttribute("toastMessage", "You must be assigned to a restaurant to view coverage zones");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
        } else {
            // Other roles don't have access
            session.setAttribute("toastMessage", "You don't have permission to view coverage zones");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
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

        // Get zones based on role and filters
        List<RestaurantDeliveryZone> zones = zoneDAO.findZonesWithFilters(
                restaurantId, statusFilter, searchFilter, page, pageSize);

        int totalZones = zoneDAO.getTotalFilteredZones(restaurantId, statusFilter, searchFilter);
        int totalPages = (int) Math.ceil((double) totalZones / pageSize);

        // Load fees for each zone (for accordion inline display)
        DeliveryFeeDAO feeDAO = new DeliveryFeeDAO();
        java.util.Map<Integer, List<DeliveryFee>> zoneFeeMap = new java.util.LinkedHashMap<>();
        for (RestaurantDeliveryZone zone : zones) {
            zoneFeeMap.put(zone.getZoneId(), feeDAO.findByZoneId(zone.getZoneId()));
        }
        request.setAttribute("zoneFeeMap", zoneFeeMap);

        // Get restaurants for filter dropdown (only for SuperAdmin)
        if (user.getRoleID() == 1) {
            request.setAttribute("restaurants", zoneDAO.getAllApprovedRestaurants());
        }

        // Set attributes for JSP
        request.setAttribute("zones", zones);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalZones", totalZones);
        request.setAttribute("userRole", user.getRoleID());

        request.getRequestDispatcher("/views/owner/coverage-zone-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");
        
        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
        RestaurantDAO restaurantDAO = new RestaurantDAO();

        // Determine restaurant ID based on role
        if (user.getRoleID() == 1) {
            // SuperAdmin - can add for any restaurant
            request.setAttribute("restaurants", zoneDAO.getAllApprovedRestaurants());
        } else if (user.getRoleID() == 2 || user.getRoleID() == 3) {
            // Owner or Staff - can only add for their own restaurant
            Integer restaurantId = (Integer) session.getAttribute("restaurantId");
            if (restaurantId == null) {
                session.setAttribute("toastMessage", "You must be assigned to a restaurant to add coverage zones");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
                return;
            }
            // Load restaurant info to populate the dropdown
            models.Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);
            if (restaurant != null) {
                java.util.List<models.Restaurant> restaurants = new java.util.ArrayList<>();
                restaurants.add(restaurant);
                request.setAttribute("restaurants", restaurants);
            }
            request.setAttribute("currentRestaurantId", restaurantId);
        } else {
            session.setAttribute("toastMessage", "You don't have permission to add coverage zones");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        request.setAttribute("userRole", user.getRoleID());
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
        models.User user = (models.User) session.getAttribute("user");
        
        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get restaurant ID based on role
        Integer restaurantId = null;
        
        if (user.getRoleID() == 1) {
            // SuperAdmin - get from form
            String restaurantIdStr = request.getParameter("restaurantId");
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
            
            if (restaurantId == null) {
                session.setAttribute("toastMessage", "Please select a restaurant");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/coverage-zone?action=add");
                return;
            }
        } else if (user.getRoleID() == 2 || user.getRoleID() == 3) {
            // Owner or Staff - use their restaurant ID from session
            restaurantId = (Integer) session.getAttribute("restaurantId");
            if (restaurantId == null) {
                session.setAttribute("toastMessage", "You must be assigned to a restaurant to add coverage zones");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/coverage-zone?action=add");
                return;
            }
        } else {
            session.setAttribute("toastMessage", "You don't have permission to add coverage zones");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        //Retrieving data from a form
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
        
        //Processing the isActi value
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

    // Show fees and fee history for a specific zone
    private void showZoneFees(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

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
                session.setAttribute("toastMessage", "Coverage zone not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
                return;
            }

            DeliveryFeeDAO feeDAO = new DeliveryFeeDAO();
            List<DeliveryFee> fees = feeDAO.findByZoneId(zoneId);

            // For each fee, load its history
            java.util.Map<Integer, List<DeliveryFeeHistory>> feeHistoryMap = new java.util.LinkedHashMap<>();
            for (DeliveryFee fee : fees) {
                feeHistoryMap.put(fee.getFeeId(), feeDAO.getHistoryByFeeId(fee.getFeeId()));
            }

            request.setAttribute("zone", zone);
            request.setAttribute("fees", fees);
            request.setAttribute("feeHistoryMap", feeHistoryMap);
            request.getRequestDispatcher("/views/owner/coverage-zone-fees.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
        }
    }
}
