package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.Club;

public class ClubDAO extends DBContext {

    // 🔹 Lấy danh sách CLB theo filter
    public List<Club> getFilteredClubs(Integer categoryId, String status, String keyword) {
        List<Club> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT c.*, cat.Name AS CategoryName "
                + "FROM Clubs c "
                + "JOIN ClubCategories cat ON c.CategoryID = cat.CategoryID "
                + "WHERE 1=1"
        );

        if (categoryId != null) {
            sql.append(" AND c.CategoryID = ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND c.Status = ?");
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND c.Name LIKE ?");
        }

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int index = 1;
            if (categoryId != null) {
                st.setInt(index++, categoryId);
            }
            if (status != null && !status.isEmpty()) {
                st.setString(index++, status);
            }
            if (keyword != null && !keyword.isEmpty()) {
                st.setString(index++, "%" + keyword + "%");
            }

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Club c = new Club(
                        rs.getInt("ClubID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getString("LogoUrl"),
                        rs.getInt("CategoryID"),
                        rs.getString("CategoryName"), // 🔹 lấy luôn tên category
                        rs.getInt("CreatedByUserID"),
                        rs.getString("Status"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getObject("ApprovedByUserID") != null ? rs.getInt("ApprovedByUserID") : null
                );
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Lấy toàn bộ categories
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT CategoryID AS id, Name FROM ClubCategories";

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
            e.printStackTrace();
        }

        return list;
    }

    // 🔹 Insert Club
    public void insertClub(Club club) {
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
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
