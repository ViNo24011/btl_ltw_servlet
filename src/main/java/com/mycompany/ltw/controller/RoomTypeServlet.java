package com.mycompany.ltw.controller;

import com.mycompany.ltw.dao.RoomTypeDAO;
import com.mycompany.ltw.model.RoomType;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

public class RoomTypeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        RoomTypeDAO dao = new RoomTypeDAO();

        RoomType rt = new RoomType();
        rt.setName(req.getParameter("name"));
        rt.setBasePrice(new BigDecimal(req.getParameter("price")));
        rt.setMaxCapacity(Integer.parseInt(req.getParameter("capacity")));
        rt.setDescription(req.getParameter("description"));

        dao.insert(rt);

        resp.sendRedirect("room");
    }
}
