
package model;

public class Membership {
    private int membershipId;
    private int userId;
    private int clubId;

    public Membership() {
    }

    public Membership(int membershipId, int userId, int clubId) {
        this.membershipId = membershipId;
        this.userId = userId;
        this.clubId = clubId;
    }

    // Getter & Setter
    public int getMembershipId() {
        return membershipId;
    }

    public void setMembershipId(int membershipId) {
        this.membershipId = membershipId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getClubId() {
        return clubId;
    }

    public void setClubId(int clubId) {
        this.clubId = clubId;
    }
}
