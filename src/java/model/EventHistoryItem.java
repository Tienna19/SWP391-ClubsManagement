package model;

import java.sql.Timestamp;

public class EventHistoryItem {
    private int eventId;
    private String eventName;
    private String clubName;
    private Timestamp startDate;
    private Timestamp endDate;
    private Timestamp registeredAt;
    private String status;    
    private boolean checkIn;

    public EventHistoryItem() {
    }

    public EventHistoryItem(int eventId, String eventName, String clubName,
                            Timestamp startDate, Timestamp endDate,
                            Timestamp registeredAt, String status, boolean checkIn) {
        this.eventId = eventId;
        this.eventName = eventName;
        this.clubName = clubName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.registeredAt = registeredAt;
        this.status = status;
        this.checkIn = checkIn;
    }

    public int getEventId() {
        return eventId;
    }

    public void setEventId(int eventId) {
        this.eventId = eventId;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getClubName() {
        return clubName;
    }

    public void setClubName(String clubName) {
        this.clubName = clubName;
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

    public Timestamp getRegisteredAt() {
        return registeredAt;
    }

    public void setRegisteredAt(Timestamp registeredAt) {
        this.registeredAt = registeredAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isCheckIn() {
        return checkIn;
    }

    public void setCheckIn(boolean checkIn) {
        this.checkIn = checkIn;
    }
}

