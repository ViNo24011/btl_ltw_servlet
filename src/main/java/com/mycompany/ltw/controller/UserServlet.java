package com.mycompany.ltw.controller;

import com.mycompany.ltw.dao.BookingDAO;
import com.mycompany.ltw.dao.UserDAO;
import com.mycompany.ltw.model.Booking;
import com.mycompany.ltw.model.Role;
import com.mycompany.ltw.model.User;
import com.mycompany.ltw.model.Voucher;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "UserServlet", urlPatterns = {
    "/profile", "/profile/edit", "/vouchers",
    "/admin/users", "/admin/users/create", "/admin/users/edit", "/admin/users/delete"
})
public class UserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    // Dieu huong GET theo tung endpoint cua user/admin.
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/profile":
                showProfile(request, response, false);
                break;
            case "/profile/edit":
                showProfile(request, response, true);
                break;
            case "/vouchers":
                showVouchers(request, response);
                break;           
            case "/admin/users":
                showUsersForAdmin(request, response);
                break;
            case "/admin/users/create":
                showUserFormForAdmin(request, response, null);
                break;
            case "/admin/users/edit":
                Long userId = parseLong(request.getParameter("id"));
                showUserFormForAdmin(request, response, userId);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // Dieu huong POST cho cac thao tac cap nhat/CRUD.
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/profile/edit":
                updateProfile(request, response);
                break;
            case "/admin/users/create":
                createUserByAdmin(request, response);
                break;
            case "/admin/users/edit":
                updateUserByAdmin(request, response);
                break;
            case "/admin/users/delete":
                deleteUserByAdmin(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // Hien thi ho so user va thong tin thong ke booking/nhom KH.
    private void showProfile(HttpServletRequest request, HttpServletResponse response, boolean editMode)
            throws ServletException, IOException {
        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = userDAO.findById(sessionUser.getId());
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int totalBookings = userDAO.countBookingsByUserId(user.getId());
        String customerGroup = userDAO.calculateCustomerGroup(user.getId());

        request.setAttribute("profileUser", user);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("customerGroup", customerGroup);
        request.setAttribute("editMode", editMode);
        request.getRequestDispatcher("/WEB-INF/Views/profile.jsp").forward(request, response);
    }

    // Cap nhat thong tin co ban cua ho so ca nhan.
    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");

        if (userDAO.isEmailExists(email, sessionUser.getId())) {
            request.setAttribute("error", "Email đã được sử dụng bới tài khoản khác.");
            showProfile(request, response, true);
            return;
        }

        User updated = new User();
        updated.setId(sessionUser.getId());
        updated.setFirstName(firstName);
        updated.setLastName(lastName);
        updated.setEmail(email);

        boolean ok = userDAO.updateProfile(updated);
        if (ok) {
            User fresh = userDAO.findById(sessionUser.getId());
            HttpSession session = request.getSession();
            session.setAttribute("user", fresh);
            response.sendRedirect(request.getContextPath() + "/profile?success=updated");
        } else {
            request.setAttribute("error", "Cập nhật hồ sơ thất bại.");
            showProfile(request, response, true);
        }
    }

    // Hien thi danh sach voucher kha dung va thong bao voucher moi.
    private void showVouchers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User sessionUser = getSessionUser(request);
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Voucher> vouchers = userDAO.getAvailableVouchersForUser(sessionUser.getId());
        String group = userDAO.calculateCustomerGroup(sessionUser.getId());

        HttpSession session = request.getSession();
        Integer lastSeenCount = (Integer) session.getAttribute("lastVoucherCount");
        if (lastSeenCount != null && vouchers.size() > lastSeenCount) {
            request.setAttribute("newVoucherMessage", "Bạn có voucher mới.");
        }
        session.setAttribute("lastVoucherCount", vouchers.size());

        request.setAttribute("customerGroup", group);
        request.setAttribute("vouchers", vouchers);
        request.getRequestDispatcher("/WEB-INF/Views/voucher.jsp").forward(request, response);
    }

    // Hien thi danh sach user cho admin.
    private void showUsersForAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User sessionUser = getSessionUser(request);
        if (!isAdmin(sessionUser)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/WEB-INF/Views/user.jsp").forward(request, response);
    }

    // Hien thi form them/sua user cho admin.
    private void showUserFormForAdmin(HttpServletRequest request, HttpServletResponse response, Long userId)
            throws ServletException, IOException {
        User sessionUser = getSessionUser(request);
        if (!isAdmin(sessionUser)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        if (userId != null) {
            User user = userDAO.findById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=not_found");
                return;
            }
            request.setAttribute("formUser", user);
            if (user.getRoles() != null && !user.getRoles().isEmpty()) {
                request.setAttribute("currentRole", user.getRoles().get(0).getName());
            }
        }

        request.getRequestDispatcher("/WEB-INF/Views/user-form.jsp").forward(request, response);
    }

    // Tao tai khoan moi tu man hinh admin.
    private void createUserByAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        User sessionUser = getSessionUser(request);
        if (!isAdmin(sessionUser)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleName = request.getParameter("roleName");
        boolean isActive = "on".equals(request.getParameter("isActive"));

        if (userDAO.isEmailExists(email, null)) {
            request.setAttribute("error", "Email đã tồn tại.");
            showUserFormForAdmin(request, response, null);
            return;
        }

        User newUser = new User();
        newUser.setFirstName(firstName);
        newUser.setLastName(lastName);
        newUser.setEmail(email);
        newUser.setPassword(password);
        newUser.setIsActive(isActive);

        boolean ok = userDAO.createUserByAdmin(newUser, roleName);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=created");
        } else {
            request.setAttribute("error", "Thêm tài khoản thất bại.");
            showUserFormForAdmin(request, response, null);
        }
    }

    // Cap nhat thong tin va quyen user tu man hinh admin.
    private void updateUserByAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        User sessionUser = getSessionUser(request);
        if (!isAdmin(sessionUser)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Long id = parseLong(request.getParameter("id"));
        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid_id");
            return;
        }

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleName = request.getParameter("roleName");
        boolean isActive = "on".equals(request.getParameter("isActive"));

        if (userDAO.isEmailExists(email, id)) {
            request.setAttribute("error", "Email dã tồn tại.");
            showUserFormForAdmin(request, response, id);
            return;
        }

        User user = new User();
        user.setId(id);
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setIsActive(isActive);

        boolean ok = userDAO.updateUserByAdmin(user, roleName, password);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=updated");
        } else {
            request.setAttribute("error", "Cập nhật tài khoản thất bại.");
            showUserFormForAdmin(request, response, id);
        }
    }

    // Xoa tai khoan user do admin yeu cau (tru chinh minh).
    private void deleteUserByAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User sessionUser = getSessionUser(request);
        if (!isAdmin(sessionUser)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Long id = parseLong(request.getParameter("id"));
        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid_id");
            return;
        }

        if (sessionUser.getId().equals(id)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=cannot_delete_self");
            return;
        }

        boolean ok = userDAO.deleteUserByAdmin(id);
        response.sendRedirect(request.getContextPath() + "/admin/users?" + (ok ? "success=deleted" : "error=delete_failed"));
    }
    

    // Lay user dang dang nhap tu session hien tai.
    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }

    // Kiem tra user co quyen ROLE_ADMIN hay khong.
    private boolean isAdmin(User user) {
        if (user == null || user.getRoles() == null) {
            return false;
        }
        for (Role role : user.getRoles()) {
            if ("ROLE_ADMIN".equals(role.getName())) {
                return true;
            }
        }
        return false;
    }

    // Parse chuoi sang Long, loi thi tra null.
    private Long parseLong(String value) {
        try {
            return Long.parseLong(value);
        } catch (Exception e) {
            return null;
        }
    }
}
