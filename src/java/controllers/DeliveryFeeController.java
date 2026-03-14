package controllers;

import dal.DeliveryFeeDAO;
import dal.RestaurantDeliveryZoneDAO;
import models.DeliveryFee;
import models.DeliveryFeeHistory;
import models.RestaurantDeliveryZone;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "DeliveryFeeController", urlPatterns = {"/delivery-fee"})
public class DeliveryFeeController extends HttpServlet {

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
            case "history":
                showFeeHistory(request, response);
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
            response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
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
                response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
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
        String feeTypeFilter = request.getParameter("feeType");
        String zoneIdStr = request.getParameter("zoneId");
        Integer zoneIdFilter = null;
        
        if (zoneIdStr != null && !zoneIdStr.isEmpty()) {
            try {
                zoneIdFilter = Integer.parseInt(zoneIdStr);
            } catch (NumberFormatException e) {
                // Ignore invalid zone ID
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
        
        DeliveryFeeDAO feeDAO = new DeliveryFeeDAO();
        RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
        
        // Determine restaurant ID based on role
        Integer restaurantId = null;
        List<DeliveryFee> fees;
        List<RestaurantDeliveryZone> zones;
        
        if (user.getRoleID() == 1) {
            // SuperAdmin - can view all delivery fees
            fees = feeDAO.findFeesWithFilters(null, feeTypeFilter, zoneIdFilter, page, pageSize);
            zones = zoneDAO.getAllActiveZones();
        } else if (user.getRoleID() == 2 || user.getRoleID() == 3) {
            // Owner or Staff - can only view their restaurant's delivery fees
            restaurantId = (Integer) session.getAttribute("restaurantId");
            if (restaurantId == null) {
                session.setAttribute("toastMessage", "You must be assigned to a restaurant to view delivery fees");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            fees = feeDAO.findFeesWithFilters(restaurantId, feeTypeFilter, zoneIdFilter, page, pageSize);
            zones = zoneDAO.getActiveZonesByRestaurantId(restaurantId);
        } else {
            session.setAttribute("toastMessage", "You don't have permission to view delivery fees");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        int totalFees = feeDAO.getTotalFilteredFees(restaurantId, feeTypeFilter, zoneIdFilter);
        int totalPages = (int) Math.ceil((double) totalFees / pageSize);
        
        // Set attributes for JSP
        request.setAttribute("fees", fees);
        request.setAttribute("zones", zones);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalFees", totalFees);
        request.setAttribute("userRole", user.getRoleID());
        
        request.getRequestDispatcher("/views/owner/delivery-fee-list.jsp").forward(request, response);
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
        List<RestaurantDeliveryZone> zones;
        
        // Determine zones based on role
        if (user.getRoleID() == 1) {
            // SuperAdmin - can add fees for any zone
            zones = zoneDAO.getAllActiveZones();
        } else if (user.getRoleID() == 2 || user.getRoleID() == 3) {
            // Owner or Staff - can only add fees for their restaurant's zones
            Integer restaurantId = (Integer) session.getAttribute("restaurantId");
            if (restaurantId == null) {
                session.setAttribute("toastMessage", "You must be assigned to a restaurant to add delivery fees");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
                return;
            }
            zones = zoneDAO.getActiveZonesByRestaurantId(restaurantId);
            
            if (zones.isEmpty()) {
                session.setAttribute("toastMessage", "Please create coverage zones first before adding delivery fees");
                session.setAttribute("toastType", "warning");
                response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
                return;
            }
        } else {
            session.setAttribute("toastMessage", "You don't have permission to add delivery fees");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        request.setAttribute("zones", zones);
        request.setAttribute("userRole", user.getRoleID());
        // Pre-select zone if coming from coverage-zone accordion "Add Fee" button
        String preselectedZoneId = request.getParameter("zoneId");
        if (preselectedZoneId != null && !preselectedZoneId.trim().isEmpty()) {
            request.setAttribute("preselectedZoneId", preselectedZoneId.trim());
        }
        request.getRequestDispatcher("/views/owner/delivery-fee-add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");
        
        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String feeIdStr = request.getParameter("id");
        
        if (feeIdStr == null || feeIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
            return;
        }
        
        try {
            Integer feeId = Integer.parseInt(feeIdStr);
            DeliveryFeeDAO feeDAO = new DeliveryFeeDAO();
            DeliveryFee fee = feeDAO.findById(feeId);
            
            if (fee == null) {
                session.setAttribute("toastMessage", "Delivery fee not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
                return;
            }
            
            RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
            List<RestaurantDeliveryZone> zones;
            
            // Check permission based on role
            if (user.getRoleID() == 1) {
                // SuperAdmin - can edit any fee
                zones = zoneDAO.getAllActiveZones();
            } else if (user.getRoleID() == 2 || user.getRoleID() == 3) {
                // Owner or Staff - verify the fee belongs to their restaurant
                Integer restaurantId = (Integer) session.getAttribute("restaurantId");
                if (restaurantId == null) {
                    session.setAttribute("toastMessage", "You must be assigned to a restaurant");
                    session.setAttribute("toastType", "error");
                    response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
                    return;
                }
                
                // Verify the fee's zone belongs to their restaurant
                RestaurantDeliveryZone zone = zoneDAO.findById(fee.getZoneId());
                if (zone == null || !zone.getRestaurantId().equals(restaurantId)) {
                    session.setAttribute("toastMessage", "You don't have permission to edit this delivery fee");
                    session.setAttribute("toastType", "error");
                    response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
                    return;
                }
                
                zones = zoneDAO.getActiveZonesByRestaurantId(restaurantId);
            } else {
                session.setAttribute("toastMessage", "You don't have permission to edit delivery fees");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            
            request.setAttribute("fee", fee);
            request.setAttribute("zones", zones);
            request.setAttribute("userRole", user.getRoleID());
            request.getRequestDispatcher("/views/owner/delivery-fee-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        String zoneIdStr = request.getParameter("zoneId");
        String feeType = request.getParameter("feeType");
        String feeValueStr = request.getParameter("feeValue");
        String minOrderAmountStr = request.getParameter("minOrderAmount");
        String maxOrderAmountStr = request.getParameter("maxOrderAmount");
        String isActiveStr = request.getParameter("isActive");
        
        // Validation
        if (zoneIdStr == null || zoneIdStr.isEmpty()) {
            session.setAttribute("toastMessage", "Coverage zone is required");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/delivery-fee?action=add");
            return;
        }
        
        if (feeType == null || feeType.isEmpty()) {
            session.setAttribute("toastMessage", "Fee type is required");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/delivery-fee?action=add");
            return;
        }
        
        if (feeValueStr == null || feeValueStr.isEmpty()) {
            session.setAttribute("toastMessage", "Fee value is required");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/delivery-fee?action=add");
            return;
        }
        
        try {
            Integer zoneId = Integer.parseInt(zoneIdStr);
            BigDecimal feeValue = new BigDecimal(feeValueStr);
            BigDecimal minOrderAmount = null;
            BigDecimal maxOrderAmount = null;

            if (minOrderAmountStr != null && !minOrderAmountStr.trim().isEmpty()) {
                minOrderAmount = new BigDecimal(minOrderAmountStr);
            }

            if (maxOrderAmountStr != null && !maxOrderAmountStr.trim().isEmpty()) {
                maxOrderAmount = new BigDecimal(maxOrderAmountStr);
            }

            DeliveryFeeDAO feeDAO = new DeliveryFeeDAO();

            // Check for duplicate/conflicting fee
            if (feeDAO.hasFeeConflict(zoneId, feeType, minOrderAmount, maxOrderAmount, null)) {
                session.setAttribute("toastMessage",
                    "A similar delivery fee already exists for this zone with the same type and overlapping conditions. " +
                    "Please adjust the fee type or order amount range.");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/delivery-fee?action=add");
                return;
            }

            Boolean isActive = isActiveStr != null && isActiveStr.equals("1");

            DeliveryFee fee = new DeliveryFee();
            fee.setZoneId(zoneId);
            fee.setFeeType(feeType);
            fee.setFeeValue(feeValue);
            fee.setMinOrderAmount(minOrderAmount);
            fee.setMaxOrderAmount(maxOrderAmount);
            fee.setIsActive(isActive);

            int result = feeDAO.insert(fee);

            if (result > 0) {
                session.setAttribute("toastMessage", "Delivery fee added successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to add delivery fee");
                session.setAttribute("toastType", "error");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid numeric value");
            session.setAttribute("toastType", "error");
        }

        // Redirect back to zone fees page if returnZoneId is present, else coverage-zone list
        String returnZoneId = request.getParameter("returnZoneId");
        if (returnZoneId != null && !returnZoneId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=fees&id=" + returnZoneId);
        } else {
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
        }
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String feeIdStr = request.getParameter("feeId");
        
        if (feeIdStr == null || feeIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
            return;
        }
        
        try {
            Integer feeId = Integer.parseInt(feeIdStr);
            String zoneIdStr = request.getParameter("zoneId");
            String feeType = request.getParameter("feeType");
            String feeValueStr = request.getParameter("feeValue");
            String minOrderAmountStr = request.getParameter("minOrderAmount");
            String maxOrderAmountStr = request.getParameter("maxOrderAmount");
            String isActiveStr = request.getParameter("isActive");
            
            // Validation
            if (zoneIdStr == null || zoneIdStr.isEmpty()) {
                session.setAttribute("toastMessage", "Coverage zone is required");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/delivery-fee?action=edit&id=" + feeId);
                return;
            }
            
            if (feeType == null || feeType.isEmpty()) {
                session.setAttribute("toastMessage", "Fee type is required");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/delivery-fee?action=edit&id=" + feeId);
                return;
            }
            
            if (feeValueStr == null || feeValueStr.isEmpty()) {
                session.setAttribute("toastMessage", "Fee value is required");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/delivery-fee?action=edit&id=" + feeId);
                return;
            }
            
            Integer zoneId = Integer.parseInt(zoneIdStr);
            BigDecimal feeValue = new BigDecimal(feeValueStr);
            BigDecimal minOrderAmount = null;
            BigDecimal maxOrderAmount = null;
            
            if (minOrderAmountStr != null && !minOrderAmountStr.trim().isEmpty()) {
                minOrderAmount = new BigDecimal(minOrderAmountStr);
            }
            
            if (maxOrderAmountStr != null && !maxOrderAmountStr.trim().isEmpty()) {
                maxOrderAmount = new BigDecimal(maxOrderAmountStr);
            }
            
            DeliveryFeeDAO feeDAO = new DeliveryFeeDAO();
            DeliveryFee fee = feeDAO.findById(feeId);
            
            if (fee == null) {
                session.setAttribute("toastMessage", "Delivery fee not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
                return;
            }
            
            // Check for duplicate/conflicting fee (exclude current fee)
            if (feeDAO.hasFeeConflict(zoneId, feeType, minOrderAmount, maxOrderAmount, feeId)) {
                session.setAttribute("toastMessage", 
                    "A similar delivery fee already exists for this zone with the same type and overlapping conditions. " +
                    "Please adjust the fee type or order amount range.");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/delivery-fee?action=edit&id=" + feeId);
                return;
            }
            
            Boolean isActive = isActiveStr != null && isActiveStr.equals("1");

            // Snapshot old values before mutation
            DeliveryFee oldFee = new DeliveryFee();
            oldFee.setFeeId(fee.getFeeId());
            oldFee.setFeeType(fee.getFeeType());
            oldFee.setFeeValue(fee.getFeeValue());
            oldFee.setMinOrderAmount(fee.getMinOrderAmount());
            oldFee.setMaxOrderAmount(fee.getMaxOrderAmount());

            fee.setZoneId(zoneId);
            fee.setFeeType(feeType);
            fee.setFeeValue(feeValue);
            fee.setMinOrderAmount(minOrderAmount);
            fee.setMaxOrderAmount(maxOrderAmount);
            fee.setIsActive(isActive);

            // Save updated fee with history record
            models.User user = (models.User) session.getAttribute("user");
            Integer userId = user != null ? user.getUserID() : null;
            boolean result = feeDAO.updateWithHistory(fee, oldFee, userId);

            if (result) {
                session.setAttribute("toastMessage", "Delivery fee updated successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to update delivery fee");
                session.setAttribute("toastType", "error");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid numeric value");
            session.setAttribute("toastType", "error");
        }

        // Redirect back to zone fees page using returnZoneId, else coverage-zone list
        String returnZoneId = request.getParameter("returnZoneId");
        if (returnZoneId != null && !returnZoneId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=fees&id=" + returnZoneId);
        } else {
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
        }
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String feeIdStr = request.getParameter("id");
        
        if (feeIdStr == null || feeIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
            return;
        }
        
        try {
            Integer feeId = Integer.parseInt(feeIdStr);
            DeliveryFeeDAO feeDAO = new DeliveryFeeDAO();
            boolean result = feeDAO.toggleStatus(feeId);

            if (result) {
                session.setAttribute("toastMessage", "Fee status updated successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to update fee status");
                session.setAttribute("toastType", "error");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid fee ID");
            session.setAttribute("toastType", "error");
        }

        // returnZone param is passed from coverage-zone-list.jsp toggle link
        String returnZone = request.getParameter("returnZone");
        if (returnZone != null && !returnZone.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/coverage-zone?action=list");
        } else {
            response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
        }
    }

    private void showFeeHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String feeIdStr = request.getParameter("id");
        if (feeIdStr == null || feeIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
            return;
        }

        try {
            Integer feeId = Integer.parseInt(feeIdStr);
            DeliveryFeeDAO feeDAO = new DeliveryFeeDAO();
            DeliveryFee fee = feeDAO.findById(feeId);

            if (fee == null) {
                session.setAttribute("toastMessage", "Delivery fee not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
                return;
            }

            List<DeliveryFeeHistory> history = feeDAO.getHistoryByFeeId(feeId);

            // Get zone info for display
            RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
            RestaurantDeliveryZone zone = zoneDAO.findById(fee.getZoneId());

            request.setAttribute("fee", fee);
            request.setAttribute("zone", zone);
            request.setAttribute("history", history);
            request.getRequestDispatcher("/views/owner/delivery-fee-history.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
        }
    }
}
