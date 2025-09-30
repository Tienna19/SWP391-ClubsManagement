package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.User;

public class UserDAO extends DBContext {

    public User login(String email, String password) {
        try {
            String sql = "SELECT * FROM Users WHERE email=? AND password=?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            st.setString(2, password);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new User(
                        rs.getInt("userId"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("role")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
}
