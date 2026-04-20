package com.mycompany.ltw.controller;

import com.mycompany.ltw.dao.VoucherDAO;
import com.mycompany.ltw.model.Role;
import com.mycompany.ltw.model.User;
import com.mycompany.ltw.model.Voucher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "VoucherAdminServlet", urlPatterns = {"/admin/voucher"})
public class VoucherAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/access-denied.jsp");
            return;
        }

        VoucherDAO dao = new VoucherDAO();
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                List<Voucher> vouchers = dao.getAll();
                req.setAttribute("vouchers", vouchers);
                req.getRequestDispatcher("/WEB-INF/Views/admin-voucher.jsp").forward(req, resp);
                break;

            case "new":
                req.getRequestDispatcher("/WEB-INF/Views/admin-voucher-form.jsp").forward(req, resp);
                break;

            case "edit":
                Long id = Long.valueOf(req.getParameter("id"));
                Voucher v = dao.getById(id);
                req.setAttribute("voucher", v);
                req.getRequestDispatcher("/WEB-INF/Views/admin-voucher-form.jsp").forward(req, resp);
                break;

            case "delete":
                Long delId = Long.valueOf(req.getParameter("id"));
                dao.delete(delId);
                resp.sendRedirect(req.getContextPath() + "/admin/voucher?action=list");
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/admin/voucher?action=list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/access-denied.jsp");
            return;
        }

        VoucherDAO dao = new VoucherDAO();
        String idStr = req.getParameter("id");

        Voucher v = new Voucher();
        v.setCode(req.getParameter("code"));
        v.setDiscountValue(Double.parseDouble(req.getParameter("discountValue")));
        v.setIsPercent(req.getParameter("isPercent") != null);
        
        String maxDiscountStr = req.getParameter("maxDiscountAmount");
        if (maxDiscountStr != null && !maxDiscountStr.trim().isEmpty()) {
            v.setMaxDiscountAmount(Double.parseDouble(maxDiscountStr));
        } else {
            v.setMaxDiscountAmount(0);
        }

        v.setTargetGroup(req.getParameter("targetGroup"));
        
        String groupValueStr = req.getParameter("groupValue");
        if (groupValueStr != null && !groupValueStr.trim().isEmpty()) {
            v.setGroupValue(Integer.parseInt(groupValueStr));
        } else {
            v.setGroupValue(0);
        }

        v.setUsageLimit(Integer.parseInt(req.getParameter("usageLimit")));
        v.setUsedCount(0); // For new vouchers.
        if (idStr != null && !idStr.isEmpty()) {
            Voucher existing = dao.getById(Long.valueOf(idStr));
            v.setUsedCount(existing.getUsedCount());
        }

        String expiryStr = req.getParameter("expiryDate");
        if (expiryStr != null && !expiryStr.isEmpty()) {
            // expiryStr format from input type="datetime-local": yyyy-MM-dd'T'HH:mm
            if (expiryStr.length() == 16) {
                expiryStr += ":00"; // Append seconds to match Timestamp format
            }
            v.setExpiryDate(Timestamp.valueOf(expiryStr.replace("T", " ")));
        } else {
            v.setExpiryDate(new Timestamp(System.currentTimeMillis() + 86400000L * 30)); // 30 days default
        }

        v.setIsActive(req.getParameter("isActive") != null);

        if (idStr == null || idStr.isEmpty()) {
            dao.insert(v);
        } else {
            v.getId(); // just to be safe
            v.setId(Long.valueOf(idStr));
            dao.update(v);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/voucher?action=list");
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                for (Role r : user.getRoles()) {
                    if ("ROLE_ADMIN".equals(r.getName())) return true;
                }
            }
        }
        return false;
    }
}
