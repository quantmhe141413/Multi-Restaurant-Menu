package controllers;

import dal.UserDAO;
import dal.RestaurantDAO;
import models.Restaurant;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

@WebServlet(name = "RegisterController", urlPatterns = { "/register" })
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("home");
            return;
        }
        String role = request.getParameter("role");
        request.setAttribute("initialRole", role);
        request.getRequestDispatcher("views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String roleIDStr = request.getParameter("roleID");
        String roleQueryParam = request.getParameter("role"); // Also check URL parameter
        int roleID = 4; // Default to Customer

        // First check the URL parameter (most reliable)
        if ("owner".equals(roleQueryParam)) {
            roleID = 2;
        } else {
            // Fall back to the hidden field value
            try {
                if (roleIDStr != null) {
                    int selectedRole = Integer.parseInt(roleIDStr);
                    // Security check: Only allow Customer (4) and Owner (2)
                    if (selectedRole == 2 || selectedRole == 4) {
                        roleID = selectedRole;
                    }
                }
            } catch (NumberFormatException e) {
                // Keep default roleID if parsing fails
            }
        }

        UserDAO udao = new UserDAO();
        if (udao.checkEmailExists(email)) {
            request.setAttribute("error", "Email already exists!");
            request.setAttribute("initialRole", roleID == 2 ? "owner" : "customer");
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
            return;
        }

        User u = new User();
        u.setFullName(fullName);
        u.setEmail(email);
        u.setPasswordHash(password); // TODO: hash before storing
        u.setPhone(phone);
        u.setRoleID(roleID);

        int generatedId = udao.register(u);
        if (generatedId > 0) {
            if (roleID == 2) { // Restaurant Owner
                String rName = request.getParameter("restaurantName");
                String rAddress = request.getParameter("restaurantAddress");
                String rPhone = request.getParameter("restaurantPhone");
                String rDescription = request.getParameter("restaurantDescription");

                RestaurantDAO rdao = new RestaurantDAO();
                Restaurant rest = new Restaurant();
                rest.setOwnerId(generatedId);
                rest.setName(rName);
                rest.setAddress(rAddress);
                rest.setPhone(rPhone != null && !rPhone.isEmpty() ? rPhone : phone);
                rest.setDescription(rDescription);
                rest.setIsOpen(true);
                rest.setStatus("Approved"); // Auto-approving for now, or could set to "Pending"

                rdao.insertRestaurant(rest);

                // Tự động đăng nhập và chuyển hướng dashboard chủ nhà hàng
                User owner = udao.login(email, password); // Đảm bảo login trả về user vừa tạo
                if (owner != null) {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", owner);
                    // Lấy restaurantId vừa tạo
                    Restaurant createdRest = rdao.getRestaurantByOwnerId(owner.getUserID());
                    if (createdRest != null) {
                        session.setAttribute("restaurantId", createdRest.getRestaurantId());
                        java.util.List<Integer> rList = new java.util.ArrayList<>();
                        rList.add(createdRest.getRestaurantId());
                        session.setAttribute("restaurantIds", rList);
                    }
                    response.sendRedirect("restaurant-analytics-dashboard");
                    return;
                }
            }
            // Nếu là customer hoặc có lỗi khi tự động login owner
            response.sendRedirect("login?registered=1");
        } else {
            request.setAttribute("error", "Registration failed! Please try again.");
            request.setAttribute("initialRole", roleID == 2 ? "owner" : "customer");
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
        }
    }
}
