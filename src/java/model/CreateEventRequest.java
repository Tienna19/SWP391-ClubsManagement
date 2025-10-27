/*
 * Model class for CreateEventRequests table
 */
package model;

import java.sql.Timestamp;

/**
 * CreateEventRequest model class representing the CreateEventRequests table in the database
 * Database structure: RequestID, ClubID, UserID, EventName, Description, Location, 
 *                     Capacity, StartDate, EndDate, RegistrationStart, RegistrationEnd, 
 *                     Image, Status, CreatedAt, ReviewedBy, ReviewedAt
 */
public class CreateEventRequest {
    private int requestID;
    private int clubID;
    private int userID;
    private String eventName;
    private String description;
    private String location;
    private int capacity;
    private Timestamp startDate;
    private Timestamp endDate;
    private Timestamp registrationStart;
    private Timestamp registrationEnd;
    private String image;
    private String status;
    private Timestamp createdAt;
    private Integer reviewedBy;
    private Timestamp reviewedAt;

    public CreateEventRequest() {
    }

    // Constructor for creating a new request (before insertion)
    public CreateEventRequest(int clubID, int userID, String eventName, String description,
                             String location, int capacity, Timestamp startDate, Timestamp endDate,
                             Timestamp registrationStart, Timestamp registrationEnd, String image) {
        this.clubID = clubID;
        this.userID = userID;
        this.eventName = eventName;
        this.description = description;
        this.location = location;
        this.capacity = capacity;
        this.startDate = startDate;
        this.endDate = endDate;
        this.registrationStart = registrationStart;
        this.registrationEnd = registrationEnd;
        this.image = image;
        this.status = "Pending";
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }

    // Full constructor
    public CreateEventRequest(int requestID, int clubID, int userID, String eventName,
                             String description, String location, int capacity,
                             Timestamp startDate, Timestamp endDate, Timestamp registrationStart,
                             Timestamp registrationEnd, String image, String status,
                             Timestamp createdAt, Integer reviewedBy, Timestamp reviewedAt) {
        this.requestID = requestID;
        this.clubID = clubID;
        this.userID = userID;
        this.eventName = eventName;
        this.description = description;
        this.location = location;
        this.capacity = capacity;
        this.startDate = startDate;
        this.endDate = endDate;
        this.registrationStart = registrationStart;
        this.registrationEnd = registrationEnd;
        this.image = image;
        this.status = status;
        this.createdAt = createdAt;
        this.reviewedBy = reviewedBy;
        this.reviewedAt = reviewedAt;
    }

    // Getters and Setters
    public int getRequestID() {
        return requestID;
    }

    public void setRequestID(int requestID) {
        this.requestID = requestID;
    }

    public int getClubID() {
        return clubID;
    }

    public void setClubID(int clubID) {
        this.clubID = clubID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) {
        this.startDate = startDate;
    }

    public Timestamp getEndDate() {
        return endDate;
    }

    public void setEndDate(Timestamp endDate) {
        this.endDate = endDate;
    }

    public Timestamp getRegistrationStart() {
        return registrationStart;
    }

    public void setRegistrationStart(Timestamp registrationStart) {
        this.registrationStart = registrationStart;
    }

    public Timestamp getRegistrationEnd() {
        return registrationEnd;
    }

    public void setRegistrationEnd(Timestamp registrationEnd) {
        this.registrationEnd = registrationEnd;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
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

    @Override
    public String toString() {
        return "CreateEventRequest{" +
                "requestID=" + requestID +
                ", clubID=" + clubID +
                ", userID=" + userID +
                ", eventName='" + eventName + '\'' +
                ", description='" + description + '\'' +
                ", location='" + location + '\'' +
                ", capacity=" + capacity +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", registrationStart=" + registrationStart +
                ", registrationEnd=" + registrationEnd +
                ", image='" + image + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", reviewedBy=" + reviewedBy +
                ", reviewedAt=" + reviewedAt +
                '}';
    }
}

