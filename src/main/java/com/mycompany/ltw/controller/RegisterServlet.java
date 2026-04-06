package com.mycompany.ltw.controller;


import com.mycompany.ltw.dao.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.mycompany.ltw.model.User;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    // 1. Khi người dùng gõ link /register hoặc nhấn vào nút "Đăng ký"
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Mở trang giao diện đăng ký
        request.getRequestDispatcher("/WEB-INF/Views/register.jsp").forward(request, response);
    }

    // 2. Khi người dùng nhấn nút "Submit" trên Form đăng ký
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    // 1. Lấy dữ liệu từ Form
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String password = request.getParameter("password");


 

    // 3. Đóng gói thông tin
    User newUser = new User();
    newUser.setFirstName(firstName);
    newUser.setLastName(lastName);
    newUser.setEmail(email);
    newUser.setPassword(password);

    UserDAO dao = new UserDAO();
    boolean isRegistered = dao.register(newUser);

    if (isRegistered) {
        // --- BẮT ĐẦU LOGIC TỰ ĐỘNG ĐĂNG NHẬP ---
        // Gọi lại hàm login để lấy Object User đầy đủ (có ID và Roles từ DB)
        User authenticatedUser = dao.login(email, password);
        
        if (authenticatedUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", authenticatedUser);
            
            // Đăng ký xong, đăng nhập luôn và đẩy về trang chủ
            response.sendRedirect("home"); 
        } else {
            // Trường hợp hy hữu: Đăng ký được nhưng login lỗi
            response.sendRedirect(request.getContextPath() + "/login?message=registered_please_login");

        }
        // --- KẾT THÚC LOGIC TỰ ĐỘNG ĐĂNG NHẬP ---
    } else {
        request.setAttribute("error", "Email này đã được sử dụng!");
        request.getRequestDispatcher("/WEB-INF/Views/register.jsp").forward(request, response);
    }
}
}
