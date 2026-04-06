package com.mycompany.ltw.controller;


import com.mycompany.ltw.dao.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.mycompany.ltw.model.User;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Trả về trang giao diện đăng nhập
        request.getRequestDispatcher("/WEB-INF/Views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(email, pass);

        if (user != null) {
            // Đăng nhập thành công -> Tạo Session
            HttpSession session = request.getSession();
            session.setAttribute("user", user); // Lưu đối tượng User vào "thẻ định danh"

            // Kiểm tra nếu là Admin thì đá sang trang quản trị, ngược lại về trang chủ
            boolean isAdmin = user.getRoles().stream().anyMatch(r -> r.getName().equals("ROLE_ADMIN"));
            if (isAdmin) {
                response.sendRedirect("admin/dashboard");
            } else {
                response.sendRedirect("home");
            }
        } else {
            // Thất bại
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("/WEB-INF/Views/login.jsp").forward(request, response);
        }
    }
}