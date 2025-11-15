package model.assignrole;

public class ClubMember {
    private int membershipId;
    private int userId;
    private String fullName;
    private String email;

    private String roleInClub;
    private String membershipStatus;

    private int systemRoleId;
    private String systemStatus;

    public ClubMember() {}

    // getters & setters

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

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRoleInClub() {
        return roleInClub;
    }

    public void setRoleInClub(String roleInClub) {
        this.roleInClub = roleInClub;
    }

    public String getMembershipStatus() {
        return membershipStatus;
    }

    public void setMembershipStatus(String membershipStatus) {
        this.membershipStatus = membershipStatus;
    }

    public int getSystemRoleId() {
        return systemRoleId;
    }

    public void setSystemRoleId(int systemRoleId) {
        this.systemRoleId = systemRoleId;
    }

    public String getSystemStatus() {
        return systemStatus;
    }

    public void setSystemStatus(String systemStatus) {
        this.systemStatus = systemStatus;
    }
}
