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
                u.setStatus(rs.getString("status"));
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
                u.setStatus(rs.getString("status"));
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
    String sql = "INSERT INTO Users "
            + "(FullName, Email, PasswordHash, PhoneNumber, Address, Gender, RoleID, ProfileImage, Status) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'Active')";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {

        ps.setNString(1, u.getFullName());
        ps.setString(2, u.getEmail());

        // ---- PASSWORD ----
        // Nếu servlet đã hash => dùng luôn.
        ps.setString(3, u.getPasswordHash());

        ps.setString(4, u.getPhoneNumber());
        ps.setNString(5, u.getAddress());
        ps.setNString(6, u.getGender());
        ps.setInt(7, u.getRoleID());

        // ---- AVATAR ----
        if (u.getProfileImage() != null && !u.getProfileImage().isBlank()) {
            ps.setString(8, u.getProfileImage());     // ảnh upload
        } else {
            ps.setString(8, "assets/images/default-avatar.png");  // ảnh mặc định
        }

        return ps.executeUpdate() > 0;
    }
}


    // Cập nhật thông tin người dùng
    public boolean updateUser(UserManager u) throws SQLException {
    StringBuilder sql = new StringBuilder("UPDATE Users SET fullName=?, email=?, phoneNumber=?, address=?, gender=?, roleID=?");

    if (u.getPasswordHash() != null) {
        sql.append(", passwordHash=?");
    }
    if (u.getProfileImage() != null) {
        sql.append(", profileImage=?");
    }
    sql.append(" WHERE userID=?");

    try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
        int idx = 1;
        ps.setString(idx++, u.getFullName());
        ps.setString(idx++, u.getEmail());
        ps.setString(idx++, u.getPhoneNumber());
        ps.setString(idx++, u.getAddress());
        ps.setString(idx++, u.getGender());
        ps.setInt(idx++, u.getRoleID());

        if (u.getPasswordHash() != null) {
            ps.setString(idx++, u.getPasswordHash());
        }
        if (u.getProfileImage() != null) {
            ps.setString(idx++, u.getProfileImage());
        }

        ps.setInt(idx, u.getUserID());
        return ps.executeUpdate() > 0;
    }
}

    
    public boolean deactivateUser(int userId) throws SQLException {
    String sql = "UPDATE Users SET status = 'Inactive' WHERE userID = ?";
    PreparedStatement st = connection.prepareStatement(sql);
    st.setInt(1, userId);
    return st.executeUpdate() > 0;
    }
    
    public boolean activateUser(int userId) throws SQLException {
    String sql = "UPDATE Users SET status = 'Active' WHERE userID = ?";
    PreparedStatement st = connection.prepareStatement(sql);
    st.setInt(1, userId);
    return st.executeUpdate() > 0;
    }


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
    u.setStatus(rs.getString("status"));
    // ĐỌC TỪ CỘT Status MỚI THÊM
    try {
        u.setStatus(rs.getString("Status"));
    } catch (SQLException e) {
        u.setStatus("Active"); // fallback nếu DB chưa có cột
    }
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
            u.setStatus(rs.getString("status"));
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
