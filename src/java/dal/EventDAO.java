package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Event;

public class EventDAO extends DBContext {
    
    public List<Event> getAllEvents() {
        List<Event> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Events";
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Event(
                        rs.getInt("eventId"),
                        rs.getString("eventName"),
                        rs.getString("eventDate"),
                        rs.getInt("clubId")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public Event getEventById(int id) {
        try {
            String sql = "SELECT * FROM Events WHERE eventId=?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Event(
                        rs.getInt("eventId"),
                        rs.getString("eventName"),
                        rs.getString("eventDate"),
                        rs.getInt("clubId")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addEvent(Event e) {
        try {
            String sql = "INSERT INTO Events(eventName, eventDate, clubId) VALUES (?, ?, ?)";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, e.getEventName());
            st.setString(2, e.getEventDate());
            st.setInt(3, e.getClubId());
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean updateEvent(Event e) {
        try {
            String sql = "UPDATE Events SET eventName=?, eventDate=?, clubId=? WHERE eventId=?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, e.getEventName());
            st.setString(2, e.getEventDate());
            st.setInt(3, e.getClubId());
            st.setInt(4, e.getEventId());
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean deleteEvent(int id) {
        try {
            String sql = "DELETE FROM Events WHERE eventId=?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }
}
