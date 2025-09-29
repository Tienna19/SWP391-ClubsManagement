package model;

import java.sql.Timestamp;

public class Club {

    private int clubId;
    private String name;
    private String description;
    private String logoUrl;
    private int categoryId;
    private int createdByUserId;
    private String status;
    private Timestamp createdAt;
    private Integer approvedByUserId; // có thể null

    public Club() {
    }

    public Club(int clubId, String name, String description, String logoUrl, int categoryId,
            int createdByUserId, String status, Timestamp createdAt, Integer approvedByUserId) {
        this.clubId = clubId;
        this.name = name;
        this.description = description;
        this.logoUrl = logoUrl;
        this.categoryId = categoryId;
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
}
