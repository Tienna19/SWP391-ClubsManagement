/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

public class PendingRequest {
    private int membershipId;
    private String oldRole;
    private String newRole;
    private int changedByUserId;
    private String status; // Pending, Approved, Rejected
    private Date createdAt;

    public PendingRequest(int membershipId, String oldRole, String newRole, int changedByUserId) {
        this.membershipId = membershipId;
        this.oldRole = oldRole;
        this.newRole = newRole;
        this.changedByUserId = changedByUserId;
        this.status = "Pending";
        this.createdAt = new Date();
    }

    public int getMembershipId() { 
        return membershipId; 
    }
    public String getOldRole() { 
        return oldRole; 
    }
    public String getNewRole() { 
        return newRole; 
    }
    public int getChangedByUserId() { 
        return changedByUserId; 
    }
    public String getStatus() { 
        return status; 
    }
    public void setStatus(String status) { 
        this.status = status; 
    }
    public Date getCreatedAt() { 
        return createdAt; }
}

