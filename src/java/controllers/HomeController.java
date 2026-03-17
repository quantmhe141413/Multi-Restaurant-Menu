package controllers;

import dal.RestaurantDAO;
import dal.ReviewDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Restaurant;

@WebServlet(name = "HomeController", urlPatterns = { "/home" })
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String zone = request.getParameter("zone");
        String cuisine = request.getParameter("cuisine");
        RestaurantDAO rdao = new RestaurantDAO();
        ReviewDAO reviewDAO = new ReviewDAO();
        List<Restaurant> restaurants = rdao.getApprovedRestaurants(search, zone, cuisine);

        // Lấy rating summary cho tất cả nhà hàng
        Map<Integer, double[]> ratingSummary = reviewDAO.getRatingSummaryForAllRestaurants();
        for (Restaurant r : restaurants) {
            double[] data = ratingSummary.get(r.getRestaurantId());
            if (data != null) {
                r.setAverageRating(Double.valueOf(data[0]));
                r.setReviewCount((int) data[1]);
            }
        }

        request.setAttribute("restaurants", restaurants);
        request.setAttribute("zones", rdao.getActiveZoneNames());
        request.setAttribute("cuisines", rdao.getAvailableCuisines());
        request.setAttribute("selectedZone", zone);
        request.setAttribute("selectedCuisine", cuisine);
        request.setAttribute("currentSearch", search);
        request.getRequestDispatcher("views/home.jsp").forward(request, response);
    }
}
