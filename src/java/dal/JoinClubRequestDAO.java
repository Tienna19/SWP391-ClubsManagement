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
        String sql = "SELECT r.RequestID, r.UserID, r.ClubID, u.FullName, u.Email, u.ProfileImage, c.ClubName, r.Reason, r.Status, r.CreatedAt " +
                     "FROM JoinClubRequests r " +
                     "JOIN Users u ON r.UserID = u.UserID " +
                     "JOIN Clubs c ON r.ClubID = c.ClubID";
        try (PreparedStatement stm = connection.prepareStatement(sql);
             ResultSet rs = stm.executeQuery()) {

            while (rs.next()) {
                JoinClubRequest req = new JoinClubRequest();
                req.setRequestId(rs.getInt("RequestID"));
                req.setUserId(rs.getInt("UserID"));
                req.setClubId(rs.getInt("ClubID"));
                req.setStudentName(rs.getString("FullName"));
                req.setStudentEmail(rs.getString("Email"));
                req.setProfileImage(rs.getString("ProfileImage"));
                req.setClubName(rs.getString("ClubName"));
                req.setReason(rs.getString("Reason"));
                req.setStatus(rs.getString("Status"));
                Timestamp createdAt = rs.getTimestamp("CreatedAt");
                if (createdAt != null) {
                    req.setCreatedAt(createdAt.toLocalDateTime());
                    req.setRequestDate(createdAt.toLocalDateTime().toLocalDate());
                }
                list.add(req);
            }
        } catch (SQLException e) {
            System.out.println("getAllRequests: " + e.getMessage());
        }
        return list;
    }

    // Lấy danh sách request theo CLB (lọc theo trạng thái nếu cần)
    public List<JoinClubRequest> getRequestsByClub(int clubId, String statusFilter) {
        List<JoinClubRequest> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT r.RequestID, r.UserID, r.ClubID, r.Reason, r.Status, r.CreatedAt, " +
            "u.FullName, u.Email, u.ProfileImage " +
            "FROM JoinClubRequests r " +
            "JOIN Users u ON r.UserID = u.UserID " +
            "WHERE r.ClubID = ?"
        );

        boolean hasStatusFilter = statusFilter != null && !statusFilter.isEmpty() && !"all".equalsIgnoreCase(statusFilter);
        if (hasStatusFilter) {
            sql.append(" AND r.Status = ?");
        }
        sql.append(" ORDER BY r.CreatedAt DESC");

        try (PreparedStatement stm = connection.prepareStatement(sql.toString())) {
            stm.setInt(1, clubId);
            if (hasStatusFilter) {
                stm.setString(2, statusFilter);
            }

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    JoinClubRequest req = new JoinClubRequest();
                    req.setRequestId(rs.getInt("RequestID"));
                    req.setUserId(rs.getInt("UserID"));
                    req.setClubId(rs.getInt("ClubID"));
                    req.setReason(rs.getString("Reason"));
                    req.setStatus(rs.getString("Status"));
                    req.setStudentName(rs.getString("FullName"));
                    req.setStudentEmail(rs.getString("Email"));
                    req.setProfileImage(rs.getString("ProfileImage"));

                    Timestamp createdAt = rs.getTimestamp("CreatedAt");
                    if (createdAt != null) {
                        req.setCreatedAt(createdAt.toLocalDateTime());
                        req.setRequestDate(createdAt.toLocalDateTime().toLocalDate());
                    }

                    list.add(req);
                }
            }
        } catch (SQLException e) {
            System.out.println("getRequestsByClub: " + e.getMessage());
        }

        return list;
    }

    // Lấy một request cụ thể của CLB
    public JoinClubRequest getRequestById(int requestId) {
        String sql = "SELECT RequestID, UserID, ClubID, Reason, Status, CreatedAt FROM JoinClubRequests WHERE RequestID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, requestId);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    JoinClubRequest req = new JoinClubRequest();
                    req.setRequestId(rs.getInt("RequestID"));
                    req.setUserId(rs.getInt("UserID"));
                    req.setClubId(rs.getInt("ClubID"));
                    req.setReason(rs.getString("Reason"));
                    req.setStatus(rs.getString("Status"));
                    Timestamp createdAt = rs.getTimestamp("CreatedAt");
                    if (createdAt != null) {
                        req.setCreatedAt(createdAt.toLocalDateTime());
                        req.setRequestDate(createdAt.toLocalDateTime().toLocalDate());
                    }
                    return req;
                }
            }
        } catch (SQLException e) {
            System.out.println("getRequestById: " + e.getMessage());
        }
        return null;
    }

    // Cập nhật trạng thái request
    public boolean updateRequestStatus(int requestId, String status) {
        String sql = "UPDATE JoinClubRequests SET Status = ? WHERE RequestID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, status);
            stm.setInt(2, requestId);
            return stm.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("updateRequestStatus: " + e.getMessage());
            return false;
        }
    }
}
