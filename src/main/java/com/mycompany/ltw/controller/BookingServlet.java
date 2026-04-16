/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.ltw.controller;

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
@WebServlet(name = "BookingServlet", urlPatterns = {"/booking"})
public class BookingServlet extends HttpServlet {
    private BookingDAO bookingDAO;
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        bookingDAO= new BookingDAO();
        String url = "/WEB-INF/Views/choose-free-room.jsp";
        String action = request.getParameter("action");
        HttpSession session=request.getSession();
         
         
        /////////for testing/////////
        RoomType roomType=new RoomType(Long.valueOf("1"), "Phong don", BigDecimal.valueOf(1000000),4,"random description");
        session.setAttribute("roomType", roomType);
        roomType= (RoomType) session.getAttribute("roomType");
        ///////////////////////////
        
        if(action.equals("getFreeRoom")){
            session.setAttribute("roomType", roomType);
            LocalDate checkIn=LocalDate.parse(request.getParameter("checkIn"));
            LocalDate checkOut=LocalDate.parse(request.getParameter("checkOut"));  
            LocalDate today = LocalDate.now();
            if (checkIn.isAfter(checkOut)){
                request.setAttribute("message", "Check in date must be before check out date.");    
                getServletContext().getRequestDispatcher(url).forward(request, response);
                return;
            }         
            if (checkIn.isBefore(today)) {
                request.setAttribute("message", "Check-in date cannot be in the past.");
                getServletContext().getRequestDispatcher(url).forward(request, response);
                return;
            }
            if (checkOut.isBefore(today)) {
                request.setAttribute("message", "Check-out date cannot be in the past.");
                getServletContext().getRequestDispatcher(url).forward(request, response);
                return;
            }
            List<Room> freeRooms; 
            try {               
                freeRooms = bookingDAO.getFreeRooms(checkIn, checkOut, roomType.getId());
                if (freeRooms.isEmpty()){
                    request.setAttribute("message", "No free rooms in this period.");
                }
                else{
                    request.setAttribute("freeRooms", freeRooms); 
                }
            } catch (SQLException ex) {
                System.getLogger(BookingServlet.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
            }
            session.setAttribute("checkIn", checkIn.toString());
            session.setAttribute("checkOut",checkOut.toString());
        }
        else if (action.equals("chooseRooms")){
            //Load dates
            if (session.getAttribute("checkIn")==null||session.getAttribute("checkOut")==null){
                request.setAttribute("message", "Please choose check in and check out date.");
                getServletContext().getRequestDispatcher(url).forward(request, response);
                return;
            }
            LocalDate checkIn = LocalDate.parse((String) session.getAttribute("checkIn"));
            LocalDate checkOut = LocalDate.parse((String) session.getAttribute("checkOut"));
            
            RoomDAO roomDAO = new RoomDAO();
            String[] selectedRoomsIds = request.getParameterValues("roomIds");
            List<Room> selectedRooms = new ArrayList<>();
            if (selectedRoomsIds != null && selectedRoomsIds.length > 0){
                
                for (String id : selectedRoomsIds) {
                    selectedRooms.add(roomDAO.getById(Long.valueOf(id)));
                }              
                session.setAttribute("selectedRooms", selectedRooms);
            }   
            else{
                request.setAttribute("message", "No room selected.");
                getServletContext().getRequestDispatcher(url).forward(request, response);
                return;
            }
            //Calculate days
            int days=(int) (ChronoUnit.DAYS.between(checkIn, checkOut) + 1); 
            BigDecimal basePrice=roomType.getBasePrice().multiply(BigDecimal.valueOf(days)).multiply(BigDecimal.valueOf(selectedRooms.size()));
            session.setAttribute("basePrice", basePrice);
            session.setAttribute("totalAmount", basePrice);
            //Create confirmation code
            session.setAttribute("confirmationCode", getConfirmationCode());
            //Continue
            url="/WEB-INF/Views/booking.jsp";
        }   
        else if (action.equals("getVouchers")){
            url = "/WEB-INF/Views/booking.jsp";
            String code= request.getParameter("voucherCode");
            if (code.isEmpty()){
                request.setAttribute("voucherMessage", "Invalid voucher");
            }
            Voucher voucher= bookingDAO.getVoucherByCode(code);
            if (voucher==null){
                request.setAttribute("voucherMessage", "Invalid voucher");
            }
            else{
                Timestamp dateTime=Timestamp.valueOf(LocalDateTime.now());
                if (voucher.isIsActive()==false ||voucher.getExpiryDate().before(dateTime)||voucher.getUsageLimit()<=voucher.getUsedCount()){
                    request.setAttribute("voucherMessage", "Invalid voucher");
                }
                else{
                    request.setAttribute("voucherMessage", null);
                    session.setAttribute("voucher", voucher); 
                    request.setAttribute("voucher", voucher);
                    
                    BigDecimal basePrice=(BigDecimal) session.getAttribute("basePrice");
                    BigDecimal calcultedTotaAmount= calulateTotalAmount(basePrice, voucher);
                    
                    session.setAttribute("totalAmount", calcultedTotaAmount);
                }    
            }           
        }
        else if (action.equals("removeVoucher")){
            url = "/WEB-INF/Views/booking.jsp";
            session.setAttribute("voucher",null);
            BigDecimal basePrice=(BigDecimal) session.getAttribute("basePrice");
            session.setAttribute("totalAmount", basePrice);
        }
        else if (action.equals("createBooking")) {
            url = "/WEB-INF/Views/booking.jsp";
            BookingRoomDAO bookingRoomDAO= new BookingRoomDAO();
            List<BookingRoom> bookingRooms= new ArrayList<>();
            
            List<Room> rooms=(List<Room>) session.getAttribute("selectedRooms");
            if (rooms == null || rooms.isEmpty()) {
                response.sendRedirect("booking");
                return;
            }
            Booking booking= new Booking();
            User user= (User) session.getAttribute("user");
            Voucher voucher = (Voucher) session.getAttribute("voucher");
            if (user != null){
                booking.setUserId(user.getId());
            }
            if(voucher!=null){
                booking.setVoucherId(voucher.getId());
            }
            booking.setCheckIn(LocalDate.parse((String) session.getAttribute("checkIn")));
            booking.setCheckOut(LocalDate.parse((String) session.getAttribute("checkOut")));
            String guestName=request.getParameter("firstName")+" "+request.getParameter("lastName");
            booking.setGuestName(guestName);
            booking.setGuestEmail(request.getParameter("guestEmail"));
            booking.setConfirmationCode((String) session.getAttribute("confirmationCode"));
            BigDecimal totalAmount = (BigDecimal) session.getAttribute("totalAmount");
            booking.setTotalAmount(totalAmount);
            booking.setStatus("Unpaid");
            booking.setTotalGuests(0);
            
            int totalGuest=0;
            for (Room room: rooms){
                int numAdults= Integer.parseInt(request.getParameter("numAdults-"+room.getId()));
                int numChildren= Integer.parseInt(request.getParameter("numChildren-"+room.getId()));               
                if (numAdults+numChildren>roomType.getMaxCapacity() || (numChildren==0&&numAdults==0)){
                    request.setAttribute("bookingMessage", "Invalid number of guests");
                    getServletContext().getRequestDispatcher(url).forward(request, response);
                    return;
                }

                totalGuest+=numAdults+numChildren;
                BookingRoom bookingRoom = new BookingRoom();
                bookingRoom.setRoomId(room.getId());
                bookingRoom.setPriceAtBooking(totalAmount);
                bookingRoom.setNumAdults(numAdults);
                bookingRoom.setNumChildren(numChildren); 
                
                bookingRooms.add(bookingRoom);                
            }
            booking.setTotalGuests(totalGuest);
            long generatedBookingID=(long)-1;
            Connection conn=null;
            try{
                conn=new DBContext().getConnection();
                
                conn.setAutoCommit(false);
                generatedBookingID=bookingDAO.createBooking(conn, booking);
                if (generatedBookingID == -1) {
                    request.setAttribute("bookingMessage", "Booking failed");
                    getServletContext().getRequestDispatcher(url).forward(request, response);
                    return;
                }
                for (BookingRoom bookingRoom: bookingRooms){
                    bookingRoom.setBookingId(generatedBookingID);
                    bookingRoomDAO.createBookingRoom(conn, bookingRoom);
                }    
                if (voucher!=null){
                    bookingDAO.updateVoucherUseCountById(conn, voucher.getId());
                }
                conn.commit();
                conn.close();
                url="/WEB-INF/Views/payment.jsp";   
            }
            catch(Exception e){
                if (conn != null) {
                    try {
                        conn.rollback();
                        conn.close();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
                
                request.setAttribute("bookingMessage", "Booking failed, someone just booked this rooms in this period.");
                getServletContext().getRequestDispatcher(url).forward(request, response);
                return;
            }
            
        }
        
        getServletContext().getRequestDispatcher(url).forward(request, response);
        return;
    }
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String url = "/WEB-INF/Views/choose-free-room.jsp";
        getServletContext().getRequestDispatcher(url).forward(request, response);

    }   
    public String getConfirmationCode(){
        String characters="ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
        String res="";
        Random rand= new Random();
        int maxLength=10;
        for (int i=0; i<maxLength; i++){
            res+=characters.charAt(rand.nextInt(characters.length()));
        }
        return res;
    }
    public BigDecimal calulateTotalAmount(BigDecimal basePrice, Voucher voucher){
        BigDecimal calcultedTotaAmount = null;
        if(voucher.isIsPercent()){
            calcultedTotaAmount=basePrice.multiply(BigDecimal.valueOf((100.0-voucher.getDiscountValue())/100.0)); 
        }
        else{
            calcultedTotaAmount=basePrice.subtract(BigDecimal.valueOf(voucher.getDiscountValue()));
        }
        return calcultedTotaAmount;
    }
}
