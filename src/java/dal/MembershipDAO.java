/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.*;
import java.util.*;
import model.MembershipRole;
import model.PendingRequest;

public class MembershipDAO extends DBContext {

    //Lấy danh sách members của 1 CLB theo phân trang
    public List<MembershipRole> getMembersByPage(int clubId, int offset, int limit) throws SQLException {
        List<MembershipRole> list = new ArrayList<>();
        String sql = """
            SELECT 
                m.MembershipID,
                m.ClubID,
                m.UserID,
                m.RoleInClub,
                m.Status,
                u.FullName,
                m.JoinDate
            FROM Memberships m
            JOIN Users u ON m.UserID = u.UserID
            WHERE m.ClubID = ?
            ORDER BY m.MembershipID
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MembershipRole m = new MembershipRole();
                m.setMembershipId(rs.getInt("MembershipID"));
                m.setClubId(rs.getInt("ClubID"));
                m.setUserId(rs.getInt("UserID"));
                m.setRoleInClub(rs.getString("RoleInClub"));
                m.setStatus(rs.getString("Status"));
                m.setFullName(rs.getString("FullName"));
                m.setJoinDate(rs.getTimestamp("JoinDate"));
                list.add(m);
            }
        }
        return list;
    }

    //tổng số thành viên
    public int getTotalMembers(int clubId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Memberships WHERE ClubID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    //Tìm thành viên theo ID
    public MembershipRole findById(int membershipId) throws SQLException {
        String sql = """
            SELECT 
                m.MembershipID,
                m.ClubID,
                m.UserID,
                m.RoleInClub,
                m.Status,
                u.FullName,
                m.JoinDate
            FROM Memberships m
            JOIN Users u ON m.UserID = u.UserID
            WHERE m.MembershipID = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, membershipId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                MembershipRole m = new MembershipRole();
                m.setMembershipId(rs.getInt("MembershipID"));
                m.setClubId(rs.getInt("ClubID"));
                m.setUserId(rs.getInt("UserID"));
                m.setRoleInClub(rs.getString("RoleInClub"));
                m.setStatus(rs.getString("Status"));
                m.setFullName(rs.getString("FullName"));
                m.setJoinDate(rs.getTimestamp("JoinDate"));
                return m;
            }
        }
        return null;
    }

    //Cập nhật role trực tiếp
    public boolean updateRole(int membershipId, String newRole) throws SQLException {
        String sql = "UPDATE Memberships SET RoleInClub = ? WHERE MembershipID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newRole);
            ps.setInt(2, membershipId);
            return ps.executeUpdate() > 0;
        }
    }

    //Thêm request pending 
    public void addPendingRequest(PendingRequest req) throws SQLException {
        System.out.println("Pending role change request for MembershipID: " + req.getMembershipId());
    }
    
    /**
     * Add a member to a club
     * Used when creating a club (auto-add creator as Leader)
     * or when a user joins a club
     * 
     * @param userId User ID to add
     * @param clubId Club ID
     * @param roleInClub Role (e.g., "Leader", "Member")
     * @param status Status (e.g., "Active", "Pending")
     * @return true if successful, false otherwise
     */
    public boolean addMemberToClub(int userId, int clubId, String roleInClub, String status) {
        String sql = "INSERT INTO Memberships (UserID, ClubID, RoleInClub, JoinDate, Status) " +
                     "VALUES (?, ?, ?, GETDATE(), ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, clubId);
            stmt.setString(3, roleInClub);
            stmt.setString(4, status);
            
            int rows = stmt.executeUpdate();
            System.out.println("✅ Added user " + userId + " to club " + clubId + " as " + roleInClub);
            return rows > 0;
        } catch (SQLException e) {
            System.err.println("❌ Error adding member to club: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
