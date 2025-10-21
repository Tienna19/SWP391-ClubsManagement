// src/.../DAO/MemberDAO.java
package DAO;

import com.app.model.MemberDTO;
import dal.DBContext;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {

    // Lấy tên CLB (chỉ đọc)
    public String getClubName(int clubId) {
        String sql = "SELECT ClubName FROM Clubs WHERE ClubID = ?";
        // 👉 Tạo DBContext tại chỗ, dùng try-with-resources để đóng Connection
        try (Connection con = new DBContext().connection;
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (con == null) throw new RuntimeException("DB connection is null. Kiểm tra DBContext!");

            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getNString("ClubName") : "CLB #" + clubId;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy tên CLB", e);
        }
    }

    // Lấy danh sách thành viên (5 cột yêu cầu)
    public List<MemberDTO> findMembersByClub(int clubId) {
        String sql = """
            SELECT u.UserID, u.FullName, u.ProfileImage,
                   m.RoleInClub, m.JoinDate
            FROM Memberships m
            JOIN Users u ON u.UserID = m.UserID
            WHERE m.ClubID = ? AND m.Status = 'Active'
            ORDER BY CASE WHEN m.RoleInClub='Leader' THEN 0 ELSE 1 END, u.FullName
        """;

        List<MemberDTO> list = new ArrayList<>();
        try (Connection con = new DBContext().connection;
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (con == null) throw new RuntimeException("DB connection is null. Kiểm tra DBContext!");

            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Timestamp ts = rs.getTimestamp("JoinDate");
                    list.add(new MemberDTO(
                        rs.getInt("UserID"),
                        rs.getNString("FullName"),
                        rs.getNString("RoleInClub"),
                        rs.getString("ProfileImage"),
                        ts != null ? ts.toLocalDateTime() : null
                    ));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Lỗi lấy danh sách thành viên", e);
        }
        return list;
    }
}
