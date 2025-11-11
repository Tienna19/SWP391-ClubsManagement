package controller;

import dal.TokenForgetDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.TokenForgetPassword;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(name = "resetPassword", urlPatterns = {"/resetPassword"})
public class resetPasswordServlet extends HttpServlet {
    private final TokenForgetDAO Token = new TokenForgetDAO();
    private final UserDAO User = new UserDAO();

    // Regex kiểm tra độ mạnh mật khẩu
    private static final String PASSWORD_REGEX =
            "^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(PASSWORD_REGEX);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        HttpSession session = request.getSession();
        if (token != null) {
            TokenForgetPassword tokenForgetPassword = Token.getTokenPassword(token);
            resetService service = new resetService();

            if (tokenForgetPassword == null) {
                request.setAttribute("mess", "Token không hợp lệ!");
                request.getRequestDispatcher("view/auth/requestPassword.jsp").forward(request, response);
                return;
            }
            if (tokenForgetPassword.isIsUsed()) {
                request.setAttribute("mess", "Token đã được sử dụng!");
                request.getRequestDispatcher("view/auth/requestPassword.jsp").forward(request, response);
                return;
            }
            if (service.isExpireTime(tokenForgetPassword.getExpiryTime())) {
                request.setAttribute("mess", "Token đã hết hạn!");
                request.getRequestDispatcher("view/auth/requestPassword.jsp").forward(request, response);
                return;
            }

            User user = User.getUserById(tokenForgetPassword.getUserId());
            request.setAttribute("email", user.getEmail());
            session.setAttribute("token", tokenForgetPassword.getToken());
            request.getRequestDispatcher("view/auth/resetPassword.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("view/auth/requestPassword.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // 1️⃣ Kiểm tra trống
        if (email == null || password == null || confirmPassword == null
                || email.isEmpty() || password.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("mess", "Vui lòng nhập đầy đủ thông tin!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("view/auth/resetPassword.jsp").forward(request, response);
            return;
        }

        // 2️⃣ Kiểm tra khớp mật khẩu
        if (!password.equals(confirmPassword)) {
            request.setAttribute("mess", "Mật khẩu nhập lại không khớp!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("view/auth/resetPassword.jsp").forward(request, response);
            return;
        }

        // 3️⃣ Kiểm tra độ mạnh mật khẩu
        if (!PASSWORD_PATTERN.matcher(password).matches()) {
            request.setAttribute("mess", 
                "Mật khẩu phải có ít nhất 8 ký tự, gồm 1 chữ hoa, 1 số và 1 ký tự đặc biệt.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("view/auth/resetPassword.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        String tokenStr = (String) session.getAttribute("token");
        TokenForgetPassword tokenForgetPassword = Token.getTokenPassword(tokenStr);

        // 4️⃣ Kiểm tra token hợp lệ
        resetService service = new resetService();
        if (tokenForgetPassword == null) {
            request.setAttribute("mess", "Token không hợp lệ!");
            request.getRequestDispatcher("view/auth/requestPassword.jsp").forward(request, response);
            return;
        }
        if (tokenForgetPassword.isIsUsed()) {
            request.setAttribute("mess", "Token đã được sử dụng!");
            request.getRequestDispatcher("view/auth/requestPassword.jsp").forward(request, response);
            return;
        }
        if (service.isExpireTime(tokenForgetPassword.getExpiryTime())) {
            request.setAttribute("mess", "Token đã hết hạn!");
            request.getRequestDispatcher("view/auth/requestPassword.jsp").forward(request, response);
            return;
        }

        // 5️⃣ Hash mật khẩu và cập nhật DB
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        boolean updated = User.updatePasswordByEmail(email, hashedPassword);

        if (updated) {
            // Cập nhật token thành đã dùng
            tokenForgetPassword.setToken(tokenStr);
            tokenForgetPassword.setIsUsed(true);
            Token.updateStatus(tokenForgetPassword);

            session.removeAttribute("token");
            request.setAttribute("message", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
        } else {
            request.setAttribute("mess", "Có lỗi xảy ra khi cập nhật mật khẩu!");
            request.setAttribute("email", email);
            request.getRequestDispatcher("view/auth/resetPassword.jsp").forward(request, response);
        }
    }
}
