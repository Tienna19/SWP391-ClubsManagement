package controller;

import dal.EventRegistrationDAO;
import model.Event;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Timestamp;

public class EventCheckInServlet extends HttpServlet {

    private EventRegistrationDAO dao;

    @Override
    public void init() {
        dao = new EventRegistrationDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String eventIdStr = request.getParameter("eventId");
        int eventId = 0;

        try {
            eventId = Integer.parseInt(eventIdStr);
        } catch (Exception ex) {
            request.setAttribute("message", "❌ Dữ liệu sự kiện không hợp lệ.");
            forwardToDetail(eventId, request, response);
            return;
        }

        // Lấy userId từ session (giống RegisterForEventServlet đang dùng)
        Integer userIdObj = (Integer) request.getSession().getAttribute("userId");
        if (userIdObj == null) {
            request.setAttribute("message", "⚠️ Vui lòng đăng nhập để check-in sự kiện.");
            forwardToDetail(eventId, request, response);
            return;
        }

        int userId = userIdObj;

        try {
            Event event = dao.getEventById(eventId);
            if (event == null) {
                request.setAttribute("message", "❌ Không tìm thấy sự kiện.");
                forwardToDetail(eventId, request, response);
                return;
            }

            Timestamp now = new Timestamp(System.currentTimeMillis());

            // Chỉ cho check-in khi sự kiện đang diễn ra
            if (now.before(event.getStartDate())) {
                request.setAttribute("message", "⚠️ Sự kiện chưa bắt đầu, chưa thể check-in.");
                forwardToDetail(eventId, request, response);
                return;
            }

            if (now.after(event.getEndDate())) {
                request.setAttribute("message", "⚠️ Sự kiện đã kết thúc, không thể check-in nữa.");
                forwardToDetail(eventId, request, response);
                return;
            }

            // Phải đăng ký thì mới được check-in
            if (!dao.isAlreadyRegistered(userId, eventId)) {
                request.setAttribute("message", "⚠️ Bạn chưa đăng ký sự kiện này nên không thể check-in.");
                forwardToDetail(eventId, request, response);
                return;
            }

            // Đã check-in rồi thì không check lại
            if (dao.hasCheckedIn(userId, eventId)) {
                request.setAttribute("message", "ℹ️ Bạn đã check-in tham gia sự kiện này rồi.");
                forwardToDetail(eventId, request, response);
                return;
            }

            boolean ok = dao.checkIn(userId, eventId);
            if (ok) {
                request.setAttribute("message", "✅ Check-in thành công. Chúc bạn có một sự kiện thật vui!");
            } else {
                request.setAttribute("message", "❌ Không thể check-in lúc này. Vui lòng thử lại.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "⚠️ Lỗi hệ thống: " + e.getMessage());
        }

        forwardToDetail(eventId, request, response);
    }

    private void forwardToDetail(int eventId, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Dùng lại ViewAllEventsServlet để hiển thị eventDetail.jsp
        request.setAttribute("eventId", eventId);
        RequestDispatcher rd = request.getRequestDispatcher("/ViewAllEventsServlet");
        rd.forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Không dùng GET cho check-in → chuyển về danh sách sự kiện
        resp.sendRedirect(req.getContextPath() + "/ViewAllEventsServlet");
    }
}
