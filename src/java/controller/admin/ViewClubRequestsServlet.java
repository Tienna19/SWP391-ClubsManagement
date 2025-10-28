package controller.admin;

import dal.CreateClubRequestDAO;
import model.CreateClubRequest;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * View Club Requests Servlet - Admin xem danh sách yêu cầu tạo CLB
 */
public class ViewClubRequestsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // ✅ Check if user is Admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=login_required");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        Integer roleId = (Integer) session.getAttribute("roleId");
        String fullName = (String) session.getAttribute("fullName");
        
        // DEBUG: Log session info
        System.out.println("=== VIEW CLUB REQUESTS - SESSION INFO ===");
        System.out.println("User ID: " + userId);
        System.out.println("Role ID: " + roleId);
        System.out.println("Full Name: " + fullName);
        System.out.println("=========================================");
        
        if (roleId == null || roleId != 1) {  // RoleID 1 = Admin
            System.err.println("❌ ACCESS DENIED - Role ID: " + roleId + " (expected: 1)");
            request.setAttribute("error", "Chỉ Admin mới có quyền xem danh sách yêu cầu tạo CLB.");
            request.setAttribute("errorCode", "403");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }
        
        System.out.println("✅ Admin access granted - Role ID: " + roleId);

        try {
            CreateClubRequestDAO dao = new CreateClubRequestDAO();
            
            // Get filter parameter
            String statusFilter = request.getParameter("status");
            List<CreateClubRequest> requests;
            
            if (statusFilter != null && !statusFilter.isEmpty() && !"All".equals(statusFilter)) {
                // Filter by status
                requests = dao.getRequestsByStatus(statusFilter);
            } else {
                // Get all requests
                requests = dao.getAllRequests();
            }

            // Get counts for badges
            int pendingCount = dao.getCountByStatus("Pending");
            int approvedCount = dao.getCountByStatus("Approved");
            int rejectedCount = dao.getCountByStatus("Rejected");

            // Set attributes
            request.setAttribute("requests", requests);
            request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "All");
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("rejectedCount", rejectedCount);

            // Forward to JSP
            request.getRequestDispatcher("/view/admin/admin-club-requests.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách yêu cầu: " + e.getMessage());
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
        }
    }
}

