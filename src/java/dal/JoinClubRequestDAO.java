package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.JoinClubRequest;

public class JoinClubRequestDAO extends DBContext {

    // Kiểm tra người dùng đã là thành viên chưa
    public boolean isAlreadyMember(int userId, int clubId) {
        String sql = "SELECT 1 FROM Memberships WHERE UserID = ? AND ClubID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, userId);
            stm.setInt(2, clubId);
            ResultSet rs = stm.executeQuery();
            return rs.next(); // có record nghĩa là đã là thành viên
        } catch (SQLException e) {
            System.out.println("isAlreadyMember: " + e.getMessage());
            return false;
        }
    }

    // Kiểm tra xem đã có request Pending cho club này chưa
    public boolean hasPendingRequest(int userId, int clubId) {
        String sql = "SELECT 1 FROM JoinClubRequests WHERE UserID = ? AND ClubID = ? AND Status = 'Pending'";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, userId);
            stm.setInt(2, clubId);
            ResultSet rs = stm.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            System.out.println("hasPendingRequest: " + e.getMessage());
            return false;
        }
    }

    // Tạo yêu cầu tham gia CLB mới
    public void createJoinRequest(int userId, int clubId, String reason) {
        String sql = "INSERT INTO JoinClubRequests (UserID, ClubID, Reason, Status, CreatedAt) VALUES (?, ?, ?, 'Pending', GETDATE())";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, userId);
            stm.setInt(2, clubId);
            stm.setString(3, reason);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println("createJoinRequest: " + e.getMessage());
        }
    }

    // Lấy danh sách request để hiển thị cho admin
    public List<JoinClubRequest> getAllRequests() {
        List<JoinClubRequest> list = new ArrayList<>();
        String sql = "SELECT r.RequestID, u.FullName, c.ClubName, r.Reason, r.Status, r.CreatedAt " +
                     "FROM JoinClubRequests r " +
                     "JOIN Users u ON r.UserID = u.UserID " +
                     "JOIN Clubs c ON r.ClubID = c.ClubID";
        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                JoinClubRequest req = new JoinClubRequest();
                req.setRequestId(rs.getInt("RequestID"));
                req.setStudentName(rs.getString("FullName"));
                req.setClubName(rs.getString("ClubName"));
                req.setReason(rs.getString("Reason"));
                req.setStatus(rs.getString("Status"));
                req.setRequestDate(rs.getTimestamp("CreatedAt").toLocalDateTime().toLocalDate());
                list.add(req);
            }
        } catch (SQLException e) {
            System.out.println("getAllRequests: " + e.getMessage());
        }
        return list;
    }
}
