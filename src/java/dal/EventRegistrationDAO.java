package dal;

import java.sql.*;
import model.Event;
import model.EventRegistration;
import java.util.*;

public class EventRegistrationDAO extends DBContext {

    // Kiểm tra user đã đăng ký chưa
    public boolean isAlreadyRegistered(int userId, int eventId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM EventRegistrations WHERE UserID = ? AND EventID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        }
        return false;
    }

    // Lấy tổng số người đã đăng ký
    public int getCurrentRegistrations(int eventId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM EventRegistrations WHERE EventID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // Lấy thông tin event (để kiểm tra điều kiện đăng ký)
    public Event getEventById(int eventId) throws SQLException {
        String sql = "SELECT * FROM Events WHERE EventID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Event e = new Event();
                e.setEventID(rs.getInt("EventID"));
                e.setEventName(rs.getString("EventName"));
                e.setCapacity(rs.getInt("Capacity"));
                e.setStartDate(rs.getTimestamp("StartDate"));
                e.setEndDate(rs.getTimestamp("EndDate"));
                e.setRegistrationStart(rs.getTimestamp("RegistrationStart"));
                e.setRegistrationEnd(rs.getTimestamp("RegistrationEnd"));
                e.setStatus(rs.getString("Status"));
                return e;
            }
        }
        return null;
    }
    
    // Lấy danh sách sự kiện đã đăng ký của user
    public List<EventRegistration> getRegistrationsByUser(int userId) throws SQLException {
        List<EventRegistration> list = new ArrayList<>();
        String sql = "SELECT * FROM EventRegistrations WHERE UserID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                EventRegistration er = new EventRegistration(
                    rs.getInt("RegistrationID"),
                    rs.getInt("EventID"),
                    rs.getInt("UserID"),
                    rs.getTimestamp("RegisteredAt"),
                    rs.getBoolean("CheckIn")
                );
                list.add(er);
            }
        }
        return list;
    }

    // Kiểm tra đã check-in chưa
    public boolean hasCheckedIn(int userId, int eventId) throws SQLException {
        String sql = "SELECT CheckIn FROM EventRegistrations WHERE UserID = ? AND EventID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getBoolean("CheckIn");
        }
        return false;
    }

    // Thực hiện check-in
    public boolean checkIn(int userId, int eventId) throws SQLException {
        String sql = "UPDATE EventRegistrations SET CheckIn = 1 WHERE UserID = ? AND EventID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, eventId);
            return ps.executeUpdate() > 0;
        }
    }

    // Đăng ký tham gia
    public boolean registerForEvent(int userId, int eventId) throws SQLException {
        String sql = "INSERT INTO EventRegistrations (EventID, UserID, RegisteredAt) VALUES (?, ?, GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }
}
