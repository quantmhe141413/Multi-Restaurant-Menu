package utils;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import models.Invoice;
import models.Order;
import models.OrderItem;
import models.Restaurant;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

public class InvoicePDFGenerator {

    private static final Font FONT_TITLE = new Font(Font.HELVETICA, 18, Font.BOLD);
    private static final Font FONT_HEADER = new Font(Font.HELVETICA, 12, Font.BOLD);
    private static final Font FONT_NORMAL = new Font(Font.HELVETICA, 10, Font.NORMAL);
    private static final Font FONT_SMALL = new Font(Font.HELVETICA, 8, Font.NORMAL);

    /**
     * Generate PDF invoice as byte array
     */
    public static byte[] generatePDF(Invoice invoice, Order order, List<OrderItem> orderItems, Restaurant restaurant) throws Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4, 50, 50, 50, 50);
        
        try {
            PdfWriter.getInstance(document, baos);
            document.open();

            // Restaurant header
            addRestaurantHeader(document, restaurant);
            document.add(new Paragraph("\n"));

            // Invoice title
            Paragraph title = new Paragraph("HÓA ĐƠN", FONT_TITLE);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);
            document.add(new Paragraph("\n"));

            // Invoice info
            addInvoiceInfo(document, invoice, order);
            document.add(new Paragraph("\n"));

            // Order items table
            addOrderItemsTable(document, orderItems);
            document.add(new Paragraph("\n"));

            // Totals
            addTotals(document, order);
            document.add(new Paragraph("\n"));

            // Payment info
            addPaymentInfo(document, order);
            document.add(new Paragraph("\n"));

            // Footer
            Paragraph footer = new Paragraph("Cảm ơn quý khách đã sử dụng dịch vụ!", FONT_NORMAL);
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);

        } finally {
            document.close();
        }

        return baos.toByteArray();
    }

    private static void addRestaurantHeader(Document document, Restaurant restaurant) throws DocumentException {
        Paragraph name = new Paragraph(restaurant.getName(), FONT_HEADER);
        name.setAlignment(Element.ALIGN_CENTER);
        document.add(name);

        Paragraph address = new Paragraph(restaurant.getAddress(), FONT_NORMAL);
        address.setAlignment(Element.ALIGN_CENTER);
        document.add(address);
    }

    private static void addInvoiceInfo(Document document, Invoice invoice, Order order) throws DocumentException {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);

        // Left column
        PdfPCell leftCell = new PdfPCell();
        leftCell.setBorder(Rectangle.NO_BORDER);
        leftCell.addElement(new Paragraph("Thông Tin Hóa Đơn", FONT_HEADER));
        leftCell.addElement(new Paragraph("Số hóa đơn: " + invoice.getInvoiceNumber(), FONT_NORMAL));
        leftCell.addElement(new Paragraph("Ngày: " + sdf.format(invoice.getIssuedDate()), FONT_NORMAL));
        
        String orderTypeText = getOrderTypeText(order.getOrderType());
        leftCell.addElement(new Paragraph("Loại đơn: " + orderTypeText, FONT_NORMAL));
        
        if (order.getTableID() != null) {
            leftCell.addElement(new Paragraph("Bàn: " + order.getTableID(), FONT_NORMAL));
        }

        // Right column
        PdfPCell rightCell = new PdfPCell();
        rightCell.setBorder(Rectangle.NO_BORDER);
        rightCell.addElement(new Paragraph("Thông Tin Khách Hàng", FONT_HEADER));
        rightCell.addElement(new Paragraph("Tên: " + order.getCustomerName(), FONT_NORMAL));
        
        if ("Online".equals(order.getOrderType()) && order.getDeliveryAddress() != null) {
            rightCell.addElement(new Paragraph("Địa chỉ: " + order.getDeliveryAddress(), FONT_NORMAL));
        }

        table.addCell(leftCell);
        table.addCell(rightCell);
        document.add(table);
    }

    private static void addOrderItemsTable(Document document, List<OrderItem> orderItems) throws DocumentException {
        PdfPTable table = new PdfPTable(4);
        table.setWidthPercentage(100);
        table.setWidths(new float[]{3, 1, 1.5f, 1.5f});

        // Header
        addTableHeader(table, "Món");
        addTableHeader(table, "SL");
        addTableHeader(table, "Đơn giá");
        addTableHeader(table, "Thành tiền");

        // Items
        NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
        for (OrderItem item : orderItems) {
            PdfPCell nameCell = new PdfPCell(new Paragraph(item.getItemName(), FONT_NORMAL));
            nameCell.setBorder(Rectangle.BOX);
            nameCell.setPadding(5);
            
            if (item.getNote() != null && !item.getNote().trim().isEmpty()) {
                nameCell.addElement(new Paragraph("Ghi chú: " + item.getNote(), FONT_SMALL));
            }
            table.addCell(nameCell);

            addTableCell(table, String.valueOf(item.getQuantity()));
            addTableCell(table, currencyFormat.format(item.getUnitPrice()) + " đ");
            addTableCell(table, currencyFormat.format(item.getQuantity() * item.getUnitPrice()) + " đ");
        }

        document.add(table);
    }

    private static void addTotals(Document document, Order order) throws DocumentException {
        NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));

        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(50);
        table.setHorizontalAlignment(Element.ALIGN_RIGHT);

        addTotalRow(table, "Tạm tính:", currencyFormat.format(order.getTotalAmount()) + " đ", false);

        if (order.getDiscountAmount() > 0) {
            addTotalRow(table, "Giảm giá:", "-" + currencyFormat.format(order.getDiscountAmount()) + " đ", false);
        }

        if (order.getDeliveryFee() > 0) {
            addTotalRow(table, "Phí giao hàng:", currencyFormat.format(order.getDeliveryFee()) + " đ", false);
        }

        addTotalRow(table, "Tổng cộng:", currencyFormat.format(order.getFinalAmount()) + " đ", true);

        document.add(table);
    }

    private static void addPaymentInfo(Document document, Order order) throws DocumentException {
        String paymentMethodText = getPaymentMethodText(order.getPaymentMethod());
        String paymentStatusText = getPaymentStatusText(order.getPaymentStatus());

        Paragraph payment = new Paragraph("Phương thức thanh toán: " + paymentMethodText, FONT_NORMAL);
        document.add(payment);

        Paragraph status = new Paragraph("Trạng thái thanh toán: " + paymentStatusText, FONT_NORMAL);
        document.add(status);
    }

    private static void addTableHeader(PdfPTable table, String text) {
        PdfPCell cell = new PdfPCell(new Paragraph(text, FONT_HEADER));
        cell.setBackgroundColor(new Color(240, 240, 240));
        cell.setBorder(Rectangle.BOX);
        cell.setPadding(5);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(cell);
    }

    private static void addTableCell(PdfPTable table, String text) {
        PdfPCell cell = new PdfPCell(new Paragraph(text, FONT_NORMAL));
        cell.setBorder(Rectangle.BOX);
        cell.setPadding(5);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        table.addCell(cell);
    }

    private static void addTotalRow(PdfPTable table, String label, String value, boolean bold) {
        Font font = bold ? FONT_HEADER : FONT_NORMAL;

        PdfPCell labelCell = new PdfPCell(new Paragraph(label, font));
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        labelCell.setPadding(3);
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Paragraph(value, font));
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        valueCell.setPadding(3);
        table.addCell(valueCell);
    }

    private static String getOrderTypeText(String orderType) {
        switch (orderType) {
            case "DineIn": return "Ăn tại chỗ";
            case "Pickup": return "Mang đi";
            case "Online": return "Giao hàng";
            default: return orderType;
        }
    }

    private static String getPaymentMethodText(String paymentMethod) {
        switch (paymentMethod) {
            case "Cash": return "Tiền mặt";
            case "Card": return "Thẻ";
            case "VNPay": return "VNPay";
            default: return paymentMethod;
        }
    }

    private static String getPaymentStatusText(String paymentStatus) {
        switch (paymentStatus) {
            case "Success": return "Đã thanh toán";
            case "Pending": return "Chờ thanh toán";
            case "Failed": return "Thất bại";
            default: return paymentStatus;
        }
    }
}
