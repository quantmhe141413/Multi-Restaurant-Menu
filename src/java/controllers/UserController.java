package controllers;

import dao.UserDAO;
import models.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class UserController extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        // Only admin can access
        if (!currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "view":
                viewUser(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            case "ban":
                toggleUserStatus(request, response);
                break;
            default:
                listUsers(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        if (!currentUser.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addUser(request, response);
        } else if ("edit".equals(action)) {
            updateUser(request, response);
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Admin only manages librarian users (staff)
        List<User> users = userDAO.getUsersByRole("librarian");
        request.setAttribute("users", users);
        request.getRequestDispatcher("/views/users/list.jsp").forward(request, response);
    }
    
    private void viewUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        User user = userDAO.getUserById(userId);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/users/view.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/users/add.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        User user = userDAO.getUserById(userId);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/users/edit.jsp").forward(request, response);
    }
    
    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            User user = new User();
            user.setUsername(request.getParameter("username"));
            user.setPassword(request.getParameter("password"));
            // Admin can only create librarian users
            user.setRole("librarian");
            user.setFullName(request.getParameter("fullName"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            user.setStatus(true); // Active by default
            
            if (userDAO.createUser(user)) {
                response.sendRedirect(request.getContextPath() + "/users?success=added");
            } else {
                request.setAttribute("error", "Failed to add user");
                showAddForm(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            showAddForm(request, response);
        }
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            User user = new User();
            user.setUserId(Integer.parseInt(request.getParameter("userId")));
            user.setUsername(request.getParameter("username"));
            
            // Only update password if provided
            String newPassword = request.getParameter("password");
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                user.setPassword(newPassword);
            } else {
                // Keep existing password
                User existingUser = userDAO.getUserById(user.getUserId());
                user.setPassword(existingUser.getPassword());
            }
            
            // Admin can only manage librarian users, role cannot be changed
            user.setRole("librarian");
            user.setFullName(request.getParameter("fullName"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            user.setStatus("1".equals(request.getParameter("status")));
            
            if (userDAO.updateUser(user)) {
                response.sendRedirect(request.getContextPath() + "/users?success=updated");
            } else {
                request.setAttribute("error", "Failed to update user");
                showEditForm(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
            showEditForm(request, response);
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        int userId = Integer.parseInt(request.getParameter("id"));
        User userToDelete = userDAO.getUserById(userId);
        
        // Prevent self-deletion
        if (userId == currentUser.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/users?error=cannot_delete_self");
            return;
        }
        
        // Only allow deleting librarian users
        if (userToDelete == null || !"librarian".equals(userToDelete.getRole())) {
            response.sendRedirect(request.getContextPath() + "/users?error=invalid_user");
            return;
        }
        
        if (userDAO.deleteUser(userId)) {
            response.sendRedirect(request.getContextPath() + "/users?success=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/users?error=delete_failed");
        }
    }
    
    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("user");
        
        int userId = Integer.parseInt(request.getParameter("id"));
        User userToToggle = userDAO.getUserById(userId);
        
        // Prevent self-ban
        if (userId == currentUser.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/users?error=cannot_ban_self");
            return;
        }
        
        // Only allow toggling librarian users
        if (userToToggle == null || !"librarian".equals(userToToggle.getRole())) {
            response.sendRedirect(request.getContextPath() + "/users?error=invalid_user");
            return;
        }
        
        if (userDAO.toggleUserStatus(userId)) {
            response.sendRedirect(request.getContextPath() + "/users?success=status_changed");
        } else {
            response.sendRedirect(request.getContextPath() + "/users?error=status_change_failed");
        }
    }
}
