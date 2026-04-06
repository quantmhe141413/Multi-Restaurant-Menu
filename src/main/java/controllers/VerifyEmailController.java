package controllers;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "VerifyEmailController", urlPatterns = {"/verify-email"})
public class VerifyEmailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        HttpSession session = request.getSession();

        if (token == null || token.trim().isEmpty()) {
            session.setAttribute("message", "Mã xác thực không hợp lệ hoặc bị thiếu.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserDAO userDAO = new UserDAO();
        boolean verified = userDAO.verifyEmail(token);

        if (verified) {
            session.setAttribute("message", "Tài khoản của bạn đã được kích hoạt thành công! Bạn có thể đăng nhập ngay bây giờ.");
            session.setAttribute("messageType", "success");
        } else {
            session.setAttribute("message", "Xác thực thất bại. Đường dẫn có thể không hợp lệ hoặc đã hết hạn.");
            session.setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/login");
    }
}
