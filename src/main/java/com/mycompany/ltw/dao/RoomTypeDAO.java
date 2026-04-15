package com.mycompany.ltw.dao;

import com.mycompany.ltw.model.RoomType;
import com.mycompany.ltw.utils.DBContext;

import java.sql.*;
import java.util.*;

public class RoomTypeDAO extends DBContext {

    public List<RoomType> getAll() {
        List<RoomType> list = new ArrayList<>();

        try (Connection conn = getConnection();
             Statement st = conn.createStatement()) {

            ResultSet rs = st.executeQuery("SELECT * FROM room_type");

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

    public void insert(RoomType rt) {
        String sql = "INSERT INTO room_type(name, base_price, max_capacity, description) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
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
}
