package model;

public class Member {
    private int userID;
    private String memberName;
    private int age;
    private int memberID;
    private String role;
    private String joinDate;
    private String status;
    private boolean isDeleted;

    public Member(int userID, String memberName, int age, int memberID, String role, String joinDate, String status, boolean isDeleted) {
        this.userID = userID;
        this.memberName = memberName;
        this.age = age;
        this.memberID = memberID;
        this.role = role;
        this.joinDate = joinDate;
        this.status = status;
        this.isDeleted = isDeleted;
    }
     public Member(){
         
     }
    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getMemberName() {
        return memberName;
    }

    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public int getMemberID() {
        return memberID;
    }

    public void setMemberID(int memberID) {
        this.memberID = memberID;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getJoinDate() {
        return joinDate;
    }

    public void setJoinDate(String joinDate) {
        this.joinDate = joinDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

}