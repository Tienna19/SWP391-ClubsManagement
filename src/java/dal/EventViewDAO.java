package dal;

import model.Event;
import java.sql.*;
import java.util.*;

public class EventViewDAO extends DBContext {

    // Lấy danh sách sự kiện của một CLB
    public List<Event> getEventsByClubId(int clubId) throws SQLException {
        List<Event> list = new ArrayList<>();
    String sql = """
        SELECT EventID, ClubID, EventName, Description, Location, Capacity, 
               StartDate, EndDate, RegistrationStart, RegistrationEnd, CreatedBy, Status
        FROM Events
        WHERE ClubID = ?
        ORDER BY StartDate DESC
    """;

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, clubId);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Event e = new Event();
            e.setEventID(rs.getInt("EventID"));
            e.setClubID(rs.getInt("ClubID"));
            e.setEventName(rs.getString("EventName"));
            e.setDescription(rs.getString("Description"));
            e.setLocation(rs.getString("Location"));
            e.setCapacity(rs.getInt("Capacity"));
            e.setStartDate(rs.getTimestamp("StartDate"));
            e.setEndDate(rs.getTimestamp("EndDate"));
            e.setRegistrationStart(rs.getTimestamp("RegistrationStart"));
            e.setRegistrationEnd(rs.getTimestamp("RegistrationEnd"));
            e.setCreatedBy(rs.getInt("CreatedBy"));
            e.setStatus(rs.getString("Status"));
            list.add(e);
        }
    }
    return list;
}
    
    // Lấy tất cả sự kiện đang Published và chưa kết thúc
    public List<Event> getAllPublishedEvents() throws SQLException {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM Events "
                   + "WHERE Status = 'Published' AND EndDate >= GETDATE() "
                   + "ORDER BY StartDate ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Event e = new Event();
                e.setEventID(rs.getInt("EventID"));
                e.setClubID(rs.getInt("ClubID"));
                e.setEventName(rs.getNString("EventName"));
                e.setDescription(rs.getNString("Description"));
                e.setLocation(rs.getNString("Location"));
                e.setCapacity(rs.getInt("Capacity"));
                e.setStartDate(rs.getTimestamp("StartDate"));
                e.setEndDate(rs.getTimestamp("EndDate"));
                e.setRegistrationStart(rs.getTimestamp("RegistrationStart"));
                e.setRegistrationEnd(rs.getTimestamp("RegistrationEnd"));
                e.setCreatedBy(rs.getInt("CreatedBy"));
                e.setStatus(rs.getString("Status"));
                e.setImage(rs.getString("Image")); // Thêm dòng này để hiển thị ảnh
                events.add(e);
            }
        }
        return events;
    }

    // Lấy chi tiết event theo ID
    public Event getEventById(int eventId) throws SQLException {
        String sql = "SELECT * FROM Events WHERE EventID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Event e = new Event();
                e.setEventID(rs.getInt("EventID"));
                e.setClubID(rs.getInt("ClubID"));
                e.setEventName(rs.getNString("EventName"));
                e.setDescription(rs.getNString("Description"));
                e.setLocation(rs.getNString("Location"));
                e.setCapacity(rs.getInt("Capacity"));
                e.setStartDate(rs.getTimestamp("StartDate"));
                e.setEndDate(rs.getTimestamp("EndDate"));
                e.setRegistrationStart(rs.getTimestamp("RegistrationStart"));
                e.setRegistrationEnd(rs.getTimestamp("RegistrationEnd"));
                e.setCreatedBy(rs.getInt("CreatedBy"));
                e.setStatus(rs.getString("Status"));
                e.setImage(rs.getString("Image"));
                return e;
            }
        }
        return null;
    }

}
