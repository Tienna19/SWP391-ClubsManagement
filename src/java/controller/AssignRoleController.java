<<<<<<< Updated upstream
=======
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
// src/controller/AssignRoleController.java
>>>>>>> Stashed changes
package controller;

import dal.MembershipDAO;
import model.Membership;
<<<<<<< Updated upstream
=======
import model.PendingRequest;
>>>>>>> Stashed changes

public class AssignRoleController {
    private MembershipDAO membershipDAO;

    public AssignRoleController() {
        this.membershipDAO = new MembershipDAO();
    }

<<<<<<< Updated upstream
    public String assignRole(int membershipId, String newRole, String currentUserRole) {
        try {
            if (!currentUserRole.equals("Leader") && !currentUserRole.equals("Admin")) {
                return "Access denied: Only Leader/Admin can assign roles.";
            }

=======
    public String assignRole(int membershipId, String newRole, String currentUserRole, int currentUserId) {
        try {
>>>>>>> Stashed changes
            Membership member = membershipDAO.findById(membershipId);
            if (member == null) {
                return "Error: Membership not found.";
            }
<<<<<<< Updated upstream

            if (newRole == null || newRole.isEmpty()) {
                return "Error: Invalid role selection.";
            }

            boolean updated = membershipDAO.updateRole(membershipId, newRole);
            if (updated) {
                return "Role updated successfully to " + newRole;
            } else {
                return "Error: Failed to update role.";
            }

=======
            if (!"Approved".equalsIgnoreCase(member.getStatus())) {
                return "Error: Member is not active.";
            }

            boolean isCritical = "Leader".equalsIgnoreCase(newRole) || "Treasurer".equalsIgnoreCase(newRole);

            if (isCritical && "Leader".equalsIgnoreCase(currentUserRole)) {
                // Leader gán role quan trọng → pending
                PendingRequest req = new PendingRequest(membershipId, member.getRole(), newRole, currentUserId);
                membershipDAO.addPendingRequest(req);
                return "Request submitted: Role change pending Admin approval.";
            }

            // Admin hoặc role thường → cập nhật trực tiếp
            boolean updated = membershipDAO.updateRole(membershipId, newRole);
            return updated ? "Role updated successfully to " + newRole
                           : "Error: Failed to update role.";
>>>>>>> Stashed changes
        } catch (Exception e) {
            return "Exception: " + e.getMessage();
        }
    }
<<<<<<< Updated upstream
}
=======
}
>>>>>>> Stashed changes
