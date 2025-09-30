package controller;

import dal.ClubDAO;
import dal.EventDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name="HomeServlet", urlPatterns={"/home"})
public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        ClubDAO cdao = new ClubDAO();
        EventDAO edao = new EventDAO();

        request.setAttribute("events", edao.getAllEvents());

        request.getRequestDispatcher("view/home/index.jsp").forward(request, response);
    }
}