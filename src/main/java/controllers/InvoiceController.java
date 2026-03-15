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
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import java.awt.Color;

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
                Integer restaurantId = (Integer) session.getAttribute("restaurantId");
                if (restaurantId == null || !invoice.getRestaurantId().equals(restaurantId)) {
                    session.setAttribute("toastMessage", "Access denied - This invoice does not belong to your restaurant");
                    session.setAttribute("toastType", "error");
                    response.sendRedirect(request.getContextPath() + "/invoice?action=list");
                    return;
                }
            }

            exportToPdf(response, invoice);

        } catch (NumberFormatException e) {
            session.setAttribute("toastMessage", "Invalid invoice ID");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/invoice?action=list");
        }
    }

    private void exportToPdf(HttpServletResponse response, Invoice invoice) throws IOException {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"Invoice-" + invoice.getInvoiceNumber() + ".pdf\"");

        Document document = new Document(PageSize.A4, 50, 50, 60, 40);
        try {
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            Font titleFont = new Font(Font.HELVETICA, 22, Font.BOLD, new Color(99, 102, 241));
            Font sectionFont = new Font(Font.HELVETICA, 12, Font.BOLD, new Color(55, 65, 81));
            Font labelFont = new Font(Font.HELVETICA, 10, Font.BOLD, Color.BLACK);
            Font valueFont = new Font(Font.HELVETICA, 10, Font.NORMAL, Color.BLACK);
            Font amountFont = new Font(Font.HELVETICA, 12, Font.BOLD, new Color(16, 185, 129));

            // Title
            Paragraph title = new Paragraph("INVOICE", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(4);
            document.add(title);

            Paragraph restaurantLine = new Paragraph(
                    invoice.getRestaurantName() != null ? invoice.getRestaurantName() : "",
                    new Font(Font.HELVETICA, 13, Font.BOLD, new Color(55, 65, 81)));
            restaurantLine.setAlignment(Element.ALIGN_CENTER);
            restaurantLine.setSpacingAfter(16);
            document.add(restaurantLine);

            // Invoice meta table
            PdfPTable metaTable = new PdfPTable(2);
            metaTable.setWidthPercentage(100);
            metaTable.setSpacingAfter(14);
            addMetaRow(metaTable, "Invoice Number:", invoice.getInvoiceNumber(), labelFont, valueFont);
            addMetaRow(metaTable, "Issued Date:",
                    invoice.getIssuedDate() != null ? invoice.getIssuedDate().toString() : "-", labelFont, valueFont);
            addMetaRow(metaTable, "Order ID:", "#" + invoice.getOrderId(), labelFont, valueFont);
            addMetaRow(metaTable, "Order Date:",
                    invoice.getOrderDate() != null ? invoice.getOrderDate().toString() : "-", labelFont, valueFont);
            document.add(metaTable);

            // Customer & Order section
            PdfPTable infoTable = new PdfPTable(2);
            infoTable.setWidthPercentage(100);
            infoTable.setSpacingAfter(14);

            // Customer info cell
            PdfPCell customerCell = new PdfPCell();
            customerCell.setBorder(PdfPCell.NO_BORDER);
            customerCell.setPadding(6);
            customerCell.addElement(new Paragraph("Customer Information", sectionFont));
            customerCell.addElement(new Paragraph("Name: " + nvl(invoice.getCustomerName()), valueFont));
            customerCell.addElement(new Paragraph("Customer ID: #" + nvl(invoice.getCustomerId()), valueFont));
            if (invoice.getDeliveryAddress() != null && !invoice.getDeliveryAddress().isEmpty()) {
                customerCell.addElement(new Paragraph("Address: " + invoice.getDeliveryAddress(), valueFont));
            }
            infoTable.addCell(customerCell);

            // Order info cell
            PdfPCell orderCell = new PdfPCell();
            orderCell.setBorder(PdfPCell.NO_BORDER);
            orderCell.setPadding(6);
            orderCell.addElement(new Paragraph("Order Information", sectionFont));
            orderCell.addElement(new Paragraph("Order Type: " + nvl(invoice.getOrderType()), valueFont));
            orderCell.addElement(new Paragraph("Order Status: " + nvl(invoice.getOrderStatus()), valueFont));
            if (invoice.getDeliveryStatus() != null && !invoice.getDeliveryStatus().isEmpty()) {
                orderCell.addElement(new Paragraph("Delivery Status: " + invoice.getDeliveryStatus(), valueFont));
            }
            infoTable.addCell(orderCell);
            document.add(infoTable);

            // Payment section
            Paragraph paymentTitle = new Paragraph("Payment Information", sectionFont);
            paymentTitle.setSpacingBefore(4);
            paymentTitle.setSpacingAfter(6);
            document.add(paymentTitle);

            PdfPTable payTable = new PdfPTable(2);
            payTable.setWidthPercentage(100);
            payTable.setSpacingAfter(14);
            addMetaRow(payTable, "Payment Method:", nvl(invoice.getPaymentType()), labelFont, valueFont);
            String paidStatus = (invoice.getIsPaid() != null && invoice.getIsPaid()) ? "Paid" : nvl(invoice.getPaymentStatus());
            addMetaRow(payTable, "Payment Status:", paidStatus, labelFont, valueFont);
            if (invoice.getTransactionRef() != null && !invoice.getTransactionRef().isEmpty()) {
                addMetaRow(payTable, "Transaction Ref:", invoice.getTransactionRef(), labelFont, valueFont);
            }
            if (invoice.getPaidAt() != null) {
                addMetaRow(payTable, "Paid At:", invoice.getPaidAt().toString(), labelFont, valueFont);
            }
            document.add(payTable);

            // Financial breakdown
            Paragraph finTitle = new Paragraph("Financial Breakdown", sectionFont);
            finTitle.setSpacingBefore(4);
            finTitle.setSpacingAfter(6);
            document.add(finTitle);

            PdfPTable finTable = new PdfPTable(2);
            finTable.setWidthPercentage(60);
            finTable.setHorizontalAlignment(Element.ALIGN_RIGHT);
            finTable.setSpacingAfter(10);
            addAmountRow(finTable, "Subtotal:", formatAmount(invoice.getSubtotal()), labelFont, valueFont);
            addAmountRow(finTable, "Tax Amount:", formatAmount(invoice.getTaxAmount()), labelFont, valueFont);

            // Final amount row with highlight
            PdfPCell finalLabelCell = new PdfPCell(new Phrase("Final Amount:", amountFont));
            finalLabelCell.setBorder(PdfPCell.TOP);
            finalLabelCell.setPadding(6);
            PdfPCell finalValueCell = new PdfPCell(new Phrase(formatAmount(invoice.getFinalAmount()), amountFont));
            finalValueCell.setBorder(PdfPCell.TOP);
            finalValueCell.setPadding(6);
            finalValueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            finTable.addCell(finalLabelCell);
            finTable.addCell(finalValueCell);
            document.add(finTable);

            // Footer note
            Paragraph note = new Paragraph(
                    "This invoice is read-only and cannot be modified to ensure financial transparency.",
                    new Font(Font.HELVETICA, 9, Font.ITALIC, Color.GRAY));
            note.setAlignment(Element.ALIGN_CENTER);
            note.setSpacingBefore(20);
            document.add(note);

        } catch (Exception ex) {
            throw new IOException("Error generating PDF: " + ex.getMessage(), ex);
        } finally {
            if (document.isOpen()) {
                document.close();
            }
        }
    }

    private void addMetaRow(PdfPTable table, String label, String value, Font labelFont, Font valueFont) {
        PdfPCell lc = new PdfPCell(new Phrase(label, labelFont));
        lc.setBorder(PdfPCell.NO_BORDER);
        lc.setPadding(4);
        PdfPCell vc = new PdfPCell(new Phrase(value, valueFont));
        vc.setBorder(PdfPCell.NO_BORDER);
        vc.setPadding(4);
        table.addCell(lc);
        table.addCell(vc);
    }

    private void addAmountRow(PdfPTable table, String label, String value, Font labelFont, Font valueFont) {
        PdfPCell lc = new PdfPCell(new Phrase(label, labelFont));
        lc.setBorder(PdfPCell.NO_BORDER);
        lc.setPadding(4);
        PdfPCell vc = new PdfPCell(new Phrase(value, valueFont));
        vc.setBorder(PdfPCell.NO_BORDER);
        vc.setPadding(4);
        vc.setHorizontalAlignment(Element.ALIGN_RIGHT);
        table.addCell(lc);
        table.addCell(vc);
    }

    private String nvl(Object val) {
        return val != null ? val.toString() : "-";
    }

    private String formatAmount(java.math.BigDecimal amount) {
        if (amount == null) return "$0.00";
        return "$" + String.format("%,.2f", amount);
    }
}
