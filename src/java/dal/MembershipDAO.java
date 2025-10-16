/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import model.Membership;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PendingRequest;

public class MembershipDAO extends DBContext {
    // giả lập bảng log trong bộ nhớ
    private static List<PendingRequest> pendingRequests = new ArrayList<>();

    public void addPendingRequest(PendingRequest req) {
        pendingRequests.add(req);
    }

    public List<PendingRequest> getAllPendingRequests() {
        return pendingRequests;
    }

    public void updatePendingRequestStatus(int membershipId, String status) {
        for (PendingRequest req : pendingRequests) {
            if (req.getMembershipId() == membershipId && req.getStatus().equals("Pending")) {
                req.setStatus(status);
                break;
            }
        }
    }
    // Find one membership by ID (include user full name)
    public Membership findById(int membershipId) throws SQLException {
        String sql = "SELECT m.MembershipID, m.ClubID, m.UserID, m.Role, m.Status, u.FullName " +
                     "FROM Memberships m " +
                     "JOIN Users u ON m.UserID = u.UserID " +
                     "WHERE m.MembershipID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, membershipId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Membership m = new Membership(
                    rs.getInt("MembershipID"),
                    rs.getInt("ClubID"),
                    rs.getInt("UserID"),
                    rs.getString("Role"),
                    rs.getString("Status")
                );
                m.setFullName(rs.getString("FullName"));
                return m;
            }
            return null;
        }
    }

    // Paginated list of members for a club, join Users to get FullName
    public List<Membership> getMembersByPage(int clubId, int offset, int limit) throws SQLException {
        List<Membership> list = new ArrayList<>();
        String sql = "SELECT m.MembershipID, m.ClubID, m.UserID, m.Role, m.Status, u.FullName " +
                     "FROM Memberships m " +
                     "JOIN Users u ON m.UserID = u.UserID " +
                     "WHERE m.ClubID = ? " +
                     "ORDER BY m.MembershipID " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, clubId);
            stmt.setInt(2, offset);
            stmt.setInt(3, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Membership m = new Membership();
                m.setMembershipId(rs.getInt("MembershipID"));
                m.setClubId(rs.getInt("ClubID"));
                m.setUserId(rs.getInt("UserID"));
                m.setRole(rs.getString("Role"));
                m.setStatus(rs.getString("Status"));
                m.setFullName(rs.getString("FullName"));
                list.add(m);
            }
        }
        return list;
    }

    // Total members count for club
    public int getTotalMembers(int clubId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Memberships WHERE ClubID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, clubId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // Update role
    public boolean updateRole(int membershipId, String newRole) throws SQLException {
        String sql = "UPDATE Memberships SET Role = ? WHERE MembershipID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, newRole);
            stmt.setInt(2, membershipId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        }
    }

    // Check uniqueness of a critical role within a club
    public boolean isRoleUnique(int clubId, String role) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Memberships WHERE ClubID = ? AND Role = ? AND Status = 'Approved'";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, clubId);
            stmt.setString(2, role);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1) == 0;
        }
        return true;
    }

    // Insert role change log
    public void insertRoleChangeLog(int membershipId, String oldRole, String newRole, int changedByUserId, String status) throws SQLException {
        String sql = "INSERT INTO RoleChangeLog (MembershipID, OldRole, NewRole, ChangedByUserID, ChangeStatus) VALUES (?,?,?,?,?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, membershipId);
            stmt.setString(2, oldRole);
            stmt.setString(3, newRole);
            stmt.setInt(4, changedByUserId);
            stmt.setString(5, status);
            stmt.executeUpdate();
        }
    }
}



