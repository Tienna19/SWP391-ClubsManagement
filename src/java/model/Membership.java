package model;

import java.util.Date;

public class Membership {
    private int MembershipID;
    private int ClubID;
    private String ClubName;   // Tên câu lạc bộ
    private int UserID;
    private String fullName;    // Tên thành viên
    private String role;        // Vai trò thành viên
    private String status;      // Trạng thái thành viên
    private Date requestedAt;   // Ngày yêu cầu gia nhập câu lạc bộ

    // Constructor
    public Membership(int MembershipID, int ClubID, String ClubName, int UserID, String fullName, String role, String status, Date requestedAt) {
        this.MembershipID = MembershipID;
        this.ClubID = ClubID;
        this.ClubName = ClubName;
        this.UserID = UserID;
        this.fullName = fullName;
        this.role = role;
        this.status = status;
        this.requestedAt = requestedAt;
    }

    // Getters và Setters
    public int getMembershipID() {
        return MembershipID;
    }

    public void setMembershipID(int membershipID) {
        MembershipID = membershipID;
    }

    public int getClubID() {
        return ClubID;
    }

    public void setClubID(int clubID) {
        ClubID = clubID;
    }

    public String getClubName() {
        return ClubName;
    }

    public void setClubName(String clubName) {
        ClubName = clubName;
    }

    public int getUserID() {
        return UserID;
    }

    public void setUserID(int userID) {
        UserID = userID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(Date requestedAt) {
        this.requestedAt = requestedAt;
    }

    @Override
    public String toString() {
        return "Membership{" +
                "MembershipID=" + MembershipID +
                ", ClubID=" + ClubID +
                ", ClubName='" + ClubName + '\'' +
                ", UserID=" + UserID +
                ", fullName='" + fullName + '\'' +
                ", role='" + role + '\'' +
                ", status='" + status + '\'' +
                ", requestedAt=" + requestedAt +
                '}';
    }
}
