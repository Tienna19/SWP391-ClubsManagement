package controller;

import dal.EventRegistrationDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class CheckInServlet extends HttpServlet {
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

        // Lấy eventId 
        String eventIdParam = request.getParameter("eventId");
        int eventId = 0;
        try {
            eventId = Integer.parseInt(eventIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("message", "❌ Thông tin sự kiện không hợp lệ.");
            forwardToDetail(eventId, request, response);
            return;
        }

        try {
            // Lấy userId từ session (set ở LoginServlet)
            Integer userIdObj = (Integer) request.getSession().getAttribute("userId");

            if (userIdObj == null) {
                request.setAttribute("message", "⚠️ Vui lòng đăng nhập để check-in.");
                forwardToDetail(eventId, request, response);
                return;
            }

            int userId = userIdObj;

            // Kiểm tra đã check-in chưa
            if (dao.hasCheckedIn(userId, eventId)) {
                request.setAttribute("message", "ℹ️ Bạn đã check-in sự kiện này rồi.");
            } else {
                boolean success = dao.checkIn(userId, eventId);
                if (success) {
                    request.setAttribute("message", "✅ Check-in thành công!");
                } else {
                    request.setAttribute("message", "❌ Check-in thất bại. Vui lòng thử lại.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "⚠️ Lỗi: " + e.getMessage());
        }

        forwardToDetail(eventId, request, response);
    }

    private void forwardToDetail(int eventId,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("eventId", eventId);
        RequestDispatcher rd = request.getRequestDispatcher("/ViewAllEventsServlet");
        rd.forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}
