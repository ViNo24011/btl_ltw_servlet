package com.mycompany.ltw.dao;

import com.mycompany.ltw.model.RoomType;
import com.mycompany.ltw.utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomTypeDAO {

    // ================= GET ALL =================
    public List<RoomType> getAll() {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT * FROM room_type ORDER BY id DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RoomType rt = new RoomType();
                rt.setId(rs.getLong("id"));
                rt.setName(rs.getString("name"));
                rt.setBasePrice(rs.getBigDecimal("base_price"));
                rt.setMaxCapacity(rs.getInt("max_capacity"));
                rt.setDescription(rs.getString("description"));
                list.add(rt);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================= GET BY ID =================
    public RoomType getById(Long id) {
        String sql = "SELECT * FROM room_type WHERE id=?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                RoomType rt = new RoomType();
                rt.setId(rs.getLong("id"));
                rt.setName(rs.getString("name"));
                rt.setBasePrice(rs.getBigDecimal("base_price"));
                rt.setMaxCapacity(rs.getInt("max_capacity"));
                rt.setDescription(rs.getString("description"));
                return rt;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ================= INSERT =================
    public void insert(RoomType rt) {
        String sql = "INSERT INTO room_type(name, base_price, max_capacity, description) VALUES (?,?,?,?)";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, rt.getName());
            ps.setBigDecimal(2, rt.getBasePrice());
            ps.setInt(3, rt.getMaxCapacity());
            ps.setString(4, rt.getDescription());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= UPDATE =================
    public void update(RoomType rt) {
        String sql = "UPDATE room_type SET name=?, base_price=?, max_capacity=?, description=? WHERE id=?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, rt.getName());
            ps.setBigDecimal(2, rt.getBasePrice());
            ps.setInt(3, rt.getMaxCapacity());
            ps.setString(4, rt.getDescription());
            ps.setLong(5, rt.getId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

  
    public boolean delete(Long id) {
        String sql = "DELETE FROM room_type WHERE id=?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (SQLException e) {
            
            return false;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasRoom(Long roomTypeId) {
        String sql = "SELECT COUNT(*) FROM room WHERE room_type_id=?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, roomTypeId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}