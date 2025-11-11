/*
 * Data Access Object for CreateEventRequests
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.CreateEventRequest;

/**
 * Data Access Object for CreateEventRequest operations
 * @author admin
 */
public class CreateEventRequestDAO extends DBContext {
    
    /**
     * Insert a new event request into the database
     * @param request The event request to insert
     * @return The generated request ID, or -1 if insertion failed
     */
    public int insertEventRequest(CreateEventRequest request) {
        // Check if database connection is available
        if (connection == null) {
            System.err.println("Database connection is null. Cannot insert event request.");
            return -1;
        }
        
        String sql = "INSERT INTO CreateEventRequests (ClubID, UserID, EventName, Description, Location, Capacity, " +
                     "StartDate, EndDate, RegistrationStart, RegistrationEnd, Image, Status, CreatedAt) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            st.setInt(1, request.getClubID());
            st.setInt(2, request.getUserID());
            st.setString(3, request.getEventName());
            st.setString(4, request.getDescription());
            st.setString(5, request.getLocation());
            st.setInt(6, request.getCapacity());
            st.setTimestamp(7, request.getStartDate());
            st.setTimestamp(8, request.getEndDate());
            st.setTimestamp(9, request.getRegistrationStart());
            st.setTimestamp(10, request.getRegistrationEnd());
            st.setString(11, request.getImage());
            st.setString(12, request.getStatus());
            st.setTimestamp(13, request.getCreatedAt());

            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: ClubID=" + request.getClubID() +
                             ", EventName=" + request.getEventName() +
                             ", UserID=" + request.getUserID() +
                             ", Status=" + request.getStatus());

            int affectedRows = st.executeUpdate();

            if (affectedRows > 0) {
                // Get the generated request ID
                ResultSet generatedKeys = st.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int requestId = generatedKeys.getInt(1);
                    System.out.println("Event request created successfully with ID: " + requestId);
                    return requestId;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error inserting event request: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        }
        return -1;
    }
    
    /**
     * Get all event requests (all statuses)
     * @return List of all event requests
     */
    public List<CreateEventRequest> getAllEventRequests() {
        List<CreateEventRequest> requests = new ArrayList<>();
        
        if (connection == null) {
            System.err.println("Database connection is null. Cannot get event requests.");
            return requests;
        }
        
        String sql = "SELECT RequestID, ClubID, UserID, EventName, Description, Location, Capacity, " +
                     "StartDate, EndDate, RegistrationStart, RegistrationEnd, Image, Status, " +
                     "CreatedAt, ReviewedBy, ReviewedAt " +
                     "FROM CreateEventRequests ORDER BY CreatedAt DESC";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CreateEventRequest request = mapResultSetToRequest(rs);
                requests.add(request);
            }
        } catch (SQLException e) {
            System.out.println("Error getting all event requests: " + e.getMessage());
            e.printStackTrace();
        }
        return requests;
    }
    
    /**
     * Get all pending event requests (excludes Draft status)
     * @return List of all pending event requests (Status = 'Pending' only)
     */
    public List<CreateEventRequest> getAllPendingRequests() {
        List<CreateEventRequest> requests = new ArrayList<>();
        
        if (connection == null) {
            System.err.println("Database connection is null. Cannot get event requests.");
            return requests;
        }
        
        // Only get 'Pending' requests - Draft requests are saved by club leaders and not submitted for approval yet, so they are excluded
        String sql = "SELECT RequestID, ClubID, UserID, EventName, Description, Location, Capacity, " +
                     "StartDate, EndDate, RegistrationStart, RegistrationEnd, Image, Status, " +
                     "CreatedAt, ReviewedBy, ReviewedAt " +
                     "FROM CreateEventRequests WHERE Status = 'Pending' ORDER BY CreatedAt DESC";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CreateEventRequest request = mapResultSetToRequest(rs);
                requests.add(request);
            }
        } catch (SQLException e) {
            System.out.println("Error getting all pending event requests: " + e.getMessage());
            e.printStackTrace();
        }
        return requests;
    }
    
    /**
     * Get a request by its ID
     * @param requestID The ID of the request to retrieve
     * @return The request object, or null if not found
     */
    public CreateEventRequest getRequestById(int requestID) {
        if (connection == null) {
            System.err.println("Database connection is null. Cannot get event request.");
            return null;
        }
        
        String sql = "SELECT RequestID, ClubID, UserID, EventName, Description, Location, Capacity, " +
                     "StartDate, EndDate, RegistrationStart, RegistrationEnd, Image, Status, " +
                     "CreatedAt, ReviewedBy, ReviewedAt " +
                     "FROM CreateEventRequests WHERE RequestID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, requestID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapResultSetToRequest(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error getting event request by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Update the status of an event request
     * @param requestID The ID of the request to update
     * @param status The new status
     * @param reviewedBy The ID of the reviewer
     * @return true if update was successful, false otherwise
     */
    public boolean updateRequestStatus(int requestID, String status, int reviewedBy) {
        if (connection == null) {
            System.err.println("Database connection is null. Cannot update event request status.");
            return false;
        }
        
        String sql = "UPDATE CreateEventRequests SET Status = ?, ReviewedBy = ?, ReviewedAt = GETDATE() WHERE RequestID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, reviewedBy);
            st.setInt(3, requestID);
            
            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating event request status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update an event request (for Draft/Pending status)
     * @param request The updated event request
     * @return true if update was successful, false otherwise
     */
    public boolean updateEventRequest(CreateEventRequest request) {
        if (connection == null) {
            System.err.println("Database connection is null. Cannot update event request.");
            return false;
        }
        
        String sql = "UPDATE CreateEventRequests SET ClubID = ?, EventName = ?, Description = ?, Location = ?, " +
                     "Capacity = ?, StartDate = ?, EndDate = ?, RegistrationStart = ?, " +
                     "RegistrationEnd = ?, Image = ?, Status = ? WHERE RequestID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, request.getClubID());
            st.setString(2, request.getEventName());
            st.setString(3, request.getDescription());
            st.setString(4, request.getLocation());
            st.setInt(5, request.getCapacity());
            st.setTimestamp(6, request.getStartDate());
            st.setTimestamp(7, request.getEndDate());
            st.setTimestamp(8, request.getRegistrationStart());
            st.setTimestamp(9, request.getRegistrationEnd());
            st.setString(10, request.getImage());
            st.setString(11, request.getStatus());
            st.setInt(12, request.getRequestID());
            
            System.out.println("Executing SQL: " + sql);
            System.out.println("Parameters: RequestID=" + request.getRequestID() +
                             ", ClubID=" + request.getClubID() +
                             ", EventName=" + request.getEventName() +
                             ", Status=" + request.getStatus());
            
            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating event request: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Helper method to map ResultSet to CreateEventRequest object
     */
    private CreateEventRequest mapResultSetToRequest(ResultSet rs) throws SQLException {
        Integer reviewedBy = rs.getObject("ReviewedBy") != null ? rs.getInt("ReviewedBy") : null;
        Timestamp reviewedAt = rs.getTimestamp("ReviewedAt");
        
        return new CreateEventRequest(
            rs.getInt("RequestID"),
            rs.getInt("ClubID"),
            rs.getInt("UserID"),
            rs.getString("EventName"),
            rs.getString("Description"),
            rs.getString("Location"),
            rs.getInt("Capacity"),
            rs.getTimestamp("StartDate"),
            rs.getTimestamp("EndDate"),
            rs.getTimestamp("RegistrationStart"),
            rs.getTimestamp("RegistrationEnd"),
            rs.getString("Image"),
            rs.getString("Status"),
            rs.getTimestamp("CreatedAt"),
            reviewedBy,
            reviewedAt
        );
    }
}

