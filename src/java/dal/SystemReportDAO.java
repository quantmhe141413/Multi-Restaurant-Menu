package dal;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.SystemReportRow;

public class SystemReportDAO extends DBContext {

    public List<SystemReportRow> getDailyReport(Date fromDate, Date toDate) {
        List<SystemReportRow> list = new ArrayList<>();

        if (fromDate == null || toDate == null) {
            return list;
        }

        String sql = "WITH Dates AS (\n"
                + "    SELECT CAST(? AS date) AS ReportDate\n"
                + "    UNION ALL\n"
                + "    SELECT DATEADD(day, 1, ReportDate)\n"
                + "    FROM Dates\n"
                + "    WHERE ReportDate < CAST(? AS date)\n"
                + ")\n"
                + "SELECT\n"
                + "    d.ReportDate,\n"
                + "    (SELECT COUNT(*) FROM Orders o WHERE CAST(o.CreatedAt AS date) = d.ReportDate) AS TotalOrders,\n"
                + "    (SELECT COUNT(*) FROM Orders o WHERE CAST(o.CreatedAt AS date) = d.ReportDate AND o.OrderStatus = 'Completed') AS CompletedOrders,\n"
                + "    (SELECT SUM(o.FinalAmount) FROM Orders o WHERE CAST(o.CreatedAt AS date) = d.ReportDate AND o.OrderStatus = 'Completed') AS Revenue,\n"
                + "    (SELECT COUNT(*) FROM Restaurants r WHERE CAST(r.CreatedAt AS date) = d.ReportDate) AS NewRestaurants,\n"
                + "    (SELECT COUNT(*) FROM Users u WHERE CAST(u.CreatedAt AS date) = d.ReportDate) AS NewUsers,\n"
                + "    (SELECT COUNT(*) FROM Complaints c WHERE CAST(c.CreatedAt AS date) = d.ReportDate) AS NewComplaints\n"
                + "FROM Dates d\n"
                + "ORDER BY d.ReportDate\n"
                + "OPTION (MAXRECURSION 1000)";

        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql);
            statement = st;
            st.setDate(1, fromDate);
            st.setDate(2, toDate);
            ResultSet rs = st.executeQuery();
            resultSet = rs;
            while (rs.next()) {
                SystemReportRow row = new SystemReportRow();
                row.setReportDate(rs.getDate("ReportDate"));
                row.setTotalOrders(rs.getInt("TotalOrders"));
                row.setCompletedOrders(rs.getInt("CompletedOrders"));
                BigDecimal revenue = rs.getBigDecimal("Revenue");
                row.setRevenue(revenue == null ? BigDecimal.ZERO : revenue);
                row.setNewRestaurants(rs.getInt("NewRestaurants"));
                row.setNewUsers(rs.getInt("NewUsers"));
                row.setNewComplaints(rs.getInt("NewComplaints"));
                list.add(row);
            }
        } catch (SQLException ex) {
            System.out.println("Error getDailyReport: " + ex.getMessage());
        } finally {
            closeResources();
        }

        return list;
    }
}
