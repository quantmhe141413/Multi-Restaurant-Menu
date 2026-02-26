package controllers;

import dal.InvoiceDAO;
import models.Invoice;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "InvoiceController", urlPatterns = {"/invoice"})
public class InvoiceController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                handleList(request, response);
                break;
            case "detail":
                showInvoiceDetail(request, response);
                break;
            case "export":
                handleExportPDF(request, response);
                break;
            default:
                handleList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Invoice management is read-only, redirect to list
        response.sendRedirect(request.getContextPath() + "/invoice?action=list");
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");
        
        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Determine restaurant ID based on role
        Integer restaurantId = null;
        
        if (user.getRoleID() == 1) {
            // SuperAdmin - can view all invoices from all restaurants
            restaurantId = null;
            // If restaurantId is null, DAO will return all invoices
        } else if (user.getRoleID() == 2 || user.getRoleID() == 3) {
            // Owner or Staff - can only view their own restaurant's invoices
            restaurantId = (Integer) session.getAttribute("restaurantId");
            if (restaurantId == null) {
                session.setAttribute("toastMessage", "You must be assigned to a restaurant to view invoices");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
        } else {
            // Other roles don't have access
            session.setAttribute("toastMessage", "You don't have permission to view invoices");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        // Get filter parameters
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        
        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        
        // Get invoices based on role and filters
        List<Invoice> invoices = invoiceDAO.findInvoicesWithFilters(
                restaurantId, fromDate, toDate, page, pageSize);
        
        int totalInvoices = invoiceDAO.getTotalFilteredInvoices(restaurantId, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) totalInvoices / pageSize);
        
        // Set attributes for JSP
        request.setAttribute("invoices", invoices);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalInvoices", totalInvoices);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("userRole", user.getRoleID());
        
        request.getRequestDispatcher("/views/owner/invoice-list.jsp").forward(request, response);
    }

    private void showInvoiceDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");
        
        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Check role permission
        if (user.getRoleID() != 1 && user.getRoleID() != 2 && user.getRoleID() != 3) {
            // Other roles don't have access
            session.setAttribute("toastMessage", "You don't have permission to view invoice details");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        String invoiceIdStr = request.getParameter("id");
        
        if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/invoice?action=list");
            return;
        }
        
        try {
            Integer invoiceId = Integer.parseInt(invoiceIdStr);
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            Invoice invoice = invoiceDAO.findById(invoiceId);
            
            if (invoice == null) {
                session.setAttribute("toastMessage", "Invoice not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/invoice?action=list");
                return;
            }
            
            // Check permission based on role
            if (user.getRoleID() == 2 || user.getRoleID() == 3) {
                // Owner or Staff - verify the invoice belongs to their restaurant
                Integer restaurantId = (Integer) session.getAttribute("restaurantId");
                if (restaurantId == null || !invoice.getRestaurantId().equals(restaurantId)) {
                    session.setAttribute("toastMessage", "Access denied - This invoice does not belong to your restaurant");
                    session.setAttribute("toastType", "error");
                    response.sendRedirect(request.getContextPath() + "/invoice?action=list");
                    return;
                }
            }
            // SuperAdmin (RoleID = 1) can view all invoices
            
            request.setAttribute("invoice", invoice);
            request.setAttribute("userRole", user.getRoleID());
            request.getRequestDispatcher("/views/owner/invoice-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/invoice?action=list");
        }
    }

    private void handleExportPDF(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");
        
        // Check if user is logged in
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Check role permission
        if (user.getRoleID() != 1 && user.getRoleID() != 2 && user.getRoleID() != 3) {
            // Other roles don't have access
            session.setAttribute("toastMessage", "You don't have permission to export invoices");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        String invoiceIdStr = request.getParameter("id");
        
        if (invoiceIdStr == null || invoiceIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/invoice?action=list");
            return;
        }
        
        try {
            Integer invoiceId = Integer.parseInt(invoiceIdStr);
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            Invoice invoice = invoiceDAO.findById(invoiceId);
            
            if (invoice == null) {
                session.setAttribute("toastMessage", "Invoice not found");
                session.setAttribute("toastType", "error");
                response.sendRedirect(request.getContextPath() + "/invoice?action=list");
                return;
            }
            
            // Check permission based on role
            if (user.getRoleID() == 2 || user.getRoleID() == 3) {
                // Owner or Staff - verify the invoice belongs to their restaurant
                Integer restaurantId = (Integer) session.getAttribute("restaurantId");
                if (restaurantId == null || !invoice.getRestaurantId().equals(restaurantId)) {
                    session.setAttribute("toastMessage", "Access denied - This invoice does not belong to your restaurant");
                    session.setAttribute("toastType", "error");
                    response.sendRedirect(request.getContextPath() + "/invoice?action=list");
                    return;
                }
            }
            // SuperAdmin (RoleID = 1) can export all invoices
            
            // TODO: Implement PDF generation using iText or similar library
            // For now, redirect to detail page with message
            session.setAttribute("toastMessage", "PDF export functionality will be implemented soon");
            session.setAttribute("toastType", "info");
            response.sendRedirect(request.getContextPath() + "/invoice?action=detail&id=" + invoiceId);
            
            /* 
             * PDF Export Implementation Example:
             * 
             * // Set response headers for PDF download
             * response.setContentType("application/pdf");
             * response.setHeader("Content-Disposition", 
             *     "attachment; filename=\"Invoice-" + invoice.getInvoiceNumber() + ".pdf\"");
             * 
             * // Generate PDF content
             * Document document = new Document(PageSize.A4);
             * PdfWriter.getInstance(document, response.getOutputStream());
             * document.open();
             * 
             * // Add invoice content to PDF
             * document.add(new Paragraph("Invoice Number: " + invoice.getInvoiceNumber()));
             * // ... add more content
             * 
             * document.close();
             */
            
        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid invoice ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/invoice?action=list");
        }
    }
}
