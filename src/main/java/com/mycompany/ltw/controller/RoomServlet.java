package com.mycompany.ltw.controller;

import com.mycompany.ltw.dao.*;
import com.mycompany.ltw.model.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "RoomServlet", urlPatterns = {"/room", "/admin/room"})
public class RoomServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        RoomDAO dao = new RoomDAO();
        RoomTypeDAO typeDAO = new RoomTypeDAO();

        User user = getUser(req);
        boolean isAdmin = isAdmin(user);

        String uri = req.getRequestURI();
        boolean isAdminRequest = uri.contains("/admin/");

        // CHẶN ACCESS ADMIN
        if (isAdminRequest && !isAdmin) {
            resp.sendRedirect(req.getContextPath() + "/access-denied.jsp");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            // ================= LIST =================
            case "list":
                int page = req.getParameter("page") == null ? 1 :
                        Integer.parseInt(req.getParameter("page"));
                HttpSession session= req.getSession();
                
                int pageSize = 9;

                List<Room> rooms = dao.getRooms(page, pageSize);
                int total = dao.countRooms();
                int totalPages = (int) Math.ceil((double) total / pageSize);

                req.setAttribute("rooms", rooms);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                session.setAttribute("currentRoomPage", page);   
                if (isAdminRequest) {
                    req.getRequestDispatcher("/WEB-INF/Views/admin-room.jsp").forward(req, resp);
                } else {
                    req.getRequestDispatcher("/WEB-INF/Views/room.jsp").forward(req, resp);
                }
                break;

            // ================= DETAIL =================
            case "detail":
                Room room = dao.getById(Long.valueOf(req.getParameter("id")));
                req.setAttribute("room", room);
                req.getRequestDispatcher("/WEB-INF/Views/room-detail.jsp").forward(req, resp);
                break;

            // ================= CREATE =================
            case "new":
                req.setAttribute("roomTypes", typeDAO.getAll());
                req.getRequestDispatcher("/WEB-INF/Views/room-form.jsp").forward(req, resp);
                break;

            // ================= EDIT =================
            case "edit":
                Room editRoom = dao.getById(Long.valueOf(req.getParameter("id")));
                req.setAttribute("room", editRoom);
                req.setAttribute("roomTypes", typeDAO.getAll());
                req.getRequestDispatcher("/WEB-INF/Views/room-form.jsp").forward(req, resp);
                break;

            // ================= DELETE =================
            case "delete":
                dao.delete(Long.valueOf(req.getParameter("id")));
                resp.sendRedirect(req.getContextPath() + "/admin/room?action=list");
                break;
            case "search":
                String checkInStr = req.getParameter("checkInSearch");
                String checkOutStr = req.getParameter("checkOutSearch");

                if (checkInStr != null && checkOutStr != null && !checkInStr.isEmpty() && !checkOutStr.isEmpty()) {

                    LocalDate checkIn = LocalDate.parse(checkInStr);
                    LocalDate checkOut = LocalDate.parse(checkOutStr);
                    BookingDAO bookingDAO = new BookingDAO();
                    try {
                        List<Room> freeRooms = bookingDAO.getFreeRooms(checkIn, checkOut);
                        req.setAttribute("allRooms", freeRooms);
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
                req.setAttribute("checkInSearch", checkInStr);
                req.setAttribute("checkOutSearch", checkOutStr);
                req.setAttribute("roomTypes", typeDAO.getAll());
                req.getRequestDispatcher("/WEB-INF/Views/index.jsp").forward(req, resp);
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/room");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = getUser(req);
        if ("bookRooms".equals(req.getParameter("action"))) {
            long roomId = Long.parseLong(req.getParameter("roomId"));
            Room selectedRoom = new RoomDAO().getById(roomId);

            HttpSession session = req.getSession();
            int page = (int) session.getAttribute("currentRoomPage");
            List<Room> selectedRooms = (List<Room>) session.getAttribute("selectedMultipleRooms");
            
            if (selectedRooms == null) {
                selectedRooms = new ArrayList<>();
            }
            boolean hasRoom = false;
            for (Room r: selectedRooms){
                if(r.getId()==roomId){
                    hasRoom=true;
                    break;
                }
            }
            if(!hasRoom){
                selectedRooms.add(selectedRoom);
            }
            
            //Sync both so booking.jsp can see it
            session.setAttribute("selectedMultipleRooms", selectedRooms);
            session.setAttribute("selectedRooms", selectedRooms);

            // redirect back to list page 
            resp.sendRedirect(req.getContextPath() + "/room?action=list&page=" + page);
            return;
        }
        if (!isAdmin(user)) {
            resp.sendRedirect(req.getContextPath() + "/access-denied.jsp");
            return;
        }

        RoomDAO dao = new RoomDAO();

        String id = req.getParameter("id");

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

        resp.sendRedirect(req.getContextPath() + "/admin/room?action=list");
    }

    // ================= HELPERS =================
    private User getUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }

    private boolean isAdmin(User user) {
        if (user == null) return false;
        return user.getRoles().stream()
                .anyMatch(r -> "ROLE_ADMIN".equals(r.getName()));
    }
}
