package dal;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.EventHistoryItem;

public class EventHistoryDAO extends DBContext {

    // Lấy danh sách sự kiện tham gia của user với filter + phân trang
    public List<EventHistoryItem> getUserEventHistory(
            int userId,
            String keyword,
            String status,
            Date fromDate,
            Date toDate,
            int pageIndex,
            int pageSize) throws SQLException {

        List<EventHistoryItem> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT e.EventID, e.EventName, c.ClubName, ")
           .append("e.StartDate, e.EndDate, r.RegisteredAt, e.Status, r.CheckIn ")
           .append("FROM EventRegistrations r ")
           .append("JOIN Events e ON r.EventID = e.EventID ")
           .append("JOIN Clubs c ON e.ClubID = c.ClubID ")
           .append("WHERE r.UserID = ? ");

        // filter keyword
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND e.EventName LIKE ? ");
        }

        // filter status (bỏ qua nếu 'All' hoặc null)
        if (status != null && !status.equalsIgnoreCase("All")
                && !status.trim().isEmpty()) {
            sql.append("AND e.Status = ? ");
        }

        // date range
        if (fromDate != null) {
            sql.append("AND e.StartDate >= ? ");
        }
        if (toDate != null) {
            sql.append("AND e.StartDate <= ? ");
        }

        sql.append("ORDER BY e.StartDate DESC ")
           .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, userId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }

            if (status != null && !status.equalsIgnoreCase("All")
                    && !status.trim().isEmpty()) {
                ps.setString(idx++, status);
            }

            if (fromDate != null) {
                ps.setDate(idx++, fromDate);
            }
            if (toDate != null) {
                ps.setDate(idx++, toDate);
            }

            int offset = (pageIndex - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    EventHistoryItem item = new EventHistoryItem();
                    item.setEventId(rs.getInt("EventID"));
                    item.setEventName(rs.getNString("EventName"));
                    item.setClubName(rs.getNString("ClubName"));
                    item.setStartDate(rs.getTimestamp("StartDate"));
                    item.setEndDate(rs.getTimestamp("EndDate"));
                    item.setRegisteredAt(rs.getTimestamp("RegisteredAt"));
                    item.setStatus(rs.getString("Status"));
                    item.setCheckIn(rs.getBoolean("CheckIn"));
                    list.add(item);
                }
            }
        }

        return list;
    }

    // Đếm tổng số bản ghi cho phân trang
    public int countUserEventHistory(
            int userId,
            String keyword,
            String status,
            Date fromDate,
            Date toDate) throws SQLException {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) ")
           .append("FROM EventRegistrations r ")
           .append("JOIN Events e ON r.EventID = e.EventID ")
           .append("WHERE r.UserID = ? ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND e.EventName LIKE ? ");
        }
        if (status != null && !status.equalsIgnoreCase("All")
                && !status.trim().isEmpty()) {
            sql.append("AND e.Status = ? ");
        }
        if (fromDate != null) {
            sql.append("AND e.StartDate >= ? ");
        }
        if (toDate != null) {
            sql.append("AND e.StartDate <= ? ");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, userId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(idx++, "%" + keyword.trim() + "%");
            }

            if (status != null && !status.equalsIgnoreCase("All")
                    && !status.trim().isEmpty()) {
                ps.setString(idx++, status);
            }

            if (fromDate != null) {
                ps.setDate(idx++, fromDate);
            }
            if (toDate != null) {
                ps.setDate(idx++, toDate);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }
}
