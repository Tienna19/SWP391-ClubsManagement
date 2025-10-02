package controller;

import dal.ClubDAO;
import dal.EventDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Club;
import model.Event;

// @WebServlet annotation removed - servlet is configured in web.xml
public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            ClubDAO cdao = new ClubDAO();
            EventDAO edao = new EventDAO();

            // Lấy danh sách tất cả clubs và events
            List<Club> clubs = cdao.getAllClubs();
            List<Event> events = edao.getAllEvents();

        // Lấy một số clubs tiêu biểu (giới hạn 4 clubs để hiển thị trên homepage)
        List<Club> featuredClubs = clubs.size() > 4 ? clubs.subList(0, 4) : clubs;
        
        // Lấy một số events sắp tới (giới hạn 3 events để hiển thị trên homepage)
        List<Event> upcomingEvents = events.size() > 3 ? events.subList(0, 3) : events;

        // Đặt danh sách clubs và events vào thuộc tính request
        request.setAttribute("clubs", clubs);
        request.setAttribute("featuredClubs", featuredClubs);
        request.setAttribute("events", events);
        request.setAttribute("upcomingEvents", upcomingEvents);
        
        // Thêm một số thống kê cho trang chủ
        request.setAttribute("totalClubs", clubs.size());
        request.setAttribute("totalEvents", events.size());

            // Chuyển tiếp yêu cầu đến trang JSP
            request.getRequestDispatcher("view/home/index.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // Show error page or redirect to error page
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("view/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }
}
