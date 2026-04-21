package com.mycompany.ltw.controller;

import com.mycompany.ltw.dao.RoomTypeDAO;
import com.mycompany.ltw.model.RoomType;
import com.mycompany.ltw.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "RoomTypeServlet", urlPatterns = { "/roomtype" })
public class RoomTypeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        User user = getSessionUser(req);

        if (!isAdmin(user)) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        RoomTypeDAO dao = new RoomTypeDAO();
        String action = req.getParameter("action");

        if (action == null)
            action = "list";

        switch (action) {

            // ================= LIST =================
            case "list":
                List<RoomType> list = dao.getAll();
                req.setAttribute("roomTypes", list);
                req.getRequestDispatcher("/WEB-INF/Views/roomtype.jsp").forward(req, resp);
                break;

            // ================= EDIT =================
            case "edit":
                long editId = Long.parseLong(req.getParameter("id"));
                RoomType rt = dao.getById(editId);

                req.setAttribute("type", rt);
                req.setAttribute("roomTypes", dao.getAll());
                req.getRequestDispatcher("/WEB-INF/Views/roomtype.jsp").forward(req, resp);
                break;

            // ================= DELETE (FIX CHÍNH) =================
            case "delete":
                long deleteId = Long.parseLong(req.getParameter("id"));

                if (dao.hasRoom(deleteId)) {
                    req.getSession().setAttribute("msg",
                            " Không thể xóa, Đang có phòng thuộc loại này.");
                } else {
                    boolean success = dao.delete(deleteId);

                    if (success) {
                        req.getSession().setAttribute("msg", " Xóa thành công!");
                    } else {
                        req.getSession().setAttribute("msg", " Xóa thất bại!");
                    }
                }

                resp.sendRedirect(req.getContextPath() + "/roomtype?action=list");
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/roomtype");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        User user = getSessionUser(req);

        // ❌ Không phải admin
        if (!isAdmin(user)) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        RoomTypeDAO dao = new RoomTypeDAO();

        try {
            String idRaw = req.getParameter("id");

            RoomType rt = new RoomType();
            rt.setName(req.getParameter("name"));
            rt.setBasePrice(new BigDecimal(req.getParameter("price")));
            rt.setMaxCapacity(Integer.parseInt(req.getParameter("capacity")));
            rt.setDescription(req.getParameter("description"));

            if (idRaw == null || idRaw.isEmpty()) {
                dao.insert(rt);
                req.getSession().setAttribute("msg", " Thêm thành công!");
            } else {
                rt.setId(Long.parseLong(idRaw));
                dao.update(rt);
                req.getSession().setAttribute("msg", " Cập nhật thành công!");
            }

            resp.sendRedirect(req.getContextPath() + "/roomtype?action=list");

        } catch (Exception e) {
            req.setAttribute("error", " Sai định dạng dữ liệu!");
            req.setAttribute("roomTypes", dao.getAll());
            req.getRequestDispatcher("/WEB-INF/Views/roomtype.jsp").forward(req, resp);
        }
    }

    // ================= HELPER =================
    private User getSessionUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }

    private boolean isAdmin(User user) {
        if (user == null)
            return false;
        return user.getRoles().stream()
                .anyMatch(r -> "ROLE_ADMIN".equals(r.getName()));
    }
}