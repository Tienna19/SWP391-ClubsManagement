package controller;

import dal.MembershipDAO;
import model.Membership;

public class AssignRoleController {
    private MembershipDAO membershipDAO;

    public AssignRoleController() {
        this.membershipDAO = new MembershipDAO();
    }

    public String assignRole(int membershipId, String newRole, String currentUserRole) {
        try {
            if (!currentUserRole.equals("Leader") && !currentUserRole.equals("Admin")) {
                return "Access denied: Only Leader/Admin can assign roles.";
            }

            Membership member = membershipDAO.findById(membershipId);
            if (member == null) {
                return "Error: Membership not found.";
            }

            if (newRole == null || newRole.isEmpty()) {
                return "Error: Invalid role selection.";
            }

            boolean updated = membershipDAO.updateRole(membershipId, newRole);
            if (updated) {
                return "Role updated successfully to " + newRole;
            } else {
                return "Error: Failed to update role.";
            }

        } catch (Exception e) {
            return "Exception: " + e.getMessage();
        }
    }
}