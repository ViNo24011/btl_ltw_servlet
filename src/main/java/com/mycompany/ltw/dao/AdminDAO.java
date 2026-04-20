package com.mycompany.ltw.dao;

import com.mycompany.ltw.utils.DBContext;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminDAO {

    public int getGlobalMetric(String metricType) {
        String sql = "";
        switch (metricType) {
            case "TOTAL_ROOMS":
                sql = "SELECT COUNT(*) FROM room";
                break;
            case "TOTAL_BOOKINGS":
                sql = "SELECT COUNT(*) FROM booking";
                break;
            case "PAID_BOOKINGS_COUNT":
                sql = "SELECT COUNT(*) FROM booking WHERE status='PAID'";
                break;
            case "CHECKED_OUT_BOOKINGS":
                sql = "SELECT COUNT(*) FROM booking WHERE status='CHECKED-OUT'";
                break;
            default: return 0;
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public BigDecimal getTotalRevenue(String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder("SELECT SUM(total_amount) FROM booking WHERE status IN ('PAID', 'CHECKED-IN', 'CHECKED-OUT')");
        List<Object> params = new ArrayList<>();

        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append(" AND created_at >= ? ");
            params.add(fromDate.trim() + " 00:00:00");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append(" AND created_at <= ? ");
            params.add(toDate.trim() + " 23:59:59");
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal result = rs.getBigDecimal(1);
                    return result != null ? result : BigDecimal.ZERO;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public List<Map<String, Object>> getRevenueChartData() {
        List<Map<String, Object>> result = new ArrayList<>();
        // Query daily revenue
        String sql = "SELECT DATE(created_at) as dt, SUM(total_amount) as revenue " +
                     "FROM booking WHERE status IN ('PAID', 'CHECKED-IN', 'CHECKED-OUT') " +
                     "GROUP BY DATE(created_at) " +
                     "ORDER BY dt ASC " +
                     "LIMIT 30"; // Up to 30 days
                     
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("date", rs.getString("dt"));
                map.put("revenue", rs.getBigDecimal("revenue"));
                result.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Map<String, Object>> getStatusChartData() {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT status, COUNT(*) as cnt FROM booking GROUP BY status";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("status", rs.getString("status"));
                map.put("count", rs.getInt("cnt"));
                result.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Map<String, Object>> getRoomPerformance(Long typeId) {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT r.room_number, " +
                     "COUNT(CASE WHEN b.status IN ('PAID', 'CHECKED-IN', 'CHECKED-OUT') THEN br.id ELSE NULL END) as booking_count, " +
                     "SUM(CASE WHEN b.status IN ('PAID', 'CHECKED-IN', 'CHECKED-OUT') THEN rt.base_price * DATEDIFF(b.check_out, b.check_in) ELSE 0 END) as revenue " +
                     "FROM room r " +
                     "JOIN room_type rt ON r.room_type_id = rt.id " +
                     "LEFT JOIN booking_room br ON r.id = br.room_id " +
                     "LEFT JOIN booking b ON br.booking_id = b.id " +
                     "WHERE (r.room_type_id = ? OR ? is NULL) " +
                     "GROUP BY r.room_number " +
                     "ORDER BY revenue DESC, r.room_number ASC";
                     
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (typeId != null) {
                ps.setLong(1, typeId);
                ps.setLong(2, typeId);
            } else {
                ps.setNull(1, java.sql.Types.BIGINT);
                ps.setNull(2, java.sql.Types.BIGINT);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("roomNumber", rs.getString("room_number"));
                    map.put("bookingCount", rs.getInt("booking_count"));
                    BigDecimal rev = rs.getBigDecimal("revenue");
                    map.put("revenue", rev != null ? rev : BigDecimal.ZERO);
                    result.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
