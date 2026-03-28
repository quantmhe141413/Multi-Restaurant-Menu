package controllers;

import dal.RestaurantDAO;
import models.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "BusinessLicenseUploadController", urlPatterns = { "/business-license-upload" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 15) // 15MB
public class BusinessLicenseUploadController extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads/licenses";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/business-license-upload.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        RestaurantDAO dao = new RestaurantDAO();
        Restaurant restaurant = dao.getRestaurantByOwnerId(user.getUserID());
        if (restaurant == null) {
            // Fallback: check RestaurantUsers table (for managers)
            dal.UserDAO userDAO = new dal.UserDAO();
            Integer restaurantId = userDAO.getRestaurantIdByUserId(user.getUserID());
            if (restaurantId != null) {
                restaurant = dao.getRestaurantById(restaurantId);
            }
        }
        if (restaurant == null) {
            response.sendRedirect("restaurant-profile-setup");
            return;
        }
        int restaurantId = restaurant.getRestaurantId();

        Part filePart = request.getPart("licenseFile");
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "Vui lòng chọn file giấy phép.");
            request.getRequestDispatcher("views/business-license-upload.jsp").forward(request, response);
            return;
        }

        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists())
            uploadDir.mkdirs();

        String submittedFileName = filePart.getSubmittedFileName();
        String ext = "";
        int idx = submittedFileName.lastIndexOf('.');
        if (idx > 0)
            ext = submittedFileName.substring(idx);
        String savedFileName = "license_" + restaurantId + "_" + UUID.randomUUID() + ext;
        String fullPath = uploadPath + File.separator + savedFileName;
        filePart.write(fullPath);

        String publicPath = request.getContextPath() + "/" + UPLOAD_DIR + "/" + savedFileName;

        dao.updateLicenseFile(restaurantId, publicPath);

        request.setAttribute("success", "Upload thành công.");
        request.getRequestDispatcher("views/business-license-upload.jsp").forward(request, response);
    }
}
