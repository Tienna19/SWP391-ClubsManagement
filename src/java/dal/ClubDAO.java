package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Category;
import model.Club;

public class ClubDAO extends DBContext {

    /**
     * Lấy tất cả clubs (không filter)
     * @return List of all clubs
     */
    public List<Club> getAllClubs() {
        return getFilteredClubs(null, null, null);
    }

    /**
     * Lấy danh sách CLB theo filter
     * @param categoryId Category ID để filter (null = tất cả)
     * @param status Status để filter (null/empty = tất cả)
     * @param keyword Keyword để tìm kiếm trong tên (null/empty = tất cả)
     * @return List of filtered clubs
     */
    public List<Club> getFilteredClubs(Integer categoryId, String status, String keyword) {
        List<Club> list = new ArrayList<>();
        
        // Check if database connection is available
        if (connection == null) {
            System.err.println("Database connection is null. Cannot execute query.");
            return list; // Return empty list instead of crashing
        }
        
        StringBuilder sql = new StringBuilder(
                "SELECT c.ClubID, c.ClubName, c.Description, c.Logo, c.ClubTypes, c.CreatedBy, c.CreatedAt, c.Status "
                + "FROM Clubs c "
                + "WHERE 1=1"
        );

        // Build dynamic WHERE clause
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (c.ClubName LIKE ? OR c.Description LIKE ?)");
        }
        
        sql.append(" ORDER BY c.CreatedAt DESC");
        
        System.out.println("[ClubDAO] SQL Query: " + sql.toString());
        System.out.println("[ClubDAO] Parameters - categoryId: " + categoryId + ", status: " + status + ", keyword: " + keyword);

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int index = 1;
            
            // Set parameters
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                st.setString(index++, searchPattern); // For ClubName
                st.setString(index++, searchPattern); // For Description
            }

            ResultSet rs = st.executeQuery();
            
            int rowCount = 0;
            while (rs.next()) {
                rowCount++;
                Club c = new Club();
                c.setClubId(rs.getInt("ClubID"));
                c.setClubName(rs.getString("ClubName"));
                c.setDescription(rs.getString("Description"));
                c.setLogo(rs.getString("Logo") != null ? rs.getString("Logo") : "");
                c.setClubTypes(rs.getString("ClubTypes"));
                c.setCreatedBy(rs.getInt("CreatedBy"));
                c.setCreatedAt(rs.getTimestamp("CreatedAt"));
                c.setStatus(rs.getString("Status"));
                
                // Apply filters after creating the club object
                boolean includeClub = true;
                
                // Filter by category (using ClubTypes)
                if (categoryId != null) {
                    // Convert categoryId to ClubTypes string for comparison
                    String expectedClubType = getClubTypeFromCategoryId(categoryId);
                    if (!expectedClubType.equals(c.getClubTypes())) {
                        includeClub = false;
                    }
                }
                
                // Filter by status
                if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase(c.getStatus())) {
                    includeClub = false;
                }
                
                if (includeClub) {
                    list.add(c);
                }
            }
            
            System.out.println("[ClubDAO] Total rows from DB: " + rowCount + ", After filtering: " + list.size());
            
        } catch (Exception e) {
            System.err.println("[ClubDAO] Error in getFilteredClubs: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy club theo ID
     * @param clubId ID của club
     * @return Club object hoặc null nếu không tìm thấy
     */
    public Club getClubById(int clubId) {
        // Check if database connection is available
        if (connection == null) {
            System.err.println("Database connection is null. Cannot execute query.");
            return null;
        }
        
        String sql = "SELECT c.ClubID, c.ClubName, c.Description, c.Logo, c.ClubTypes, c.CreatedBy, c.CreatedAt, c.Status "
                + "FROM Clubs c "
                + "WHERE c.ClubID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, clubId);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Club c = new Club();
                c.setClubId(rs.getInt("ClubID"));
                c.setClubName(rs.getString("ClubName"));
                c.setDescription(rs.getString("Description"));
                c.setLogo(rs.getString("Logo") != null ? rs.getString("Logo") : "");
                c.setClubTypes(rs.getString("ClubTypes"));
                c.setCreatedBy(rs.getInt("CreatedBy"));
                c.setCreatedAt(rs.getTimestamp("CreatedAt"));
                c.setStatus(rs.getString("Status"));
                return c;
            }
        } catch (Exception e) {
            System.err.println("Error in getClubById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy clubs theo status
     * @param status Status cần filter
     * @return List of clubs with specified status
     */
    public List<Club> getClubsByStatus(String status) {
        return getFilteredClubs(null, status, null);
    }

    /**
     * Lấy clubs theo category
     * @param categoryId Category ID
     * @return List of clubs in specified category
     */
    public List<Club> getClubsByCategory(int categoryId) {
        return getFilteredClubs(categoryId, null, null);
    }

    /**
     * Tìm kiếm clubs theo keyword
     * @param keyword Keyword để tìm kiếm
     * @return List of clubs matching keyword
     */
    public List<Club> searchClubs(String keyword) {
        return getFilteredClubs(null, null, keyword);
    }

    // Cache for category mapping to avoid repeated database calls
    private static Map<String, Integer> categoryIdCache = null;
    
    /**
     * Lấy toàn bộ categories từ ClubType trong database
     * @return List of all categories
     */
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        
        // Check if database connection is available
        if (connection == null) {
            System.err.println("Database connection is null. Cannot execute query.");
            return list; // Return empty list instead of crashing
        }
        
        // Get distinct ClubTypes from database with consistent ordering
        String sql = "SELECT DISTINCT ClubTypes FROM Clubs WHERE ClubTypes IS NOT NULL ORDER BY ClubTypes";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            int id = 1;
            categoryIdCache = new HashMap<>(); // Initialize cache
            
            while (rs.next()) {
                Category c = new Category();
                String clubTypes = rs.getString("ClubTypes");
                c.setId(id);
                c.setName(clubTypes);
                categoryIdCache.put(clubTypes, id); // Cache the mapping
                list.add(c);
                id++;
            }
        } catch (Exception e) {
            System.err.println("Error in getAllCategories: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
    }
    
    /**
     * Convert ClubType to category ID based on database order
     * @param clubType ClubType from database
     * @return category ID
     */
    private int getCategoryIdFromClubType(String clubType) {
        if (clubType == null) return 0;
        
        // Use cache if available
        if (categoryIdCache != null) {
            return categoryIdCache.getOrDefault(clubType, 0);
        }
        
        // Fallback: query database directly
        if (connection == null) return 0;
        
        try {
            String sql = "SELECT DISTINCT ClubTypes FROM Clubs WHERE ClubTypes IS NOT NULL ORDER BY ClubTypes";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            int id = 1;
            
            while (rs.next()) {
                if (rs.getString("ClubTypes").equals(clubType)) {
                    return id;
                }
                id++;
            }
        } catch (Exception e) {
            System.err.println("Error in getCategoryIdFromClubType: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Convert category ID to ClubType for database insertion
     * @param categoryId Category ID from form
     * @return ClubType string for database
     */
    private String getClubTypeFromCategoryId(int categoryId) {
        // Use cache if available
        if (categoryIdCache != null) {
            for (Map.Entry<String, Integer> entry : categoryIdCache.entrySet()) {
                if (entry.getValue() == categoryId) {
                    return entry.getKey();
                }
            }
        }
        
        // Fallback: query database directly
        if (connection == null) return "Khác";
        
        try {
            String sql = "SELECT DISTINCT ClubTypes FROM Clubs WHERE ClubTypes IS NOT NULL ORDER BY ClubTypes";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            int id = 1;
            
            while (rs.next()) {
                if (id == categoryId) {
                    return rs.getString("ClubTypes");
                }
                id++;
            }
        } catch (Exception e) {
            System.err.println("Error in getClubTypeFromCategoryId: " + e.getMessage());
        }
        
        return "Khác"; // Default fallback
    }

    /**
     * Insert Club mới
     * @param club Club object để insert
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean insertClub(Club club) {
        // Check if database connection is available
        if (connection == null) {
            System.err.println("Database connection is null. Cannot insert club.");
            return false;
        }
        
        try {
            String sql = "INSERT INTO Clubs (ClubName, Description, Logo, ClubTypes, CreatedBy, CreatedAt, Status) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, club.getClubName());
            st.setString(2, club.getDescription());
            st.setString(3, club.getLogo());
            st.setString(4, club.getClubTypes());
            st.setInt(5, club.getCreatedBy());
            st.setTimestamp(6, club.getCreatedAt());
            st.setString(7, club.getStatus());
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error in insertClub: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update Club
     * @param club Club object với thông tin mới
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateClub(Club club) {
        // Check if database connection is available
        if (connection == null) {
            System.err.println("Database connection is null. Cannot update club.");
            return false;
        }
        
        try {
            String sql = "UPDATE Clubs SET ClubName = ?, Description = ?, Logo = ?, "
                    + "ClubTypes = ?, CreatedBy = ?, Status = ? WHERE ClubID = ?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, club.getClubName());
            st.setString(2, club.getDescription());
            st.setString(3, club.getLogo());
            st.setString(4, club.getClubTypes());
            st.setInt(5, club.getCreatedBy());
            st.setString(6, club.getStatus());
            st.setInt(7, club.getClubId());
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error in updateClub: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete Club
     * @param clubId ID của club cần xóa
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deleteClub(int clubId) {
        // Check if database connection is available
        if (connection == null) {
            System.err.println("Database connection is null. Cannot delete club.");
            return false;
        }
        
        try {
            String sql = "DELETE FROM Clubs WHERE ClubID = ?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, clubId);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error in deleteClub: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Count clubs by status
     * @param status Status to count
     * @return Number of clubs
     */
    public int countClubsByStatus(String status) {
        // Check if database connection is available
        if (connection == null) {
            System.err.println("Database connection is null. Cannot count clubs by status.");
            return 0;
        }
        
        String sql = "SELECT COUNT(*) FROM Clubs WHERE Status = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Error in countClubsByStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Count total clubs
     * @return Total number of clubs
     */
    public int getTotalClubsCount() {
        // Check if database connection is available
        if (connection == null) {
            System.err.println("Database connection is null. Cannot get total clubs count.");
            return 0;
        }
        
        String sql = "SELECT COUNT(*) FROM Clubs";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Error in getTotalClubsCount: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
}