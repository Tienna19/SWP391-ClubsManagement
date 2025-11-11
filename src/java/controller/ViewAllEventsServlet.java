package controller;

import dal.EventViewDAO;
import model.Event;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ViewAllEventsServlet extends HttpServlet {

    private EventViewDAO eventDAO;

    @Override
    public void init() {
        eventDAO = new EventViewDAO();
    }

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    try {
        // Ưu tiên lấy từ attribute (forward)
        Object eventIdAttr = request.getAttribute("eventId");
        String eventIdParam = request.getParameter("eventId");

        Integer eventId = null;
        if (eventIdAttr != null) {
            eventId = (Integer) eventIdAttr;
        } else if (eventIdParam != null) {
            eventId = Integer.parseInt(eventIdParam);
        }

        if (eventId != null) {
            // Nếu có ID, hiển thị chi tiết
            Event event = eventDAO.getEventById(eventId);
            request.setAttribute("event", event);

            // message cũng được truyền từ RegisterForEventServlet
            String message = (String) request.getAttribute("message");
            if (message != null) {
                request.setAttribute("message", message);
            }

            request.getRequestDispatcher("eventDetail.jsp").forward(request, response);
        } else {
            // Nếu không có ID, hiển thị danh sách
            List<Event> events = eventDAO.getAllPublishedEvents();
            request.setAttribute("events", events);
            request.getRequestDispatcher("viewAllEvents.jsp").forward(request, response);
        }
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("message", "Error loading events: " + e.getMessage());
        request.getRequestDispatcher("viewAllEvents.jsp").forward(request, response);
    }
}

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    doGet(request, response);
}

}
