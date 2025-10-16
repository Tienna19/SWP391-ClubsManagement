package model;

import java.sql.Timestamp;

public class Club {

    private int clubId;
    private String name;
    private String description;
    private String logoUrl;
    private int categoryId;
    private String categoryName; // Tên category
    private int createdByUserId;
    private String status;
    private Timestamp createdAt;
    private Integer approvedByUserId; // có thể null

    public Club() {
    }

    // Constructor cũ (backward compatibility)
    public Club(int clubId, String name, String description, String logoUrl, int categoryId,
            int createdByUserId, String status, Timestamp createdAt, Integer approvedByUserId) {
        this.clubId = clubId;
        this.name = name;
        this.description = description;
        this.logoUrl = logoUrl;
        this.categoryId = categoryId;
        this.categoryName = null; // Sẽ được set sau
        this.createdByUserId = createdByUserId;
        this.status = status;
        this.createdAt = createdAt;
        this.approvedByUserId = approvedByUserId;
    }
    
    // Constructor mới với categoryName
    public Club(int clubId, String name, String description, String logoUrl, int categoryId,
            String categoryName, int createdByUserId, String status, Timestamp createdAt, Integer approvedByUserId) {
        this.clubId = clubId;
        this.name = name;
        this.description = description;
        this.logoUrl = logoUrl;
        this.categoryId = categoryId;
        this.categoryName = categoryName;
        this.createdByUserId = createdByUserId;
        this.status = status;
        this.createdAt = createdAt;
        this.approvedByUserId = approvedByUserId;
    }

    // Getters & Setters
    public int getClubId() {
        return clubId;
    }

    public void setClubId(int clubId) {
        this.clubId = clubId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLogoUrl() {
        return logoUrl;
    }

    public void setLogoUrl(String logoUrl) {
        this.logoUrl = logoUrl;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public int getCreatedByUserId() {
        return createdByUserId;
    }

    public void setCreatedByUserId(int createdByUserId) {
        this.createdByUserId = createdByUserId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getApprovedByUserId() {
        return approvedByUserId;
    }

    public void setApprovedByUserId(Integer approvedByUserId) {
        this.approvedByUserId = approvedByUserId;
    }
    
    // Utility methods
    
    /**
     * Check if the club is approved
     * @return true if status is "Approved", false otherwise
     */
    public boolean isApproved() {
        return "Approved".equalsIgnoreCase(this.status);
    }
    
    /**
     * Check if the club is pending approval
     * @return true if status is "Pending", false otherwise
     */
    public boolean isPending() {
        return "Pending".equalsIgnoreCase(this.status);
    }
    
    /**
     * Check if the club is active (approved and not suspended)
     * @return true if club is active, false otherwise
     */
    public boolean isActive() {
        return "Approved".equalsIgnoreCase(this.status) || "Active".equalsIgnoreCase(this.status);
    }
    
    /**
     * Get display status with proper formatting
     * @return formatted status string
     */
    public String getDisplayStatus() {
        if (this.status == null) return "Unknown";
        
        switch (this.status.toLowerCase()) {
            case "approved":
            case "active":
                return "Active";
            case "pending":
                return "Pending Approval";
            case "rejected":
                return "Rejected";
            case "suspended":
                return "Suspended";
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
            case "approved":
            case "active":
                return "text-success";
            case "pending":
                return "text-warning";
            case "rejected":
            case "suspended":
                return "text-danger";
            default:
                return "text-secondary";
        }
    }
    
    /**
     * Safe getter for display status (null-safe)
     * @return formatted status string or "Unknown"
     */
    public String getSafeDisplayStatus() {
        try {
            return getDisplayStatus();
        } catch (Exception e) {
            return "Unknown";
        }
    }
    
    /**
     * Safe getter for status CSS class (null-safe)
     * @return CSS class name or "text-secondary"
     */
    public String getSafeStatusCssClass() {
        try {
            return getStatusCssClass();
        } catch (Exception e) {
            return "text-secondary";
        }
    }
    
    /**
     * Get default logo URL if logoUrl is null or empty
     * @return logo URL or default placeholder
     */
    public String getLogoUrlOrDefault() {
        if (this.logoUrl == null || this.logoUrl.trim().isEmpty()) {
            return "assets/images/clubs/default-club-logo.png";
        }
        return this.logoUrl;
    }
    
    /**
     * Get formatted creation date
     * @return formatted date string
     */
    public String getFormattedCreatedAt() {
        if (this.createdAt == null) return "Unknown";
        
        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy");
            return sdf.format(this.createdAt);
        } catch (Exception e) {
            return "Unknown";
        }
    }
    
    /**
     * Get short description (truncated if too long)
     * @param maxLength maximum length of description
     * @return truncated description
     */
    public String getShortDescription(int maxLength) {
        if (this.description == null || this.description.trim().isEmpty()) return "";
        
        try {
            if (this.description.length() <= maxLength) {
                return this.description;
            }
            
            return this.description.substring(0, maxLength - 3) + "...";
        } catch (Exception e) {
            return this.description != null ? this.description : "";
        }
    }
    
    /**
     * Get short description with default length of 100 characters
     * @return truncated description
     */
    public String getShortDescription() {
        return getShortDescription(100);
    }
    
    /**
     * Safe getter for short description (null-safe)
     * @param maxLength maximum length
     * @return truncated description or empty string
     */
    public String getSafeShortDescription(int maxLength) {
        try {
            return getShortDescription(maxLength);
        } catch (Exception e) {
            return "";
        }
    }
    
    /**
     * Safe getter for formatted date (null-safe)
     * @return formatted date or "Unknown"
     */
    public String getSafeFormattedCreatedAt() {
        try {
            return getFormattedCreatedAt();
        } catch (Exception e) {
            return "Unknown";
        }
    }
    
    @Override
    public String toString() {
        return "Club{" +
                "clubId=" + clubId +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", logoUrl='" + logoUrl + '\'' +
                ", categoryId=" + categoryId +
                ", createdByUserId=" + createdByUserId +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", approvedByUserId=" + approvedByUserId +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        Club club = (Club) obj;
        return clubId == club.clubId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(clubId);
    }
}
