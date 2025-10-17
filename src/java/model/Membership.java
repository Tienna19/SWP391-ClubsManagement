
package model;

import java.sql.Timestamp;

/**
 * Membership model class representing the Memberships table in the database
 * Database structure: MembershipID, UserID, ClubID, RoleInClub, JoinDate, Status
 */
public class Membership {
    private int membershipId;
    private int userId; // Foreign key to Users.UserID
    private int clubId; // Foreign key to Clubs.ClubID
    private String roleInClub; // Default: 'Member'
    private Timestamp joinDate; // Default: GETDATE()
    private String status; // Default: 'Active'

    public Membership() {
    }

    // Constructor đầy đủ
    public Membership(int membershipId, int userId, int clubId, String roleInClub, 
                     Timestamp joinDate, String status) {
        this.membershipId = membershipId;
        this.userId = userId;
        this.clubId = clubId;
        this.roleInClub = roleInClub;
        this.joinDate = joinDate;
        this.status = status;
    }

    // Constructor không có ID (cho insert)
    public Membership(int userId, int clubId, String roleInClub, String status) {
        this.userId = userId;
        this.clubId = clubId;
        this.roleInClub = roleInClub != null ? roleInClub : "Member";
        this.joinDate = new Timestamp(System.currentTimeMillis());
        this.status = status != null ? status : "Active";
    }

    // Constructor đơn giản (chỉ userId và clubId)
    public Membership(int userId, int clubId) {
        this.userId = userId;
        this.clubId = clubId;
        this.roleInClub = "Member";
        this.joinDate = new Timestamp(System.currentTimeMillis());
        this.status = "Active";
    }

    // Getters & Setters
    public int getMembershipId() {
        return membershipId;
    }

    public void setMembershipId(int membershipId) {
        this.membershipId = membershipId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getClubId() {
        return clubId;
    }

    public void setClubId(int clubId) {
        this.clubId = clubId;
    }

    public String getRoleInClub() {
        return roleInClub;
    }

    public void setRoleInClub(String roleInClub) {
        this.roleInClub = roleInClub;
    }

    public Timestamp getJoinDate() {
        return joinDate;
    }

    public void setJoinDate(Timestamp joinDate) {
        this.joinDate = joinDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    // Utility methods
    
    /**
     * Check if the membership is active
     * @return true if status is "Active", false otherwise
     */
    public boolean isActive() {
        return "Active".equalsIgnoreCase(this.status);
    }
    
    /**
     * Check if the membership is inactive
     * @return true if status is "Inactive", false otherwise
     */
    public boolean isInactive() {
        return "Inactive".equalsIgnoreCase(this.status);
    }
    
    /**
     * Check if the user is a member (not admin/leader)
     * @return true if role is "Member", false otherwise
     */
    public boolean isMember() {
        return "Member".equalsIgnoreCase(this.roleInClub);
    }
    
    /**
     * Check if the user is an admin/leader
     * @return true if role is "Admin" or "Leader", false otherwise
     */
    public boolean isAdmin() {
        return "Admin".equalsIgnoreCase(this.roleInClub) || 
               "Leader".equalsIgnoreCase(this.roleInClub) ||
               "President".equalsIgnoreCase(this.roleInClub);
    }
    
    /**
     * Get display status with proper formatting
     * @return formatted status string
     */
    public String getDisplayStatus() {
        if (this.status == null) return "Unknown";
        
        switch (this.status.toLowerCase()) {
            case "active":
                return "Active";
            case "inactive":
                return "Inactive";
            case "suspended":
                return "Suspended";
            case "pending":
                return "Pending";
            default:
                return this.status;
        }
    }
    
    /**
     * Get CSS class for status display
     * @return CSS class name for status styling
     */
    public String getStatusCssClass() {
        if (this.status == null) return "text-secondary";
        
        switch (this.status.toLowerCase()) {
            case "active":
                return "text-success";
            case "inactive":
            case "suspended":
                return "text-danger";
            case "pending":
                return "text-warning";
            default:
                return "text-secondary";
        }
    }
    
    /**
     * Get display role with proper formatting
     * @return formatted role string
     */
    public String getDisplayRole() {
        if (this.roleInClub == null) return "Member";
        
        switch (this.roleInClub.toLowerCase()) {
            case "admin":
                return "Admin";
            case "leader":
                return "Leader";
            case "president":
                return "President";
            case "member":
                return "Member";
            default:
                return this.roleInClub;
        }
    }
    
    /**
     * Get CSS class for role display
     * @return CSS class name for role styling
     */
    public String getRoleCssClass() {
        if (this.roleInClub == null) return "text-secondary";
        
        switch (this.roleInClub.toLowerCase()) {
            case "admin":
            case "president":
                return "text-danger";
            case "leader":
                return "text-warning";
            case "member":
                return "text-info";
            default:
                return "text-secondary";
        }
    }
    
    /**
     * Get formatted join date
     * @return formatted date string
     */
    public String getFormattedJoinDate() {
        if (this.joinDate == null) return "Unknown";
        
        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
            return sdf.format(this.joinDate);
        } catch (Exception e) {
            return "Unknown";
        }
    }
    
    /**
     * Get membership duration in days
     * @return number of days since joining
     */
    public long getMembershipDurationInDays() {
        if (this.joinDate == null) return 0;
        
        long currentTime = System.currentTimeMillis();
        long joinTime = this.joinDate.getTime();
        return (currentTime - joinTime) / (1000 * 60 * 60 * 24);
    }
    
    /**
     * Get membership duration as formatted string
     * @return formatted duration string
     */
    public String getFormattedDuration() {
        long days = getMembershipDurationInDays();
        
        if (days < 1) {
            return "Less than 1 day";
        } else if (days < 30) {
            return days + " day" + (days > 1 ? "s" : "");
        } else if (days < 365) {
            long months = days / 30;
            return months + " month" + (months > 1 ? "s" : "");
        } else {
            long years = days / 365;
            return years + " year" + (years > 1 ? "s" : "");
        }
    }
    
    @Override
    public String toString() {
        return "Membership{" +
                "membershipId=" + membershipId +
                ", userId=" + userId +
                ", clubId=" + clubId +
                ", roleInClub='" + roleInClub + '\'' +
                ", joinDate=" + joinDate +
                ", status='" + status + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Membership membership = (Membership) obj;
        return membershipId == membership.membershipId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(membershipId);
    }
}
