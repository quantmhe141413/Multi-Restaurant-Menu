package controllers;

import dal.RestaurantTableDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.RestaurantTable;

/**
 * Owner-only controller for managing restaurant tables.
 * URL: /owner/tables
 * Actions (GET): list, add, edit
 * Actions (POST): add, edit, deactivate, activate
 */
@WebServlet(name = "TableManagementController", urlPatterns = {"/owner/tables"})
public class TableManagementController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");
        Integer roleId = getRoleId(session);

        if (restaurantId == null || roleId == null || roleId != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response, restaurantId);
                break;
            default:
                listTables(request, response, restaurantId);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");
        Integer roleId = getRoleId(session);

        if (restaurantId == null || roleId == null || roleId != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/owner/tables");
            return;
        }

        switch (action) {
            case "add":
                handleAdd(request, response, restaurantId);
                break;
            case "edit":
                handleEdit(request, response, restaurantId);
                break;
            case "deactivate":
                handleToggleActive(request, response, restaurantId, false);
                break;
            case "activate":
                handleToggleActive(request, response, restaurantId, true);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/owner/tables");
                break;
        }
    }

    // --- GET handlers ---

    private void listTables(HttpServletRequest request, HttpServletResponse response, int restaurantId)
            throws ServletException, IOException {
        RestaurantTableDAO tableDAO = new RestaurantTableDAO();
        List<RestaurantTable> tables = tableDAO.getAllTablesByRestaurant(restaurantId);

        request.setAttribute("tables", tables);
        request.getRequestDispatcher("/views/owner/table-list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("formAction", "add");
        request.getRequestDispatcher("/views/owner/table-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, int restaurantId)
            throws ServletException, IOException {
        String tableIdParam = request.getParameter("tableId");
        if (tableIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/owner/tables");
            return;
        }

        try {
            int tableId = Integer.parseInt(tableIdParam);
            RestaurantTableDAO tableDAO = new RestaurantTableDAO();

            // Use getTableByIdForManagement to allow fetching inactive tables for edit
            RestaurantTable table = tableDAO.getTableByIdForManagement(tableId, restaurantId);

            if (table == null) {
                setFlashError(request, "Bàn không tồn tại");
                response.sendRedirect(request.getContextPath() + "/owner/tables");
                return;
            }

            request.setAttribute("table", table);
            request.setAttribute("formAction", "edit");
            request.getRequestDispatcher("/views/owner/table-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/tables");
        }
    }

    // --- POST handlers ---

    private void handleAdd(HttpServletRequest request, HttpServletResponse response, int restaurantId)
            throws ServletException, IOException {
        String tableNumber = request.getParameter("tableNumber");
        String capacityParam = request.getParameter("capacity");

        // Validate inputs
        if (tableNumber == null || tableNumber.trim().isEmpty()) {
            forwardToFormWithError(request, response, "add", null,
                tableNumber, capacityParam, "Vui lòng nhập số bàn");
            return;
        }

        int capacity;
        try {
            capacity = Integer.parseInt(capacityParam);
            if (capacity <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            forwardToFormWithError(request, response, "add", null,
                tableNumber, capacityParam, "Sức chứa phải là số nguyên dương");
            return;
        }

        RestaurantTable table = new RestaurantTable();
        table.setRestaurantID(restaurantId);
        table.setTableNumber(tableNumber.trim());
        table.setCapacity(capacity);

        try {
            RestaurantTableDAO tableDAO = new RestaurantTableDAO();
            tableDAO.createTable(table);
            setFlashSuccess(request, "Thêm bàn \"" + tableNumber.trim() + "\" thành công");
            response.sendRedirect(request.getContextPath() + "/owner/tables");
        } catch (SQLException ex) {
            String errorMsg = resolveSqlError(ex, "bàn \"" + tableNumber.trim() + "\"");
            forwardToFormWithError(request, response, "add", null,
                tableNumber, capacityParam, errorMsg);
        }
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response, int restaurantId)
            throws ServletException, IOException {
        String tableIdParam = request.getParameter("tableId");
        String tableNumber = request.getParameter("tableNumber");
        String capacityParam = request.getParameter("capacity");

        // Validate tableId
        int tableId;
        try {
            tableId = Integer.parseInt(tableIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/tables");
            return;
        }

        // Validate inputs
        if (tableNumber == null || tableNumber.trim().isEmpty()) {
            forwardToFormWithError(request, response, "edit", tableId,
                tableNumber, capacityParam, "Vui lòng nhập số bàn");
            return;
        }

        int capacity;
        try {
            capacity = Integer.parseInt(capacityParam);
            if (capacity <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            forwardToFormWithError(request, response, "edit", tableId,
                tableNumber, capacityParam, "Sức chứa phải là số nguyên dương");
            return;
        }

        RestaurantTable table = new RestaurantTable();
        table.setTableID(tableId);
        table.setRestaurantID(restaurantId);
        table.setTableNumber(tableNumber.trim());
        table.setCapacity(capacity);

        try {
            RestaurantTableDAO tableDAO = new RestaurantTableDAO();
            tableDAO.updateTable(table);
            setFlashSuccess(request, "Cập nhật bàn thành công");
            response.sendRedirect(request.getContextPath() + "/owner/tables");
        } catch (SQLException ex) {
            String errorMsg = resolveSqlError(ex, "bàn \"" + tableNumber.trim() + "\"");
            forwardToFormWithError(request, response, "edit", tableId,
                tableNumber, capacityParam, errorMsg);
        }
    }

    private void handleToggleActive(HttpServletRequest request, HttpServletResponse response,
                                    int restaurantId, boolean activate) throws IOException {
        String tableIdParam = request.getParameter("tableId");

        int tableId;
        try {
            tableId = Integer.parseInt(tableIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/owner/tables");
            return;
        }

        RestaurantTableDAO tableDAO = new RestaurantTableDAO();

        // setTableActive has built-in guard for unpaid orders when deactivating
        boolean success = tableDAO.setTableActive(tableId, restaurantId, activate);

        if (success) {
            String msg = activate ? "Bàn đã được kích hoạt" : "Bàn đã được ẩn";
            setFlashSuccess(request, msg);
        } else {
            String msg = activate
                ? "Lỗi khi kích hoạt bàn"
                : "Không thể ẩn bàn đang có đơn hàng chưa thanh toán";
            setFlashError(request, msg);
        }

        response.sendRedirect(request.getContextPath() + "/owner/tables");
    }

    // --- Helpers ---

    private Integer getRoleId(HttpSession session) {
        Object user = session.getAttribute("user");
        if (user instanceof models.User) {
            return ((models.User) user).getRoleID();
        }
        return null;
    }

    private void setFlashSuccess(HttpServletRequest request, String message) {
        request.getSession().setAttribute("flashSuccess", message);
    }

    private void setFlashError(HttpServletRequest request, String message) {
        request.getSession().setAttribute("flashError", message);
    }

    /**
     * Forward back to the form page with an inline error and preserved input values.
     * Uses request attributes (not session) so data is only available for this render.
     */
    private void forwardToFormWithError(HttpServletRequest request, HttpServletResponse response,
                                        String formAction, Integer tableId,
                                        String tableNumber, String capacity,
                                        String errorMessage) throws ServletException, IOException {
        request.setAttribute("formAction", formAction);
        request.setAttribute("formError", errorMessage);
        request.setAttribute("inputTableNumber", tableNumber != null ? tableNumber : "");
        request.setAttribute("inputCapacity", capacity != null ? capacity : "");

        // For edit form: re-attach tableId so the hidden field and breadcrumb work
        if (tableId != null) {
            RestaurantTable stub = new RestaurantTable();
            stub.setTableID(tableId);
            stub.setTableNumber(tableNumber != null ? tableNumber : "");
            try {
                stub.setCapacity(Integer.parseInt(capacity));
            } catch (NumberFormatException ignored) {
                stub.setCapacity(0);
            }
            request.setAttribute("table", stub);
        }

        request.getRequestDispatcher("/views/owner/table-form.jsp").forward(request, response);
    }

    /**
     * Translate a SQLException into a user-friendly Vietnamese message.
     * SQL Server duplicate key: error codes 2601 (unique index) and 2627 (unique constraint).
     */
    private String resolveSqlError(SQLException ex, String label) {
        int errorCode = ex.getErrorCode();
        if (errorCode == 2601 || errorCode == 2627) {
            return "Số " + label + " đã tồn tại trong nhà hàng. Vui lòng chọn tên khác.";
        }
        return "Lỗi hệ thống: " + ex.getMessage();
    }
}
