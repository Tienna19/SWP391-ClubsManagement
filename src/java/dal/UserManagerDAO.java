package dal;

import model.UserManager;
import java.sql.*;
import java.util.*;

public class UserManagerDAO extends DBContext {

    // Lấy toàn bộ danh sách người dùng
    public List<UserManager> getAllUsers() throws SQLException {
        List<UserManager> list = new ArrayList<>();
        String sql = "SELECT u.*, r.RoleName FROM Users u "
                   + "JOIN Roles r ON u.RoleID = r.RoleID ORDER BY u.UserID DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                UserManager u = new UserManager();
                u.setUserID(rs.getInt("UserID"));
                u.setFullName(rs.getNString("FullName"));
                u.setEmail(rs.getString("Email"));
                u.setPhoneNumber(rs.getString("PhoneNumber"));
                u.setAddress(rs.getNString("Address"));
                u.setGender(rs.getNString("Gender"));
                u.setRoleID(rs.getInt("RoleID"));
                u.setProfileImage(rs.getString("ProfileImage"));
                u.setStatus("Active"); // giả định, vì DB chưa có cột Status
                u.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(u);
            }
        }
        return list;
    }

    // Tìm kiếm theo từ khóa
    public List<UserManager> searchUsers(String keyword) throws SQLException {
        List<UserManager> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE FullName LIKE ? OR Email LIKE ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserManager u = new UserManager();
                u.setUserID(rs.getInt("UserID"));
                u.setFullName(rs.getNString("FullName"));
                u.setEmail(rs.getString("Email"));
                u.setPhoneNumber(rs.getString("PhoneNumber"));
                u.setAddress(rs.getNString("Address"));
                u.setGender(rs.getNString("Gender"));
                u.setRoleID(rs.getInt("RoleID"));
                u.setProfileImage(rs.getString("ProfileImage"));
                u.setStatus("Active");
                u.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(u);
            }
        }
        return list;
    }
    
    // Lấy 1 user theo ID
    public UserManager findById(int userId) throws SQLException {
        String sql = "SELECT * FROM Users WHERE UserID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
        }
        return null;
    }

    // Thêm user mới
    public boolean addUser(UserManager u) throws SQLException {
        String sql = "INSERT INTO Users (FullName, Email, PasswordHash, PhoneNumber, Address, Gender, RoleID, ProfileImage) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, u.getFullName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPasswordHash() != null ? u.getPasswordHash() : "123456"); // default password
            ps.setString(4, u.getPhoneNumber());
            ps.setNString(5, u.getAddress());
            ps.setNString(6, u.getGender());
            ps.setInt(7, u.getRoleID());
            ps.setString(8, u.getProfileImage());
            return ps.executeUpdate() > 0;
        }
    }

    // Cập nhật thông tin người dùng
    public boolean updateUser(UserManager user) throws SQLException {
        String sql = "UPDATE Users SET FullName=?, Email=?, PhoneNumber=?, Address=?, "
                   + "Gender=?, RoleID=? WHERE UserID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhoneNumber());
            ps.setNString(4, user.getAddress());
            ps.setNString(5, user.getGender());
            ps.setInt(6, user.getRoleID());
            ps.setInt(7, user.getUserID());
            return ps.executeUpdate() > 0;
        }
    }

//    // Xóa tạm thời (Deactivate)
//    public boolean deactivateUser(int userId) throws SQLException {
//        String sql = "UPDATE Users SET RoleID = 0 WHERE UserID = ?"; // hoặc gán cờ Status nếu có
//        try (PreparedStatement ps = connection.prepareStatement(sql)) {
//            ps.setInt(1, userId);
//            return ps.executeUpdate() > 0;
//        }
//    }
    
    // Deactive tài khoản bằng cách gắn tiền tố vào email
        public boolean deactivateUser(int userId) throws SQLException {
            String sql = "UPDATE Users SET Email = '[DEACTIVATED]_' + Email WHERE UserID = ? AND Email NOT LIKE '[DEACTIVATED]%'";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, userId);
        return ps.executeUpdate() > 0;
    }
}

    
    // Helper method
    private UserManager extractUser(ResultSet rs) throws SQLException {
        UserManager u = new UserManager();
        u.setUserID(rs.getInt("UserID"));
        u.setFullName(rs.getNString("FullName"));
        u.setEmail(rs.getString("Email"));
        u.setPhoneNumber(rs.getString("PhoneNumber"));
        u.setAddress(rs.getNString("Address"));
        u.setGender(rs.getNString("Gender"));
        u.setRoleID(rs.getInt("RoleID"));
        u.setProfileImage(rs.getString("ProfileImage"));
        u.setCreatedAt(rs.getTimestamp("CreatedAt"));
        u.setStatus("Active");
        return u;
    }
    
    // Lấy danh sách user theo trang
    public List<UserManager> getUsersByPage(int start, int total) {
    List<UserManager> list = new ArrayList<>();
    String sql = "SELECT * FROM Users ORDER BY UserID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, start);
        ps.setInt(2, total);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            UserManager u = new UserManager();
            u.setUserID(rs.getInt("UserID"));
            u.setFullName(rs.getString("FullName"));
            u.setEmail(rs.getString("Email"));
            u.setPhoneNumber(rs.getString("PhoneNumber"));
            u.setAddress(rs.getString("Address"));
            u.setGender(rs.getString("Gender"));
            u.setRoleID(rs.getInt("RoleID"));
            u.setProfileImage(rs.getString("ProfileImage"));
            list.add(u);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

    // Đếm tổng số bản ghi
    public int getTotalUsers() {
    String sql = "SELECT COUNT(*) FROM Users";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}

}
