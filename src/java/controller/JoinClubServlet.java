package controller;

import dal.JoinClubRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
// ĐỔI model.User theo class thực tế của bạn (ví dụ model.Account)
import model.User;

public class JoinClubServlet extends HttpServlet {

    private final JoinClubRequestDAO dao = new JoinClubRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        // LẤY USER THEO KEY THỰC TẾ (thường là "account")
        User authUser = (session == null) ? null : (User) session.getAttribute("account");
        // Nếu dự án bạn dùng tên khác, đổi "account" cho đúng.

        String clubIdStr = request.getParameter("clubId");
        if (authUser == null) {
            response.sendRedirect(request.getContextPath()
                    + "/login?redirect=clubDetail&clubId=" + (clubIdStr == null ? "" : clubIdStr));
            return;
        }
        if (clubIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing clubId");
            return;
        }

        int clubId = Integer.parseInt(clubIdStr);
        int userId = authUser.getUserId(); // đổi getter nếu khác

        // Nếu đã là member/pending thì flash & quay lại trang CLB (UX tốt)
        if (dao.isAlreadyMember(userId, clubId)) {
            session.setAttribute("flashInfo", "Bạn đã là thành viên CLB này.");
            response.sendRedirect(request.getContextPath() + "/clubDetail?clubId=" + clubId);
            return;
        }
        if (dao.hasPendingRequest(userId, clubId)) {
            session.setAttribute("flashError", "Bạn đã gửi yêu cầu và đang chờ duyệt.");
            response.sendRedirect(request.getContextPath() + "/clubDetail?clubId=" + clubId);
            return;
        }

        // Prefill cho form
        request.setAttribute("prefillFullName", authUser.getFullName()); // đổi getter nếu khác
        request.setAttribute("prefillEmail", authUser.getEmail());
        request.setAttribute("prefillUserId", userId);
        request.setAttribute("prefillClubId", clubId);

        request.getRequestDispatcher("joinClub.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User authUser = (session == null) ? null : (User) session.getAttribute("account");
        if (authUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String clubIdStr = request.getParameter("clubId");
        String reason = request.getParameter("reason");

        try {
            int clubId = Integer.parseInt(clubIdStr);
            int userId = authUser.getUserId(); // đổi getter nếu khác

            if (dao.isAlreadyMember(userId, clubId)) {
                session.setAttribute("flashInfo", "Bạn đã là thành viên CLB này.");
            } else if (dao.hasPendingRequest(userId, clubId)) {
                session.setAttribute("flashError", "Bạn đã gửi yêu cầu và đang chờ duyệt.");
            } else {
                dao.createJoinRequest(userId, clubId, reason);
                session.setAttribute("flashSuccess", "Đã gửi yêu cầu tham gia! Vui lòng chờ duyệt.");
            }
            // PRG: redirect về trang chi tiết CLB để hiển thị flash
            response.sendRedirect(request.getContextPath() + "/clubDetail?clubId=" + clubId);

        } catch (NumberFormatException e) {
            session.setAttribute("flashError", "Dữ liệu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/");
        } catch (Exception e) {
            session.setAttribute("flashError", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
}
