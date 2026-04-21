package com.mycompany.ltw.controller;

import com.mycompany.ltw.dao.UserDAO;
import com.mycompany.ltw.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/Views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        if (dao.isEmailExists(email, null)) {
            request.setAttribute("error", "Email này đã được sử dụng!");
            request.getRequestDispatcher("/WEB-INF/Views/register.jsp").forward(request, response);
            return;
        }

        User newUser = new User();
        newUser.setFirstName(firstName);
        newUser.setLastName(lastName);
        newUser.setEmail(email);
        newUser.setPassword(password);

        boolean isRegistered = dao.register(newUser);
        if (isRegistered) {
            User authenticatedUser = dao.login(email, password);
            if (authenticatedUser != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", authenticatedUser);
                response.sendRedirect("home");
            } else {
                response.sendRedirect(request.getContextPath() + "/login?message=registered_please_login");
            }
            return;
        }

        request.setAttribute("error", "Không thể đăng ký. Vui lòng thử lại.");
        request.getRequestDispatcher("/WEB-INF/Views/register.jsp").forward(request, response);
    }
}
