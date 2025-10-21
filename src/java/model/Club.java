package model;

import java.sql.Timestamp;

/**
 * Club model class representing the Clubs table in the database
 * Database structure: ClubID, ClubName, Description, Logo, ClubTypes, CreatedBy, CreatedAt, Status
 */
public class Club {

    private int clubId;
    private String clubName;
    private String description;
    private String logo;
    private String clubTypes;
    private int createdBy; // Foreign key to Users.UserID
    private Timestamp createdAt;
    private String status;

    public Club() {
    }

    // Constructor đầy đủ
    public Club(int clubId, String clubName, String description, String logo, 
                String clubTypes, int createdBy, Timestamp createdAt, String status) {
        this.clubId = clubId;
        this.clubName = clubName;
        this.description = description;
        this.logo = logo;
        this.clubTypes = clubTypes;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
        this.status = status;
    }

    // Constructor không có ID (cho insert)
    public Club(String clubName, String description, String logo, 
                String clubTypes, int createdBy, String status) {
        this.clubName = clubName;
        this.description = description;
        this.logo = logo;
        this.clubTypes = clubTypes;
        this.createdBy = createdBy;
        this.createdAt = new Timestamp(System.currentTimeMillis());
        this.status = status;
    }

    // Getters & Setters
    public int getClubId() {
        return clubId;
    }

    public void setClubId(int clubId) {
        this.clubId = clubId;
    }

    public String getClubName() {
        return clubName;
    }

    public void setClubName(String clubName) {
        this.clubName = clubName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public String getClubTypes() {
        return clubTypes;
    }

    public void setClubTypes(String clubTypes) {
        this.clubTypes = clubTypes;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    
    // Utility methods
    
    /**
     * Check if the club is active
     * @return true if status is "Active", false otherwise
     */
    public boolean isActive() {
        return "Active".equalsIgnoreCase(this.status);
    }
    
    /**
     * Check if the club is inactive
     * @return true if status is "Inactive", false otherwise
     */
    public boolean isInactive() {
        return "Inactive".equalsIgnoreCase(this.status);
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
                return "text-danger";
            default:
                return "text-secondary";
        }
    }
    
    /**
     * Get default logo URL if logo is null or empty
     * @return logo URL or default placeholder
     */
    public String getLogoOrDefault() {
        if (this.logo == null || this.logo.trim().isEmpty()) {
            return "assets/images/clubs/default-club-logo.png";
        }
        return this.logo;
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
    
    @Override
    public String toString() {
        return "Club{" +
                "clubId=" + clubId +
                ", clubName='" + clubName + '\'' +
                ", description='" + description + '\'' +
                ", logo='" + logo + '\'' +
                ", clubTypes='" + clubTypes + '\'' +
                ", createdBy=" + createdBy +
                ", createdAt=" + createdAt +
                ", status='" + status + '\'' +
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
