package com.mycompany.ltw.utils;


import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import com.mycompany.ltw.model.User;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/profile"})
public class AuthFilter implements Filter {
    /*
     * AuthFilter (hỗ trợ Module 5.2):
     * - Chặn người chưa đăng nhập truy cập /profile và /admin/*
     * - Kiểm tra ROLE_ADMIN khi truy cập URL admin
     *
     * Input: HttpSession + request URI
     * Output:
     * - Cho đi tiếp (chain.doFilter) nếu hợp lệ
     * - Redirect /login hoặc /access-denied.jsp nếu không hợp lệ
     */

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        // Lấy thông tin user từ session đã lưu ở LoginServlet
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // Chưa đăng nhập -> Chặn lại và đẩy về trang Login
            res.sendRedirect(req.getContextPath() + "/login");
        } else {
            // Đã đăng nhập -> Kiểm tra xem có quyền Admin không nếu muốn vào /admin
            String uri = req.getRequestURI();
            if (uri.contains("/admin/")) {
                boolean isAdmin = user.getRoles().stream().anyMatch(r -> r.getName().equals("ROLE_ADMIN"));
                if (isAdmin) {
                    chain.doFilter(request, response); // Cho phép đi tiếp
                } else {
                    res.sendRedirect(req.getContextPath() + "/access-denied.jsp"); // Không đủ quyền
                }
            } else {
                chain.doFilter(request, response); // Các trang User bình thường thì cho qua
            }
        }
    }

    @Override public void init(FilterConfig filterConfig) throws ServletException {}
    @Override public void destroy() {}
}
