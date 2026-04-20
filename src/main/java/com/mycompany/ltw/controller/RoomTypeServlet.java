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

@WebServlet(name = "RoomTypeServlet", urlPatterns = {"/roomtype"})
public class RoomTypeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        User sessionUser = getSessionUser(req);
        if (!isAdmin(sessionUser)) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        RoomTypeDAO dao = new RoomTypeDAO();
        List<RoomType> roomTypes = dao.getAll();
        
        req.setAttribute("roomTypes", roomTypes);
        req.getRequestDispatcher("/WEB-INF/Views/roomtype.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        User sessionUser = getSessionUser(req);
        if (!isAdmin(sessionUser)) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        RoomTypeDAO dao = new RoomTypeDAO();

        try {
            RoomType rt = new RoomType();
            rt.setName(req.getParameter("name"));
            rt.setBasePrice(new BigDecimal(req.getParameter("price")));
            rt.setMaxCapacity(Integer.parseInt(req.getParameter("capacity")));
            rt.setDescription(req.getParameter("description"));

            dao.insert(rt);

            resp.sendRedirect(req.getContextPath() + "/roomtype");
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid price or capacity format");
            RoomTypeDAO typeDao = new RoomTypeDAO();
            req.setAttribute("roomTypes", typeDao.getAll());
            req.getRequestDispatcher("/WEB-INF/Views/roomtype.jsp").forward(req, resp);
        }
    }
    
    private User getSessionUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }
    
    private boolean isAdmin(User user) {
        if (user == null) return false;
        return user.getRoles().stream().anyMatch(r -> r.getName().equals("ROLE_ADMIN"));
    }
}
