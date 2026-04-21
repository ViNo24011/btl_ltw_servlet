/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.ltw.controller;

import com.mycompany.ltw.dao.BookingDAO;
import com.mycompany.ltw.dao.BookingRoomDAO;
import com.mycompany.ltw.dao.VoucherDAO;
import com.mycompany.ltw.model.Booking;
import com.mycompany.ltw.model.BookingRoom;
import com.mycompany.ltw.model.Voucher;
import com.mycompany.ltw.utils.DBContext;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.http.HttpSession;
/**
 *
 * @author Admin
 */
@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session=request.getSession();
        Booking booking= (Booking) session.getAttribute("booking");
        String action=request.getParameter("action");
        if("continuePayment".equals(action)){
            continuePayment(request, response);
            return;
        }
        List<BookingRoom> bookedRooms=(List<BookingRoom>) session.getAttribute("bookedRooms");
        if(booking==null || bookedRooms==null){
            getServletContext().getRequestDispatcher("/WEB-INF/Views/booking.jsp").forward(request, response);
            return;
        }
        String bankId = "VCB";           // Vietnam Techcombank
        String accountNo = "0123456789"; // Your account number
        String template = "compact";     // compact or print
        String amount = booking.getTotalAmount().toString();
        String description = booking.getId().toString();
        String accountName = "lakeSide Hotel"; // Your business name
        
        // Build QR URL with correct format
        String qrUrl = "https://img.vietqr.io/image/" 
                + bankId + "-" 
                + accountNo + "-" 
                + template + ".png?"
                + "amount=" + amount;

        session.setAttribute("qrUrl", qrUrl);
        getServletContext().getRequestDispatcher("/WEB-INF/Views/payment.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session=request.getSession();
        String url = "/WEB-INF/Views/payment.jsp";
        Booking booking= (Booking) session.getAttribute("booking");
        Voucher voucher= (Voucher) session.getAttribute("voucher");
        List<BookingRoom> bookedRooms=(List<BookingRoom>) session.getAttribute("bookedRooms");
        if(booking==null){
            getServletContext().getRequestDispatcher("/WEB-INF/Views/booking.jsp").forward(request, response);
            return;
        }
        if ("confirmPayment".equals(action)){
            BookingDAO bookingDAO= new BookingDAO();
            BookingRoomDAO bookingRoomDAO= new BookingRoomDAO();
            try{
                bookingDAO.updateBookingStatus(booking.getId(), "PAID");
                request.setAttribute("paymentMessage", "Booking succeeded");
            }
            catch(Exception e){
                e.printStackTrace();
                request.setAttribute("paymentMessage", "Booking failed");
                getServletContext().getRequestDispatcher("/WEB-INF/Views/booking.jsp").forward(request, response);
                return;
            }       
        }

        getServletContext().getRequestDispatcher("/WEB-INF/Views/payment.jsp").forward(request, response);
    }
    private void continuePayment(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        HttpSession session=request.getSession();
        VoucherDAO voucherDAO = new VoucherDAO();
        BookingDAO bookingDAO = new BookingDAO();
        long selectedBookingId = Long.parseLong(request.getParameter("selectedBookingId"));
        Booking booking = bookingDAO.getById(selectedBookingId);
        session.setAttribute("booking", booking);
        session.setAttribute("voucher", booking.getVoucherId());
        session.setAttribute("guestName",booking.getGuestName());
        session.setAttribute("guestEmail", booking.getGuestEmail());
        session.setAttribute("confirmationCode", booking.getConfirmationCode());
        session.setAttribute("checkIn", booking.getCheckIn());
        session.setAttribute("checkOut", booking.getCheckOut());
        session.setAttribute("totalGuest", booking.getTotalGuests());
        session.setAttribute("totalAmount", booking.getTotalAmount());
        
        if(booking.getVoucherId()!=null){
            session.setAttribute("voucher", voucherDAO.getById(booking.getVoucherId()));
        }       
        
        String bankId = "VCB";           // Vietnam Techcombank
        String accountNo = "0123456789"; // Your account number
        String template = "compact";     // compact or print
        String amount = booking.getTotalAmount().toString();
        String description = booking.getId().toString();
        String accountName = "lakeSide Hotel"; // Your business name
        
        // Build QR URL with correct format
        String qrUrl = "https://img.vietqr.io/image/" 
                + bankId + "-" 
                + accountNo + "-" 
                + template + ".png?"
                + "amount=" + amount;

        session.setAttribute("qrUrl", qrUrl);
        getServletContext().getRequestDispatcher("/WEB-INF/Views/payment.jsp").forward(request, response);
    }
}
