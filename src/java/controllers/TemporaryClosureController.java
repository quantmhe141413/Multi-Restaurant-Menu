package controllers;

import dal.TemporaryClosureDAO;
import models.TemporaryClosure;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "TemporaryClosureController", urlPatterns = {"/temporary-closure"})
public class TemporaryClosureController extends HttpServlet {

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
            response.sendRedirect(request.getContextPath() + "/temporary-closure?action=list");
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
                response.sendRedirect(request.getContextPath() + "/temporary-closure?action=list");
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
            session.setAttribute("toastMessage", "You must be assigned to a restaurant to view temporary closures");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        TemporaryClosureDAO closureDAO = new TemporaryClosureDAO();
        List<TemporaryClosure> closures;
        TemporaryClosure activeClosure = null;
        
        if (restaurantId == null) {
            // SuperAdmin - get all temporary closures from all restaurants
            closures = closureDAO.findAll();
        } else {
            // Owner/Staff - get only their restaurant's closures
            closures = closureDAO.findByRestaurantId(restaurantId);
            activeClosure = closureDAO.getActiveClosure(restaurantId);
        }
        
        request.setAttribute("closures", closures);
        request.setAttribute("activeClosure", activeClosure);
        request.setAttribute("restaurantId", restaurantId);
        request.getRequestDispatcher("/views/owner/temporary-closure-list.jsp").forward(request, response);
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

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/owner/temporary-closure-add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String closureIdStr = request.getParameter("id");
        
        if (closureIdStr == null || closureIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/temporary-closure?action=list");
            return;
        }
        
        try {
            Integer closureId = Integer.parseInt(closureIdStr);
            TemporaryClosureDAO closureDAO = new TemporaryClosureDAO();
            TemporaryClosure closure = closureDAO.findById(closureId);
            
            if (closure == null) {
                session.setAttribute("toastMessage", "Temporary closure not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/temporary-closure?action=list");
                return;
            }
            
            request.setAttribute("closure", closure);
            request.getRequestDispatcher("/views/owner/temporary-closure-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/temporary-closure?action=list");
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
        Integer restaurantId = getRestaurantIdForUser(session, user);
        
        if (restaurantId == null) {
            session.setAttribute("toastMessage", "You must be assigned to a restaurant to add temporary closures");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/temporary-closure?action=list");
            return;
        }
        
        String startDateTimeStr = request.getParameter("startDateTime");
        String endDateTimeStr = request.getParameter("endDateTime");
        String reason = request.getParameter("reason");
        String isActiveStr = request.getParameter("isActive");
        
        // Validation: Required fields
        if (startDateTimeStr == null || startDateTimeStr.trim().isEmpty() ||
            endDateTimeStr == null || endDateTimeStr.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Start and end date/time are required");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/temporary-closure?action=add");
            return;
        }
        
        try {
            Timestamp startDateTime = Timestamp.valueOf(startDateTimeStr.replace("T", " ") + ":00");
            Timestamp endDateTime = Timestamp.valueOf(endDateTimeStr.replace("T", " ") + ":00");
            Timestamp currentDateTime = new Timestamp(System.currentTimeMillis());
            
            // Validation 1: Start date cannot be in the past
            if (startDateTime.before(currentDateTime)) {
                session.setAttribute("toastMessage", "Start date/time cannot be in the past");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/temporary-closure?action=add");
                return;
            }
            
            // Validation 2: End must be after start
            if (endDateTime.compareTo(startDateTime) <= 0) {
                session.setAttribute("toastMessage", "End date/time must be after start date/time");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/temporary-closure?action=add");
                return;
            }
            
            Boolean isActive = isActiveStr != null && isActiveStr.equals("1");
            
            TemporaryClosure closure = new TemporaryClosure();
            closure.setRestaurantId(restaurantId);
            closure.setStartDateTime(startDateTime);
            closure.setEndDateTime(endDateTime);
            closure.setReason(reason);
            closure.setIsActive(isActive);
            
            TemporaryClosureDAO closureDAO = new TemporaryClosureDAO();
            int result = closureDAO.insert(closure);
            
            if (result > 0) {
                session.setAttribute("toastMessage", "Temporary closure added successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to add temporary closure");
                session.setAttribute("toastType", "error");
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("toastMessage", "Invalid date/time format: " + e.getMessage());
            session.setAttribute("toastType", "error");
        } catch (Exception e) {
            session.setAttribute("toastMessage", "Error: " + e.getMessage());
            session.setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/temporary-closure?action=list");
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String closureIdStr = request.getParameter("closureId");
        
        if (closureIdStr == null || closureIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/temporary-closure?action=list");
            return;
        }
        
        try {
            Integer closureId = Integer.parseInt(closureIdStr);
            String startDateTimeStr = request.getParameter("startDateTime");
            String endDateTimeStr = request.getParameter("endDateTime");
            String reason = request.getParameter("reason");
            String isActiveStr = request.getParameter("isActive");
            
            TemporaryClosureDAO closureDAO = new TemporaryClosureDAO();
            TemporaryClosure closure = closureDAO.findById(closureId);
            
            if (closure == null) {
                session.setAttribute("toastMessage", "Temporary closure not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/temporary-closure?action=list");
                return;
            }
            
            Timestamp startDateTime = Timestamp.valueOf(startDateTimeStr.replace("T", " ") + ":00");
            Timestamp endDateTime = Timestamp.valueOf(endDateTimeStr.replace("T", " ") + ":00");
            Timestamp currentDateTime = new Timestamp(System.currentTimeMillis());
            
            // Validation 1: Start date cannot be in the past (only for future closures)
            if (startDateTime.before(currentDateTime)) {
                session.setAttribute("toastMessage", "Start date/time cannot be in the past");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/temporary-closure?action=edit&id=" + closureId);
                return;
            }
            
            // Validation 2: End must be after start
            if (endDateTime.compareTo(startDateTime) <= 0) {
                session.setAttribute("toastMessage", "End date/time must be after start date/time");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/temporary-closure?action=edit&id=" + closureId);
                return;
            }
            
            Boolean isActive = isActiveStr != null && isActiveStr.equals("1");
            
            closure.setStartDateTime(startDateTime);
            closure.setEndDateTime(endDateTime);
            closure.setReason(reason);
            closure.setIsActive(isActive);
            
            boolean result = closureDAO.update(closure);
            
            if (result) {
                session.setAttribute("toastMessage", "Temporary closure updated successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to update temporary closure");
                session.setAttribute("toastType", "error");
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("toastMessage", "Invalid date/time format: " + e.getMessage());
            session.setAttribute("toastType", "error");
        } catch (Exception e) {
            session.setAttribute("toastMessage", "Error: " + e.getMessage());
            session.setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/temporary-closure?action=list");
    }

    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String closureIdStr = request.getParameter("id");
        
        if (closureIdStr == null || closureIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/temporary-closure?action=list");
            return;
        }
        
        try {
            Integer closureId = Integer.parseInt(closureIdStr);
            TemporaryClosureDAO closureDAO = new TemporaryClosureDAO();
            boolean result = closureDAO.toggleStatus(closureId);
            
            if (result) {
                session.setAttribute("toastMessage", "Closure status updated successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to update closure status");
                session.setAttribute("toastType", "error");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid closure ID");
            session.setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/temporary-closure?action=list");
    }
}
