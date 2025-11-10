/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.eventMgt;

import dal.EventDAO;
import dal.ClubDAO;
import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Event;
import model.Club;
import model.User;

/**
 * Servlet for handling Event Detail View functionality
 * 
 * @author admin
 */
public class ViewEventDetailServlet extends HttpServlet {

    private EventDAO eventDAO;
    private ClubDAO clubDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        eventDAO = new EventDAO();
        clubDAO = new ClubDAO();
        userDAO = new UserDAO();
    }

    /**
     * Handles the HTTP <code>GET</code> method - displays the event detail page
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get event ID from request
            String eventIdStr = request.getParameter("eventId");
            if (eventIdStr == null || eventIdStr.trim().isEmpty()) {
                request.setAttribute("error", "ID sự kiện không hợp lệ.");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }

            int eventId = Integer.parseInt(eventIdStr);

            // Get the event
            Event event = eventDAO.getEventById(eventId);
            if (event == null) {
                request.setAttribute("error", "Không tìm thấy sự kiện với ID: " + eventId);
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }

            // Get club information
            Club club = clubDAO.getClubById(event.getClubID());
            
            // Get creator information
            User creator = userDAO.getUserById(event.getCreatedBy());
            
            // Get registration count
            int registrationCount = eventDAO.getRegistrationCount(eventId);
            
            // Check if current user is registered (if logged in)
            boolean isRegistered = false;
            HttpSession session = request.getSession(false);
            if (session != null) {
                User currentUser = (User) session.getAttribute("account");
                if (currentUser != null) {
                    isRegistered = eventDAO.isUserRegistered(eventId, currentUser.getUserId());
                }
            }

            // Set attributes for JSP
            request.setAttribute("event", event);
            request.setAttribute("club", club);
            request.setAttribute("creator", creator);
            request.setAttribute("registrationCount", registrationCount);
            request.setAttribute("isRegistered", isRegistered);
            request.setAttribute("availableSlots", event.getCapacity() - registrationCount);

            // Forward to event detail JSP
            request.getRequestDispatcher("/view/eventMgt/event-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID sự kiện không hợp lệ.");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi tải thông tin sự kiện: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for displaying event detail page in the club management system";
    }
}

