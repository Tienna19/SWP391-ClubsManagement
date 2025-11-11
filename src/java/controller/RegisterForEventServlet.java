package controller;

import dal.EventRegistrationDAO;
import model.Event;
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
        response.getWriter().println("✅ Servlet POST handled successfully!");
        try {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            Integer userIdObj = (Integer) request.getSession().getAttribute("userId");

            if (userIdObj == null) {
                request.setAttribute("message", "⚠️ Please log in to register for this event.");
                forwardToDetail(eventId, request, response);
                return;
            }

            int userId = userIdObj;
            Event event = dao.getEventById(eventId);

            if (event == null) {
                request.setAttribute("message", "❌ Event not found.");
                forwardToDetail(eventId, request, response);
                return;
            }

            Timestamp now = new Timestamp(System.currentTimeMillis());
            if (now.before(event.getRegistrationStart()) || now.after(event.getRegistrationEnd())) {
                request.setAttribute("message", "⚠️ Registration is closed.");
                forwardToDetail(eventId, request, response);
                return;
            }

            if (dao.isAlreadyRegistered(userId, eventId)) {
                request.setAttribute("message", "ℹ️ You are already registered for this event.");
                forwardToDetail(eventId, request, response);
                return;
            }

            int current = dao.getCurrentRegistrations(eventId);
            if (current >= event.getCapacity()) {
                request.setAttribute("message", "🚫 Event is full.");
                forwardToDetail(eventId, request, response);
                return;
            }

            boolean success = dao.registerForEvent(userId, eventId);
            if (success)
                request.setAttribute("message", "✅ Registration successful for: " + event.getEventName());
            else
                request.setAttribute("message", "❌ Registration failed. Try again later.");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "⚠️ Error: " + e.getMessage());
        }

        // Quay lại trang chi tiết sau khi xử lý
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        forwardToDetail(eventId, request, response);
        System.out.println(">>> Entered doPost");

    }

    private void forwardToDetail(int eventId, HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    request.setAttribute("eventId", eventId); // truyền ID qua attribute
    RequestDispatcher rd = request.getRequestDispatcher("/ViewAllEventsServlet");
    rd.forward(request, response);
}

    
    @Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
    resp.getWriter().println("✅ GET working");
}

}
