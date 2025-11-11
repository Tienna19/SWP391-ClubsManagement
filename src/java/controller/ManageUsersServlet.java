package controller;

import dal.UserManagerDAO;
import model.UserManager;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ManageUsersServlet extends HttpServlet {
    private UserManagerDAO dao;

    @Override
    public void init() {
        dao = new UserManagerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String action = request.getParameter("action");
            String keyword = request.getParameter("keyword");
            int page = 1;
            int recordsPerPage = 10;

            if (request.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException ignored) {}
            }

            // Xử lý Edit
            if ("edit".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                UserManager user = dao.findById(userId);
                request.setAttribute("user", user);
            }

            // Lấy danh sách người dùng (theo search hoặc phân trang)
            List<UserManager> users;
            if (keyword != null && !keyword.trim().isEmpty()) {
                users = dao.searchUsers(keyword);
            } else {
                users = dao.getUsersByPage((page - 1) * recordsPerPage, recordsPerPage);
            }

            int totalRecords = dao.getTotalUsers();
            int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error loading users: " + e.getMessage());
        }

        request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String action = request.getParameter("action");

            if ("create".equals(action)) {
                UserManager u = new UserManager();
                u.setFullName(request.getParameter("fullName"));
                u.setEmail(request.getParameter("email"));
                u.setPhoneNumber(request.getParameter("phone"));
                u.setAddress(request.getParameter("address"));
                u.setGender(request.getParameter("gender"));
                u.setRoleID(Integer.parseInt(request.getParameter("role")));
                dao.addUser(u);
                request.setAttribute("message", "✅ User created successfully!");

            } else if ("update".equals(action)) {
                UserManager u = new UserManager();
                u.setUserID(Integer.parseInt(request.getParameter("userId")));
                u.setFullName(request.getParameter("fullName"));
                u.setEmail(request.getParameter("email"));
                u.setPhoneNumber(request.getParameter("phone"));
                u.setAddress(request.getParameter("address"));
                u.setGender(request.getParameter("gender"));
                u.setRoleID(Integer.parseInt(request.getParameter("role")));
                dao.updateUser(u);
                request.setAttribute("message", "✅ User updated successfully!");

            } else if ("deactivate".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                dao.deactivateUser(userId);
                request.setAttribute("message", "⚠️ User deactivated successfully!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
        }

        // Quay lại danh sách user (tránh lỗi forward lặp)
        doGet(request, response);
    }
}
