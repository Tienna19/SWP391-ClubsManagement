package dal;

import model.CreateClubRequest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for CreateClubRequests table
 * Handles club creation request operations
 */
public class CreateClubRequestDAO extends DBContext {

    /**
     * Insert a new club creation request
     * 
     * @param request CreateClubRequest object
     * @return RequestID if successful, -1 if failed
     */
    public int insertRequest(CreateClubRequest request) {
        if (connection == null) {
            System.err.println("❌ Database connection is null");
            return -1;
        }

        String sql = "INSERT INTO CreateClubRequests (ClubName, Description, Logo, ClubTypes, UserID, CreatedAt, Status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            st.setString(1, request.getClubName());
            st.setString(2, request.getDescription());
            st.setString(3, request.getLogo());
            st.setString(4, request.getClubTypes());
            st.setInt(5, request.getRequestedBy());  // Maps to UserID
            st.setTimestamp(6, request.getRequestedAt());  // Maps to CreatedAt
            st.setString(7, request.getStatus());

            int rows = st.executeUpdate();
            if (rows > 0) {
                ResultSet rs = st.getGeneratedKeys();
                if (rs.next()) {
                    int requestId = rs.getInt(1);
                    System.out.println("✅ Club creation request saved with ID: " + requestId);
                    return requestId;
                }
            }
            return -1;
        } catch (SQLException e) {
            System.err.println("❌ Error inserting club request: " + e.getMessage());
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Get all club creation requests (with user info)
     * 
     * @return List of CreateClubRequest
     */
    public List<CreateClubRequest> getAllRequests() {
        List<CreateClubRequest> list = new ArrayList<>();
        if (connection == null) {
            System.err.println("❌ Database connection is null");
            return list;
        }

        String sql = "SELECT r.RequestID, r.ClubName, r.Description, r.Logo, r.ClubTypes, r.UserID, r.CreatedAt, r.Status, " +
                     "r.ReviewedBy, r.ReviewedAt, " +
                     "u1.FullName AS RequestedByName, " +
                     "u2.FullName AS ReviewedByName " +
                     "FROM CreateClubRequests r " +
                     "LEFT JOIN Users u1 ON r.UserID = u1.UserID " +
                     "LEFT JOIN Users u2 ON r.ReviewedBy = u2.UserID " +
                     "ORDER BY r.CreatedAt DESC";

        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            
            while (rs.next()) {
                CreateClubRequest req = mapResultSetToRequest(rs);
                list.add(req);
            }
            
            System.out.println("✅ Retrieved " + list.size() + " club requests");
        } catch (SQLException e) {
            System.err.println("❌ Error getting all requests: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Get requests by status
     * 
     * @param status Status to filter (Pending, Approved, Rejected)
     * @return List of CreateClubRequest
     */
    public List<CreateClubRequest> getRequestsByStatus(String status) {
        List<CreateClubRequest> list = new ArrayList<>();
        if (connection == null) {
            System.err.println("❌ Database connection is null");
            return list;
        }

        String sql = "SELECT r.*, " +
                     "u1.FullName AS RequestedByName, " +
                     "u2.FullName AS ReviewedByName " +
                     "FROM CreateClubRequests r " +
                     "LEFT JOIN Users u1 ON r.UserID = u1.UserID " +
                     "LEFT JOIN Users u2 ON r.ReviewedBy = u2.UserID " +
                     "WHERE LOWER(LTRIM(RTRIM(r.Status))) = LOWER(?) " +
                     "ORDER BY r.CreatedAt DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                CreateClubRequest req = mapResultSetToRequest(rs);
                list.add(req);
            }
            
            System.out.println("✅ Retrieved " + list.size() + " requests with status: " + status);
        } catch (SQLException e) {
            System.err.println("❌ Error getting requests by status: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Get request by ID
     * 
     * @param requestId Request ID
     * @return CreateClubRequest or null if not found
     */
    public CreateClubRequest getRequestById(int requestId) {
        if (connection == null) {
            System.err.println("❌ Database connection is null");
            return null;
        }

        String sql = "SELECT r.*, " +
                     "u1.FullName AS RequestedByName, " +
                     "u2.FullName AS ReviewedByName " +
                     "FROM CreateClubRequests r " +
                     "LEFT JOIN Users u1 ON r.UserID = u1.UserID " +
                     "LEFT JOIN Users u2 ON r.ReviewedBy = u2.UserID " +
                     "WHERE r.RequestID = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, requestId);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToRequest(rs);
            }
        } catch (SQLException e) {
            System.err.println("❌ Error getting request by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Update request status (Approve or Reject)
     * 
     * @param requestId Request ID
     * @param status New status (Approved, Rejected)
     * @param reviewedBy Admin UserID
     * @param reviewComment Admin's comment
     * @param createdClubId ClubID if approved (null if rejected)
     * @return true if successful
     */
    public boolean updateRequestStatus(int requestId, String status, int reviewedBy) {
        if (connection == null) {
            System.err.println("❌ Database connection is null");
            return false;
        }

        String sql = "UPDATE CreateClubRequests " +
                     "SET Status = ?, ReviewedBy = ?, ReviewedAt = GETDATE() " +
                     "WHERE RequestID = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            st.setInt(2, reviewedBy);
            st.setInt(3, requestId);

            int rows = st.executeUpdate();
            if (rows > 0) {
                System.out.println("✅ Request " + requestId + " updated to: " + status);
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("❌ Error updating request status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get count of requests by status
     * 
     * @param status Status to count
     * @return count
     */
    public int getCountByStatus(String status) {
        if (connection == null) {
            System.err.println("❌ Database connection is null");
            return 0;
        }

        String sql = "SELECT COUNT(*) FROM CreateClubRequests WHERE LOWER(LTRIM(RTRIM(Status))) = LOWER(?)";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("❌ Error counting requests: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    /**
     * Get requests by user
     * 
     * @param userId User ID
     * @return List of user's requests
     */
    public List<CreateClubRequest> getRequestsByUser(int userId) {
        List<CreateClubRequest> list = new ArrayList<>();
        if (connection == null) {
            System.err.println("❌ Database connection is null");
            return list;
        }

        String sql = "SELECT r.*, " +
                     "u1.FullName AS RequestedByName, " +
                     "u2.FullName AS ReviewedByName " +
                     "FROM CreateClubRequests r " +
                     "LEFT JOIN Users u1 ON r.UserID = u1.UserID " +
                     "LEFT JOIN Users u2 ON r.ReviewedBy = u2.UserID " +
                     "WHERE r.UserID = ? " +
                     "ORDER BY r.CreatedAt DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                CreateClubRequest req = mapResultSetToRequest(rs);
                list.add(req);
            }
            
            System.out.println("✅ Retrieved " + list.size() + " requests for user: " + userId);
        } catch (SQLException e) {
            System.err.println("❌ Error getting requests by user: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }

    /**
     * Map ResultSet to CreateClubRequest object
     */
    private CreateClubRequest mapResultSetToRequest(ResultSet rs) throws SQLException {
        CreateClubRequest req = new CreateClubRequest();
        
        req.setRequestId(rs.getInt("RequestID"));
        String clubName = rs.getString("ClubName");
        if (clubName != null) {
            req.setClubName(clubName.trim());
        }
        String description = rs.getString("Description");
        if (description != null) {
            req.setDescription(description.trim());
        }
        String logo = rs.getString("Logo");
        if (logo != null) {
            req.setLogo(logo.trim());
        }
        String clubTypes = rs.getString("ClubTypes");
        if (clubTypes != null) {
            req.setClubTypes(clubTypes.trim());
        }
        req.setRequestedBy(rs.getInt("UserID"));  // Database column is UserID
        req.setRequestedAt(rs.getTimestamp("CreatedAt"));  // Database column is CreatedAt
        String status = rs.getString("Status");
        if (status != null) {
            req.setStatus(status.trim());
        }
        
        // Nullable fields
        int reviewedBy = rs.getInt("ReviewedBy");
        if (!rs.wasNull()) {
            req.setReviewedBy(reviewedBy);
        }
        
        Timestamp reviewedAt = rs.getTimestamp("ReviewedAt");
        if (reviewedAt != null) {
            req.setReviewedAt(reviewedAt);
        }
        
        req.setReviewComment(null);
        req.setCreatedClubId(null);
        
        // Display fields from JOIN
        req.setRequestedByName(rs.getString("RequestedByName"));
        req.setReviewedByName(rs.getString("ReviewedByName"));
        
        return req;
    }
}

