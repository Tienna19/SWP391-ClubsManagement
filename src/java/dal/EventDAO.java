/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.Event;

/**
 * Data Access Object for Event operations
 * @author admin
 */
public class EventDAO extends DBContext {
    
    /**
     * Insert a new event into the database
     * @param event The event to insert
     * @return The generated event ID, or -1 if insertion failed
     */
    public int insertEvent(Event event) {
        // Check if database connection is available
        if (connection == null) {
            System.err.println("Database connection is null. Cannot insert event.");
            return -1;
        }
        
        // First check if the club exists
        if (!clubExists(event.getClubID())) {
            System.out.println("Error: Club with ID " + event.getClubID() + " does not exist");
            return -1;
        }

        String sql = "INSERT INTO Events (ClubID, EventName, Description, EventDate, Status, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            st.setInt(1, event.getClubID());
            st.setString(2, event.getEventName());
            st.setString(3, event.getDescription());
            st.setTimestamp(4, event.getEventDate());
            st.setString(5, event.getStatus());

            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: ClubID=" + event.getClubID() +
                             ", EventName=" + event.getEventName() +
                             ", EventDate=" + event.getEventDate());

            int affectedRows = st.executeUpdate();

            if (affectedRows > 0) {
                // Get the generated event ID
                ResultSet generatedKeys = st.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int eventId = generatedKeys.getInt(1);
                    System.out.println("Event created successfully with ID: " + eventId);
                    return eventId;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error inserting event: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Check if a club exists in the database
     * @param clubID The ID of the club to check
     * @return true if the club exists, false otherwise
     */
    private boolean clubExists(int clubID) {
        // Check if database connection is available
        if (connection == null) {
            System.err.println("Database connection is null. Cannot check club existence.");
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM Clubs WHERE ClubID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, clubID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking if club exists: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Create a default club if none exists (for testing purposes)
     * @return The ID of the created club, or -1 if creation failed
     */
    public int createDefaultClub() {
        String sql = "INSERT INTO Clubs (Name, Description, CategoryID, CreatedByUserID, Status, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            st.setString(1, "Default Club");
            st.setString(2, "Default club for testing purposes");
            st.setObject(3, null); // CategoryID can be null
            st.setInt(4, 1); // Assuming user ID 1 exists, or we'll need to create a user too
            st.setString(5, "Approved");

            int affectedRows = st.executeUpdate();

            if (affectedRows > 0) {
                ResultSet generatedKeys = st.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int clubId = generatedKeys.getInt(1);
                    System.out.println("Default club created with ID: " + clubId);
                    return clubId;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error creating default club: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }
    
    /**
     * Get all events from the database
     * @return List of all events
     */
    public List<Event> getAllEvents() {
        List<Event> events = new ArrayList<>();
        
        // Check if database connection is available
        if (connection == null) {
            System.err.println("Database connection is null. Cannot get events.");
            return events; // Return empty list instead of crashing
        }
        
        String sql = "SELECT EventID, ClubID, EventName, Description, EventDate, Status, CreatedAt FROM Events ORDER BY CreatedAt DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Event event = new Event(
                    rs.getInt("EventID"),
                    rs.getInt("ClubID"),
                    rs.getString("EventName"),
                    rs.getString("Description"),
                    rs.getTimestamp("EventDate"),
                    rs.getString("Status"),
                    rs.getTimestamp("CreatedAt")
                );
                events.add(event);
            }
        } catch (SQLException e) {
            System.out.println("Error getting all events: " + e.getMessage());
            e.printStackTrace();
        }
        return events;
    }
    
    /**
     * Get an event by its ID
     * @param eventID The ID of the event to retrieve
     * @return The event object, or null if not found
     */
    public Event getEventById(int eventID) {
        String sql = "SELECT EventID, ClubID, EventName, Description, EventDate, Status, CreatedAt FROM Events WHERE EventID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, eventID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Event(
                    rs.getInt("EventID"),
                    rs.getInt("ClubID"),
                    rs.getString("EventName"),
                    rs.getString("Description"),
                    rs.getTimestamp("EventDate"),
                    rs.getString("Status"),
                    rs.getTimestamp("CreatedAt")
                );
            }
        } catch (SQLException e) {
            System.out.println("Error getting event by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get events by club ID
     * @param clubID The ID of the club
     * @return List of events for the specified club
     */
    public List<Event> getEventsByClubId(int clubID) {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT EventID, ClubID, EventName, Description, EventDate, Status, CreatedAt FROM Events WHERE ClubID = ? ORDER BY EventDate ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, clubID);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Event event = new Event(
                    rs.getInt("EventID"),
                    rs.getInt("ClubID"),
                    rs.getString("EventName"),
                    rs.getString("Description"),
                    rs.getTimestamp("EventDate"),
                    rs.getString("Status"),
                    rs.getTimestamp("CreatedAt")
                );
                events.add(event);
            }
        } catch (SQLException e) {
            System.out.println("Error getting events by club ID: " + e.getMessage());
            e.printStackTrace();
        }
        return events;
    }
    
    /**
     * Update an event's status
     * @param eventID The ID of the event to update
     * @param status The new status
     * @return true if update was successful, false otherwise
     */
    public boolean updateEventStatus(int eventID, String status) {
        String sql = "UPDATE Events SET Status = ? WHERE EventID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, eventID);
            
            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating event status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}
