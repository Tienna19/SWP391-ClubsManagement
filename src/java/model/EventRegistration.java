package model;

import java.sql.Timestamp;

public class EventRegistration {
    private int registrationID;
    private int eventID;
    private int userID;
    private Timestamp registeredAt;
    private boolean checkIn;

    public EventRegistration() {}

    public EventRegistration(int registrationID, int eventID, int userID,
                             Timestamp registeredAt, boolean checkIn) {
        this.registrationID = registrationID;
        this.eventID = eventID;
        this.userID = userID;
        this.registeredAt = registeredAt;
        this.checkIn = checkIn;
    }

    public int getRegistrationID() { return registrationID; }
    public void setRegistrationID(int registrationID) { this.registrationID = registrationID; }

    public int getEventID() { return eventID; }
    public void setEventID(int eventID) { this.eventID = eventID; }

    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }

    public Timestamp getRegisteredAt() { return registeredAt; }
    public void setRegisteredAt(Timestamp registeredAt) { this.registeredAt = registeredAt; }

    public boolean isCheckIn() { return checkIn; }
    public void setCheckIn(boolean checkIn) { this.checkIn = checkIn; }

    @Override
    public String toString() {
        return "EventRegistration{" +
                "registrationID=" + registrationID +
                ", eventID=" + eventID +
                ", userID=" + userID +
                ", registeredAt=" + registeredAt +
                ", checkIn=" + checkIn +
                '}';
    }
}
