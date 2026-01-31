package controllers;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ResetPasswordController", urlPatterns = { "/reset-password" })
public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");

        // Validate token
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Link reset không hợp lệ");
            request.getRequestDispatcher("views/reset-password.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();

        // Check if token is valid and not expired
        if (!dao.isResetTokenValid(token)) {
            request.setAttribute("error", "Link reset đã hết hạn hoặc không hợp lệ");
            request.getRequestDispatcher("views/reset-password.jsp").forward(request, response);
            return;
        }

        request.setAttribute("token", token);
        request.getRequestDispatcher("views/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate token
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Token không hợp lệ");
            request.getRequestDispatcher("views/reset-password.jsp").forward(request, response);
            return;
        }

        // Validate new password
        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu mới");
            request.setAttribute("token", token);
            request.getRequestDispatcher("views/reset-password.jsp").forward(request, response);
            return;
        }

        // Validate password length
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.setAttribute("token", token);
            request.getRequestDispatcher("views/reset-password.jsp").forward(request, response);
            return;
        }

        // Validate password strength
        if (!newPassword.matches(".*[A-Z].*")) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 1 chữ hoa");
            request.setAttribute("token", token);
            request.getRequestDispatcher("views/reset-password.jsp").forward(request, response);
            return;
        }

        if (!newPassword.matches(".*[0-9].*")) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 1 số");
            request.setAttribute("token", token);
            request.getRequestDispatcher("views/reset-password.jsp").forward(request, response);
            return;
        }

        // Validate confirm password
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.setAttribute("token", token);
            request.getRequestDispatcher("views/reset-password.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();

        // Check if token is still valid
        if (!dao.isResetTokenValid(token)) {
            request.setAttribute("error", "Link reset đã hết hạn hoặc không hợp lệ");
            request.getRequestDispatcher("views/reset-password.jsp").forward(request, response);
            return;
        }

        // Reset password
        boolean success = dao.resetPassword(token, newPassword);

        if (success) {
            request.setAttribute("success", "Đổi mật khẩu thành công! Bạn có thể đăng nhập ngay bây giờ.");
            request.getRequestDispatcher("views/reset-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau.");
            request.setAttribute("token", token);
            request.getRequestDispatcher("views/reset-password.jsp").forward(request, response);
        }
    }
}
