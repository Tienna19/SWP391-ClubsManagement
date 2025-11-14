package controller;

import dal.UserDAO;
import dal.MemberDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.User;

import com.google.api.client.googleapis.auth.oauth2.*;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.client.http.javanet.NetHttpTransport;

@WebServlet(name = "GoogleCallbackServlet", urlPatterns = {"/google-callback"})
public class GoogleCallbackServlet extends HttpServlet {

    private String CLIENT_ID;
    private String CLIENT_SECRET;
    private final String REDIRECT_URI = "http://localhost:9999/ClubManagerTest/google-callback";

    @Override
    public void init() throws ServletException {
        CLIENT_ID = getServletContext().getInitParameter("GOOGLE_CLIENT_ID");
        CLIENT_SECRET = getServletContext().getInitParameter("GOOGLE_CLIENT_SECRET");

        if (CLIENT_ID == null || CLIENT_SECRET == null) {
            throw new ServletException("Không tìm thấy cấu hình Google Client ID/Secret trong web.xml");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = request.getParameter("code");
        if (code == null || code.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/view/auth/login.jsp");
            return;
        }

        try {
            // Lấy token từ gg
            GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    new NetHttpTransport(),
                    GsonFactory.getDefaultInstance(),
                    CLIENT_ID,
                    CLIENT_SECRET,
                    code,
                    REDIRECT_URI
            ).execute();

            // Lấy tt user
            GoogleIdToken idToken = tokenResponse.parseIdToken();
            if (idToken == null) {
                throw new ServletException("Không thể xác thực với Google.");
            }

            GoogleIdToken.Payload payload = idToken.getPayload();
            String email = payload.getEmail();
            String name = (String) payload.get("name");
            String avatar = (String) payload.get("picture");

            // Log thông tin từ Google
            System.out.println("📧 Email từ Google: " + email);
            System.out.println("👤 Name từ Google: " + name);
            System.out.println("🖼️ Avatar từ Google: " + avatar);

            // Kiểm tra email
            if (email == null || email.trim().isEmpty()) {
                throw new ServletException("Không thể lấy email từ Google. Vui lòng thử lại!");
            }

            // Kiểm tra user mới
            UserDAO dao = new UserDAO();
            User user = dao.getUserByEmail(email);
            if (user == null) {
                System.out.println("🔄 User chưa tồn tại, đang tạo tài khoản mới: " + email);
                boolean inserted = dao.insertUserGoogle(name, email, avatar);
                if (inserted) {
                    System.out.println("✅ Đã tạo tài khoản thành công, đang lấy thông tin user...");
                    user = dao.getUserByEmail(email);
                    if (user == null) {
                        System.err.println("❌ Không thể lấy thông tin user sau khi tạo: " + email);
                        throw new ServletException("Tạo user mới thành công nhưng không thể lấy thông tin user. Vui lòng thử lại!");
                    }
                    System.out.println("✅ Đã lấy thông tin user thành công: " + user.getUserId());
                } else {
                    System.err.println("❌ Không thể tạo user mới: " + email);
                    // Kiểm tra lại xem user đã được tạo chưa (có thể do race condition)
                    user = dao.getUserByEmail(email);
                    if (user == null) {
                        throw new ServletException("Tạo user mới thất bại! Vui lòng kiểm tra log server để biết chi tiết lỗi.");
                    } else {
                        System.out.println("⚠️ User đã tồn tại sau khi insert thất bại (có thể do race condition)");
                    }
                }
            } else {
                System.out.println("✅ User đã tồn tại: " + email + " (UserID: " + user.getUserId() + ")");
            }

            // Tạo session
            HttpSession session = request.getSession(true);
            session.setAttribute("account", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("roleId", user.getRoleId());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("email", user.getEmail());

            // Redirect theo role
            String redirect = (String) session.getAttribute("redirect");
            String clubId = (String) session.getAttribute("clubId");
            String eventId = (String) session.getAttribute("eventId");

            int roleId = user.getRoleId();

            if ("clubDetail".equals(redirect) && clubId != null) {
                String url = "clubDetail?clubId=" + clubId + (eventId != null ? "&eventId=" + eventId : "");
                response.sendRedirect(url);
                return;
            }

            switch (roleId) {
                case 4 ->
                    response.sendRedirect(request.getContextPath() + "/adminDashboard"); // Admin
                case 3 -> { // Club Leader
                    MemberDAO memberDAO = new MemberDAO();
                    List<Integer> clubIds = memberDAO.getClubsWhereUserIsLeader(user.getUserId());
                    if (!clubIds.isEmpty()) {
                        Integer leaderClubId = clubIds.get(0);
                        session.setAttribute("currentClubId", leaderClubId);
                        response.sendRedirect(request.getContextPath() + "/clubDashboard?clubId=" + leaderClubId);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/home");
                    }
                }
                default ->
                    response.sendRedirect(request.getContextPath() + "/home"); // User khác
            }

        } catch (Exception e) {
            System.err.println("❌ Lỗi trong GoogleCallbackServlet:");
            System.err.println("   Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Đăng nhập Google thất bại: " + e.getMessage() + ". Vui lòng thử lại!");
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
        }
    }
}
