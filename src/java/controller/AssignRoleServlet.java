/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
// File: src/controller/AssignRoleServlet.java
package controller;

import dal.MembershipDAO;
import model.Membership;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AssignRoleServlet extends HttpServlet {
    private AssignRoleController controller;
    private MembershipDAO membershipDAO;

    @Override
    public void init() {
        controller = new AssignRoleController();
        membershipDAO = new MembershipDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int clubId = 1; // TODO: lấy từ session hoặc dropdown khi có
            int page = 1;
            int recordsPerPage = 10;
            if (request.getParameter("page") != null) {
                try { page = Integer.parseInt(request.getParameter("page")); } catch (NumberFormatException ignored) {}
            }
            List<Membership> members = membershipDAO.getMembersByPage(clubId, (page - 1) * recordsPerPage, recordsPerPage);
            int totalRecords = membershipDAO.getTotalMembers(clubId);
            int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

            request.setAttribute("members", members);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
        } catch (Exception e) {
            request.setAttribute("message", "Error loading members: " + e.getMessage());
        }
        request.getRequestDispatcher("assignRoles.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int membershipId = Integer.parseInt(request.getParameter("membershipId"));
            String newRole = request.getParameter("newRole");

            // Demo: read current user info from session in real app
            String currentUserRole = (String) request.getSession().getAttribute("currentUserRole");
            if (currentUserRole == null) currentUserRole = "Leader"; // fallback for demo
            Integer currentUserIdObj = (Integer) request.getSession().getAttribute("currentUserId");
            int currentUserId = (currentUserIdObj != null) ? currentUserIdObj.intValue() : 1;

            String result = controller.assignRole(membershipId, newRole, currentUserRole, currentUserId);
            request.setAttribute("message", result);

        } catch (Exception e) {
            request.setAttribute("message", "Error assigning role: " + e.getMessage());
        }
        // reload page (first page)
        doGet(request, response);
    }
}
