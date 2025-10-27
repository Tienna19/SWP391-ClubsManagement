package controller.club;

import dal.ClubDAO;
import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.List;
import java.util.UUID;
import model.Club;
import model.User;

/**
 * Update Club Servlet - Cập nhật thông tin CLB
 */
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,      // 5MB
    maxRequestSize = 10 * 1024 * 1024   // 10MB
)
public class UpdateClubServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads";
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Get clubId
            String clubIdParam = request.getParameter("clubId");
            
            if (clubIdParam == null || clubIdParam.isEmpty()) {
                request.setAttribute("error", "Club ID không hợp lệ.");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            int clubId = Integer.parseInt(clubIdParam);
            ClubDAO clubDAO = new ClubDAO();
            Club club = clubDAO.getClubById(clubId);
            
            if (club == null) {
                request.setAttribute("error", "CLB không tồn tại.");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // ✅ CHECK PERMISSIONS: Only Admin or Club Leader can edit
            HttpSession session = request.getSession(false);
            
            // Check if user is logged in
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=login_required&redirect=updateClub&clubId=" + clubId);
                return;
            }
            
            Integer userId = (Integer) session.getAttribute("userId");
            Integer roleId = (Integer) session.getAttribute("roleId");
            
            // Check permissions:
            // RoleID: 1 = Admin, 2 = ClubLeader, 3 = Member, 4 = User
            boolean hasPermission = false;
            
            if (roleId == 1) {
                // Admin can edit any club
                hasPermission = true;
            } else if (roleId == 2 || roleId == 3) {
                // Club Leader or Member: check if they are the leader of THIS club
                if (club.getCreatedBy() == userId) {
                    hasPermission = true;
                }
            }
            
            if (!hasPermission) {
                request.setAttribute("error", "Bạn không có quyền chỉnh sửa CLB này. Chỉ Admin hoặc Club Leader mới có quyền.");
                request.setAttribute("errorCode", "403");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Load all users for leader dropdown
            UserDAO userDAO = new UserDAO();
            List<User> allUsers = userDAO.getAllUsers();
            
            // Set attributes
            request.setAttribute("club", club);
            request.setAttribute("allUsers", allUsers);
            
            request.getRequestDispatcher("/view/club/edit-club.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            // Get form data
            int clubId = Integer.parseInt(request.getParameter("clubId"));
            String clubName = request.getParameter("clubName");
            String description = request.getParameter("description");
            String clubTypes = request.getParameter("clubTypes");
            String status = request.getParameter("status");
            String newLeaderIdParam = request.getParameter("newLeaderId");
            String currentLogo = request.getParameter("currentLogo");
            
            // ✅ CHECK PERMISSIONS FIRST
            HttpSession session = request.getSession(false);
            
            // Check if user is logged in
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=login_required");
                return;
            }
            
            Integer currentUserId = (Integer) session.getAttribute("userId");
            Integer roleId = (Integer) session.getAttribute("roleId");
            
            // Validate
            if (clubName == null || clubName.trim().isEmpty()) {
                request.setAttribute("error", "Tên CLB không được để trống.");
                doGet(request, response);
                return;
            }
            
            // Get existing club
            ClubDAO clubDAO = new ClubDAO();
            Club club = clubDAO.getClubById(clubId);
            
            if (club == null) {
                request.setAttribute("error", "CLB không tồn tại.");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // ✅ Verify permission again (double check)
            boolean hasPermission = false;
            if (roleId == 1) {
                hasPermission = true; // Admin
            } else if (roleId == 2 || roleId == 3) {
                if (club.getCreatedBy() == currentUserId) {
                    hasPermission = true; // Club Leader
                }
            }
            
            if (!hasPermission) {
                request.setAttribute("error", "Bạn không có quyền chỉnh sửa CLB này.");
                request.setAttribute("errorCode", "403");
                request.getRequestDispatcher("/view/error.jsp").forward(request, response);
                return;
            }
            
            // Handle logo upload
            Part filePart = request.getPart("logo");
            String newLogo = currentLogo; // Default to current logo
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = filePart.getSubmittedFileName();
                
                // Validate file
                if (!isValidFileExtension(fileName)) {
                    request.setAttribute("error", "Chỉ chấp nhận file ảnh: JPG, JPEG, PNG, GIF, WEBP");
                    doGet(request, response);
                    return;
                }
                
                if (filePart.getSize() > MAX_FILE_SIZE) {
                    request.setAttribute("error", "Kích thước file không được vượt quá 5MB");
                    doGet(request, response);
                    return;
                }
                
                // Save new logo
                String uniqueFileName = generateUniqueFileName(fileName);
                String uploadPath = getServletContext().getRealPath("/" + UPLOAD_DIR);
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                String filePath = uploadPath + File.separator + uniqueFileName;
                try (InputStream input = filePart.getInputStream()) {
                    Files.copy(input, new File(filePath).toPath());
                }
                
                newLogo = UPLOAD_DIR + "/" + uniqueFileName;
                
                // Delete old logo if it exists and is in uploads folder
                if (currentLogo != null && currentLogo.startsWith(UPLOAD_DIR)) {
                    try {
                        String oldFilePath = getServletContext().getRealPath("/" + currentLogo);
                        Files.deleteIfExists(new File(oldFilePath).toPath());
                    } catch (Exception ex) {
                        System.err.println("Could not delete old logo: " + ex.getMessage());
                    }
                }
            }
            
            // Handle leader change
            if (newLeaderIdParam != null && !newLeaderIdParam.trim().isEmpty()) {
                int newLeaderId = Integer.parseInt(newLeaderIdParam);
                if (newLeaderId != club.getCreatedBy()) {
                    club.setCreatedBy(newLeaderId);
                }
            }
            
            // Update club info
            club.setClubName(clubName);
            club.setDescription(description);
            club.setClubTypes(clubTypes);
            club.setStatus(status);
            club.setLogo(newLogo);
            
            // Update in database
            boolean success = clubDAO.updateClub(club);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/updateClub?clubId=" + clubId + "&success=true");
            } else {
                request.setAttribute("error", "Cập nhật thất bại. Vui lòng thử lại.");
                request.setAttribute("club", club);
                doGet(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Check if file extension is allowed
     */
    private boolean isValidFileExtension(String fileName) {
        if (fileName == null) return false;
        
        String extension = fileName.toLowerCase();
        for (String allowedExt : ALLOWED_EXTENSIONS) {
            if (extension.endsWith(allowedExt)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Generate unique file name to avoid conflicts
     */
    private String generateUniqueFileName(String originalFileName) {
        String extension = "";
        int lastDotIndex = originalFileName.lastIndexOf('.');
        if (lastDotIndex > 0) {
            extension = originalFileName.substring(lastDotIndex);
        }
        
        String uniqueId = UUID.randomUUID().toString();
        return uniqueId + extension;
    }
}

