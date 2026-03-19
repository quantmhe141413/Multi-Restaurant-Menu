package controllers;

import dal.InvoiceDAO;
import dal.OrderDAO;
import dal.RestaurantDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Invoice;
import models.Order;
import models.OrderItem;
import models.Restaurant;
import utils.InvoicePDFGenerator;

@WebServlet(name = "StaffInvoicePrintController", urlPatterns = {"/staff/invoice/print"})
public class StaffInvoicePrintController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");

        if (restaurantId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
            return;
        }

        // Get orderId parameter
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing orderId");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid orderId");
            return;
        }

        // Retrieve order and verify it belongs to restaurant
        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderDetailForRestaurant(orderId, restaurantId);

        if (order == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Order not found");
            return;
        }

        // Retrieve invoice
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        Invoice invoice = invoiceDAO.findByOrderId(orderId);

        if (invoice == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invoice not found");
            return;
        }

        // Retrieve order items
        List<OrderItem> orderItems = orderDAO.getOrderItemsByOrderId(orderId);

        // Retrieve restaurant information
        RestaurantDAO restaurantDAO = new RestaurantDAO();
        Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);

        try {
            // Generate PDF
            byte[] pdfBytes = InvoicePDFGenerator.generatePDF(invoice, order, orderItems, restaurant);

            // Set response headers
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"invoice-" + invoice.getInvoiceNumber() + ".pdf\"");
            response.setContentLength(pdfBytes.length);

            // Write PDF to response
            response.getOutputStream().write(pdfBytes);
            response.getOutputStream().flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF: " + e.getMessage());
        }
    }
}
