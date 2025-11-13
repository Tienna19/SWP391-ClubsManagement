package controller;

import dal.UserManagerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import model.UserManager;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1MB
        maxFileSize = 5 * 1024 * 1024,        // 5MB
        maxRequestSize = 10 * 1024 * 1024     // 10MB
)

public class ManageUsersServlet extends HttpServlet {
    private UserManagerDAO dao;

    @Override
    public void init() {
        dao = new UserManagerDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            // --------- 1. XỬ LÝ MESSAGE TRÊN URL (msg=...) ----------
            String msg = request.getParameter("msg");
            if (msg != null) {
                String message = null;
                String type = "info";

                switch (msg) {
                    case "create_success":
                        message = "Tạo người dùng mới thành công.";
                        type = "success";
                        break;
                    case "create_exists":
                        message = "Email đã tồn tại trong hệ thống.";
                        type = "warning";
                        break;
                    case "create_error":
                        message = "Không thể tạo người dùng. Vui lòng thử lại.";
                        type = "danger";
                        break;
                    case "update_success":
                        message = "Cập nhật thông tin người dùng thành công.";
                        type = "success";
                        break;
                    case "update_error":
                        message = "Không thể cập nhật thông tin người dùng.";
                        type = "danger";
                        break;
                    case "deactivate_success":
                        message = "Đã vô hiệu hóa người dùng.";
                        type = "success";
                        break;
                    case "reactivate_success":
                        message = "Đã khôi phục người dùng.";
                        type = "success";
                        break;
                }

                if (message != null) {
                    request.setAttribute("message", message);
                    request.setAttribute("messageType", type);
                }
            }

            // --------- 2. PHÂN TRANG + TÌM KIẾM ----------
            String keyword = request.getParameter("keyword");
            int page = 1;
            int recordsPerPage = 10;

            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException ignored) { }
            }

            List<UserManager> users;
            if (keyword != null && !keyword.trim().isEmpty()) {
                users = dao.searchUsers(keyword.trim());
            } else {
                int start = (page - 1) * recordsPerPage;
                users = dao.getUsersByPage(start, recordsPerPage);
            }

            int totalRecords = dao.getTotalUsers();
            int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("keyword", keyword);

            // active menu cho sidebar
            request.setAttribute("activeMenu", "users");
            request.setAttribute("activeSubMenu", "users-management");

            // --------- 3. FORWARD ĐẾN JSP ----------
            request.getRequestDispatcher("/view/admin/manageUsers.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/view/error.jsp")
                   .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String baseUrl = request.getContextPath() + "/ManageUsersServlet?msg=";


        try {
            if ("create".equals(action)) {
                UserManager u = new UserManager();
                u.setFullName(request.getParameter("fullName"));
                u.setEmail(request.getParameter("email"));
                u.setPhoneNumber(request.getParameter("phone"));
                u.setAddress(request.getParameter("address"));
                u.setGender(request.getParameter("gender"));
                u.setRoleID(Integer.parseInt(request.getParameter("role")));
                u.setStatus("Active");
                // password
                String plainPassword = request.getParameter("password");
                if (plainPassword == null || plainPassword.isBlank()) {
                    plainPassword = "123456"; // fallback
                }
                u.setPasswordHash(hashPassword(plainPassword));

                // ảnh đại diện (optional)
                String avatarPath = handleUpload(request, "profileImage");
                if (avatarPath != null) {
                    u.setProfileImage(avatarPath);
                } else {
                    u.setProfileImage("assets/images/default-avatar.png");
                }

                boolean ok = dao.addUser(u);
                response.sendRedirect(baseUrl + (ok ? "create_success" : "create_error"));
                return;

            } else if ("update".equals(action)) {
                UserManager u = new UserManager();
                u.setUserID(Integer.parseInt(request.getParameter("userId")));
                u.setFullName(request.getParameter("fullName"));
                u.setEmail(request.getParameter("email"));
                u.setPhoneNumber(request.getParameter("phone"));
                u.setAddress(request.getParameter("address"));
                u.setGender(request.getParameter("gender"));
                u.setRoleID(Integer.parseInt(request.getParameter("role")));
                u.setStatus("Active");

                // password: chỉ cập nhật nếu có nhập mới
                String newPassword = request.getParameter("password");
                if (newPassword != null && !newPassword.isBlank()) {
                    u.setPasswordHash(hashPassword(newPassword));
                } else {
                    u.setPasswordHash(null); // để DAO hiểu là "không cập nhật password"
                }

                // ảnh: chỉ cập nhật nếu có chọn file
                String avatarPath = handleUpload(request, "profileImage");
                if (avatarPath != null) {
                    u.setProfileImage(avatarPath);
                } else {
                    u.setProfileImage(null); // DAO xử lý không update cột này
                }
                boolean ok = dao.updateUser(u);
                response.sendRedirect(baseUrl + (ok ? "update_success" : "update_error"));
                return;

            } else if ("deactivate".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                dao.deactivateUser(userId); // nhớ implement trong DAO
                response.sendRedirect(baseUrl + "deactivate_success");
                return;
            }
            else if ("activate".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                dao.activateUser(userId); // nhớ implement trong DAO
                response.sendRedirect(baseUrl + "reactivate_success");
                return;
            }

            // action không hợp lệ
            response.sendRedirect(baseUrl + "create_error");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(baseUrl + "create_error");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(baseUrl + "create_error");
        }
    }
    
    // ==================== HELPER: HASH PASSWORD ====================
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));

            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    // ==================== HELPER: UPLOAD ẢNH ====================
    private String handleUpload(HttpServletRequest request, String fieldName)
            throws IOException, ServletException {

        Part part = request.getPart(fieldName);
        if (part == null || part.getSize() == 0) {
            return null;
        }

        String submittedFileName = getFileName(part);
        if (submittedFileName == null || submittedFileName.isBlank()) {
            return null;
        }

        // thư mục lưu ảnh trong project (tùy bạn chỉnh lại)
        String uploadDir = getServletContext().getRealPath("/uploads/avatars");
        Files.createDirectories(Paths.get(uploadDir));

        String safeName = "user_" + System.currentTimeMillis() + "_" +
                Paths.get(submittedFileName).getFileName().toString();

        String fullPath = uploadDir + File.separator + safeName;
        part.write(fullPath);

        // đường dẫn lưu vào DB (tương đối so với context)
        return "uploads/avatars/" + safeName;
    }
    
    private String getFileName(Part part) {
        String header = part.getHeader("content-disposition");
        if (header == null) return null;
        for (String cd : header.split(";")) {
            cd = cd.trim();
            if (cd.startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName;
            }
        }
        return null;
    }

}
