package controllers;

import dal.DeliveryFeeDAO;
import dal.RestaurantDeliveryZoneDAO;
import models.DeliveryFee;
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
        // Get ALL fees (pass null to get all)
        List<DeliveryFee> fees = feeDAO.findFeesWithFilters(
                null, feeTypeFilter, zoneIdFilter, page, pageSize);
        
        int totalFees = feeDAO.getTotalFilteredFees(null, feeTypeFilter, zoneIdFilter);
        int totalPages = (int) Math.ceil((double) totalFees / pageSize);
        
        // Get all active zones for filter dropdown
        RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
        List<RestaurantDeliveryZone> zones = zoneDAO.getAllActiveZones();
        
        // Set attributes for JSP
        request.setAttribute("fees", fees);
        request.setAttribute("zones", zones);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalFees", totalFees);
        
        request.getRequestDispatcher("/views/owner/delivery-fee-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get ALL active zones for dropdown (not filtered by restaurant)
        RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
        List<RestaurantDeliveryZone> zones = zoneDAO.getAllActiveZones();
        
        request.setAttribute("zones", zones);
        request.getRequestDispatcher("/views/owner/delivery-fee-add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
                HttpSession session = request.getSession();
                session.setAttribute("toastMessage", "Delivery fee not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
                return;
            }
            
            // Get all active zones for dropdown
            RestaurantDeliveryZoneDAO zoneDAO = new RestaurantDeliveryZoneDAO();
            List<RestaurantDeliveryZone> zones = zoneDAO.getAllActiveZones();
            
            request.setAttribute("fee", fee);
            request.setAttribute("zones", zones);
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
        
        response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
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
            
            fee.setZoneId(zoneId);
            fee.setFeeType(feeType);
            fee.setFeeValue(feeValue);
            fee.setMinOrderAmount(minOrderAmount);
            fee.setMaxOrderAmount(maxOrderAmount);
            fee.setIsActive(isActive);
            
            boolean result = feeDAO.update(fee);
            
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
        
        response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
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
        
        response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
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
            boolean result = feeDAO.delete(feeId);
            
            if (result) {
                session.setAttribute("toastMessage", "Delivery fee deleted successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Cannot delete fee: applied to ongoing orders");
                session.setAttribute("toastType", "error");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid fee ID");
            session.setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/delivery-fee?action=list");
    }
}
