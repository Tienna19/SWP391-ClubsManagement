package dal;

import model.assignrole.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AssignRoleNewDAO extends DBContext {

    /* ============================
       1. Lấy danh sách CLB
     ============================ */
    public List<ClubBasic> getClubsForUser(int userId, boolean isAdmin) throws SQLException {
        List<ClubBasic> list = new ArrayList<>();

        String sqlAdmin = "SELECT ClubID, ClubName FROM Clubs WHERE Status = 'Active'";
        String sqlLeader =
                "SELECT DISTINCT c.ClubID, c.ClubName " +
                "FROM Clubs c JOIN Memberships m ON c.ClubID = m.ClubID " +
                "WHERE m.UserID = ? AND m.RoleInClub = 'Leader' AND m.Status='Active'";

        PreparedStatement ps = connection.prepareStatement(isAdmin ? sqlAdmin : sqlLeader);
        if (!isAdmin) ps.setInt(1, userId);

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new ClubBasic(
                    rs.getInt("ClubID"),
                    rs.getNString("ClubName")
            ));
        }
        return list;
    }

    /* =====================================
       2. Đếm tổng số members theo filter
     ===================================== */
    public int countMembers(int clubId, String keyword, String roleFilter) throws SQLException {

        String sql = "SELECT COUNT(*) FROM Memberships m JOIN Users u ON m.UserID = u.UserID WHERE m.ClubID = ?";

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND (u.FullName LIKE ? OR u.Email LIKE ?)";
        }
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql += " AND m.RoleInClub = ?";
        }

        PreparedStatement ps = connection.prepareStatement(sql);
        int idx = 1;

        ps.setInt(idx++, clubId);

        if (keyword != null && !keyword.isEmpty()) {
            ps.setString(idx++, "%" + keyword + "%");
            ps.setString(idx++, "%" + keyword + "%");
        }

        if (roleFilter != null && !roleFilter.isEmpty()) {
            ps.setString(idx++, roleFilter);
        }

        ResultSet rs = ps.executeQuery();
        return rs.next() ? rs.getInt(1) : 0;
    }

    /* ==========================================
       3. Lấy danh sách members theo trang
     ========================================== */
    public List<ClubMember> getMembersPaged(
            int clubId, String keyword, String roleFilter,
            int offset, int pageSize) throws SQLException {

        List<ClubMember> list = new ArrayList<>();

        String sql =
                "SELECT m.MembershipID, m.UserID, m.RoleInClub, m.Status AS MembershipStatus, " +
                "u.FullName, u.Email, u.RoleID, u.Status AS UserStatus " +
                "FROM Memberships m JOIN Users u ON m.UserID = u.UserID " +
                "WHERE m.ClubID = ?";

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND (u.FullName LIKE ? OR u.Email LIKE ?)";
        }
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql += " AND m.RoleInClub = ?";
        }

        sql += " ORDER BY u.FullName OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        PreparedStatement ps = connection.prepareStatement(sql);

        int idx = 1;
        ps.setInt(idx++, clubId);

        if (keyword != null && !keyword.isEmpty()) {
            ps.setString(idx++, "%" + keyword + "%");
            ps.setString(idx++, "%" + keyword + "%");
        }

        if (roleFilter != null && !roleFilter.isEmpty()) {
            ps.setString(idx++, roleFilter);
        }

        ps.setInt(idx++, offset);
        ps.setInt(idx++, pageSize);

        ResultSet rs = ps.executeQuery();

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

        return list;
    }

    /* ================================
       4. Lấy tất cả roles hệ thống
     ================================ */
    public List<RoleSystem> getSystemRoles() throws SQLException {
        List<RoleSystem> list = new ArrayList<>();

        String sql = "SELECT RoleID, RoleName FROM Roles ORDER BY RoleID";

        PreparedStatement ps = connection.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            list.add(new RoleSystem(
                    rs.getInt("RoleID"),
                    rs.getNString("RoleName")
            ));
        }
        return list;
    }

    /* ====================================
       5. Lấy tất cả role CLB (từ Roles)
     ==================================== */
    public List<String> getClubRoles() throws SQLException {
        List<String> list = new ArrayList<>();

        String sql = "SELECT RoleName FROM Roles ORDER BY RoleID";

        PreparedStatement ps = connection.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            list.add(rs.getNString("RoleName"));
        }
        return list;
    }

    /* ================================
       6. Lấy chi tiết 1 member
     ================================ */
    public ClubMember getMemberDetail(int membershipId) throws SQLException {

        String sql =
                "SELECT m.MembershipID, m.UserID, m.ClubID, m.RoleInClub, m.Status AS MembershipStatus, " +
                "u.FullName, u.Email, u.RoleID, u.Status AS UserStatus " +
                "FROM Memberships m JOIN Users u ON m.UserID = u.UserID " +
                "WHERE m.MembershipID = ?";

        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, membershipId);

        ResultSet rs = ps.executeQuery();

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

        return null;
    }

    /* ================================
       7. Update Role (Transaction)
     ================================ */
    public void updateRole(
            int membershipId,
            String newClubRole,
            String newMembershipStatus,
            Integer newSystemRole,
            String newUserStatus)
            throws SQLException {

        String queryGetUser =
                "SELECT UserID FROM Memberships WHERE MembershipID = ?";

        String updateMembership =
                "UPDATE Memberships SET RoleInClub = ?, Status = ? WHERE MembershipID = ?";

        String updateUser =
                "UPDATE Users SET RoleID = ?, Status = ? WHERE UserID = ?";

        connection.setAutoCommit(false);

        try {
            // Get UserID
            int userId = -1;
            PreparedStatement p1 = connection.prepareStatement(queryGetUser);
            p1.setInt(1, membershipId);
            ResultSet rs = p1.executeQuery();

            if (rs.next()) userId = rs.getInt("UserID");

            // Update Membership
            PreparedStatement p2 = connection.prepareStatement(updateMembership);
            p2.setString(1, newClubRole);
            p2.setString(2, newMembershipStatus);
            p2.setInt(3, membershipId);
            p2.executeUpdate();

            // Update User if Admin changed role
            if (newSystemRole != null) {
                PreparedStatement p3 = connection.prepareStatement(updateUser);
                p3.setInt(1, newSystemRole);
                p3.setString(2, newUserStatus);
                p3.setInt(3, userId);
                p3.executeUpdate();
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
