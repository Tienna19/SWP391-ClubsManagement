package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import model.User;

@WebServlet(name = "EditProfileServlet", urlPatterns = {"/edit-profile"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10,               // 10 MB
        maxRequestSize = 1024 * 1024 * 50)            // 50 MB
public class EditProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User account = (session != null) ? (User) session.getAttribute("account") : null;

        if (account == null) {
            response.sendRedirect("login");
            return;
        }

        request.setAttribute("userInfo", account);
        request.getRequestDispatcher("view/user/editProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User account = (session != null) ? (User) session.getAttribute("account") : null;

        if (account == null) {
            response.sendRedirect("login");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender");

        // Upload ảnh (avatar)
        Part filePart = request.getPart("profileImage");
        if (filePart != null && filePart.getSize() > 0) {
            // Tên file duy nhất
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

            // Thư mục lưu file upload (trong thư mục webapp)
            String uploadPath = getServletContext().getRealPath("/uploads");
            Path uploadDir = Paths.get(uploadPath);
            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
            }

            // Ghi file vào thư mục
            try (InputStream fileContent = filePart.getInputStream()) {
                Path filePath = uploadDir.resolve(fileName);
                Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
            }

            // Lưu đường dẫn tương đối để hiển thị trong JSP
            account.setProfileImage("uploads/" + fileName);
        }

        account.setFullName(fullName);
        account.setPhoneNumber(phoneNumber);
        account.setAddress(address);
        account.setGender(gender);

        UserDAO dao = new UserDAO();
        boolean updated = dao.updateProfile(account);

        if (updated) {
            session.setAttribute("account", account);
            request.setAttribute("message", "Cập nhật thông tin thành công!");
        } else {
            request.setAttribute("error", "Cập nhật thất bại. Vui lòng thử lại!");
        }

        request.setAttribute("userInfo", account);
        request.getRequestDispatcher("view/user/profile.jsp").forward(request, response);
    }
}
