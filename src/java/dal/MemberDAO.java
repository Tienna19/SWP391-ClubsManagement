package dal;

import model.Member;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO extends DBContext{

    public List<Member> getAllMembers() {
        List<Member> members = new ArrayList<>();
        String query = "SELECT * FROM member WHERE isDeleted = 0";  

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
         
            while (rs.next()) {
                int userID = rs.getInt("userID");
                String memberName = rs.getString("memberName");
                int age = rs.getInt("age");
                int memberID = rs.getInt("memberID");
                String role = rs.getString("role");
                String joinDate = rs.getString("joinDate");
                String status = rs.getString("status");
                boolean isDeleted = rs.getBoolean("isDeleted");

               
                members.add(new Member(userID, memberName, age, memberID, role, joinDate, status, isDeleted));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return members ;  
    }
}
