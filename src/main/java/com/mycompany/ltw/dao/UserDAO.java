package com.mycompany.ltw.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.mycompany.ltw.model.Role;
import com.mycompany.ltw.model.User;
import com.mycompany.ltw.utils.DBContext;

public class UserDAO extends DBContext {

    // 1. Hàm Đăng nhập: Trả về đối tượng User đầy đủ kèm danh sách Roles
    public User login(String email, String password) {
        String sql = "SELECT * FROM user WHERE email = ? AND password = ? AND is_active = 1";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getLong("id"));
                u.setEmail(rs.getString("email"));
                u.setFirstName(rs.getString("first_name"));
                u.setLastName(rs.getString("last_name"));
                u.setActive(rs.getBoolean("is_active"));
                
                // Quan trọng: Lấy luôn danh sách quyền của User này
                u.setRoles(getUserRoles(u.getId()));
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 2. Hàm lấy danh sách quyền (Roles) từ bảng trung gian user_roles
    private List<Role> getUserRoles(Long userId) {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT r.id, r.name FROM role r " +
                     "JOIN user_roles ur ON r.id = ur.role_id " +
                     "WHERE ur.user_id = ?";
        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                roles.add(new Role(rs.getLong("id"), rs.getString("name")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return roles;
    }

    // 3. Hàm Đăng ký: Sử dụng Transaction để lưu vào 2 bảng cùng lúc
    public boolean register(User user) {
        String sqlUser = "INSERT INTO user (first_name, last_name, email, password, is_active) VALUES (?, ?, ?, ?, 1)";
        String sqlRole = "INSERT INTO user_roles (user_id, role_id) VALUES (?, ?)";
        
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // Bắt đầu giao dịch (Transaction)

            // Bước A: Thêm vào bảng user và lấy ID tự tăng vừa tạo
            PreparedStatement psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, user.getFirstName());
            psUser.setString(2, user.getLastName());
            psUser.setString(3, user.getEmail());
            psUser.setString(4, user.getPassword());
            psUser.executeUpdate();

            ResultSet rs = psUser.getGeneratedKeys();
            if (rs.next()) {
                long newUserId = rs.getLong(1);
                
                // Bước B: Gán quyền mặc định là ROLE_USER (Giả sử ID của ROLE_USER là 2)
                PreparedStatement psRole = conn.prepareStatement(sqlRole);
                psRole.setLong(1, newUserId);
                psRole.setLong(2, 2); 
                psRole.executeUpdate();
            }

            conn.commit(); // Thành công hết thì mới lưu thật vào DB
            return true;
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) {} // Lỗi thì hủy hết
            e.printStackTrace();
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException ex) {}
        }
        return false;
    }
}