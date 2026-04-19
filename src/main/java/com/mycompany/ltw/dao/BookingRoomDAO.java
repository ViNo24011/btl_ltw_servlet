/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ltw.dao;

import com.mycompany.ltw.model.Booking;
import com.mycompany.ltw.model.BookingRoom;
import com.mycompany.ltw.utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author Admin
 */
public class BookingRoomDAO extends DBContext{
    public void createBookingRoom(Connection conn, BookingRoom bookingRoom) throws SQLException, Exception {
        String sql = "INSERT INTO booking_room "
                   + "(booking_id, room_id, price_at_booking, num_adults, num_children) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, bookingRoom.getBookingId());
            ps.setLong(2, bookingRoom.getRoomId());
            ps.setBigDecimal(3, bookingRoom.getPriceAtBooking());
            ps.setInt(4, bookingRoom.getNumAdults());
            ps.setInt(5, bookingRoom.getNumChildren());

            ps.executeUpdate();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
}
