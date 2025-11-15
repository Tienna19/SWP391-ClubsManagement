package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Club;
import model.User;
import model.Membership;
import model.Role;

public class AssignRoleDAO extends DBContext {

    // 1. Danh sách CLB mà user được phép quản lý
    public List<Club> getManagedClubs(int userId, boolean isAdmin) throws SQLException {
        List<Club> clubs = new ArrayList<>();

        String sql;
        if (isAdmin) {
            sql = "SELECT c.ClubID, c.ClubName " +
                  "FROM Clubs c WHERE c.Status = 'Active'";
        } else {
            sql = "SELECT DISTINCT c.ClubID, c.ClubName " +
                  "FROM Clubs c " +
                  "JOIN Memberships m ON c.ClubID = m.ClubID " +
                  "WHERE m.UserID = ? AND m.RoleInClub = 'Leader' AND m.Status = 'Active'";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (!isAdmin) {
                ps.setInt(1, userId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Club c = new Club();
                    c.setClubId(rs.getInt("ClubID"));
                    c.setClubName(rs.getNString("ClubName"));
                    clubs.add(c);
                }
            }
        }
        return clubs;
    }

    // 2. Danh sách members trong 1 CLB
    public List<Membership> getMembersByClub(int clubId) throws SQLException {
        List<Membership> list = new ArrayList<>();

        String sql = "SELECT m.MembershipID, m.UserID, m.RoleInClub, m.Status, " +
                     "u.FullName, u.Email, u.RoleID, u.Status AS UserStatus " +
                     "FROM Memberships m " +
                     "JOIN Users u ON m.UserID = u.UserID " +
                     "WHERE m.ClubID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, clubId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Membership m = new Membership();
                    m.setMembershipId(rs.getInt("MembershipID"));
                    m.setUserId(rs.getInt("UserID"));
                    m.setClubId(clubId);
                    m.setRoleInClub(rs.getNString("RoleInClub"));
                    m.setStatus(rs.getNString("Status"));

                    User u = new User();
                    u.setUserId(rs.getInt("UserID"));
                    u.setFullName(rs.getNString("FullName"));
                    u.setEmail(rs.getString("Email"));
                    u.setRoleId(rs.getInt("RoleID"));
                    u.setStatus(rs.getString("UserStatus"));

                    m.setUser(u); // nếu bạn có field này trong model, nếu không thì chỉ dùng riêng
                    list.add(m);
                }
            }
        }
        return list;
    }

    // 3. Lấy tất cả system roles (User/Member/ClubLeader/Admin)
    public List<Role> getAllSystemRoles() throws SQLException {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT RoleID, RoleName FROM Roles ORDER BY RoleID";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Role r = new Role();
                r.setRoleID(rs.getInt("RoleID"));
                r.setRoleName(rs.getNString("RoleName"));
                roles.add(r);
            }
        }
        return roles;
    }

    // 4. Lấy chi tiết 1 membership + user
    public Membership getMembershipDetail(int membershipId) throws SQLException {
        String sql = "SELECT m.MembershipID, m.UserID, m.ClubID, m.RoleInClub, m.Status, " +
                     "u.FullName, u.Email, u.RoleID, u.Status AS UserStatus " +
                     "FROM Memberships m " +
                     "JOIN Users u ON m.UserID = u.UserID " +
                     "WHERE m.MembershipID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, membershipId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Membership m = new Membership();
                    m.setMembershipId(rs.getInt("MembershipID"));
                    m.setUserId(rs.getInt("UserID"));
                    m.setClubId(rs.getInt("ClubID"));
                    m.setRoleInClub(rs.getNString("RoleInClub"));
                    m.setStatus(rs.getNString("Status"));

                    User u = new User();
                    u.setUserId(rs.getInt("UserID"));
                    u.setFullName(rs.getNString("FullName"));
                    u.setEmail(rs.getString("Email"));
                    u.setRoleId(rs.getInt("RoleID"));
                    u.setStatus(rs.getString("UserStatus"));

                    m.setUser(u);
                    return m;
                }
            }
        }
        return null;
    }

    // 5. Transaction: cập nhật role trong CLB + role hệ thống
    public void updateRolesTransaction(
            int membershipId,
            String newClubRole,
            String membershipStatus,
            Integer newSystemRoleId,  // null nếu không đổi
            String userStatus,
            String note,              // hiện tại chưa lưu, bạn có thể thêm bảng log
            int updatedByUserId) throws SQLException {

        String sqlUpdateMembership =
                "UPDATE Memberships " +
                "SET RoleInClub = ?, Status = ? " +
                "WHERE MembershipID = ?";

        String sqlGetUserId =
                "SELECT UserID FROM Memberships WHERE MembershipID = ?";

        String sqlUpdateUser =
                "UPDATE Users SET RoleID = ?, Status = ? WHERE UserID = ?";

        try {
            connection.setAutoCommit(false);

            int userId = -1;
            // lấy UserID từ Membership
            try (PreparedStatement psGet = connection.prepareStatement(sqlGetUserId)) {
                psGet.setInt(1, membershipId);
                try (ResultSet rs = psGet.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("UserID");
                    } else {
                        throw new SQLException("Membership not found");
                    }
                }
            }

            // update Memberships
            try (PreparedStatement psMem = connection.prepareStatement(sqlUpdateMembership)) {
                psMem.setString(1, newClubRole);
                psMem.setString(2, membershipStatus);
                psMem.setInt(3, membershipId);
                psMem.executeUpdate();
            }

            // nếu có đổi role/system status
            if (newSystemRoleId != null) {
                try (PreparedStatement psUser = connection.prepareStatement(sqlUpdateUser)) {
                    psUser.setInt(1, newSystemRoleId);
                    psUser.setString(2, userStatus);
                    psUser.setInt(3, userId);
                    psUser.executeUpdate();
                }
            }

            // TODO: insert log AssignRole nếu muốn (RoleAssignmentLog)
            // (ở đây bạn có thêm 1 transaction nữa nếu cần)

            connection.commit();
        } catch (SQLException ex) {
            connection.rollback();
            throw ex;
        } finally {
            connection.setAutoCommit(true);
        }
    }
}
