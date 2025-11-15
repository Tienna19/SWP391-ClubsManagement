package controller;

import dal.EventRegistrationDAO;
import model.Event;
import model.User;      

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;

public class RegisterForEventServlet extends HttpServlet {

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

        int eventId = -1;

        try {
            // 1. Lấy eventId từ form
            String idParam = request.getParameter("eventId");
            if (idParam == null) {
                request.setAttribute("message", "❌ Thiếu mã sự kiện.");
                forwardToList(request, response);
                return;
            }
            eventId = Integer.parseInt(idParam);

            // 2. Lấy user đang đăng nhập từ session (đối tượng "account")
            HttpSession session = request.getSession(false);
            User account = (session != null)
                    ? (User) session.getAttribute("account")
                    : null;

            if (account == null) {
                request.setAttribute("message", "⚠️ Bạn cần đăng nhập trước khi đăng ký sự kiện.");
                forwardToDetail(eventId, request, response);
                return;
            }

            int userId = account.getUserId();

            // 3. Lấy thông tin sự kiện
            Event event = dao.getEventById(eventId);
            if (event == null) {
                request.setAttribute("message", "❌ Không tìm thấy sự kiện.");
                forwardToList(request, response);
                return;
            }

            Timestamp now = new Timestamp(System.currentTimeMillis());

            // 4. Kiểm tra thời gian mở đăng ký
            Timestamp regStart = event.getRegistrationStart();
            Timestamp regEnd   = event.getRegistrationEnd();

            if (now.before(event.getRegistrationStart())) {
            // Chưa mở
            request.setAttribute("message", "⚠️ Thời gian đăng ký cho sự kiện này CHƯA BẮT ĐẦU.");
            forwardToDetail(eventId, request, response);
            return;
            }

            if (now.after(event.getRegistrationEnd())) {
            // Đã kết thúc
            request.setAttribute("message", "⚠️ Thời gian đăng ký sự kiện này đã KẾT THÚC.");
            forwardToDetail(eventId, request, response);
            return;
            }
            // 5. Kiểm tra đã đăng ký chưa
            if (dao.isAlreadyRegistered(userId, eventId)) {
                request.setAttribute("message",
                        "ℹ️ Bạn đã đăng ký sự kiện này trước đó rồi.");
                forwardToDetail(eventId, request, response);
                return;
            }

            // 6. Kiểm tra sức chứa
            int current = dao.getCurrentRegistrations(eventId);
            if (current >= event.getCapacity()) {
                request.setAttribute("message",
                        "🚫 Sự kiện đã đủ số lượng người tham gia.");
                forwardToDetail(eventId, request, response);
                return;
            }

            // 7. Thực hiện đăng ký
            boolean success = dao.registerForEvent(userId, eventId);
            if (success) {
                request.setAttribute("message",
                        "✅ Đăng ký thành công sự kiện: " + event.getEventName());
            } else {
                request.setAttribute("message",
                        "❌ Đăng ký thất bại, vui lòng thử lại sau.");
            }

        } catch (NumberFormatException ex) {
            request.setAttribute("message", "❌ Mã sự kiện không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "⚠️ Có lỗi xảy ra: " + e.getMessage());
        }

        // Sau khi xử lý xong, quay về trang chi tiết sự kiện
        if (eventId > 0) {
            forwardToDetail(eventId, request, response);
        } else {
            forwardToList(request, response);
        }
    }

    // Quay lại chi tiết 1 event
    private void forwardToDetail(int eventId,
                                 HttpServletRequest request,
                                 HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("eventId", eventId);
        RequestDispatcher rd = request.getRequestDispatcher("/ViewAllEventsServlet");
        rd.forward(request, response);
    }

    // Quay lại danh sách events 
    private void forwardToList(HttpServletRequest request,
                               HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher rd = request.getRequestDispatcher("/ViewAllEventsServlet");
        rd.forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect(req.getContextPath() + "/viewAllEvents");
    }
}
