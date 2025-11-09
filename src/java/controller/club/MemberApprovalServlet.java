package controller.club;

import dal.ClubDAO;
import dal.JoinClubRequestDAO;
import dal.MemberDAO;
import dal.MembershipDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import model.Club;
import model.JoinClubRequest;
import model.User;

@WebServlet(name = "MemberApprovalServlet", urlPatterns = {"/memberApprovals"})
public class MemberApprovalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        MemberDAO memberDAO = new MemberDAO();
        JoinClubRequestDAO joinRequestDAO = new JoinClubRequestDAO();
        ClubDAO clubDAO = new ClubDAO();

        User user = (User) session.getAttribute("account");
        Integer clubId = resolveClubId(session, request);
        if (clubId == null) {
            request.setAttribute("error", "Không xác định được CLB để hiển thị yêu cầu.");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }

        Club club = clubDAO.getClubById(clubId);
        if (club == null) {
            request.setAttribute("error", "CLB không tồn tại.");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }

        if (!hasPermission(user, clubId, memberDAO)) {
            request.setAttribute("error", "Bạn không có quyền phê duyệt thành viên cho CLB này.");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }

        String statusParam = request.getParameter("status");
        String statusFilter = (statusParam == null || statusParam.isEmpty())
                ? "pending"
                : statusParam.toLowerCase();

        String dbStatus = null;
        switch (statusFilter) {
            case "pending":
                dbStatus = "Pending";
                break;
            case "approved":
                dbStatus = "Approved";
                break;
            case "rejected":
                dbStatus = "Rejected";
                break;
            case "all":
                dbStatus = null;
                break;
            default:
                dbStatus = statusParam;
                break;
        }

        List<JoinClubRequest> requests = joinRequestDAO.getRequestsByClub(clubId, dbStatus);

        int pendingCount = joinRequestDAO.getRequestsByClub(clubId, "Pending").size();

        request.setAttribute("club", club);
        request.setAttribute("clubId", clubId);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("requests", requests);
        request.setAttribute("pageTitle", "Phê duyệt thành viên");
        request.setAttribute("activeMenu", "memberApprovals");
        request.setAttribute("pendingRequests", pendingCount);

        // Flash messages
        Object flashMessage = session.getAttribute("flashMessage");
        Object flashType = session.getAttribute("flashType");
        if (flashMessage != null) {
            request.setAttribute("flashMessage", flashMessage);
            request.setAttribute("flashType", flashType);
            session.removeAttribute("flashMessage");
            session.removeAttribute("flashType");
        }

        request.getRequestDispatcher("/view/club/member-approvals.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        MemberDAO memberDAO = new MemberDAO();
        JoinClubRequestDAO joinRequestDAO = new JoinClubRequestDAO();
        MembershipDAO membershipDAO = new MembershipDAO();

        User user = (User) session.getAttribute("account");
        Integer clubId = resolveClubId(session, request);
        if (clubId == null) {
            redirectWithMessage(session, response, request, "Không xác định được CLB.", "danger");
            return;
        }

        if (!hasPermission(user, clubId, memberDAO)) {
            redirectWithMessage(session, response, request, "Bạn không có quyền thực hiện thao tác này.", "danger");
            return;
        }

        String action = request.getParameter("action");
        String requestIdRaw = request.getParameter("requestId");

        if (action == null || requestIdRaw == null) {
            redirectWithMessage(session, response, request, "Thiếu thông tin yêu cầu.", "danger");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdRaw);
            JoinClubRequest joinRequest = joinRequestDAO.getRequestById(requestId);

            if (joinRequest == null || joinRequest.getClubId() != clubId) {
                redirectWithMessage(session, response, request, "Yêu cầu không tồn tại hoặc không thuộc CLB này.", "danger");
                return;
            }

            if (!"Pending".equalsIgnoreCase(joinRequest.getStatus())) {
                redirectWithMessage(session, response, request, "Yêu cầu đã được xử lý trước đó.", "warning");
                return;
            }

            boolean success = false;
            if ("approve".equalsIgnoreCase(action)) {
                if (joinRequestDAO.isAlreadyMember(joinRequest.getUserId(), clubId)) {
                    joinRequestDAO.updateRequestStatus(requestId, "Approved");
                    redirectWithMessage(session, response, request, "Người dùng này đã là thành viên. Đã cập nhật trạng thái yêu cầu.", "info");
                    return;
                }

                success = membershipDAO.addMemberToClub(joinRequest.getUserId(), clubId, "Member", "Active");
                if (success) {
                    joinRequestDAO.updateRequestStatus(requestId, "Approved");
                    redirectWithMessage(session, response, request, "Đã phê duyệt yêu cầu tham gia CLB.", "success");
                } else {
                    redirectWithMessage(session, response, request, "Không thể thêm thành viên. Vui lòng thử lại.", "danger");
                }
            } else if ("reject".equalsIgnoreCase(action)) {
                success = joinRequestDAO.updateRequestStatus(requestId, "Rejected");
                if (success) {
                    redirectWithMessage(session, response, request, "Đã từ chối yêu cầu tham gia CLB.", "success");
                } else {
                    redirectWithMessage(session, response, request, "Không thể cập nhật trạng thái yêu cầu.", "danger");
                }
            } else {
                redirectWithMessage(session, response, request, "Hành động không hợp lệ.", "danger");
            }

        } catch (NumberFormatException ex) {
            redirectWithMessage(session, response, request, "Định dạng dữ liệu không hợp lệ.", "danger");
        }
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
        if (user.getRoleId() == 1) {
            return true;
        }
        if (user.getRoleId() == 2) {
            return memberDAO.isClubLeader(user.getUserId(), clubId);
        }
        return false;
    }

    private void redirectWithMessage(HttpSession session, HttpServletResponse response,
                                     HttpServletRequest request, String message, String type) throws IOException {
        session.setAttribute("flashMessage", message);
        session.setAttribute("flashType", type);

        String status = request.getParameter("status");
        StringBuilder url = new StringBuilder(request.getContextPath())
                .append("/memberApprovals");

        Integer clubId = (Integer) session.getAttribute("currentClubId");
        if (clubId != null) {
            url.append("?clubId=").append(clubId);
            if (status != null && !status.isEmpty()) {
                url.append("&status=").append(URLEncoder.encode(status, StandardCharsets.UTF_8));
            }
        }

        response.sendRedirect(url.toString());
    }
}

