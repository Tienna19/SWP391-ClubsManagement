package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.regex.Pattern;
import model.User;

@WebServlet(name="RegisterServlet", urlPatterns={"/register"})
public class RegisterServlet extends HttpServlet {

    // Regex kiểm tra mật khẩu
    private static final String PASSWORD_REGEX = 
        "^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
    private static final Pattern PASSWORD_PATTERN = Pattern.compile(PASSWORD_REGEX);

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");

        UserDAO dao = new UserDAO();

        if (!password.equals(confirm)) {
            request.setAttribute("error", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
            return;
        }

        if (!PASSWORD_PATTERN.matcher(password).matches()) {
            request.setAttribute("error", 
                "Mật khẩu phải có ít nhất 8 ký tự, bao gồm 1 chữ hoa, 1 chữ số và 1 ký tự đặc biệt.");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
            return;
        }

        if (dao.checkUserExist(email)) {
            request.setAttribute("error", "Email đã tồn tại!");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
            return;
        }

        User newUser = new User(0, username, password, email, "member");
        if (dao.register(newUser)) {
            request.setAttribute("message", "Đăng ký thành công! Mời bạn đăng nhập.");
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại!");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
        }
    }
}