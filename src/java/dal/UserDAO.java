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
            String sql = "INSERT INTO Users " +
                         "(FullName, Email, PasswordHash, PhoneNumber, Address, Gender, RoleID, ProfileImage, CreatedAt) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
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

    // LẤY THÔNG TIN CƠ BẢN CỦA USER THEO ID (dành cho Profile)
    public User getBasicUserInfoById(int userId) {
        try {
            String sql = "SELECT UserID, FullName, Email, PhoneNumber, Address, Gender, CreatedAt "
                    + "FROM Users WHERE UserID = ?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("UserID"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setPhoneNumber(rs.getString("PhoneNumber"));
                user.setAddress(rs.getString("Address"));
                user.setGender(rs.getString("Gender"));
                user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

// CẬP NHẬT MẬT KHẨU
    public boolean updatePassword(int userId, String hashedPassword) {
        try {
            String sql = "UPDATE Users SET PasswordHash = ? WHERE UserID = ?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, hashedPassword);
            st.setInt(2, userId);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // CẬP NHẬT THÔNG TIN PROFILE
    public boolean updateProfile(User user) {
        try {
            String sql = "UPDATE Users SET FullName = ?, PhoneNumber = ?, Address = ?, Gender = ?, ProfileImage = ? WHERE UserID = ?";
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user.getFullName());
            st.setString(2, user.getPhoneNumber());
            st.setString(3, user.getAddress());
            st.setString(4, user.getGender());
            st.setString(5, user.getProfileImage());
            st.setInt(6, user.getUserId());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // GET ALL USERS (for dropdown, etc.)
    public java.util.List<User> getAllUsers() {
        java.util.List<User> userList = new java.util.ArrayList<>();
        try {
            String sql = "SELECT UserID, FullName, Email, RoleID FROM Users ORDER BY FullName";
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("UserID"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setRoleId(rs.getInt("RoleID"));
                userList.add(user);
            }
        } catch (Exception e) {
            System.err.println("Error in getAllUsers: " + e.getMessage());
            e.printStackTrace();
        }
        return userList;
    }
    
}
