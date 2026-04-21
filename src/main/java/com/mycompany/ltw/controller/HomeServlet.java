package com.mycompany.ltw.controller;

import com.mycompany.ltw.dao.RoomDAO;
import com.mycompany.ltw.dao.RoomTypeDAO;
import com.mycompany.ltw.model.Room;
import com.mycompany.ltw.model.RoomType;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.mycompany.ltw.model.User;
import com.mycompany.ltw.dao.AdminDAO;
import com.mycompany.ltw.dao.BookingDAO;
import java.sql.SQLException;
import java.time.LocalDate;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        boolean isAdmin = false;
        String action=request.getParameter("action");
        if ("search-free-rooms".equals(action)){
            String checkInStr = request.getParameter("checkInSearch");
            String checkOutStr = request.getParameter("checkOutSearch");

            LocalDate checkIn = null;
            LocalDate checkOut = null;

            try {
                if (checkInStr != null && !checkInStr.isBlank()) {
                    checkIn = LocalDate.parse(checkInStr);
                }
                if (checkOutStr != null && !checkOutStr.isBlank()) {
                    checkOut = LocalDate.parse(checkOutStr);
                }

            } catch (Exception e) {
                System.out.println("Invalid date input: " + checkInStr + " / " + checkOutStr);
            }


            BookingDAO bookingDAO = new BookingDAO();
            try {
                List<Room> freeRooms = bookingDAO.getFreeRooms(checkIn, checkOut);
                request.setAttribute("allRooms", freeRooms);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }

            request.setAttribute("checkInSearch", checkInStr);
            request.setAttribute("checkOutSearch", checkOutStr);
            request.setAttribute("roomTypes", new RoomTypeDAO().getAll());

            request.getRequestDispatcher("/WEB-INF/Views/index.jsp").forward(request, response);
            return;
        }
        else if("clear-search".equals(action)){
            request.setAttribute("checkInSearch", null);
            request.setAttribute("checkOutSearch",null);
            RoomDAO roomDAO = new RoomDAO();
            try {
                List<Room> rooms = roomDAO.getAll();
                request.setAttribute("allRooms", rooms);
            } catch (Exception e) {
                e.printStackTrace();
            }
            request.getRequestDispatcher("/WEB-INF/Views/index.jsp").forward(request, response);
            return;
        }
        if (user != null) {
            isAdmin = user.getRoles().stream().anyMatch(r -> "ROLE_ADMIN".equals(r.getName()));
        }

        if (isAdmin) {
            AdminDAO adminDAO = new AdminDAO();
            BookingDAO bookingDAO = new BookingDAO();
            RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

            int totalRooms = adminDAO.getGlobalMetric("TOTAL_ROOMS");
            int totalBookings = adminDAO.getGlobalMetric("TOTAL_BOOKINGS");
            int pendingBookings = adminDAO.getGlobalMetric("PAID_BOOKINGS_COUNT");
            int completedBookings = adminDAO.getGlobalMetric("CHECKED_OUT_BOOKINGS");

            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");

            java.math.BigDecimal totalRevenue = adminDAO.getTotalRevenue(fromDate, toDate);
            
            List<Map<String, Object>> revChartData = adminDAO.getRevenueChartData();
            List<Map<String, Object>> statusChartData = adminDAO.getStatusChartData();

            String roomTypeIdParam = request.getParameter("roomTypeId");
            Long roomTypeId = null;
            if (roomTypeIdParam != null && !roomTypeIdParam.isEmpty()) {
                try { roomTypeId = Long.parseLong(roomTypeIdParam); } catch (Exception ignored){}
            }
            List<Map<String, Object>> roomPerf = adminDAO.getRoomPerformance(roomTypeId);
            List<RoomType> roomTypes = roomTypeDAO.getAll();
            
            List<com.mycompany.ltw.dto.BookingDetailDTO> bookings = bookingDAO.getAllAdminBookings(null, null, fromDate, toDate);

            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("completedBookings", completedBookings);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
            request.setAttribute("revChartData", revChartData);
            request.setAttribute("statusChartData", statusChartData);
            request.setAttribute("roomPerf", roomPerf);
            request.setAttribute("roomTypes", roomTypes);
            request.setAttribute("selectedRoomTypeId", roomTypeIdParam);
            request.setAttribute("recentBookings", bookings);

            request.getRequestDispatcher("/WEB-INF/Views/report.jsp").forward(request, response);
            return;
        }
        
        // Lấy dữ liệu từ database for normal users
        RoomDAO roomDAO = new RoomDAO();
        RoomTypeDAO roomTypeDAO = new RoomTypeDAO();
        
        List<Room> allRooms = roomDAO.getAll();
        List<RoomType> roomTypes = roomTypeDAO.getAll();
        
        // Set vào request attribute để JSP sử dụng
        request.setAttribute("allRooms", allRooms);
        request.setAttribute("roomTypes", roomTypes);
        
        request.getRequestDispatcher("/WEB-INF/Views/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}