package dal;

import model.Membership;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MembershipDAO {

    public List<Membership> getClubMembers(int clubId) {
        List<Membership> members = new ArrayList<>();
        String sql = "SELECT m.MembershipID, m.ClubID, c.Name AS ClubName, m.UserID, u.FullName AS MemberName, m.Role, m.Status, m.RequestedAt " +
                     "FROM Memberships m " +
                     "JOIN Clubs c ON m.ClubID = c.ClubID " +
                     "JOIN Users u ON m.UserID = u.UserID " +
                     "WHERE m.ClubID = ?";

        
        DBContext dbContext = new DBContext();  
        try (Connection conn = dbContext.getConnection();  
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
           
            stmt.setInt(1, clubId);  
            ResultSet rs = stmt.executeQuery();  
            
           
            while (rs.next()) {
                Membership membership = new Membership(
                    rs.getInt("MembershipID"),
                    rs.getInt("ClubID"),
                    rs.getString("ClubName"),
                    rs.getInt("UserID"),
                    rs.getString("MemberName"),
                    rs.getString("Role"),
                    rs.getString("Status"),
                    rs.getTimestamp("RequestedAt")
                );
                members.add(membership);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return members;  
    }
}
