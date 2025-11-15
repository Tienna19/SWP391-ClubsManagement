package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.assignrole.ClubBasic;
import model.assignrole.ClubMember;
import model.assignrole.RoleSystem;

public class AssignRoleNewDAO extends DBContext {

    // 1. Lấy danh sách CLB (Admin thấy tất cả, Leader thấy CLB mình làm leader)
    public List<ClubBasic> getClubsForUser(int userId, boolean isAdmin) throws SQLException {
        List<ClubBasic> list = new ArrayList<>();

        String sqlAdmin = "SELECT ClubID, ClubName FROM Clubs WHERE Status = 'Active'";
        String sqlLeader = 
            "SELECT DISTINCT c.ClubID, c.ClubName " +
            "FROM Clubs c JOIN Memberships m ON c.ClubID = m.ClubID " +
            "WHERE m.UserID = ? AND m.RoleInClub = 'Leader'";

        String sql = isAdmin ? sqlAdmin : sqlLeader;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (!isAdmin) ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new ClubBasic(
                            rs.getInt("ClubID"),
                            rs.getNString("ClubName")));
                }
            }
        }
        return list;
    }

    // 2. Lấy danh sách members trong 1 CLB
    public List<ClubMember> getMembersByClub(int clubId) throws SQLException {
        List<ClubMember> list = new ArrayList<>();

        String sql =
            "SELECT m.MembershipID, m.UserID, m.RoleInClub, m.Status AS MembershipStatus, " +
            "u.FullName, u.Email, u.RoleID, u.Status AS UserStatus " +
            "FROM Memberships m JOIN Users u ON m.UserID = u.UserID " +
            "WHERE m.ClubID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, clubId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ClubMember cm = new ClubMember();
                    cm.setMembershipId(rs.getInt("MembershipID"));
                    cm.setUserId(rs.getInt("UserID"));
                    cm.setFullName(rs.getNString("FullName"));
                    cm.setEmail(rs.getString("Email"));
                    cm.setRoleInClub(rs.getString("RoleInClub"));
                    cm.setMembershipStatus(rs.getString("MembershipStatus"));
                    cm.setSystemRoleId(rs.getInt("RoleID"));
                    cm.setSystemStatus(rs.getString("UserStatus"));
                    list.add(cm);
                }
            }
        }
        return list;
    }

    // 3. Lấy role hệ thống
    public List<RoleSystem> getSystemRoles() throws SQLException {
        List<RoleSystem> list = new ArrayList<>();

        String sql = "SELECT RoleID, RoleName FROM Roles ORDER BY RoleID";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new RoleSystem(
                        rs.getInt("RoleID"),
                        rs.getNString("RoleName")));
            }
        }
        return list;
    }

    // 4. Lấy chi tiết 1 member
    public ClubMember getMemberDetail(int membershipId) throws SQLException {
        String sql =
            "SELECT m.MembershipID, m.UserID, m.ClubID, m.RoleInClub, m.Status AS MembershipStatus, " +
            "u.FullName, u.Email, u.RoleID, u.Status AS UserStatus " +
            "FROM Memberships m JOIN Users u ON m.UserID = u.UserID " +
            "WHERE m.MembershipID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, membershipId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ClubMember cm = new ClubMember();
                    cm.setMembershipId(rs.getInt("MembershipID"));
                    cm.setUserId(rs.getInt("UserID"));
                    cm.setFullName(rs.getNString("FullName"));
                    cm.setEmail(rs.getString("Email"));
                    cm.setRoleInClub(rs.getString("RoleInClub"));
                    cm.setMembershipStatus(rs.getString("MembershipStatus"));
                    cm.setSystemRoleId(rs.getInt("RoleID"));
                    cm.setSystemStatus(rs.getString("UserStatus"));
                    return cm;
                }
            }
        }
        return null;
    }

    // 5. Update role (transaction đầy đủ)
    public void updateRole(
            int membershipId,
            String newClubRole,
            String newMembershipStatus,
            Integer newSystemRole,
            String newUserStatus)
            throws SQLException {

        String updateMembership =
            "UPDATE Memberships SET RoleInClub = ?, Status = ? WHERE MembershipID = ?";

        String getUserId =
            "SELECT UserID FROM Memberships WHERE MembershipID = ?";

        String updateUser =
            "UPDATE Users SET RoleID = ?, Status = ? WHERE UserID = ?";

        connection.setAutoCommit(false);

        try {
            // 1. Lấy userId
            int userId = -1;
            try (PreparedStatement ps = connection.prepareStatement(getUserId)) {
                ps.setInt(1, membershipId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) userId = rs.getInt("UserID");
            }

            // 2. Update Membership
            try (PreparedStatement ps = connection.prepareStatement(updateMembership)) {
                ps.setString(1, newClubRole);
                ps.setString(2, newMembershipStatus);
                ps.setInt(3, membershipId);
                ps.executeUpdate();
            }

            // 3. Update User nếu admin đổi role
            if (newSystemRole != null) {
                try (PreparedStatement ps = connection.prepareStatement(updateUser)) {
                    ps.setInt(1, newSystemRole);
                    ps.setString(2, newUserStatus);
                    ps.setInt(3, userId);
                    ps.executeUpdate();
                }
            }

            connection.commit();
        } catch (SQLException ex) {
            connection.rollback();
            throw ex;
        } finally {
            connection.setAutoCommit(true);
        }
    }
}
