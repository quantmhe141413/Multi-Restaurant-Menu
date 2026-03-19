package controllers;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

@WebServlet(name = "LoginController", urlPatterns = { "/login" })
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.getRoleID() == 1) { // SuperAdmin
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if (user.getRoleID() == 2) { // Owner
                response.sendRedirect(request.getContextPath() + "/owner/order-history");
            } else if (user.getRoleID() == 3) { // Staff
                response.sendRedirect(request.getContextPath() + "/staff/home");
            } else { // Customer
                response.sendRedirect("home");
            }
            return;
        }
        request.getRequestDispatcher("views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO udao = new UserDAO();
        User u = udao.login(email, password);

        if (u != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", u);
            if (u.getRoleID() == 2 || u.getRoleID() == 3) {
                Integer restaurantId = udao.getRestaurantIdByUserId(u.getUserID());
                if (restaurantId != null) {
                    session.setAttribute("restaurantId", restaurantId);
                }
            }
            
            if (u.getRoleID() == 1) { // SuperAdmin
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if (u.getRoleID() == 2) { // Owner
                response.sendRedirect(request.getContextPath() + "/owner/order-history");
            } else if (u.getRoleID() == 3) { // Staff
                response.sendRedirect(request.getContextPath() + "/staff/home");
            } else { // Customer
                response.sendRedirect("home");
            }
        } else {
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("views/login.jsp").forward(request, response);
        }
    }
}
