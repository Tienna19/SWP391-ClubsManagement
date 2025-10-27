package model;

import java.sql.Timestamp;

/**
 * Model for CreateClubRequests table
 * Represents a club creation request that needs admin approval
 */
public class CreateClubRequest {
    private int requestId;
    private String clubName;
    private String description;
    private String logo;
    private String clubTypes;
    private int requestedBy;       // UserID who requested
    private Timestamp requestedAt;
    private String status;         // Pending, Approved, Rejected
    private Integer reviewedBy;    // Admin UserID who reviewed (nullable)
    private Timestamp reviewedAt;  // When reviewed (nullable)
    private String reviewComment;  // Admin's comment (nullable)
    private Integer createdClubId; // ClubID after approval (nullable)
    
    // Additional fields for display (JOIN with Users)
    private String requestedByName;  // FullName of requester
    private String reviewedByName;   // FullName of reviewer

    // Constructors
    public CreateClubRequest() {
    }

    /**
     * Constructor for new request (before approval)
     */
    public CreateClubRequest(String clubName, String description, String logo, 
                           String clubTypes, int requestedBy) {
        this.clubName = clubName;
        this.description = description;
        this.logo = logo;
        this.clubTypes = clubTypes;
        this.requestedBy = requestedBy;
        this.status = "Pending";
        this.requestedAt = new Timestamp(System.currentTimeMillis());
    }

    /**
     * Full constructor
     */
    public CreateClubRequest(int requestId, String clubName, String description, 
                           String logo, String clubTypes, int requestedBy, 
                           Timestamp requestedAt, String status, Integer reviewedBy, 
                           Timestamp reviewedAt, String reviewComment, Integer createdClubId) {
        this.requestId = requestId;
        this.clubName = clubName;
        this.description = description;
        this.logo = logo;
        this.clubTypes = clubTypes;
        this.requestedBy = requestedBy;
        this.requestedAt = requestedAt;
        this.status = status;
        this.reviewedBy = reviewedBy;
        this.reviewedAt = reviewedAt;
        this.reviewComment = reviewComment;
        this.createdClubId = createdClubId;
    }

    // Getters and Setters
    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
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

    public int getRequestedBy() {
        return requestedBy;
    }

    public void setRequestedBy(int requestedBy) {
        this.requestedBy = requestedBy;
    }

    public Timestamp getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(Timestamp requestedAt) {
        this.requestedAt = requestedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getReviewedBy() {
        return reviewedBy;
    }

    public void setReviewedBy(Integer reviewedBy) {
        this.reviewedBy = reviewedBy;
    }

    public Timestamp getReviewedAt() {
        return reviewedAt;
    }

    public void setReviewedAt(Timestamp reviewedAt) {
        this.reviewedAt = reviewedAt;
    }

    public String getReviewComment() {
        return reviewComment;
    }

    public void setReviewComment(String reviewComment) {
        this.reviewComment = reviewComment;
    }

    public Integer getCreatedClubId() {
        return createdClubId;
    }

    public void setCreatedClubId(Integer createdClubId) {
        this.createdClubId = createdClubId;
    }

    public String getRequestedByName() {
        return requestedByName;
    }

    public void setRequestedByName(String requestedByName) {
        this.requestedByName = requestedByName;
    }

    public String getReviewedByName() {
        return reviewedByName;
    }

    public void setReviewedByName(String reviewedByName) {
        this.reviewedByName = reviewedByName;
    }

    // Utility Methods
    
    /**
     * Check if request is pending
     */
    public boolean isPending() {
        return "Pending".equalsIgnoreCase(this.status);
    }

    /**
     * Check if request is approved
     */
    public boolean isApproved() {
        return "Approved".equalsIgnoreCase(this.status);
    }

    /**
     * Check if request is rejected
     */
    public boolean isRejected() {
        return "Rejected".equalsIgnoreCase(this.status);
    }

    /**
     * Get status CSS class for badge styling
     */
    public String getStatusCssClass() {
        if (status == null) return "badge-secondary";
        
        switch (status.toLowerCase()) {
            case "pending":
                return "badge-warning";
            case "approved":
                return "badge-success";
            case "rejected":
                return "badge-danger";
            default:
                return "badge-secondary";
        }
    }

    /**
     * Get status icon
     */
    public String getStatusIcon() {
        if (status == null) return "fa-question-circle";
        
        switch (status.toLowerCase()) {
            case "pending":
                return "fa-clock-o";
            case "approved":
                return "fa-check-circle";
            case "rejected":
                return "fa-times-circle";
            default:
                return "fa-question-circle";
        }
    }

    /**
     * Get formatted requested date
     */
    public String getFormattedRequestedAt() {
        if (requestedAt == null) return "N/A";
        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
            return sdf.format(requestedAt);
        } catch (Exception e) {
            return requestedAt.toString();
        }
    }

    /**
     * Get formatted reviewed date
     */
    public String getFormattedReviewedAt() {
        if (reviewedAt == null) return "N/A";
        try {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
            return sdf.format(reviewedAt);
        } catch (Exception e) {
            return reviewedAt.toString();
        }
    }

    @Override
    public String toString() {
        return "CreateClubRequest{" +
                "requestId=" + requestId +
                ", clubName='" + clubName + '\'' +
                ", clubTypes='" + clubTypes + '\'' +
                ", requestedBy=" + requestedBy +
                ", status='" + status + '\'' +
                ", requestedAt=" + requestedAt +
                '}';
    }
}

