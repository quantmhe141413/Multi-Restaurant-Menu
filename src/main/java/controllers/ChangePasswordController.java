package controllers;

import dal.UserDAO;
import models.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ChangePasswordController", urlPatterns = { "/change-password" })
public class ChangePasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate inputs
        if (oldPassword == null || oldPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin");
            request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
            return;
        }

        // Verify old password (Note: In a real app, use PasswordHash comparison)
        // Since the current app uses PasswordHash as the field name but stores plaintext in login()? 
        // Let's check login logic in UserDAO again.
        
        UserDAO dao = new UserDAO();
        User currentUser = dao.login(user.getEmail(), oldPassword);
        
        if (currentUser == null) {
            request.setAttribute("error", "Mật khẩu cũ không chính xác");
            request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
            return;
        }

        // Validate new password strength
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự");
            request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
            return;
        }

        if (newPassword.equals(oldPassword)) {
            request.setAttribute("error", "Mật khẩu mới không được trùng với mật khẩu cũ");
            request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
            return;
        }

        // Update password
        boolean success = dao.changePassword(user.getUserID(), newPassword);

        if (success) {
            request.setAttribute("success", "Đổi mật khẩu thành công!");
            request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau.");
            request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
        }
    }
}
