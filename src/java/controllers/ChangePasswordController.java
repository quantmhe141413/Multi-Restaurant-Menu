package controllers;

import dal.UserDAO;
import models.User;
import utils.PasswordUtils;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ChangePasswordController", urlPatterns = { "/change-password" })
public class ChangePasswordController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới không khớp.");
            request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
            return;
        }
        UserDAO userDAO = new UserDAO();
        if (!PasswordUtils.verifyPassword(oldPassword, user.getPasswordHash())) {
            request.setAttribute("error", "Mật khẩu cũ không đúng.");
            request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
            return;
        }
        userDAO.updatePassword(user.getUserID(), PasswordUtils.hashPassword(newPassword));
        request.setAttribute("success", "Đổi mật khẩu thành công.");
        request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
    }
}