package model;

public class Event {
    private int eventId;
    private String eventName;
    private String eventDate;  // có thể dùng java.sql.Date nếu muốn làm chuẩn
    private int clubId;

    public Event() {
    }

    public Event(int eventId, String eventName, String eventDate, int clubId) {
        this.eventId = eventId;
        this.eventName = eventName;
        this.eventDate = eventDate;
        this.clubId = clubId;
    }

    // Getter & Setter
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

    public String getEventDate() {
        return eventDate;
    }

    public void setEventDate(String eventDate) {
        this.eventDate = eventDate;
    }

    public int getClubId() {
        return clubId;
    }

    public void setClubId(int clubId) {
        this.clubId = clubId;
    }
}
