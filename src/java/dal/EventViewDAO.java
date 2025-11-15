package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Event;
import model.EventClub;

public class EventViewDAO extends DBContext {

    public List<Event> getEventsByClubId(int clubId) throws SQLException {
        List<Event> list = new ArrayList<>();
        String sql = """
            SELECT EventID, ClubID, EventName, Description, Location, Capacity,
                   StartDate, EndDate, RegistrationStart, RegistrationEnd,
                   CreatedBy, Status, Image
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
                list.add(e);
            }
        }
        return list;
    }

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
                e.setImage(rs.getString("Image"));
                events.add(e);
            }
        }
        return events;
    }

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


    public int countPublishedEvents(String keyword, Integer clubId) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM Events " +
            "WHERE Status = 'Published' AND EndDate >= GETDATE()"
        );

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql.append(" AND (EventName LIKE ? OR Description LIKE ? OR Location LIKE ?)");
        }
        if (clubId != null) {
            sql.append(" AND ClubID = ?");
        }

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (hasKeyword) {
                String like = "%" + keyword.trim() + "%";
                ps.setNString(idx++, like);
                ps.setNString(idx++, like);
                ps.setNString(idx++, like);
            }
            if (clubId != null) {
                ps.setInt(idx++, clubId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public List<Event> searchPublishedEvents(String keyword, Integer clubId,
                                             int offset, int pageSize) throws SQLException {
        List<Event> events = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT * FROM Events " +
            "WHERE Status = 'Published' AND EndDate >= GETDATE()"
        );

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql.append(" AND (EventName LIKE ? OR Description LIKE ? OR Location LIKE ?)");
        }
        if (clubId != null) {
            sql.append(" AND ClubID = ?");
        }

        sql.append(" ORDER BY StartDate ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (hasKeyword) {
                String like = "%" + keyword.trim() + "%";
                ps.setNString(idx++, like);
                ps.setNString(idx++, like);
                ps.setNString(idx++, like);
            }
            if (clubId != null) {
                ps.setInt(idx++, clubId);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
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
                    e.setImage(rs.getString("Image"));
                    events.add(e);
                }
            }
        }
        return events;
    }

    public List<EventClub> getPublishedClubs() throws SQLException {
        List<EventClub> clubs = new ArrayList<>();
        String sql = """
            SELECT DISTINCT c.ClubID, c.ClubName
            FROM Clubs c
            INNER JOIN Events e ON e.ClubID = c.ClubID
            WHERE e.Status = 'Published' AND e.EndDate >= GETDATE()
            ORDER BY c.ClubName
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                EventClub club = new EventClub(
                        rs.getInt("ClubID"),
                        rs.getNString("ClubName")
                );
                clubs.add(club);
            }
        }
        return clubs;
    }
}
