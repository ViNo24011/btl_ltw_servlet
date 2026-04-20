package com.mycompany.ltw.controller;

import com.mycompany.ltw.dao.BookingDAO;
import com.mycompany.ltw.dto.BookingDetailDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "BookingAdminServlet", urlPatterns = {"/admin/booking"})
public class BookingAdminServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            doPost(request, response);
            return;
        }

        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        List<BookingDetailDTO> bookings = bookingDAO.getAllAdminBookings(search, status, fromDate, toDate);

        request.setAttribute("bookings", bookings);
        request.setAttribute("search", search);
        request.setAttribute("status", status);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);

        request.getRequestDispatcher("/WEB-INF/Views/admin-booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            try {
                long bookingId = Long.parseLong(request.getParameter("id"));
                String newStatus = request.getParameter("newStatus");
                
                if (newStatus != null && !newStatus.isEmpty()) {
                    bookingDAO.updateBookingStatus(bookingId, newStatus);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // Preserve filter parameters when redirecting back
        String search = request.getParameter("search");
        String statusFilter = request.getParameter("statusFilter");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/admin/booking?");
        if (search != null) redirectUrl.append("search=").append(search).append("&");
        if (statusFilter != null) redirectUrl.append("status=").append(statusFilter).append("&");
        if (fromDate != null) redirectUrl.append("fromDate=").append(fromDate).append("&");
        if (toDate != null) redirectUrl.append("toDate=").append(toDate).append("&");

        response.sendRedirect(redirectUrl.toString());
    }
}
