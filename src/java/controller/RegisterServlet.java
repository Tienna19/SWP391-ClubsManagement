package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebServlet(name="RegisterServlet", urlPatterns={"/register"})
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.getRequestDispatcher("view/register.jsp").forward(request, response);
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
            request.getRequestDispatcher("view/register.jsp").forward(request, response);
            return;
        }
        
        if (dao.checkUserExist(email)) {
            request.setAttribute("error", "Email đã tồn tại!");
            request.getRequestDispatcher("view/register.jsp").forward(request, response);
            return;
        }

        User newUser = new User(0, username, password, email, "member");
        if (dao.register(newUser)) {
            request.setAttribute("message", "Đăng ký thành công! Mời bạn đăng nhập.");
            request.getRequestDispatcher("view/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại!");
            request.getRequestDispatcher("view/register.jsp").forward(request, response);
        }
    }
}
