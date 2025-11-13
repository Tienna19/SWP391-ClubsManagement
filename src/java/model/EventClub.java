package model;

public class EventClub {
    private int clubID;
    private String clubName;

    public EventClub() {}

    public EventClub(int clubID, String clubName) {
        this.clubID = clubID;
        this.clubName = clubName;
    }

    public int getClubID() {
        return clubID;
    }

    public void setClubID(int clubID) {
        this.clubID = clubID;
    }

    public String getClubName() {
        return clubName;
    }

    public void setClubName(String clubName) {
        this.clubName = clubName;
    }
}
