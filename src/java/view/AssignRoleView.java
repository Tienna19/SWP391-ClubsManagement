package view;

import controller.AssignRoleController;
import java.util.Scanner;

public class AssignRoleView {
    public static void main(String[] args) {
        try (Scanner sc = new Scanner(System.in)) {
            AssignRoleController controller = new AssignRoleController();

            System.out.print("Enter MembershipID to update: ");
            int membershipId = sc.nextInt();
            sc.nextLine();

            System.out.print("Enter new role (Leader/Vice/Treasurer/Secretary/Member): ");
            String newRole = sc.nextLine();

            String currentUserRole = "Leader"; // người đang login là Leader
            String result = controller.assignRole(membershipId, newRole, currentUserRole);

            System.out.println(result);
        }
    }
}
