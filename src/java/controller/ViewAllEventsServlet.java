package controller;

import dal.EventViewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Event;
import model.EventClub;

public class ViewAllEventsServlet extends HttpServlet {

    private EventViewDAO eventDAO;

    @Override
    public void init() {
        eventDAO = new EventViewDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // ====== 1. Nếu có eventId -> xem chi tiết ======
            String eventIdParam = request.getParameter("eventId");
            if (eventIdParam != null && !eventIdParam.isEmpty()) {
                try {
                    int eventId = Integer.parseInt(eventIdParam);
                    Event event = eventDAO.getEventById(eventId);
                    if (event == null) {
                        request.setAttribute("message", "Sự kiện không tồn tại hoặc đã bị xóa.");
                    } else {
                        request.setAttribute("event", event);
                    }
                    request.getRequestDispatcher("/view/events/eventDetail.jsp")
                           .forward(request, response);
                    return;
                } catch (NumberFormatException ignore) {
                    // nếu eventId sai định dạng thì rớt xuống danh sách
                }
            }

            // ====== 2. Đọc tham số tìm kiếm / lọc / phân trang ======
            String keyword = request.getParameter("keyword");
            String clubIdStr = request.getParameter("clubId");
            Integer clubId = null;
            if (clubIdStr != null && !clubIdStr.isEmpty()) {
                try {
                    clubId = Integer.parseInt(clubIdStr);
                } catch (NumberFormatException ignore) {}
            }

            int pageSize = 9;
            int page = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException ignore) {}
            }
            int offset = (page - 1) * pageSize;

            // ====== 3. Gọi DAO lấy data ======
            int totalRecords = eventDAO.countPublishedEvents(keyword, clubId);
            int totalPages = (int) Math.ceil(totalRecords * 1.0 / pageSize);

            if (totalPages == 0) totalPages = 1;
            if (page > totalPages) {
                page = totalPages;
                offset = (page - 1) * pageSize;
            }

            List<Event> events = eventDAO.searchPublishedEvents(keyword, clubId, offset, pageSize);
            List<EventClub> clubs = eventDAO.getPublishedClubs();

            // ====== 4. Gán attribute cho JSP ======
            request.setAttribute("events", events);
            request.setAttribute("clubs", clubs);
            request.setAttribute("keyword", keyword);
            request.setAttribute("selectedClubId", clubId);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);

            // ====== 5. Forward ======
            request.getRequestDispatcher("/view/events/viewAllEvents.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Đã xảy ra lỗi khi tải danh sách sự kiện: " + e.getMessage());
            request.getRequestDispatcher("/view/events/viewAllEvents.jsp")
                   .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
