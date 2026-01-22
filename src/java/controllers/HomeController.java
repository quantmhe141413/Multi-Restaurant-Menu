package controllers;

import dal.RestaurantDAO;
import java.io.IOException;
import java.util.List;
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
        RestaurantDAO rdao = new RestaurantDAO();
        List<Restaurant> restaurants = rdao.getApprovedRestaurants(search, zone);
        request.setAttribute("restaurants", restaurants);
        request.setAttribute("zones", rdao.getActiveZoneNames());
        request.setAttribute("selectedZone", zone);
        request.setAttribute("currentSearch", search);
        request.getRequestDispatcher("views/home.jsp").forward(request, response);
    }
}
