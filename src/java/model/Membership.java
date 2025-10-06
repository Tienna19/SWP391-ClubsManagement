<<<<<<< Updated upstream
=======
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
>>>>>>> Stashed changes
package model;

public class Membership {
    private int membershipId;
    private int clubId;
    private int userId;
    private String role;
    private String status;
<<<<<<< Updated upstream
=======
    private String fullName; 
>>>>>>> Stashed changes

    public Membership() {}

    public Membership(int membershipId, int clubId, int userId, String role, String status) {
        this.membershipId = membershipId;
        this.clubId = clubId;
        this.userId = userId;
        this.role = role;
        this.status = status;
    }

<<<<<<< Updated upstream
    public int getMembershipId() { 
        return membershipId; 
    }
    public void setMembershipId(int membershipId) { 
        this.membershipId = membershipId; 
    }

    public int getClubId() { 
        return clubId; 
    }
    public void setClubId(int clubId) { 
        this.clubId = clubId; 
    }

    public int getUserId() { 
        return userId; 
    }
    public void setUserId(int userId) { 
        this.userId = userId; 
    }

    public String getRole() { 
        return role; 
    }
    public void setRole(String role) { 
        this.role = role; 
    }

    public String getStatus() { 
        return status; 
    }
    public void setStatus(String status) { 
        this.status = status; 
    }
=======
    public int getMembershipId() { return membershipId; }
    public void setMembershipId(int membershipId) { this.membershipId = membershipId; }

    public int getClubId() { return clubId; }
    public void setClubId(int clubId) { this.clubId = clubId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
>>>>>>> Stashed changes
}
