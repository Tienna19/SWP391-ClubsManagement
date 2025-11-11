package controller.club;

import dal.ClubDAO;
import dal.MemberDAO;
import dal.JoinClubRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Club;
import model.MemberDTO;
import model.User;

@WebServlet(name = "MemberListServlet", urlPatterns = {"/memberList"})
public class MemberListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("account");
        Integer clubId = resolveClubId(session, request);
        if (clubId == null) {
            request.setAttribute("error", "Không xác định được CLB để hiển thị thành viên.");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }

        MemberDAO memberDAO = new MemberDAO();
        ClubDAO clubDAO = new ClubDAO();
        JoinClubRequestDAO joinRequestDAO = new JoinClubRequestDAO();

        Club club = clubDAO.getClubById(clubId);
        if (club == null) {
            request.setAttribute("error", "CLB không tồn tại.");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }

        boolean hasPermission = hasPermission(user, clubId, memberDAO);
        if (!hasPermission) {
            request.setAttribute("error", "Bạn không có quyền xem danh sách thành viên của CLB này.");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }

        List<MemberDTO> members = memberDAO.findMembersByClub(clubId);

        request.setAttribute("club", club);
        request.setAttribute("clubId", clubId);
        request.setAttribute("members", members);
        request.setAttribute("totalMembers", members != null ? members.size() : 0);
        request.setAttribute("pendingRequests", joinRequestDAO.getRequestsByClub(clubId, "Pending").size());
        request.setAttribute("pageTitle", "Danh sách thành viên");
        request.setAttribute("activeMenu", "members");
        request.setAttribute("activeSubMenu", "members-list");

        request.getRequestDispatcher("/view/club/member-list.jsp").forward(request, response);
    }

    private Integer resolveClubId(HttpSession session, HttpServletRequest request) {
        Integer clubId = (Integer) session.getAttribute("currentClubId");
        if (clubId != null) {
            return clubId;
        }

        String clubIdParam = request.getParameter("clubId");
        if (clubIdParam != null && !clubIdParam.isEmpty()) {
            try {
                clubId = Integer.parseInt(clubIdParam);
                session.setAttribute("currentClubId", clubId);
                return clubId;
            } catch (NumberFormatException ignored) {
            }
        }
        return null;
    }

    private boolean hasPermission(User user, int clubId, MemberDAO memberDAO) {
        // RoleID 4 = Admin -> full access
        if (user.getRoleId() == 4) {
            return true;
        }
        // RoleID 3 = Club Leader -> must be leader of this club
        if (user.getRoleId() == 3) {
            return memberDAO.isClubLeader(user.getUserId(), clubId);
        }
        return false;
    }
}

