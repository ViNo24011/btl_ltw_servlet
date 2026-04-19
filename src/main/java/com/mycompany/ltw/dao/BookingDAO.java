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
import com.mycompany.ltw.dto.BookingDetailDTO;


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
            if (booking.getUserId() != null) {
                ps.setLong(1, booking.getUserId());
            } else {
                ps.setNull(1, Types.BIGINT);
            }
            if (booking.getVoucherId() != null) {
                ps.setLong(2, booking.getVoucherId());
            } else {
                ps.setNull(2, Types.BIGINT);
            }
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
    public boolean isRoomFree(long roomId, LocalDate checkIn, LocalDate checkOut) {
        String sql = """
            SELECT COUNT(*) 
            FROM booking_room br
            JOIN booking b ON br.booking_id = b.id
            WHERE br.room_id = ?
            AND b.status != 'cancelled'
            AND b.check_in < ?
            AND b.check_out > ?
        """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, roomId);
            ps.setDate(2, java.sql.Date.valueOf(checkOut)); // ⚠️ note order
            ps.setDate(3, java.sql.Date.valueOf(checkIn));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) == 0; // 0 = free
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
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

    public int countUserBookings(long userId) {
        String sql = "SELECT COUNT(*) FROM booking WHERE user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<BookingDetailDTO> getAllAdminBookings(String search, String status, String fromDate, String toDate) {
        List<BookingDetailDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT " +
            "    MAX(br.id) as id, " +
            "    b.id as booking_id, " +
            "    0 as room_id, " +
            "    b.voucher_id, " +
            "    b.check_in, " +
            "    b.check_out, " +
            "    b.guest_name, " +
            "    b.guest_email, " +
            "    b.guest_phone, " +
            "    SUM(br.num_adults) as num_adults, " +
            "    SUM(br.num_children) as num_children, " +
            "    b.total_guests, " +
            "    b.confirmation_code, " +
            "    b.total_amount, " +
            "    b.status, " +
            "    b.created_at, " +
            "    GROUP_CONCAT(CONCAT(r.id, ' - Rm ', r.room_number, ' <span style=\"color:#64748b;font-size:0.85em\">(', br.num_adults, 'A, ', br.num_children, 'C)</span>') SEPARATOR '<br>') as room_number " +
            "FROM booking b " +
            "JOIN booking_room br ON b.id = br.booking_id " +
            "JOIN room r ON br.room_id = r.id " +
            "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (b.confirmation_code LIKE ? OR b.guest_name LIKE ? OR b.guest_phone LIKE ? OR b.guest_email LIKE ?) ");
            String likeParam = "%" + search.trim() + "%";
            params.add(likeParam);
            params.add(likeParam);
            params.add(likeParam);
            params.add(likeParam);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND b.status = ? ");
            params.add(status.trim());
        }

        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND b.created_at >= ? ");
            params.add(fromDate.trim() + " 00:00:00");
        }

        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND b.created_at <= ? ");
            params.add(toDate.trim() + " 23:59:59");
        }

        sql.append(" GROUP BY b.id ORDER BY b.created_at DESC");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingDetailDTO dto = new BookingDetailDTO();
                    dto.setId(rs.getLong("id"));
                    dto.setBookingId(rs.getLong("booking_id"));
                    dto.setRoomId(rs.getLong("room_id"));
                    
                    long vid = rs.getLong("voucher_id");
                    if (!rs.wasNull()) dto.setVoucherId(vid);

                    Date ci = rs.getDate("check_in");
                    if (ci != null) dto.setCheckIn(ci.toLocalDate());

                    Date co = rs.getDate("check_out");
                    if (co != null) dto.setCheckOut(co.toLocalDate());

                    dto.setGuestName(rs.getString("guest_name"));
                    dto.setGuestEmail(rs.getString("guest_email"));
                    
                    // Fallback using try-catch inside row mapping just in case their DB hasn't been updated with guest_phone
                    String phone = "";
                    try { phone = rs.getString("guest_phone"); } catch(Exception e) {}
                    dto.setGuestPhone(phone);
                    
                    dto.setNumAdults(rs.getInt("num_adults"));
                    dto.setNumChildren(rs.getInt("num_children"));
                    dto.setTotalBookedGuests(rs.getInt("total_guests"));
                    dto.setConfirmationCode(rs.getString("confirmation_code"));
                    dto.setTotalAmount(rs.getBigDecimal("total_amount"));
                    dto.setStatus(rs.getString("status"));
                    dto.setCreatedAt(rs.getTimestamp("created_at"));
                    dto.setRoomNumber(rs.getString("room_number"));

                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateBookingStatus(long bookingId, String newStatus) {
        String sql = "UPDATE booking SET status = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setLong(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
