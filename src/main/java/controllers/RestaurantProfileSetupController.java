package controllers;

import dal.RestaurantDAO;
import models.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;
import jakarta.servlet.annotation.MultipartConfig;

@WebServlet(name = "RestaurantProfileSetupController", urlPatterns = { "/restaurant-profile-setup" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 15)
public class RestaurantProfileSetupController extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads/licenses";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            models.User user = (models.User) session.getAttribute("user");
            if (user != null) {
                RestaurantDAO dao = new RestaurantDAO();
                models.Restaurant r = dao.getRestaurantByOwnerId(user.getUserID());
                if (r != null) {
                    session.setAttribute("restaurantId", r.getRestaurantId());
                    response.sendRedirect("restaurant-analytics-dashboard");
                    return;
                }
            }
        }
        request.getRequestDispatcher("views/restaurant-profile-setup.jsp").forward(request, response);
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
        Integer ownerId = user.getUserID();

        RestaurantDAO restaurantDAO = new RestaurantDAO();
        models.Restaurant existing = restaurantDAO.getRestaurantByOwnerId(ownerId);
        if (existing != null) {
            session.setAttribute("restaurantId", existing.getRestaurantId());
            response.sendRedirect("restaurant-analytics-dashboard");
            return;
        }
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String description = request.getParameter("description");

        if (name == null || name.trim().isEmpty() || address == null || address.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ tên nhà hàng và địa chỉ.");
            request.getRequestDispatcher("views/restaurant-profile-setup.jsp").forward(request, response);
            return;
        }

        Restaurant restaurant = new Restaurant();
        restaurant.setOwnerId(ownerId);
        restaurant.setName(name.trim());
        restaurant.setAddress(address.trim());
        restaurant.setPhone(phone != null ? phone.trim() : "");
        restaurant.setDescription(description != null ? description.trim() : "");
        restaurantDAO.insertRestaurant(restaurant);

        // Fetch newly created restaurant.
        models.Restaurant created = restaurantDAO.getRestaurantByOwnerId(ownerId);
        if (created == null) {
            request.setAttribute("error", "Có lỗi xảy ra khi tạo hồ sơ nhà hàng. Vui lòng thử lại.");
            request.getRequestDispatcher("views/restaurant-profile-setup.jsp").forward(request, response);
            return;
        }

        session.setAttribute("restaurantId", created.getRestaurantId());
        int restaurantId = created.getRestaurantId();

        try {
            Part filePart = request.getPart("licenseFile");
            if (filePart != null && filePart.getSize() > 0) {
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String submittedFileName = filePart.getSubmittedFileName();
                String ext = "";
                int idx = submittedFileName.lastIndexOf('.');
                if (idx > 0) ext = submittedFileName.substring(idx);
                String savedFileName = "license_" + restaurantId + "_" + UUID.randomUUID() + ext;
                String fullPath = uploadPath + File.separator + savedFileName;
                filePart.write(fullPath);

                String publicPath = "/" + UPLOAD_DIR + "/" + savedFileName;
                restaurantDAO.updateLicenseFile(restaurantId, publicPath);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect to dashboard after successful setup
        response.sendRedirect(request.getContextPath() + "/restaurant-analytics-dashboard");
    }
}
