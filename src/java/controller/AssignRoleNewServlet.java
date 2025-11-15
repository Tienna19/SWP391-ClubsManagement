package controller;

import dal.AssignRoleNewDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

import model.assignrole.*;

@WebServlet(name="AssignRoleNewServlet", urlPatterns={"/AssignRoleNew"})
public class AssignRoleNewServlet extends HttpServlet {

    AssignRoleNewDAO dao = new AssignRoleNewDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (session == null) ? null : (Integer) session.getAttribute("userId");
        Integer roleId = (session == null) ? null : (Integer) session.getAttribute("roleId");

        if (userId == null) {
            response.sendRedirect("login");
            return;
        }

        boolean isAdmin = (roleId != null && roleId == 4);

        try {
            // Load clubs
            List<ClubBasic> clubs = dao.getClubsForUser(userId, isAdmin);
            request.setAttribute("clubs", clubs);

            // Params
            String clubIdStr = request.getParameter("clubId");
            String membershipIdStr = request.getParameter("membershipId");
            String keyword = request.getParameter("keyword");
            String roleFilter = request.getParameter("roleFilter");

            request.setAttribute("keyword", keyword);
            request.setAttribute("roleFilter", roleFilter);

            // Pagination
            int pageSize = 10;
            int page = 1;

            String pageStr = request.getParameter("page");
            if (pageStr != null) page = Integer.parseInt(pageStr);

            if (clubIdStr != null && !clubIdStr.isEmpty()) {

                int clubId = Integer.parseInt(clubIdStr);
                request.setAttribute("selectedClubId", clubId);

                int totalMembers = dao.countMembers(clubId, keyword, roleFilter);
                int totalPages = (int) Math.ceil((double) totalMembers / pageSize);

                int offset = (page - 1) * pageSize;

                List<ClubMember> members =
                        dao.getMembersPaged(clubId, keyword, roleFilter,
                                offset, pageSize);

                request.setAttribute("members", members);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("currentPage", page);
            }

            // Load detail
            if (membershipIdStr != null && !membershipIdStr.isEmpty()) {
                ClubMember detail = dao.getMemberDetail(Integer.parseInt(membershipIdStr));
                request.setAttribute("detail", detail);
            }

            // Load system roles
            request.setAttribute("systemRoles", dao.getSystemRoles());

            // Load club roles
            request.setAttribute("clubRoles", dao.getClubRoles());

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
        }

        request.getRequestDispatcher("/assignRole.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int membershipId = Integer.parseInt(request.getParameter("membershipId"));
            String clubRole = request.getParameter("newClubRole");
            String membershipStatus = request.getParameter("membershipStatus");

            String sysRoleStr = request.getParameter("systemRoleId");
            Integer sysRole = (sysRoleStr == null || sysRoleStr.isEmpty()) ? null : Integer.parseInt(sysRoleStr);

            String sysStatus = request.getParameter("systemStatus");

            dao.updateRole(membershipId, clubRole, membershipStatus, sysRole, sysStatus);

            request.setAttribute("message", "Cập nhật thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi cập nhật: " + e.getMessage());
        }

        doGet(request, response);
    }
}
