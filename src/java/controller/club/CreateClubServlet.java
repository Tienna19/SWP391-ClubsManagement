package controller;

import dal.ClubDAO;
import model.Club;
import model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/createClub")
@MultipartConfig // ⚠️ Bắt buộc để xử lý form có file upload
public class CreateClubServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ClubDAO dao = new ClubDAO();
        List<Category> categoryList = dao.getAllCategories();

        request.setAttribute("categoryList", categoryList);
        request.getRequestDispatcher("/view/club/createClubs.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int createdByUserId = Integer.parseInt(request.getParameter("createdByUserId")); // 👉 Giữ dạng String
            String status = "Pending";

            // ✅ Xử lý upload file logo
            Part filePart = request.getPart("logo");
            String fileName = filePart.getSubmittedFileName();

            String uploadPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String filePath = uploadPath + File.separator + fileName;
            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, new File(filePath).toPath());
            }

            String logoUrl = "uploads/" + fileName;

            // ✅ Tạo object Club
            Club newClub = new Club();
            newClub.setName(name);
            newClub.setDescription(description);
            newClub.setLogoUrl(logoUrl);
            newClub.setCategoryId(categoryId);
            newClub.setCreatedByUserId(createdByUserId); // kiểu String
            newClub.setStatus(status);
            newClub.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            newClub.setApprovedByUserId(null);

            // ✅ Gọi DAO lưu DB
            ClubDAO dao = new ClubDAO();
            dao.insertClub(newClub);

            response.sendRedirect(request.getContextPath() + "/viewAllClubs");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Lỗi khi thêm CLB: " + e.getMessage());
        }
    }
}
