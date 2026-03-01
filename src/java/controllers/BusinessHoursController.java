package controllers;

import dal.BusinessHoursDAO;
import models.BusinessHours;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Time;
import java.util.List;

@WebServlet(name = "BusinessHoursController", urlPatterns = {"/business-hours"})
public class BusinessHoursController extends HttpServlet {

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
            response.sendRedirect(request.getContextPath() + "/business-hours?action=list");
            return;
        }
        
        switch (action) {
            case "update":
                handleUpdate(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/business-hours?action=list");
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
        
        // Get restaurant ID based on role
        // SuperAdmin (roleID=1): restaurantId will be null - can see all
        // Owner/Staff (roleID=2/3): restaurantId from session - see only their restaurant
        Integer restaurantId = getRestaurantIdForUser(session, user);
        
        // Only block Owner/Staff without restaurant assignment, not SuperAdmin
        if (user.getRoleID() != 1 && restaurantId == null) {
            session.setAttribute("toastMessage", "You must be assigned to a restaurant to view business hours");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        BusinessHoursDAO hoursDAO = new BusinessHoursDAO();
        List<BusinessHours> hoursList;
        
        if (restaurantId == null) {
            // SuperAdmin - get all business hours from all restaurants
            hoursList = hoursDAO.findAll();
        } else {
            // Owner/Staff - get only their restaurant's hours
            hoursList = hoursDAO.findByRestaurantId(restaurantId);
            
            // If no hours exist, initialize default hours
            if (hoursList.isEmpty()) {
                hoursDAO.initializeDefaultHours(restaurantId);
                hoursList = hoursDAO.findByRestaurantId(restaurantId);
            }
        }
        
        request.setAttribute("hoursList", hoursList);
        request.setAttribute("restaurantId", restaurantId);
        request.getRequestDispatcher("/views/owner/business-hours.jsp").forward(request, response);
    }
    
    /**
     * Get restaurant ID for user based on their role
     * Returns null for SuperAdmin (roleID = 1) - they can see all restaurants
     * Returns restaurantId for Owner/Staff (roleID = 2/3) - they see only their restaurant
     */
    private Integer getRestaurantIdForUser(HttpSession session, models.User user) {
        if (user.getRoleID() == 2 || user.getRoleID() == 3) {
            // Owner or Staff - get from session
            return (Integer) session.getAttribute("restaurantId");
        }
        // SuperAdmin (roleID = 1) returns null - will see all data
        return null;
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");
        
        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get restaurant ID based on role
        Integer restaurantId = getRestaurantIdForUser(session, user);
        
        // SuperAdmin cannot update business hours (no specific restaurant)
        // Only Owner/Staff with assigned restaurant can update
        if (restaurantId == null) {
            session.setAttribute("toastMessage", "You must be assigned to a restaurant to update business hours");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/business-hours?action=list");
            return;
        }
        
        BusinessHoursDAO hoursDAO = new BusinessHoursDAO();
        String[] daysOfWeek = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
        
        boolean allSuccess = true;
        
        for (String day : daysOfWeek) {
            String isOpenStr = request.getParameter(day + "_isOpen");
            String openingTimeStr = request.getParameter(day + "_openingTime");
            String closingTimeStr = request.getParameter(day + "_closingTime");
            
            Boolean isOpen = isOpenStr != null && isOpenStr.equals("1");
            
            // Validation: If open, times must be provided
            if (isOpen) {
                if (openingTimeStr == null || openingTimeStr.trim().isEmpty() ||
                    closingTimeStr == null || closingTimeStr.trim().isEmpty()) {
                    session.setAttribute("toastMessage", 
                        "Opening and closing times are required for " + day);
                    session.setAttribute("toastType", "error");
                    response.sendRedirect(request.getContextPath() + "/business-hours?action=list");
                    return;
                }
                
                try {
                    Time openingTime = Time.valueOf(openingTimeStr + ":00");
                    Time closingTime = Time.valueOf(closingTimeStr + ":00");
                    
                    // Validation: Closing time must be after opening time
                    if (closingTime.compareTo(openingTime) <= 0) {
                        session.setAttribute("toastMessage", 
                            "Closing time must be after opening time for " + day);
                        session.setAttribute("toastType", "error");
                        response.sendRedirect(request.getContextPath() + "/business-hours?action=list");
                        return;
                    }
                    
                    BusinessHours hours = new BusinessHours();
                    hours.setRestaurantId(restaurantId);
                    hours.setDayOfWeek(day);
                    hours.setOpeningTime(openingTime);
                    hours.setClosingTime(closingTime);
                    hours.setIsOpen(true);
                    
                    if (!hoursDAO.upsert(hours)) {
                        allSuccess = false;
                    }
                } catch (IllegalArgumentException e) {
                    session.setAttribute("toastMessage", "Invalid time format for " + day);
                    session.setAttribute("toastType", "error");
                    response.sendRedirect(request.getContextPath() + "/business-hours?action=list");
                    return;
                }
            } else {
                // Day is closed
                BusinessHours hours = new BusinessHours();
                hours.setRestaurantId(restaurantId);
                hours.setDayOfWeek(day);
                hours.setOpeningTime(null);
                hours.setClosingTime(null);
                hours.setIsOpen(false);
                
                if (!hoursDAO.upsert(hours)) {
                    allSuccess = false;
                }
            }
        }
        
        if (allSuccess) {
            session.setAttribute("toastMessage", "Business hours updated successfully");
            session.setAttribute("toastType", "success");
        } else {
            session.setAttribute("toastMessage", "Some hours could not be updated");
            session.setAttribute("toastType", "warning");
        }
        
        response.sendRedirect(request.getContextPath() + "/business-hours?action=list");
    }
}
