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
        try {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            Integer userIdObj = (Integer) request.getSession().getAttribute("userId");

            if (userIdObj == null) {
                request.setAttribute("message", "⚠️ Vui lòng đăng nhập để check-in.");
                forwardToEvents(request, response);
                return;
            }

            int userId = userIdObj;

            if (dao.hasCheckedIn(userId, eventId)) {
                request.setAttribute("message", "ℹ️ Bạn đã check-in rồi.");
            } else {
                boolean success = dao.checkIn(userId, eventId);
                if (success) {
                    request.setAttribute("message", "✅ Check-in thành công!");
                } else {
                    request.setAttribute("message", "❌ Check-in thất bại.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "⚠️ Lỗi: " + e.getMessage());
        }

        forwardToEvents(request, response);
    }

    private void forwardToEvents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher("/MyRegisteredEventsServlet");
        rd.forward(request, response);
    }
}
