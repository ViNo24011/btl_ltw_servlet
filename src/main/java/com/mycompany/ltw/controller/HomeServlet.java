package com.mycompany.ltw.controller;

import com.mycompany.ltw.dao.RoomDAO;
import com.mycompany.ltw.dao.RoomTypeDAO;
import com.mycompany.ltw.model.Room;
import com.mycompany.ltw.model.RoomType;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy dữ liệu từ database
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