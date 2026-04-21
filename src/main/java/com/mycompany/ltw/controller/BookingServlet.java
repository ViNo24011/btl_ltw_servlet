/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.ltw.controller;

import java.util.*;
import com.mycompany.ltw.dao.BookingDAO;
import com.mycompany.ltw.dao.BookingRoomDAO;
import com.mycompany.ltw.dao.RoomDAO;
import com.mycompany.ltw.model.Booking;
import com.mycompany.ltw.model.BookingRoom;
import com.mycompany.ltw.model.Room;
import com.mycompany.ltw.model.RoomType;
import com.mycompany.ltw.model.User;
import com.mycompany.ltw.model.Voucher;
import com.mycompany.ltw.utils.DBContext;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@WebServlet(name = "BookingServlet", urlPatterns = { "/booking" })
public class BookingServlet extends HttpServlet {
    private BookingDAO bookingDAO;

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //tieng viet
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        bookingDAO = new BookingDAO();
        String url = "/WEB-INF/Views/booking.jsp";
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        switch (action) {
            case "removeRoomById":
                removeRoomById(request, response);
                break;
            case "applyVoucher":
                applyVoucher(request, response);
                break;
            case "removeVoucher":
                removeVoucher(request, response);
                break;
            case "proceedPayment":
                proceedPayment(request, response);
                break;
            case "cancelBooking":
                cancelBooking(request, response);
                break;      
            default:
                throw new AssertionError();
        }
    }

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        clearSession(request);
        bookingDAO = new BookingDAO();
        HttpSession session = request.getSession();
        String action=request.getParameter("action");
        
        User user = (User) session.getAttribute("user");
        if(user!=null){
            session.setAttribute("firstName", user.getFirstName());
            session.setAttribute("lastName", user.getLastName());
            session.setAttribute("guestEmail", user.getEmail());
        }
  
        if ("bookingHistory".equals(action)){
            getBookingHistory(request, response);
            return;

        }

        List<Room> selectedSingle = (List<Room>) session.getAttribute("selectedRooms");
        String bookingType=request.getParameter("bookingType");
        if("one".equals(bookingType)){
               long roomId = Long.parseLong(request.getParameter("roomId"));
            RoomDAO roomDAO = new RoomDAO();
            Room room = roomDAO.getById(roomId);
            List<Room> selectedRooms = new ArrayList<>();
            if (room!=null){
                selectedRooms.add(room);
                session.setAttribute("selectedRooms", selectedRooms);
                session.setAttribute("bookingType", "one");
            } 
        }
        else{
            List<Room> selectedMultiple = (List<Room>) session.getAttribute("selectedMultipleRooms");
            if (selectedMultiple != null && !selectedMultiple.isEmpty()) {
                session.setAttribute("selectedRooms", selectedMultiple);
                session.setAttribute("bookingType", "multiple");
            }
        }

        request.getRequestDispatcher("/WEB-INF/Views/booking.jsp").forward(request, response);
    }

    
    public void removeRoomById(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException{
        String url = "/WEB-INF/Views/booking.jsp";
        HttpSession session=request.getSession();
        bookingDAO=new BookingDAO();
        persistInput(request);
        long removeRoomId = Long.parseLong(request.getParameter("removeRoomId"));

        List<Room> selectedRooms = (List<Room>) session.getAttribute("selectedRooms");
        List<Room> selectedMultipleRooms = (List<Room>) session.getAttribute("selectedMultipleRooms");
        String bookingType=(String) session.getAttribute("bookingType");
        if (selectedRooms != null) {
            selectedRooms.removeIf(r -> r.getId().equals(removeRoomId));
            session.setAttribute("selectedRooms", selectedRooms);
        }
        if (selectedMultipleRooms != null && bookingType.equals("multiple")) {
            selectedMultipleRooms.removeIf(r -> r.getId().equals(removeRoomId));
            session.setAttribute("selectedMultipleRooms", selectedMultipleRooms);
        }
        getServletContext().getRequestDispatcher(url).forward(request, response);
    }
    public void applyVoucher(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String url = "/WEB-INF/Views/booking.jsp";
        HttpSession session=request.getSession();
        persistInput(request);
        String code = request.getParameter("voucherCode");
        if (code == null || code.trim().isEmpty() || !code.matches("^[\\p{L}\\p{N}\\s]+$")) {
            request.setAttribute("voucherMessage", "Invalid voucher");
            getServletContext().getRequestDispatcher(url).forward(request, response);
            return;
        }
        Voucher voucher = bookingDAO.getVoucherByCode(code);
        if (voucher == null) {
            request.setAttribute("voucherMessage", "Invalid voucher");
        } else {
            
            Timestamp dateTime = Timestamp.valueOf(LocalDateTime.now());
            if (voucher.isIsActive() == false || voucher.getExpiryDate().before(dateTime)
                    || voucher.getUsageLimit() <= voucher.getUsedCount()) {
                request.setAttribute("voucherMessage", "Invalid voucher");
            } else {
                User user = (User) session.getAttribute("user");
                boolean isValid = true;

                if ("VIP".equals(voucher.getTargetGroup())) {
                    if (user == null) {
                        isValid = false;
                    } else {
                        int totalBookings = bookingDAO.countUserBookings(user.getId());
                        if (totalBookings < voucher.getGroupValue()) {
                            isValid = false;
                            request.setAttribute("voucherMessage", "Voucher requires VIP status (" + voucher.getGroupValue() + " bookings).");
                        }
                    }
                } else if ("LONG_TERM".equals(voucher.getTargetGroup())) {
                    if (user == null || user.getCreatedAt() == null) {
                        isValid = false;
                    } else {
                        long days = (System.currentTimeMillis() - user.getCreatedAt().getTime()) / 86400000L;
                        if (days < voucher.getGroupValue()) {
                            isValid = false;
                            request.setAttribute("voucherMessage", "Voucher is for users registered for " + voucher.getGroupValue() + " days.");
                        }
                    }
                }
                if (isValid) {
                    request.setAttribute("voucherMessage", null);
                    session.setAttribute("voucher", voucher);
                    request.setAttribute("voucher", voucher);
                } else if (request.getAttribute("voucherMessage") == null) {
                    request.setAttribute("voucherMessage", "You are not eligible for this voucher.");
                }
            }
        }
        getServletContext().getRequestDispatcher(url).forward(request, response);
    }
    public void removeVoucher(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String url = "/WEB-INF/Views/booking.jsp";
        HttpSession session=request.getSession();
        persistInput(request);
        session.setAttribute("voucher", null);
        BigDecimal basePrice = (BigDecimal) session.getAttribute("basePrice");
        session.setAttribute("totalAmount", basePrice);
        getServletContext().getRequestDispatcher(url).forward(request, response);
    }
    public void proceedPayment(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException{
        String url = "/WEB-INF/Views/booking.jsp";
        HttpSession session=request.getSession();
        persistInput(request);
        if(checkInput(request, response)==false){
            return;
        }
        
        BookingRoomDAO bookingRoomDAO = new BookingRoomDAO();
        List<BookingRoom> bookingRooms = new ArrayList<>();
        Booking booking = new Booking();
        User user = (User) session.getAttribute("user");
        // Check user
        if (user != null) {
            booking.setUserId(user.getId());
        }

        // Check date
        LocalDate checkIn = LocalDate.parse(request.getParameter("checkIn"));
        LocalDate checkOut = LocalDate.parse(request.getParameter("checkOut"));
        LocalDate today = LocalDate.now();
        
        if (checkIn.isAfter(checkOut)) {
            request.setAttribute("bookingMessage", "Check in date must be before check out date.");
            getServletContext().getRequestDispatcher(url).forward(request, response);
            return;
        }
        if (checkIn.isBefore(today)) {
            request.setAttribute("bookingMessage", "Check-in date cannot be in the past.");
            getServletContext().getRequestDispatcher(url).forward(request, response);
            return;
        }
        if (checkOut.isBefore(today)) {
            request.setAttribute("bookingMessage", "Check-out date cannot be in the past.");
            getServletContext().getRequestDispatcher(url).forward(request, response);
            return;
        }
        if (checkOut.isEqual(checkIn)){
            request.setAttribute("bookingMessage", "Check-out and check-in cant be in the same day.");
            getServletContext().getRequestDispatcher(url).forward(request, response);
            return;
        }


        List<Room> rooms = null;
        if ("one".equals(request.getParameter("bookingType"))) {
            rooms = (List<Room>) session.getAttribute("selectedRooms");
        } else {
            rooms = (List<Room>) session.getAttribute("selectedMultipleRooms");
        }
        // Check room
        if (rooms == null || rooms.isEmpty()) {
            request.setAttribute("bookingMessage", "No room chose.");
            getServletContext().getRequestDispatcher(url).forward(request, response);
            return;
        }
        // Check every selected room
        Map<Long, String> roomErrors = new HashMap<>();
        boolean hasError = false;
        for (Room r : rooms) {
            if (!bookingDAO.isRoomFree(r.getId(), checkIn, checkOut)) {
                roomErrors.put(r.getId(), "Booked in this period");
                hasError = true;
            }
        }
        if (hasError) {
            request.setAttribute("roomErrors", roomErrors);
            getServletContext().getRequestDispatcher(url).forward(request, response);
            return;
        }

        System.out.println("Done checking room");

        // Calculate total amount
        long days = Math.max(1, ChronoUnit.DAYS.between(checkIn, checkOut));
        BigDecimal totalAmount = BigDecimal.ZERO;
        for (Room r : rooms) {
            totalAmount = totalAmount.add(r.getBasePrice().multiply(BigDecimal.valueOf(days)));
        }
        Voucher voucher = (Voucher) session.getAttribute("voucher");
        // Check voucher
        if (voucher != null) {
            booking.setVoucherId(voucher.getId());
            if (voucher.isIsPercent()) {
                totalAmount = totalAmount.multiply(BigDecimal.valueOf((100.0 - voucher.getDiscountValue()) / 100f));
            } else {
                totalAmount = totalAmount.subtract(BigDecimal.valueOf(voucher.getDiscountValue()));
            }
        }
        session.setAttribute("totalAmount", totalAmount);

        // Create Booking and Booking Rooms
        booking.setCheckIn(checkIn);
        booking.setCheckOut(checkOut);
        String guestName = request.getParameter("firstName") + " " + request.getParameter("lastName");
        session.setAttribute("guestName", guestName);
        booking.setGuestName(guestName);
        booking.setGuestEmail(request.getParameter("guestEmail"));
        booking.setTotalAmount(totalAmount);
        booking.setStatus("UNPAID");
        // Create code

        
        // Check guests
        int totalGuest = 0;
        for (Room room : rooms) {
            int numAdults = Integer.parseInt(request.getParameter("numAdults-" + room.getId()));
            int numChildren = Integer.parseInt(request.getParameter("numChildren-" + room.getId()));
            if (numAdults + numChildren > room.getRoomType().getMaxCapacity()
                    || (numChildren == 0 && numAdults == 0)) {
                request.setAttribute("bookingMessage", "Invalid number of guests");
                getServletContext().getRequestDispatcher(url).forward(request, response);
                return;
            }
            totalGuest += numAdults + numChildren;
            BookingRoom bookingRoom = new BookingRoom();
            bookingRoom.setRoomId(room.getId());
            BigDecimal priceAtBooking= room.getBasePrice().multiply(BigDecimal.valueOf(days));
            if (voucher != null) {
                if (voucher.isIsPercent()) {
                    priceAtBooking = priceAtBooking.multiply(BigDecimal.valueOf((100.0 - voucher.getDiscountValue()) / 100f));
                } else {
                    priceAtBooking = priceAtBooking.subtract(BigDecimal.valueOf(voucher.getDiscountValue()).divide(BigDecimal.valueOf((long) rooms.size())));
                }
            }
            bookingRoom.setPriceAtBooking(priceAtBooking);
            bookingRoom.setNumAdults(numAdults);
            bookingRoom.setNumChildren(numChildren);
            bookingRooms.add(bookingRoom);
        }
        session.setAttribute("totalGuest", totalGuest);
        booking.setTotalGuests(totalGuest);

        long generatedBookingID = (long) -1;
        Connection conn = null;
        try {
            conn = new DBContext().getConnection();

            conn.setAutoCommit(false);
            generatedBookingID = bookingDAO.createBooking(conn, booking);
            if (generatedBookingID == -1) {
                request.setAttribute("bookingMessage", "Booking failed");
                getServletContext().getRequestDispatcher(url ).forward(request, response);
                return;
            }
            booking.setId(generatedBookingID);
            for (BookingRoom bookingRoom : bookingRooms) {
                bookingRoom.setBookingId(generatedBookingID);
                bookingRoomDAO.createBookingRoom(conn, bookingRoom);
            }
            if (voucher != null) {
                bookingDAO.updateVoucherUseCountById(conn, voucher.getId());
            }
            conn.commit();
            conn.close();

        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            request.setAttribute("bookingMessage","Booking failed, someone just booked this rooms in this period.");
            url = "/WEB-INF/Views/booking.jsp";
            getServletContext().getRequestDispatcher(url).forward(request, response);
            return;
        }

        session.setAttribute("booking", booking);
        session.setAttribute("bookedRooms", bookingRooms);
        response.sendRedirect(request.getContextPath() + "/payment");
    }
    public void cancelBooking(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException{
        String url = "/WEB-INF/Views/booking-history.jsp";
        long bookingId=Long.parseLong(request.getParameter("cancelBookingId"));
        bookingDAO.updateBookingStatus(bookingId, "CANCELLED"); 

        response.sendRedirect(request.getContextPath() + "/booking?action=bookingHistory");
    }

    private void getBookingHistory(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String url = "/WEB-INF/Views/booking-history.jsp";
        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        int page = 1;
        int pageSize = 10;

        // Prevent invalid input in url
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (Exception e) {
                page = 1;
            }
        }
        request.setAttribute("now", LocalDate.now());
        // Get total records
        int totalBookings = bookingDAO.countUserBookings(user.getId());
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
               
        // Get booking history
        List<Booking> bookingHistory =bookingDAO.getUserBooking(user.getId(), page, pageSize);

        // Set attributes
        request.setAttribute("bookingHistory", bookingHistory);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // Forward to JSP
        request.getRequestDispatcher(url).forward(request, response);
    
    }
    
    public BigDecimal calulateTotalAmount(BigDecimal basePrice, Voucher voucher) {
        BigDecimal calcultedTotaAmount = null;
        if (voucher.isIsPercent()) {
            calcultedTotaAmount = basePrice.multiply(BigDecimal.valueOf((100.0 - voucher.getDiscountValue()) / 100.0));
        } else {
            calcultedTotaAmount = basePrice.subtract(BigDecimal.valueOf(voucher.getDiscountValue()));
        }
        return calcultedTotaAmount;
    }
    public boolean checkInput(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String url = "/WEB-INF/Views/booking.jsp";
        HttpSession session=request.getSession();
        String checkInStr = request.getParameter("checkIn");
        String checkOutStr = request.getParameter("checkOut");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String guestEmail = request.getParameter("guestEmail");

        
        
        if (checkInStr == null || checkInStr.isEmpty() || 
            checkOutStr == null || checkOutStr.isEmpty() ||
            firstName == null || firstName.isEmpty() ||
            lastName == null || lastName.isEmpty() ||
            guestEmail == null || guestEmail.isEmpty()) {
            request.setAttribute("bookingMessage", "Please fill in all required fields.");
            getServletContext().getRequestDispatcher(url).forward(request, response);
            return false;
        }
        //check if not unicode characters
        else if(!firstName.matches("^[\\p{L}\\s]+$") ||
                !lastName.matches("^[\\p{L}\\s]+$")){
            request.setAttribute("bookingMessage", "Please dont type in special characters.");
            getServletContext().getRequestDispatcher(url).forward(request, response);
            return false;
        }
        return true;
    }
    public void persistInput(HttpServletRequest request){
        HttpSession session = request.getSession();

        String checkIn = request.getParameter("checkIn");
        String checkOut = request.getParameter("checkOut");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String guestEmail = request.getParameter("guestEmail");

        if (checkIn != null && !checkIn.isEmpty()) {
            session.setAttribute("checkIn", checkIn);
        }
        if (checkOut != null && !checkOut.isEmpty()) {
            session.setAttribute("checkOut", checkOut);
        }
        if (firstName != null && !firstName.isEmpty()) {
            session.setAttribute("firstName", firstName.trim());
        }
        if (lastName != null && !lastName.isEmpty()) {
            session.setAttribute("lastName", lastName.trim());
        }
        if (guestEmail != null && !guestEmail.isEmpty()) {
            session.setAttribute("guestEmail", guestEmail.trim());
        }
    }
    
    public void clearSession(HttpServletRequest request){
        HttpSession session=request.getSession();
        session.removeAttribute("checkIn");
        session.removeAttribute("checkOut");
        session.removeAttribute("firstName");
        session.removeAttribute("lastName");
        session.removeAttribute("guestEmail");
        session.removeAttribute("booking");
        session.removeAttribute("bookedRooms");
        session.removeAttribute("guestName");
        session.removeAttribute("totalGuest");
        session.removeAttribute("totalAmount");
        session.removeAttribute("voucher");
    }
}
