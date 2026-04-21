package com.mycompany.ltw.dao;

import com.mycompany.ltw.model.Role;
import com.mycompany.ltw.model.User;
import com.mycompany.ltw.model.Voucher;
import com.mycompany.ltw.utils.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBContext {
    /*
     * =========================== MODULE 5.2 - UserDAO ===========================
     * Mục đích:
     * - Chứa toàn bộ câu lệnh SQL của User Module.
     * - Là tầng truy cập dữ liệu (DAO) cho UserServlet.
     *
     * Input:
     * - Tham số từ servlet (email, userId, User, roleName, password...)
     * - Kết nối DB từ DBContext.getConnection()
     *
     * Output:
     * - Dữ liệu trả về cho servlet: User, List<User>, List<Voucher>, Role list
     * - Kết quả thao tác ghi DB: boolean thành công/thất bại
     *
     * Bảng dữ liệu sử dụng:
     * - user, role, user_roles, booking, voucher, user_voucher_usage
     * ========================================================================
     */

    // Xac thuc dang nhap bang email + mat khau + trang thai active.
    public User login(String email, String password) {
        String sql = "SELECT * FROM `user` WHERE email = ? AND password = ? AND is_active = 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapUserBasic(rs, true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lay thong tin user theo ID.
    public User findById(Long userId) {
        String sql = "SELECT * FROM `user` WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUserBasic(rs, true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lay danh sach tat ca user cho man hinh admin.
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM `user` ORDER BY id DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                users.add(mapUserBasic(rs, true));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    // Dang ky user moi va gan role mac dinh ROLE_USER.
    public boolean register(User user) {
        String sqlUser = "INSERT INTO `user` (first_name, last_name, email, password) VALUES (?, ?, ?, ?)";
        String sqlRole = "INSERT INTO user_roles (user_id, role_id) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            PreparedStatement psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, user.getFirstName());
            psUser.setString(2, user.getLastName());
            psUser.setString(3, user.getEmail());
            psUser.setString(4, user.getPassword());
            psUser.executeUpdate();

            ResultSet rs = psUser.getGeneratedKeys();
            if (rs.next()) {
                long newUserId = rs.getLong(1);
                PreparedStatement psRole = conn.prepareStatement(sqlRole);
                psRole.setLong(1, newUserId);
                psRole.setLong(2, 2); // ROLE_USER
                psRole.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return false;
    }

    // Cap nhat thong tin profile co ban cua user.
    public boolean updateProfile(User user) {
        String sql = "UPDATE `user` SET first_name = ?, last_name = ?, email = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getEmail());
            ps.setLong(4, user.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tao user moi tu phia admin va gan role theo chon.
    public boolean createUserByAdmin(User user, String roleName) {
        String sqlUser = "INSERT INTO `user` (first_name, last_name, email, password, is_active) VALUES (?, ?, ?, ?, ?)";
        String sqlRole = "INSERT INTO user_roles (user_id, role_id) VALUES (?, ?)";
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            PreparedStatement psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            psUser.setString(1, user.getFirstName());
            psUser.setString(2, user.getLastName());
            psUser.setString(3, user.getEmail());
            psUser.setString(4, user.getPassword());
            psUser.setBoolean(5, user.isIsActive());
            psUser.executeUpdate();

            ResultSet rs = psUser.getGeneratedKeys();
            if (rs.next()) {
                long newUserId = rs.getLong(1);
                PreparedStatement psRole = conn.prepareStatement(sqlRole);
                psRole.setLong(1, newUserId);
                psRole.setLong(2, getRoleIdByName(roleName));
                psRole.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return false;
    }

    // Cap nhat user tu phia admin, co the doi mat khau va role.
    public boolean updateUserByAdmin(User user, String roleName, String newPassword) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            String sqlUser = (newPassword == null || newPassword.trim().isEmpty())
                    ? "UPDATE `user` SET first_name = ?, last_name = ?, email = ?, is_active = ? WHERE id = ?"
                    : "UPDATE `user` SET first_name = ?, last_name = ?, email = ?, is_active = ?, password = ? WHERE id = ?";

            PreparedStatement psUser = conn.prepareStatement(sqlUser);
            psUser.setString(1, user.getFirstName());
            psUser.setString(2, user.getLastName());
            psUser.setString(3, user.getEmail());
            psUser.setBoolean(4, user.isIsActive());

            if (newPassword == null || newPassword.trim().isEmpty()) {
                psUser.setLong(5, user.getId());
            } else {
                psUser.setString(5, newPassword);
                psUser.setLong(6, user.getId());
            }
            psUser.executeUpdate();

            PreparedStatement psDeleteRole = conn.prepareStatement("DELETE FROM user_roles WHERE user_id = ?");
            psDeleteRole.setLong(1, user.getId());
            psDeleteRole.executeUpdate();

            PreparedStatement psInsertRole = conn.prepareStatement("INSERT INTO user_roles (user_id, role_id) VALUES (?, ?)");
            psInsertRole.setLong(1, user.getId());
            psInsertRole.setLong(2, getRoleIdByName(roleName));
            psInsertRole.executeUpdate();

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return false;
    }

    // Xoa user (kem mapping role) tu phia admin.
    public boolean deleteUserByAdmin(Long userId) {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            PreparedStatement psDeleteRoles = conn.prepareStatement("DELETE FROM user_roles WHERE user_id = ?");
            psDeleteRoles.setLong(1, userId);
            psDeleteRoles.executeUpdate();

            PreparedStatement psDeleteUser = conn.prepareStatement("DELETE FROM `user` WHERE id = ?");
            psDeleteUser.setLong(1, userId);
            psDeleteUser.executeUpdate();

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return false;
    }

    // Kiem tra email da ton tai chua, co the bo qua 1 user ID.
    public boolean isEmailExists(String email, Long excludeUserId) {
        String sql = (excludeUserId == null)
                ? "SELECT COUNT(*) FROM `user` WHERE email = ?"
                : "SELECT COUNT(*) FROM `user` WHERE email = ? AND id <> ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            if (excludeUserId != null) {
                ps.setLong(2, excludeUserId);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Dem tong so booking cua mot user.
    public int countBookingsByUserId(Long userId) {
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

    // Tinh so ngay tu ngay dang ky den hien tai.
    public long getMembershipDays(Long userId) {
        String sql = "SELECT DATEDIFF(CURDATE(), DATE(created_at)) FROM `user` WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getLong(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Phan nhom khach hang theo booking va thoi gian thanh vien.
    public String calculateCustomerGroup(Long userId) {
        int totalBookings = countBookingsByUserId(userId);
        long membershipDays = getMembershipDays(userId);

        if (totalBookings >= 5 || membershipDays >= 365) {
            return "VIP";
        }
        if (totalBookings >= 2 || membershipDays >= 180) {
            return "LONG_TERM";
        }
        return "ALL";
    }

    // Lay voucher kha dung theo nhom KH, han dung, gioi han su dung.
    public List<Voucher> getAvailableVouchersForUser(Long userId) {
        List<Voucher> vouchers = new ArrayList<>();
        int totalBookings = countBookingsByUserId(userId);
        long membershipDays = getMembershipDays(userId);

        String sql = "SELECT id, code, discount_value, is_percent, max_discount_amount, target_group, "
                + "group_value, usage_limit, used_count, expiry_date, is_active "
                + "FROM voucher v WHERE is_active = 1 AND expiry_date >= NOW() "
                + "AND used_count < usage_limit "
                + "AND NOT EXISTS (SELECT 1 FROM user_voucher_usage uvu WHERE uvu.user_id = ? AND uvu.voucher_id = v.id) "
                + "AND ("
                + "target_group = 'ALL' "
                + "OR (target_group = 'VIP' AND ? >= group_value) "
                + "OR (target_group = 'LONG_TERM' AND ? >= group_value)"
                + ") "
                + "ORDER BY expiry_date ASC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, userId);
            ps.setInt(2, totalBookings);
            ps.setLong(3, membershipDays);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Voucher v = new Voucher();
                v.setId(rs.getLong("id"));
                v.setCode(rs.getString("code"));
                v.setDiscountValue(rs.getDouble("discount_value"));
                v.setIsPercent(rs.getBoolean("is_percent"));
                v.setMaxDiscountAmount(rs.getDouble("max_discount_amount"));
                v.setTargetGroup(rs.getString("target_group"));
                v.setGroupValue(rs.getInt("group_value"));
                v.setUsageLimit(rs.getInt("usage_limit"));
                v.setUsedCount(rs.getInt("used_count"));
                v.setExpiryDate(rs.getTimestamp("expiry_date"));
                v.setIsActive(rs.getBoolean("is_active"));
                vouchers.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return vouchers;
    }

    // Lay danh sach role cua user.
    public List<Role> getUserRoles(Long userId) {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT r.id, r.name FROM role r "
                + "JOIN user_roles ur ON r.id = ur.role_id "
                + "WHERE ur.user_id = ?";

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

    // Tra ve role_id tu ten role, mac dinh ROLE_USER neu khong thay.
    private long getRoleIdByName(String roleName) {
        String sql = "SELECT id FROM role WHERE name = ? LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roleName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getLong("id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 2L;
    }

    // Map du lieu ResultSet thanh object User.
    private User mapUserBasic(ResultSet rs, boolean includeRoles) throws SQLException {
        User u = new User();
        u.setId(rs.getLong("id"));
        u.setEmail(rs.getString("email"));
        u.setFirstName(rs.getString("first_name"));
        u.setLastName(rs.getString("last_name"));
        u.setIsActive(rs.getBoolean("is_active"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        if (includeRoles) {
            u.setRoles(getUserRoles(u.getId()));
        }
        return u;
    }
}
