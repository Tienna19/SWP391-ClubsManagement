package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.regex.Pattern;
import model.User;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    // Regex kiểm tra độ mạnh của passwordHash
    private static final String PASSWORD_REGEX
            = "^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(PASSWORD_REGEX);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String passwordHash = request.getParameter("passwordHash");
        String confirmHash = request.getParameter("confirmHash");

        UserDAO dao = new UserDAO();

        // 1️⃣ Kiểm tra mật khẩu nhập lại
        if (!passwordHash.equals(confirmHash)) {
            request.setAttribute("error", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
            return;
        }

        // 2️⃣ Kiểm tra độ mạnh của mật khẩu
        if (!PASSWORD_PATTERN.matcher(passwordHash).matches()) {
            request.setAttribute("error",
                    "Mật khẩu phải có ít nhất 8 ký tự, bao gồm 1 chữ hoa, 1 chữ số và 1 ký tự đặc biệt.");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
            return;
        }

        // 3️⃣ Kiểm tra email đã tồn tại
        if (dao.checkUserExist(email)) {
            request.setAttribute("error", "Email đã tồn tại!");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
            return;
        }

        // 4️⃣ Tạo đối tượng user mới
        // roleId = 1 (User)
        User newUser = new User(
                fullName,
                email,
                passwordHash, // sẽ được hash trong UserDAO.register()
                null, // phone
                null, // address
                null, // gender
                1, // roleId
                null // profileImage (default avatar)
        );

        // 5️⃣ Gọi DAO để lưu vào DB
        boolean success = dao.register(newUser);

        if (success) {
            HttpSession session = request.getSession();
            
            // Set user information in session
            session.setAttribute("account", newUser);
            session.setAttribute("userId", newUser.getUserId());
            session.setAttribute("roleId", newUser.getRoleId());
            session.setAttribute("fullName", newUser.getFullName());
            session.setAttribute("email", newUser.getEmail());
            
            response.sendRedirect("home");
        } else {
            request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại!");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
        }
    }
}
