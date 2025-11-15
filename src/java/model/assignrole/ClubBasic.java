package model.assignrole;

public class ClubBasic {
    private int clubId;
    private String clubName;

    public ClubBasic() {}

    public ClubBasic(int clubId, String clubName) {
        this.clubId = clubId;
        this.clubName = clubName;
    }

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
}
