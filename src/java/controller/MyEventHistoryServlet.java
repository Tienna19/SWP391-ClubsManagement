package controller;

import dal.EventHistoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import model.EventHistoryItem;

public class MyEventHistoryServlet extends HttpServlet {

    private EventHistoryDAO dao;

    @Override
    public void init() {
        dao = new EventHistoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userIdObj = (Integer) session.getAttribute("userId");
        if (userIdObj == null) {
            // chưa login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int userId = userIdObj;

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        String fromStr = request.getParameter("fromDate");
        String toStr = request.getParameter("toDate");
        String pageStr = request.getParameter("page");

        int pageIndex = 1;
        int pageSize = 5;
        if (pageStr != null) {
            try {
                pageIndex = Integer.parseInt(pageStr);
                if (pageIndex < 1) pageIndex = 1;
            } catch (NumberFormatException e) {
                pageIndex = 1;
            }
        }

        Date fromDate = null;
        Date toDate = null;
        try {
            if (fromStr != null && !fromStr.isEmpty()) {
                fromDate = Date.valueOf(fromStr);
            }
            if (toStr != null && !toStr.isEmpty()) {
                toDate = Date.valueOf(toStr);
            }
        } catch (IllegalArgumentException ex) {
            // ignore parse error, just treat as null
        }

        try {
            int totalRecords = dao.countUserEventHistory(userId, keyword, status, fromDate, toDate);
            int totalPages = (int) Math.ceil(totalRecords / (double) pageSize);

            List<EventHistoryItem> history =
                    dao.getUserEventHistory(userId, keyword, status, fromDate, toDate, pageIndex, pageSize);

            request.setAttribute("history", history);
            request.setAttribute("keyword", keyword);
            request.setAttribute("statusFilter", status == null ? "All" : status);
            request.setAttribute("fromDate", fromStr);
            request.setAttribute("toDate", toStr);
            request.setAttribute("currentPage", pageIndex);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);

            request.getRequestDispatcher("/view/events/myEvents.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading event history: " + e.getMessage());
            request.getRequestDispatcher("/view/events/myEvents.jsp")
                   .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // dùng GET cho filter => POST chỉ redirect về GET
        doGet(request, response);
    }
}
