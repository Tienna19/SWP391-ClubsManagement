package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.regex.Pattern;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/change-password"})
public class ChangePasswordServlet extends HttpServlet {

    // Regex kiểm tra độ mạnh của mật khẩu
    private static final String PASSWORD_REGEX =
            "^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(PASSWORD_REGEX);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User account = (session != null) ? (User) session.getAttribute("account") : null;

        if (account == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy lại thông tin user để hiển thị sidebar
        request.setAttribute("userInfo", account);
        request.getRequestDispatcher("view/user/changePassword.jsp").forward(request, response);
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

        // Lấy dữ liệu từ form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        UserDAO dao = new UserDAO();

        // 1️⃣ Kiểm tra trống
        if (currentPassword == null || newPassword == null || confirmPassword == null
                || currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.setAttribute("userInfo", account);
            request.getRequestDispatcher("view/user/changePassword.jsp").forward(request, response);
            return;
        }

        // 2️⃣ Kiểm tra mật khẩu hiện tại
        if (!BCrypt.checkpw(currentPassword, account.getPasswordHash())) {
            request.setAttribute("error", "Mật khẩu hiện tại không chính xác!");
            request.setAttribute("userInfo", account);
            request.getRequestDispatcher("view/user/changePassword.jsp").forward(request, response);
            return;
        }

        // 3️⃣ Kiểm tra khớp giữa mật khẩu mới và xác nhận
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu nhập lại không khớp!");
            request.setAttribute("userInfo", account);
            request.getRequestDispatcher("view/user/changePassword.jsp").forward(request, response);
            return;
        }

        // 4️⃣ Kiểm tra độ mạnh mật khẩu mới
        if (!PASSWORD_PATTERN.matcher(newPassword).matches()) {
            request.setAttribute("error",
                    "Mật khẩu phải có ít nhất 8 ký tự, gồm 1 chữ hoa, 1 số và 1 ký tự đặc biệt.");
            request.setAttribute("userInfo", account);
            request.getRequestDispatcher("view/user/changePassword.jsp").forward(request, response);
            return;
        }

        // 5️⃣ Hash và cập nhật mật khẩu mới
        String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        boolean updated = dao.updatePassword(account.getUserId(), hashedNewPassword);

        if (updated) {
            // Cập nhật lại trong session
            account.setPasswordHash(hashedNewPassword);
            session.setAttribute("account", account);

            request.setAttribute("message", "Đổi mật khẩu thành công!");
        } else {
            request.setAttribute("error", "Đã xảy ra lỗi khi cập nhật mật khẩu. Vui lòng thử lại!");
        }

        request.setAttribute("userInfo", account);
        request.getRequestDispatcher("view/user/changePassword.jsp").forward(request, response);
    }
}
