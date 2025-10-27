package controller.admin;

import dal.CreateClubRequestDAO;
import dal.ClubDAO;
import dal.MembershipDAO;
import model.CreateClubRequest;
import model.Club;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;

/**
 * Approve/Reject Club Request Servlet - Admin phê duyệt hoặc từ chối yêu cầu
 */
public class ApproveClubRequestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // ✅ Check if user is Admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=login_required");
            return;
        }

        Integer adminId = (Integer) session.getAttribute("userId");
        Integer roleId = (Integer) session.getAttribute("roleId");
        
        if (roleId == null || roleId != 1) {  // RoleID 1 = Admin
            request.setAttribute("error", "Chỉ Admin mới có quyền phê duyệt yêu cầu tạo CLB.");
            request.setAttribute("errorCode", "403");
            request.getRequestDispatcher("/view/error.jsp").forward(request, response);
            return;
        }

        try {
            // Get form data
            String requestIdStr = request.getParameter("requestId");
            String action = request.getParameter("action");  // "approve" or "reject"
            String reviewComment = request.getParameter("reviewComment");

            if (requestIdStr == null || action == null) {
                throw new IllegalArgumentException("Thiếu thông tin yêu cầu");
            }

            int requestId = Integer.parseInt(requestIdStr);

            // Get request from database
            CreateClubRequestDAO requestDAO = new CreateClubRequestDAO();
            CreateClubRequest clubRequest = requestDAO.getRequestById(requestId);

            if (clubRequest == null) {
                throw new Exception("Không tìm thấy yêu cầu với ID: " + requestId);
            }

            if (!"Pending".equals(clubRequest.getStatus())) {
                throw new Exception("Yêu cầu đã được xử lý trước đó");
            }

            if ("approve".equals(action)) {
                // ✅ APPROVE: Create Club + Add creator to Memberships
                handleApproval(clubRequest, adminId, reviewComment, requestDAO);
                session.setAttribute("successMessage", 
                    "Đã phê duyệt yêu cầu! CLB '" + clubRequest.getClubName() + "' đã được tạo.");
            } else if ("reject".equals(action)) {
                // ❌ REJECT: Just update status
                handleRejection(clubRequest, adminId, reviewComment, requestDAO);
                session.setAttribute("successMessage", 
                    "Đã từ chối yêu cầu tạo CLB '" + clubRequest.getClubName() + "'.");
            } else {
                throw new IllegalArgumentException("Action không hợp lệ: " + action);
            }

            // Redirect back to requests list
            response.sendRedirect(request.getContextPath() + "/viewClubRequests");

        } catch (NumberFormatException e) {
            handleError(request, response, "Dữ liệu không hợp lệ: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            handleError(request, response, e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            handleError(request, response, "Lỗi khi xử lý yêu cầu: " + e.getMessage());
        }
    }

    /**
     * Handle approval: Create Club + Add creator to Memberships
     */
    private void handleApproval(CreateClubRequest clubRequest, int adminId, 
                               String reviewComment, CreateClubRequestDAO requestDAO) 
                               throws Exception {
        
        // 1. Create Club object
        Club newClub = new Club();
        newClub.setClubName(clubRequest.getClubName());
        newClub.setDescription(clubRequest.getDescription());
        newClub.setLogo(clubRequest.getLogo());
        newClub.setClubTypes(clubRequest.getClubTypes());
        newClub.setCreatedBy(clubRequest.getRequestedBy());  // Original requester
        newClub.setStatus("Active");
        newClub.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        // 2. Insert Club and get ClubID
        ClubDAO clubDAO = new ClubDAO();
        int newClubId = clubDAO.insertClubAndGetId(newClub);

        if (newClubId <= 0) {
            throw new Exception("Lỗi khi tạo CLB trong database");
        }

        // 3. Add creator to Memberships as Leader
        MembershipDAO membershipDAO = new MembershipDAO();
        boolean memberAdded = membershipDAO.addMemberToClub(
            clubRequest.getRequestedBy(),  // userId
            newClubId,                     // clubId
            "Leader",                      // roleInClub
            "Active"                       // status
        );

        if (!memberAdded) {
            System.err.println("⚠️ Warning: Club created but failed to add creator to Memberships!");
            // Continue anyway - club is created
        }

        // 4. Update request status to Approved
        boolean updated = requestDAO.updateRequestStatus(
            clubRequest.getRequestId(),
            "Approved",
            adminId,
            reviewComment != null ? reviewComment : "Yêu cầu đã được phê duyệt",
            newClubId  // Link to created club
        );

        if (!updated) {
            throw new Exception("Lỗi khi cập nhật trạng thái yêu cầu");
        }

        System.out.println("✅ Request " + clubRequest.getRequestId() + 
                          " approved. Club created with ID: " + newClubId);
    }

    /**
     * Handle rejection: Just update status
     */
    private void handleRejection(CreateClubRequest clubRequest, int adminId, 
                                String reviewComment, CreateClubRequestDAO requestDAO) 
                                throws Exception {
        
        boolean updated = requestDAO.updateRequestStatus(
            clubRequest.getRequestId(),
            "Rejected",
            adminId,
            reviewComment != null ? reviewComment : "Yêu cầu bị từ chối",
            null  // No club created
        );

        if (!updated) {
            throw new Exception("Lỗi khi cập nhật trạng thái yêu cầu");
        }

        System.out.println("❌ Request " + clubRequest.getRequestId() + " rejected");
    }

    /**
     * Handle errors
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, 
                           String errorMessage) throws ServletException, IOException {
        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher("/view/error.jsp").forward(request, response);
    }
}

