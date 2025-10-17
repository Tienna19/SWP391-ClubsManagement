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
    private Timestamp eventDate;
    private String status;
    private Timestamp createdAt;

    public Event() {
    }

    public Event(int eventID, int clubID, String eventName, String description, 
                 Timestamp eventDate, String status, Timestamp createdAt) {
        this.eventID = eventID;
        this.clubID = clubID;
        this.eventName = eventName;
        this.description = description;
        this.eventDate = eventDate;
        this.status = status;
        this.createdAt = createdAt;
    }

    public Event(int clubID, String eventName, String description, 
                 Timestamp eventDate, String status) {
        this.clubID = clubID;
        this.eventName = eventName;
        this.description = description;
        this.eventDate = eventDate;
        this.status = status;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getEventDate() {
        return eventDate;
    }

    public void setEventDate(Timestamp eventDate) {
        this.eventDate = eventDate;
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

    @Override
    public String toString() {
        return "Event{" +
                "eventID=" + eventID +
                ", clubID=" + clubID +
                ", eventName='" + eventName + '\'' +
                ", description='" + description + '\'' +
                ", eventDate=" + eventDate +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
