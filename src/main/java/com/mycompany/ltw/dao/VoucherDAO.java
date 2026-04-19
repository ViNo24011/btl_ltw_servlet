package com.mycompany.ltw.dao;

import com.mycompany.ltw.model.Voucher;
import com.mycompany.ltw.utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    public List<Voucher> getAll() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM voucher ORDER BY id DESC";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Voucher v = extractVoucherFromResultSet(rs);
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Voucher> getVouchers(int page, int size) {
        List<Voucher> list = new ArrayList<>();
        int offset = (page - 1) * size;
        String sql = "SELECT * FROM voucher ORDER BY id DESC LIMIT ? OFFSET ?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, size);
            ps.setInt(2, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractVoucherFromResultSet(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countVouchers() {
        String sql = "SELECT COUNT(*) FROM voucher";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Voucher getById(Long id) {
        String sql = "SELECT * FROM voucher WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractVoucherFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insert(Voucher v) {
        String sql = "INSERT INTO voucher (code, discount_value, is_percent, max_discount_amount, target_group, group_value, usage_limit, used_count, expiry_date, is_active) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            setPreparedStatementForVoucher(ps, v);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(Voucher v) {
        String sql = "UPDATE voucher SET code=?, discount_value=?, is_percent=?, max_discount_amount=?, target_group=?, group_value=?, usage_limit=?, used_count=?, expiry_date=?, is_active=? "
                +
                "WHERE id=?";

        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            setPreparedStatementForVoucher(ps, v);
            ps.setLong(11, v.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(Long id) {
        String sql = "DELETE FROM voucher WHERE id=?";
        try (Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setLong(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Voucher extractVoucherFromResultSet(ResultSet rs) throws Exception {
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
        return v;
    }

    private void setPreparedStatementForVoucher(PreparedStatement ps, Voucher v) throws Exception {
        ps.setString(1, v.getCode());
        ps.setDouble(2, v.getDiscountValue());
        ps.setBoolean(3, v.isIsPercent());
        ps.setDouble(4, v.getMaxDiscountAmount());
        ps.setString(5, v.getTargetGroup());
        ps.setInt(6, v.getGroupValue());
        ps.setInt(7, v.getUsageLimit());
        ps.setInt(8, v.getUsedCount());
        ps.setTimestamp(9, v.getExpiryDate());
        ps.setBoolean(10, v.isIsActive());
    }
}
