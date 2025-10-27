/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 * Event model class representing the Events table in the database
 * @author admin
 */
public class Event {
    private int eventID;
    private int clubID;
    private String eventName;
    private String description;
    private String location;
    private int capacity;
    private Timestamp startDate;
    private Timestamp endDate;
    private Timestamp registrationStart;
    private Timestamp registrationEnd;
    private int createdBy;
    private String status;
    private String image;

    public Event() {
    }

    public Event(int eventID, int clubID, String eventName, String description,
                 String location, int capacity, Timestamp startDate, Timestamp endDate,
                 Timestamp registrationStart, Timestamp registrationEnd, int createdBy,
                 String status) {
        this.eventID = eventID;
        this.clubID = clubID;
        this.eventName = eventName;
        this.description = description;
        this.location = location;
        this.capacity = capacity;
        this.startDate = startDate;
        this.endDate = endDate;
        this.registrationStart = registrationStart;
        this.registrationEnd = registrationEnd;
        this.createdBy = createdBy;
        this.status = status;
    }

    public Event(int eventID, int clubID, String eventName, String description,
                 String location, int capacity, Timestamp startDate, Timestamp endDate,
                 Timestamp registrationStart, Timestamp registrationEnd, int createdBy,
                 String status, String image) {
        this.eventID = eventID;
        this.clubID = clubID;
        this.eventName = eventName;
        this.description = description;
        this.location = location;
        this.capacity = capacity;
        this.startDate = startDate;
        this.endDate = endDate;
        this.registrationStart = registrationStart;
        this.registrationEnd = registrationEnd;
        this.createdBy = createdBy;
        this.status = status;
        this.image = image;
    }

    public Event(int clubID, String eventName, String description, String location,
                 int capacity, Timestamp startDate, Timestamp endDate, int createdBy, String status) {
        this.clubID = clubID;
        this.eventName = eventName;
        this.description = description;
        this.location = location;
        this.capacity = capacity;
        this.startDate = startDate;
        this.endDate = endDate;
        this.createdBy = createdBy;
        this.status = status;
    }

    public Event(int clubID, String eventName, String description, String location,
                 int capacity, Timestamp startDate, Timestamp endDate,
                 Timestamp registrationStart, Timestamp registrationEnd, int createdBy, String status) {
        this.clubID = clubID;
        this.eventName = eventName;
        this.description = description;
        this.location = location;
        this.capacity = capacity;
        this.startDate = startDate;
        this.endDate = endDate;
        this.registrationStart = registrationStart;
        this.registrationEnd = registrationEnd;
        this.createdBy = createdBy;
        this.status = status;
    }

    public Event(int clubID, String eventName, String description, String location,
                 int capacity, Timestamp startDate, Timestamp endDate,
                 Timestamp registrationStart, Timestamp registrationEnd, int createdBy, String status, String image) {
        this.clubID = clubID;
        this.eventName = eventName;
        this.description = description;
        this.location = location;
        this.capacity = capacity;
        this.startDate = startDate;
        this.endDate = endDate;
        this.registrationStart = registrationStart;
        this.registrationEnd = registrationEnd;
        this.createdBy = createdBy;
        this.status = status;
        this.image = image;
    }

    public int getEventID() {
        return eventID;
    }

    public void setEventID(int eventID) {
        this.eventID = eventID;
    }

    public int getClubID() {
        return clubID;
    }

    public void setClubID(int clubID) {
        this.clubID = clubID;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    // Alias for JSP compatibility
    public String getTitle() {
        return eventName;
    }

    public void setTitle(String title) {
        this.eventName = title;
    }

    // Aliases for JSP compatibility
    public Timestamp getStartTime() {
        return startDate;
    }

    public void setStartTime(Timestamp startTime) {
        this.startDate = startTime;
    }

    public Timestamp getEndTime() {
        return endDate;
    }

    public void setEndTime(Timestamp endTime) {
        this.endDate = endTime;
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

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    @Override
    public String toString() {
        return "Event{" +
                "eventID=" + eventID +
                ", clubID=" + clubID +
                ", eventName='" + eventName + '\'' +
                ", description='" + description + '\'' +
                ", location='" + location + '\'' +
                ", capacity=" + capacity +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", registrationStart=" + registrationStart +
                ", registrationEnd=" + registrationEnd +
                ", createdBy=" + createdBy +
                ", status='" + status + '\'' +
                ", image='" + image + '\'' +
                '}';
    }
}
