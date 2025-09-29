package dal;

import model.Membership;
import java.sql.*;

public class MembershipDAO extends DBContext {

    public Membership findById(int membershipId) throws SQLException {
        String sql = "SELECT * FROM Memberships WHERE MembershipID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, membershipId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return new Membership(
                    rs.getInt("MembershipID"),
                    rs.getInt("ClubID"),
                    rs.getInt("UserID"),
                    rs.getString("Role"),
                    rs.getString("Status")
                );
            }
            return null;
        }
    }

    public boolean updateRole(int membershipId, String newRole) throws SQLException {
        String sql = "UPDATE Memberships SET Role = ? WHERE MembershipID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, newRole);
            stmt.setInt(2, membershipId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        }
    }
}
