/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dal.MembershipDAO;
import model.MembershipRole;
import model.PendingRequest;

public class AssignRoleController {
    private MembershipDAO membershipDAO;

    public AssignRoleController() {
        this.membershipDAO = new MembershipDAO();
    }

    public String assignRole(int membershipId, String newRole, String currentUserRole, int currentUserId) {
        try {
            MembershipRole member = membershipDAO.findById(membershipId);
            if (member == null) {
                return "Error: Membership not found.";
            }
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
        } catch (Exception e) {
            return "Exception: " + e.getMessage();
        }
    }
}
