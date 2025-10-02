package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
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
                "SELECT c.ClubID, c.Name, c.Description, c.LogoUrl, c.CategoryID, "
                + "cat.Name AS CategoryName, c.CreatedByUserID, c.Status, c.CreatedAt, c.ApprovedByUserID "
                + "FROM Clubs c "
                + "LEFT JOIN ClubCategories cat ON c.CategoryID = cat.CategoryID "
                + "WHERE 1=1"
        );

        // Build dynamic WHERE clause
        if (categoryId != null) {
            sql.append(" AND c.CategoryID = ?");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND c.Status = ?");
        }
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (c.Name LIKE ? OR c.Description LIKE ?)");
        }
        
        sql.append(" ORDER BY c.CreatedAt DESC");

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int index = 1;
            
            // Set parameters
            if (categoryId != null) {
                st.setInt(index++, categoryId);
            }
            if (status != null && !status.trim().isEmpty()) {
                st.setString(index++, status);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchPattern = "%" + keyword.trim() + "%";
                st.setString(index++, searchPattern); // For name
                st.setString(index++, searchPattern); // For description
            }

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Club c = new Club(
                        rs.getInt("ClubID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getString("LogoUrl"),
                        rs.getInt("CategoryID"),
                        rs.getString("CategoryName"), // Category name from JOIN
                        rs.getInt("CreatedByUserID"),
                        rs.getString("Status"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getObject("ApprovedByUserID") != null ? rs.getInt("ApprovedByUserID") : null
                );
                list.add(c);
            }
        } catch (Exception e) {
            System.err.println("Error in getFilteredClubs: " + e.getMessage());
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
        
        String sql = "SELECT c.ClubID, c.Name, c.Description, c.LogoUrl, c.CategoryID, "
                + "cat.Name AS CategoryName, c.CreatedByUserID, c.Status, c.CreatedAt, c.ApprovedByUserID "
                + "FROM Clubs c "
                + "LEFT JOIN ClubCategories cat ON c.CategoryID = cat.CategoryID "
                + "WHERE c.ClubID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, clubId);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                return new Club(
                        rs.getInt("ClubID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getString("LogoUrl"),
                        rs.getInt("CategoryID"),
                        rs.getString("CategoryName"),
                        rs.getInt("CreatedByUserID"),
                        rs.getString("Status"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getObject("ApprovedByUserID") != null ? rs.getInt("ApprovedByUserID") : null
                );
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

    /**
     * Lấy toàn bộ categories
     * @return List of all categories
     */
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        
        // Check if database connection is available
        if (connection == null) {
            System.err.println("Database connection is null. Cannot execute query.");
            return list; // Return empty list instead of crashing
        }
        
        String sql = "SELECT CategoryID AS id, Name FROM ClubCategories ORDER BY Name";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("Name"));
                list.add(c);
            }
        } catch (Exception e) {
            System.err.println("Error in getAllCategories: " + e.getMessage());
            e.printStackTrace();
        }

        return list;
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
            String sql = "INSERT INTO Clubs (Name, Description, LogoUrl, CategoryID, CreatedByUserID, Status, CreatedAt) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, club.getName());
            st.setString(2, club.getDescription());
            st.setString(3, club.getLogoUrl());
            st.setInt(4, club.getCategoryId());
            st.setInt(5, club.getCreatedByUserId());
            st.setString(6, club.getStatus());
            st.setTimestamp(7, club.getCreatedAt());
            
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
            String sql = "UPDATE Clubs SET Name = ?, Description = ?, LogoUrl = ?, "
                    + "CategoryID = ?, Status = ?, ApprovedByUserID = ? WHERE ClubID = ?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, club.getName());
            st.setString(2, club.getDescription());
            st.setString(3, club.getLogoUrl());
            st.setInt(4, club.getCategoryId());
            st.setString(5, club.getStatus());
            if (club.getApprovedByUserId() != null) {
                st.setInt(6, club.getApprovedByUserId());
            } else {
                st.setNull(6, java.sql.Types.INTEGER);
            }
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
     * Đếm số lượng clubs theo status
     * @param status Status cần đếm
     * @return Số lượng clubs
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
     * Đếm tổng số clubs
     * @return Tổng số clubs
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