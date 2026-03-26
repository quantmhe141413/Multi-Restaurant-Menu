package controllers;

import dal.ShiftTemplateDAO;
import dal.EmployeeShiftDAO;
import models.ShiftTemplate;
import models.EmployeeShift;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;

@WebServlet(name = "ShiftManagementController", urlPatterns = {"/shift-management"})
public class ShiftManagementController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "templates";
        }
        
        switch (action) {
            case "templates":
                handleTemplatesList(request, response);
                break;
            case "add-template":
                showAddTemplateForm(request, response);
                break;
            case "edit-template":
                showEditTemplateForm(request, response);
                break;
            case "toggle-template":
                handleToggleTemplate(request, response);
                break;
            case "assignments":
                handleAssignmentsList(request, response);
                break;
            case "add-assignment":
                showAddAssignmentForm(request, response);
                break;
            case "edit-assignment":
                showEditAssignmentForm(request, response);
                break;
            case "delete-assignment":
                handleDeleteAssignment(request, response);
                break;
            default:
                handleTemplatesList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/shift-management?action=templates");
            return;
        }
        
        switch (action) {
            case "add-template":
                handleAddTemplate(request, response);
                break;
            case "edit-template":
                handleEditTemplate(request, response);
                break;
            case "add-assignment":
                handleAddAssignment(request, response);
                break;
            case "edit-assignment":
                handleEditAssignment(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/shift-management?action=templates");
                break;
        }
    }

    // ==================== SHIFT TEMPLATES ====================

    private void handleTemplatesList(HttpServletRequest request, HttpServletResponse response)
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
            session.setAttribute("toastMessage", "You must be assigned to a restaurant to view shift templates");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        ShiftTemplateDAO templateDAO = new ShiftTemplateDAO();
        List<ShiftTemplate> templates;
        
        if (restaurantId == null) {
            // SuperAdmin - get all templates from all restaurants
            templates = templateDAO.findAll();
        } else {
            // Owner/Staff - get only their restaurant's templates
            templates = templateDAO.findByRestaurantId(restaurantId);
        }
        
        request.setAttribute("templates", templates);
        request.getRequestDispatcher("/views/owner/shift-templates.jsp").forward(request, response);
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

    private void showAddTemplateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/owner/shift-template-add.jsp").forward(request, response);
    }

    private void showEditTemplateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String templateIdStr = request.getParameter("id");
        
        if (templateIdStr == null || templateIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/shift-management?action=templates");
            return;
        }
        
        try {
            Integer templateId = Integer.parseInt(templateIdStr);
            ShiftTemplateDAO templateDAO = new ShiftTemplateDAO();
            ShiftTemplate template = templateDAO.findById(templateId);
            
            if (template == null) {
                session.setAttribute("toastMessage", "Shift template not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=templates");
                return;
            }
            
            request.setAttribute("template", template);
            request.getRequestDispatcher("/views/owner/shift-template-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/shift-management?action=templates");
        }
    }

    private void handleAddTemplate(HttpServletRequest request, HttpServletResponse response)
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
            session.setAttribute("toastMessage", "You must be assigned to a restaurant to add shift templates");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/shift-management?action=templates");
            return;
        }
        
        String shiftName = request.getParameter("shiftName");
        String position = request.getParameter("position");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        String isActiveStr = request.getParameter("isActive");
        
        if (shiftName == null || shiftName.trim().isEmpty()) {
            session.setAttribute("toastMessage", "Shift name is required");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/shift-management?action=add-template");
            return;
        }
        
        try {
            Time startTime = Time.valueOf(startTimeStr + ":00");
            Time endTime = Time.valueOf(endTimeStr + ":00");
            
            if (endTime.compareTo(startTime) <= 0) {
                session.setAttribute("toastMessage", "End time must be after start time");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=add-template");
                return;
            }
            
            Boolean isActive = isActiveStr != null && isActiveStr.equals("1");
            
            ShiftTemplate template = new ShiftTemplate();
            template.setRestaurantId(restaurantId);
            template.setShiftName(shiftName.trim());
            template.setPosition(position);
            template.setStartTime(startTime);
            template.setEndTime(endTime);
            template.setIsActive(isActive);
            
            ShiftTemplateDAO templateDAO = new ShiftTemplateDAO();
            int result = templateDAO.insert(template);
            
            if (result > 0) {
                session.setAttribute("toastMessage", "Shift template added successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to add shift template");
                session.setAttribute("toastType", "error");
            }
        } catch (IllegalArgumentException e) {
            session.setAttribute("toastMessage", "Invalid time format");
            session.setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/shift-management?action=templates");
    }

    private void handleEditTemplate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String templateIdStr = request.getParameter("templateId");
        
        if (templateIdStr == null || templateIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/shift-management?action=templates");
            return;
        }
        
        try {
            Integer templateId = Integer.parseInt(templateIdStr);
            ShiftTemplateDAO templateDAO = new ShiftTemplateDAO();
            ShiftTemplate template = templateDAO.findById(templateId);
            
            if (template == null) {
                session.setAttribute("toastMessage", "Shift template not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=templates");
                return;
            }
            
            String shiftName = request.getParameter("shiftName");
            String position = request.getParameter("position");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String isActiveStr = request.getParameter("isActive");
            
            Time startTime = Time.valueOf(startTimeStr + ":00");
            Time endTime = Time.valueOf(endTimeStr + ":00");
            
            if (endTime.compareTo(startTime) <= 0) {
                session.setAttribute("toastMessage", "End time must be after start time");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=edit-template&id=" + templateId);
                return;
            }
            
            Boolean isActive = isActiveStr != null && isActiveStr.equals("1");
            
            template.setShiftName(shiftName.trim());
            template.setPosition(position);
            template.setStartTime(startTime);
            template.setEndTime(endTime);
            template.setIsActive(isActive);
            
            boolean result = templateDAO.update(template);
            
            if (result) {
                session.setAttribute("toastMessage", "Shift template updated successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to update shift template");
                session.setAttribute("toastType", "error");
            }
        } catch (Exception e) {
            session.setAttribute("toastMessage", "Error: " + e.getMessage());
            session.setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/shift-management?action=templates");
    }

    private void handleToggleTemplate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String templateIdStr = request.getParameter("id");
        
        if (templateIdStr == null || templateIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/shift-management?action=templates");
            return;
        }
        
        try {
            Integer templateId = Integer.parseInt(templateIdStr);
            ShiftTemplateDAO templateDAO = new ShiftTemplateDAO();
            boolean result = templateDAO.toggleStatus(templateId);
            
            if (result) {
                session.setAttribute("toastMessage", "Template status updated successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to update template status");
                session.setAttribute("toastType", "error");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid template ID");
            session.setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/shift-management?action=templates");
    }

    // ==================== SHIFT ASSIGNMENTS ====================

    private void handleAssignmentsList(HttpServletRequest request, HttpServletResponse response)
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
            session.setAttribute("toastMessage", "You must be assigned to a restaurant to view shift assignments");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        String dateStr = request.getParameter("date");
        Date selectedDate = null;
        
        // Only filter by date if date parameter is provided
        if (dateStr != null && !dateStr.trim().isEmpty()) {
            selectedDate = Date.valueOf(dateStr);
        }
        
        EmployeeShiftDAO shiftDAO = new EmployeeShiftDAO();
        List<EmployeeShift> shifts;
        
        if (restaurantId == null) {
            // SuperAdmin - get all shifts from all restaurants
            if (selectedDate == null) {
                shifts = shiftDAO.findAll();
            } else {
                shifts = shiftDAO.findByDate(selectedDate);
            }
        } else {
            // Owner/Staff - get only their restaurant's shifts
            shifts = shiftDAO.findByRestaurantAndDate(restaurantId, selectedDate);
        }
        
        request.setAttribute("shifts", shifts);
        request.setAttribute("selectedDate", selectedDate);
        request.getRequestDispatcher("/views/owner/shift-assignments.jsp").forward(request, response);
    }

    private void showAddAssignmentForm(HttpServletRequest request, HttpServletResponse response)
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
            session.setAttribute("toastMessage", "You must be assigned to a restaurant to add shift assignments");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
            return;
        }
        
        EmployeeShiftDAO shiftDAO = new EmployeeShiftDAO();
        ShiftTemplateDAO templateDAO = new ShiftTemplateDAO();
        
        List<models.User> availableStaff = shiftDAO.getAvailableStaff(restaurantId);
        List<ShiftTemplate> templates = templateDAO.findActiveByRestaurantId(restaurantId);
        
        request.setAttribute("availableStaff", availableStaff);
        request.setAttribute("templates", templates);
        request.getRequestDispatcher("/views/owner/shift-assignment-add.jsp").forward(request, response);
    }

    private void handleAddAssignment(HttpServletRequest request, HttpServletResponse response)
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
            session.setAttribute("toastMessage", "You must be assigned to a restaurant to add shift assignments");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
            return;
        }
        
        String staffIdStr = request.getParameter("staffId");
        String shiftDateStr = request.getParameter("shiftDate");
        String templateIdStr = request.getParameter("templateId");
        
        try {
            Integer staffId = Integer.parseInt(staffIdStr);
            Date shiftDate = Date.valueOf(shiftDateStr);
            Integer templateId = Integer.parseInt(templateIdStr);
            
            // Validate: Cannot create shift for past dates
            Date currentDate = new Date(System.currentTimeMillis());
            if (shiftDate.before(currentDate)) {
                session.setAttribute("toastMessage", "Cannot create shift for past dates");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=add-assignment");
                return;
            }
            
            EmployeeShiftDAO shiftDAO = new EmployeeShiftDAO();
            
            // Check for overlapping shifts (using templateId)
            if (shiftDAO.hasOverlappingShift(staffId, shiftDate, templateId, null)) {
                session.setAttribute("toastMessage", "Employee already has an overlapping shift on this date");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=add-assignment");
                return;
            }
            
            EmployeeShift shift = new EmployeeShift();
            shift.setRestaurantId(restaurantId);
            shift.setStaffId(staffId);
            shift.setShiftDate(shiftDate);
            shift.setTemplateId(templateId);
            
            int result = shiftDAO.insert(shift);
            
            if (result > 0) {
                session.setAttribute("toastMessage", "Shift assignment added successfully");
                session.setAttribute("toastType", "success");
                // Redirect to the date that was just assigned
                response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments&date=" + shiftDateStr);
            } else {
                session.setAttribute("toastMessage", "Failed to add shift assignment");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
            }
        } catch (Exception e) {
            session.setAttribute("toastMessage", "Error: " + e.getMessage());
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
        }
    }

    private void showEditAssignmentForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String shiftIdStr = request.getParameter("id");
        System.out.println("[DEBUG] edit-assignment id param: " + shiftIdStr);
        
        if (shiftIdStr == null || shiftIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
            return;
        }

        try {
            Integer shiftId = Integer.parseInt(shiftIdStr);
            EmployeeShiftDAO shiftDAO = new EmployeeShiftDAO();
            EmployeeShift shift = shiftDAO.findById(shiftId);
            System.out.println("[DEBUG] shift found: " + shift);

            if (shift == null) {
                System.out.println("[DEBUG] shift is null, redirecting to assignments");
                session.setAttribute("toastMessage", "Shift assignment not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
                return;
            }

            // Cannot edit past shifts
            Date currentDate = new Date(System.currentTimeMillis());
            System.out.println("[DEBUG] shiftDate=" + shift.getShiftDate() + " currentDate=" + currentDate + " isPast=" + shift.getShiftDate().before(currentDate));
            if (shift.getShiftDate().before(currentDate)) {
                session.setAttribute("toastMessage", "Cannot edit past shift assignments");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
                return;
            }

            Integer restaurantId = getRestaurantIdForUser(session, user);
            System.out.println("[DEBUG] restaurantId=" + restaurantId + " userRole=" + user.getRoleID());
            if (restaurantId == null) {
                session.setAttribute("toastMessage", "You must be assigned to a restaurant to edit shift assignments");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
                return;
            }

            ShiftTemplateDAO templateDAO = new ShiftTemplateDAO();
            List<models.User> availableStaff = shiftDAO.getAvailableStaff(restaurantId);
            List<ShiftTemplate> templates = templateDAO.findActiveByRestaurantId(restaurantId);

            System.out.println("[DEBUG] forwarding to shift-assignment-edit.jsp");
            request.setAttribute("shift", shift);
            request.setAttribute("availableStaff", availableStaff);
            request.setAttribute("templates", templates);
            request.getRequestDispatcher("/views/owner/shift-assignment-edit.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("[DEBUG] Exception in showEditAssignmentForm: " + e.getClass().getName() + ": " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("toastMessage", "Error: " + e.getMessage());
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
        }
    }

    private void handleEditAssignment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String shiftIdStr = request.getParameter("shiftId");
        String staffIdStr = request.getParameter("staffId");
        String shiftDateStr = request.getParameter("shiftDate");
        String templateIdStr = request.getParameter("templateId");

        try {
            Integer shiftId = Integer.parseInt(shiftIdStr);
            Integer staffId = Integer.parseInt(staffIdStr);
            Date shiftDate = Date.valueOf(shiftDateStr);
            Integer templateId = Integer.parseInt(templateIdStr);

            // Cannot edit to a past date
            Date currentDate = new Date(System.currentTimeMillis());
            if (shiftDate.before(currentDate)) {
                session.setAttribute("toastMessage", "Cannot assign shift to a past date");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=edit-assignment&id=" + shiftId);
                return;
            }

            EmployeeShiftDAO shiftDAO = new EmployeeShiftDAO();

            // Check for overlapping shifts, excluding current shift
            if (shiftDAO.hasOverlappingShift(staffId, shiftDate, templateId, shiftId)) {
                session.setAttribute("toastMessage", "Employee already has an overlapping shift on this date");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=edit-assignment&id=" + shiftId);
                return;
            }

            EmployeeShift shift = new EmployeeShift();
            shift.setShiftId(shiftId);
            shift.setStaffId(staffId);
            shift.setShiftDate(shiftDate);
            shift.setTemplateId(templateId);

            boolean result = shiftDAO.update(shift);

            if (result) {
                session.setAttribute("toastMessage", "Shift assignment updated successfully");
                session.setAttribute("toastType", "success");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments&date=" + shiftDateStr);
            } else {
                session.setAttribute("toastMessage", "Failed to update shift assignment");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=edit-assignment&id=" + shiftId);
            }
        } catch (Exception e) {
            session.setAttribute("toastMessage", "Error: " + e.getMessage());
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
        }
    }

    private void handleDeleteAssignment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String shiftIdStr = request.getParameter("id");
        
        if (shiftIdStr == null || shiftIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
            return;
        }
        
        try {
            Integer shiftId = Integer.parseInt(shiftIdStr);
            EmployeeShiftDAO shiftDAO = new EmployeeShiftDAO();
            
            // Get the shift to check its date
            EmployeeShift shift = shiftDAO.findById(shiftId);
            
            if (shift == null) {
                session.setAttribute("toastMessage", "Shift assignment not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
                return;
            }
            
            // Validate: Cannot delete past shifts
            Date currentDate = new Date(System.currentTimeMillis());
            if (shift.getShiftDate().before(currentDate)) {
                session.setAttribute("toastMessage", "Cannot delete past shift assignments");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
                return;
            }
            
            boolean result = shiftDAO.delete(shiftId);
            
            if (result) {
                session.setAttribute("toastMessage", "Shift assignment deleted successfully");
                session.setAttribute("toastType", "success");
            } else {
                session.setAttribute("toastMessage", "Failed to delete shift assignment");
                session.setAttribute("toastType", "error");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid shift ID");
            session.setAttribute("toastType", "error");
        }
        
        response.sendRedirect(request.getContextPath() + "/shift-management?action=assignments");
    }
}
