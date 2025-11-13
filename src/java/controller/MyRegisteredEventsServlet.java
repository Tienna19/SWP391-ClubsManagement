package controller;

import dal.EventRegistrationDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.EventRegistration;

public class MyRegisteredEventsServlet extends HttpServlet {
    private EventRegistrationDAO dao;

    @Override
    public void init() {
        dao = new EventRegistrationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Integer userId = (Integer) request.getSession().getAttribute("userId");

            if (userId == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            List<EventRegistration> registrations = dao.getRegistrationsByUser(userId);
            request.setAttribute("registrations", registrations);
            RequestDispatcher rd = request.getRequestDispatcher("myRegisteredEvents.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi: " + e.getMessage());
        }
    }
}
