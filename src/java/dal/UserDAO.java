package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO extends DBContext {

    // ĐĂNG NHẬP (LOGIN)
    public User login(String email, String passwordHash) {
        User user = getUserByEmail(email); 
        if (user != null && BCrypt.checkpw(passwordHash, user.getPasswordHash())) {
            return user; 
        }
        return null; 
    }

    // LẤY USER THEO EMAIL
    public User getUserByEmail(String email) {
        try {
            String sql = "SELECT * FROM Users WHERE Email = ?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("UserID"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("PasswordHash"),
                        rs.getString("PhoneNumber"),
                        rs.getString("Address"),
                        rs.getString("Gender"),
                        rs.getInt("RoleID"),
                        rs.getString("ProfileImage"),
                        rs.getTimestamp("CreatedAt")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // KIỂM TRA EMAIL ĐÃ TỒN TẠI
    public boolean checkUserExist(String email) {
        return getUserByEmail(email) != null;
    }

    // ĐĂNG KÝ NGƯỜI DÙNG MỚI
    public boolean register(User user) {
        try {
            String sql = """
                INSERT INTO Users 
                (FullName, Email, PasswordHash, PhoneNumber, Address, Gender, RoleID, ProfileImage, CreatedAt)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
            PreparedStatement st = connection.prepareStatement(sql);

            st.setString(1, user.getFullName());
            st.setString(2, user.getEmail());

            String passwordHash = user.getPasswordHash();
            if (!passwordHash.startsWith("$2a$")) { // tránh hash lại mật khẩu đã mã hóa
                passwordHash = BCrypt.hashpw(passwordHash, BCrypt.gensalt());
            }
            st.setString(3, passwordHash);

            st.setString(4, user.getPhoneNumber());
            st.setString(5, user.getAddress());
            st.setString(6, user.getGender());
            st.setInt(7, user.getRoleId());
            st.setString(8, user.getProfileImage());
            st.setTimestamp(9, new Timestamp(System.currentTimeMillis()));

            return st.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // LẤY USER THEO ID
    public User getUserById(int userId) {
        try {
            String sql = "SELECT * FROM Users WHERE UserID = ?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("UserID"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("PasswordHash"),
                        rs.getString("PhoneNumber"),
                        rs.getString("Address"),
                        rs.getString("Gender"),
                        rs.getInt("RoleID"),
                        rs.getString("ProfileImage"),
                        rs.getTimestamp("CreatedAt")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
