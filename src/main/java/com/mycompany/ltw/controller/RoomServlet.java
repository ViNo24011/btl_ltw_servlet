package com.mycompany.ltw.controller;

import com.mycompany.ltw.dao.*;
import com.mycompany.ltw.model.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "RoomServlet", urlPatterns = {"/room"})
public class RoomServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        User sessionUser = getSessionUser(req);
        if (!isAdmin(sessionUser)) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        RoomDAO dao = new RoomDAO();
        RoomTypeDAO typeDAO = new RoomTypeDAO();

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                int page = req.getParameter("page") == null ? 1 :
                        Integer.parseInt(req.getParameter("page"));
                List<Room> rooms = dao.getRooms(page, 5);
                int totalCount = dao.countRooms();
                int totalPages = (totalCount + 4) / 5; // Math.ceil
                req.setAttribute("rooms", rooms);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("currentPage", page);
                req.getRequestDispatcher("/WEB-INF/Views/room.jsp").forward(req, resp);
                break;
            case "detail":
                {
                    Room room = dao.getById(Long.parseLong(req.getParameter("id")));
                    req.setAttribute("room", room);
                    req.getRequestDispatcher("/WEB-INF/Views/room-detail.jsp").forward(req, resp);
                    break;
                }
            case "new":
                req.setAttribute("roomTypes", typeDAO.getAll());
                req.getRequestDispatcher("/WEB-INF/Views/room-form.jsp").forward(req, resp);
                break;
            case "edit":
                {
                    Room room = dao.getById(Long.valueOf(req.getParameter("id")));
                    req.setAttribute("room", room);
                    req.setAttribute("roomTypes", typeDAO.getAll());
                    req.getRequestDispatcher("/WEB-INF/Views/room-form.jsp").forward(req, resp);
                    break;
                }
            case "delete":
                dao.delete(Long.valueOf(req.getParameter("id")));
                resp.sendRedirect("room");
                break;
            default:
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        User sessionUser = getSessionUser(req);
        if (!isAdmin(sessionUser)) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        RoomDAO dao = new RoomDAO();

        String id = req.getParameter("id");

        try {
            Room r = new Room();
            r.setRoomNumber(req.getParameter("roomNumber"));
            r.setPhoto(req.getParameter("photo"));
            r.setStatus(req.getParameter("status"));
            r.setRoomTypeId(Long.valueOf(req.getParameter("roomTypeId")));

            if (id == null || id.isEmpty()) {
                dao.insert(r);
            } else {
                r.setId(Long.valueOf(id));
                dao.update(r);
            }

            resp.sendRedirect(req.getContextPath() + "/room");
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid input format");
            req.getRequestDispatcher("/WEB-INF/Views/room-form.jsp").forward(req, resp);
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
