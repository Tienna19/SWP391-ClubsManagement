// src/.../DAO/MemberDAO.java
package dal;

import model.MemberDTO;
import dal.DBContext;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {

 
    public String getClubName(int clubId) {
        String sql = "SELECT ClubName FROM Clubs WHERE ClubID = ?";
       
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

   
    public List<MemberDTO> findMembersByClub(int clubId) {
        String sql = "SELECT u.UserID, u.FullName, u.ProfileImage, " +
                     "m.RoleInClub, m.JoinDate " +
                     "FROM Memberships m " +
                     "JOIN Users u ON u.UserID = m.UserID " +
                     "WHERE m.ClubID = ? AND m.Status = 'Active' " +
                     "ORDER BY CASE WHEN m.RoleInClub='Leader' THEN 0 ELSE 1 END, u.FullName";

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
    
    /**
     * Check if user is leader of a club
     * @param userId User ID
     * @param clubId Club ID
     * @return true if user is leader, false otherwise
     */
    public boolean isClubLeader(int userId, int clubId) {
        String sql = "SELECT RoleInClub FROM Memberships WHERE UserID = ? AND ClubID = ? AND Status = 'Active'";
        
        try (Connection con = new DBContext().connection;
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            if (con == null) return false;
            
            ps.setInt(1, userId);
            ps.setInt(2, clubId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String role = rs.getString("RoleInClub");
                    return "Leader".equalsIgnoreCase(role);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking club leader: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Get club IDs where user is a leader
     * @param userId User ID
     * @return List of club IDs where user is leader
     */
    public List<Integer> getClubsWhereUserIsLeader(int userId) {
        List<Integer> clubIds = new ArrayList<>();
        String sql = "SELECT ClubID FROM Memberships WHERE UserID = ? AND RoleInClub = 'Leader' AND Status = 'Active'";
        
        try (Connection con = new DBContext().connection;
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            if (con == null) {
                System.err.println("Error: Database connection is null in getClubsWhereUserIsLeader");
                return clubIds;
            }
            
            System.out.println("Getting clubs for user ID: " + userId);
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                System.out.println("Executing query: " + sql + " with userId=" + userId);
                
                while (rs.next()) {
                    int clubId = rs.getInt("ClubID");
                    System.out.println("Found club ID: " + clubId);
                    clubIds.add(clubId);
                }
            }
            
            System.out.println("Total clubs found: " + clubIds.size());
        } catch (SQLException e) {
            System.err.println("Error getting clubs where user is leader: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Unexpected error in getClubsWhereUserIsLeader: " + e.getMessage());
            e.printStackTrace();
        }
        return clubIds;
    }
}
