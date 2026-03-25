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

@WebServlet(name = "StorefrontCustomizationController", urlPatterns = { "/storefront-customization" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 8 // 8MB
)
public class StorefrontCustomizationController extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads/logos";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        models.User user = (models.User) session.getAttribute("user");
        Integer restaurantId = null;

        // Try to get restaurantId from parameter (for Admin)
        String paramId = request.getParameter("restaurantId");
        if (paramId != null && !paramId.isEmpty()) {
            try {
                restaurantId = Integer.parseInt(paramId);
            } catch (NumberFormatException e) {}
        }

        // Fallback to session (for Owner)
        if (restaurantId == null) {
            restaurantId = (Integer) session.getAttribute("restaurantId");
        }

        if (restaurantId != null) {
            RestaurantDAO dao = new RestaurantDAO();
            Restaurant r = dao.getRestaurantById(restaurantId);
            if (r != null) {
                request.setAttribute("restaurant", r);
                request.setAttribute("currentLogo", r.getLogoUrl());
                request.setAttribute("currentTheme", r.getThemeColor());
                request.setAttribute("restaurantId", restaurantId);
            }
        } else if (user.getRoleID() == 1) {
            // Admin without restaurantId: show list of restaurants or redirect to list
            response.sendRedirect(request.getContextPath() + "/admin/restaurant-applications");
            return;
        }

        request.getRequestDispatcher("views/storefront-customization.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer restaurantId = null;
        try {
            restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
        } catch (Exception e) {
            restaurantId = (Integer) session.getAttribute("restaurantId");
        }

        if (restaurantId == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Part filePart = request.getPart("logoFile");
        String themeColor = request.getParameter("themeColor");

        String logoPublicPath = null;
        if (filePart != null && filePart.getSize() > 0) {
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
            String savedFileName = "logo_" + restaurantId + "_" + UUID.randomUUID() + ext;
            String fullPath = uploadPath + File.separator + savedFileName;
            filePart.write(fullPath);
            logoPublicPath = request.getContextPath() + "/" + UPLOAD_DIR + "/" + savedFileName;
        }

        RestaurantDAO dao = new RestaurantDAO();
        dao.updateLogoAndTheme(restaurantId, logoPublicPath, themeColor);

        request.setAttribute("success", "Cập nhật Branding thành công.");
        
        // Re-fetch to show updated info
        Restaurant r = dao.getRestaurantById(restaurantId);
        if (r != null) {
            request.setAttribute("restaurant", r);
            request.setAttribute("currentLogo", r.getLogoUrl());
            request.setAttribute("currentTheme", r.getThemeColor());
            request.setAttribute("restaurantId", restaurantId);
        }
        
        request.getRequestDispatcher("views/storefront-customization.jsp").forward(request, response);
    }
}
