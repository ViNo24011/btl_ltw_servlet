/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.ltw.dao;

import com.mycompany.ltw.model.Booking;
import com.mycompany.ltw.model.Room;
import com.mycompany.ltw.model.Voucher;
import com.mycompany.ltw.utils.DBContext;
import java.sql.*;
import java.sql.DriverManager;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;


/**
 *
 * @author Admin
 */
public class BookingDAO extends DBContext {

    public long createBooking(Connection conn, Booking booking) {
        String sql = "INSERT INTO booking "
                + "(user_id, voucher_id, check_in, check_out, guest_name, guest_email, total_guests, confirmation_code, total_amount, status, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

        try (
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Set parameters
            ps.setObject(1, booking.getUserId()); // can be null
            ps.setObject(2, booking.getVoucherId()); // can be null
            ps.setDate(3, java.sql.Date.valueOf(booking.getCheckIn()));
            ps.setDate(4, java.sql.Date.valueOf(booking.getCheckOut()));
            ps.setString(5, booking.getGuestName());
            ps.setString(6, booking.getGuestEmail());
            ps.setInt(7, booking.getTotalGuests());
            ps.setString(8, booking.getConfirmationCode());
            ps.setBigDecimal(9, booking.getTotalAmount());
            ps.setString(10, booking.getStatus());

            ps.executeUpdate();

            //Get generated ID
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {//To next row
                return rs.getLong(1);//Get the id in the first column (the only column returned)
            }
           
        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1; //Failed
    }
    public List<Room> getFreeRooms(LocalDate checkIn, LocalDate checkOut, Long roomTypeID) throws SQLException {
        List<Room> freeRooms = new ArrayList<>();
        String sql = """
            SELECT r.*
            FROM room r
            JOIN room_type rt ON r.room_type_id=rt.id
            WHERE rt.id = ? AND NOT EXISTS (
                SELECT 1
                FROM booking_room br
                JOIN booking b ON b.id = br.booking_id
                WHERE br.room_id = r.id
                  AND b.check_in <= ?
                  AND b.check_out >= ?
            );
        """;
        try{
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ps.setLong(1, roomTypeID);
            ps.setString(2, checkOut.toString());
            ps.setString(3, checkIn.toString());

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Room room = new Room(rs.getLong("id"), 
                        rs.getLong("room_type_id"), 
                        rs.getString("room_number"), 
                        rs.getString("photo"), 
                        rs.getString("status"));
                freeRooms.add(room);
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }      
        return freeRooms;
    }
    public Voucher getVoucherByCode(String code) {
        Voucher voucher = null;

        String sql = "SELECT * FROM voucher WHERE code = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, code);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                voucher = new Voucher();

                voucher.setId(rs.getLong("id"));
                voucher.setCode(rs.getString("code"));
                voucher.setDiscountValue(rs.getDouble("discount_value"));
                voucher.setIsPercent(rs.getBoolean("is_percent"));
                voucher.setMaxDiscountAmount(rs.getDouble("max_discount_amount"));
                voucher.setTargetGroup(rs.getString("target_group"));
                voucher.setGroupValue(rs.getInt("group_value"));
                voucher.setUsageLimit(rs.getInt("usage_limit"));
                voucher.setUsedCount(rs.getInt("used_count"));
                voucher.setExpiryDate(rs.getTimestamp("expiry_date"));
                voucher.setIsActive(rs.getBoolean("is_active"));
            }
           
        } catch (Exception e) {
            e.printStackTrace();
        }

        return voucher;
    }
    public boolean updateVoucherUseCountById(Connection conn, long id) {
        String sql = "UPDATE voucher " +
                     "SET used_count = used_count + 1 " +
                     "WHERE id = ? AND used_count < usage_limit";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);

            int rowsAffected = ps.executeUpdate();
           

            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
