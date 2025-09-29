package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Category;
import model.Club;

public class ClubDAO extends DBContext {

    public List<Club> getAllClubs() {
        List<Club> list = new ArrayList<>();
        try {
            String sql = "SELECT * FROM Clubs";
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Club c = new Club(
                        rs.getInt("ClubID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getString("LogoUrl"),
                        rs.getInt("CategoryID"),
                        rs.getInt("CreatedByUserID"), // 🔹 lấy dạng String
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

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT CategoryID AS id, Name FROM ClubCategories"; // ✅ bảng đúng

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

    public void insertClub(Club club) {
        try {
            String sql = "INSERT INTO Clubs (Name, Description, LogoUrl, CategoryID, CreatedByUserID, Status, CreatedAt) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, club.getName());
            st.setString(2, club.getDescription());
            st.setString(3, club.getLogoUrl());
            st.setInt(4, club.getCategoryId());
            st.setInt(5, club.getCreatedByUserId()); // 🔹 lưu dạng String
            st.setString(6, club.getStatus());
            st.setTimestamp(7, club.getCreatedAt());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
