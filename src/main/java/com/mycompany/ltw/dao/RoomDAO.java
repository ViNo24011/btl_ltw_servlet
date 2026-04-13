package com.mycompany.ltw.dao;

import com.mycompany.ltw.model.*;
import com.mycompany.ltw.utils.DBContext;

import java.sql.*;
import java.util.*;

public class RoomDAO {

    public List<Room> getRooms(int page, int size) {
        List<Room> list = new ArrayList<>();

        String sql = "SELECT r.*, rt.name, rt.base_price, rt.max_capacity, rt.description "
                + "FROM room r JOIN room_type rt ON r.room_type_id = rt.id "
                + "LIMIT ?, ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, (page - 1) * size);
            ps.setInt(2, size);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setId(rs.getLong("room_type_id"));
                rt.setName(rs.getString("name"));
                rt.setBasePrice(rs.getBigDecimal("base_price"));
                rt.setMaxCapacity(rs.getInt("max_capacity"));
                rt.setDescription(rs.getString("description"));

                Room r = new Room();
                r.setId(rs.getLong("id"));
                r.setRoomNumber(rs.getString("room_number"));
                r.setPhoto(rs.getString("photo"));
                r.setStatus(rs.getString("status"));

                r.setRoomTypeId(rs.getLong("room_type_id")); // ✔ DB
                r.setRoomType(rt); // ✔ hiển thị

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Room getById(Long id) {
        String sql = "SELECT r.*, rt.name, rt.base_price, rt.max_capacity, rt.description "
                + "FROM room r JOIN room_type rt ON r.room_type_id = rt.id WHERE r.id=?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                RoomType rt = new RoomType();
                rt.setId(rs.getLong("room_type_id"));
                rt.setName(rs.getString("name"));
                rt.setBasePrice(rs.getBigDecimal("base_price"));
                rt.setMaxCapacity(rs.getInt("max_capacity"));
                rt.setDescription(rs.getString("description"));

                Room r = new Room();
                r.setId(rs.getLong("id"));
                r.setRoomNumber(rs.getString("room_number"));
                r.setPhoto(rs.getString("photo"));
                r.setStatus(rs.getString("status"));

                r.setRoomTypeId(rs.getLong("room_type_id"));
                r.setRoomType(rt);

                return r;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(Room r) {
        String sql = "INSERT INTO room(room_type_id, room_number, photo, status) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, r.getRoomTypeId());
            ps.setString(2, r.getRoomNumber());
            ps.setString(3, r.getPhoto());
            ps.setString(4, r.getStatus());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(Room r) {
        String sql = "UPDATE room SET room_type_id=?, room_number=?, photo=?, status=? WHERE id=?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, r.getRoomTypeId());
            ps.setString(2, r.getRoomNumber());
            ps.setString(3, r.getPhoto());
            ps.setString(4, r.getStatus());
            ps.setLong(5, r.getId());

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(Long id) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM room WHERE id=?")) {

            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public int countRooms() {
    String sql = "SELECT COUNT(*) FROM room";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);

    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}
}
