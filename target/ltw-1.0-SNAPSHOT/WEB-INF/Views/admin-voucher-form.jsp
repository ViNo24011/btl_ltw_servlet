<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voucher Form | LakeSide Hotel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Sora:wght@600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --ink: #1f2937;
            --muted: #6b7280;
            --border: #e5e7eb;
            --accent: #a64d79;
            --accent-strong: #8e3a64;
            --bg-grad: radial-gradient(circle at 8% 8%, #e0e7ff 0, transparent 30%),
                radial-gradient(circle at 92% 20%, #99f6e4 0, transparent 30%),
                linear-gradient(135deg, #dbeafe 0%, #eef2ff 45%, #ecfeff 100%);
        }

        * { box-sizing: border-box; }
        body { margin: 0; font-family: "Plus Jakarta Sans", sans-serif; background: var(--bg-grad); color: var(--ink); }
        .page { width: min(800px, 95%); margin: 40px auto; }

        .card {
            background: rgba(255,255,255,0.96);
            border: 1px solid #dbeafe;
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 16px 34px rgba(15, 23, 42, 0.08);
        }

        .card h1 {
            margin: 0 0 20px;
            font-family: "Sora", sans-serif;
            font-size: 1.8rem;
            color: var(--accent);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .field {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .field.full {
            grid-column: 1 / -1;
        }

        .field label {
            font-weight: 700;
            font-size: 0.9rem;
            color: #334155;
        }

        .field input, .field select {
            padding: 10px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            font: inherit;
            background: #fff;
            transition: border-color 0.2s;
        }

        .field input:focus, .field select:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(166, 77, 121, 0.15);
        }

        .btn-group {
            margin-top: 24px;
            display: flex;
            gap: 12px;
            justify-content: flex-end;
        }

        .btn {
            border: 1px solid #bfdbfe;
            background: #f8fafc;
            color: #0f172a;
            border-radius: 10px;
            padding: 10px 18px;
            font: inherit;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn.primary {
            border: none;
            color: #fff;
            background: linear-gradient(120deg, var(--accent), var(--accent-strong));
        }

        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .checkbox-lbl {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 700;
            color: #334155;
            cursor: pointer;
        }
        
        #groupValueField {
            display: none;
        }

        @media (max-width: 600px) {
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<main class="page">
    <div class="card">
        <h1>${empty voucher ? 'Thêm Voucher Mới' : 'Cập Nhật Voucher'}</h1>
        
        <form method="post" action="${pageContext.request.contextPath}/admin/voucher">
            <input type="hidden" name="id" value="${voucher.id}">
            
            <div class="form-grid">
                <div class="field full">
                    <label>Mã Voucher (Code)</label>
                    <input type="text" name="code" value="${voucher.code}" required placeholder="VD: SUMMER2026">
                </div>

                <div class="field">
                    <label>Giá trị giảm</label>
                    <input type="number" step="0.01" name="discountValue" value="${voucher.discountValue != null ? voucher.discountValue : 0}" required>
                </div>

                <div class="field">
                    <label><br></label>
                    <label class="checkbox-lbl">
                        <input type="checkbox" name="isPercent" value="true" ${voucher.isPercent ? 'checked' : ''}>
                        Giảm theo phần trăm (%)
                    </label>
                </div>

                <div class="field full">
                    <label>Số tiền giảm tối đa (Áp dụng cho %)</label>
                    <input type="number" step="0.01" name="maxDiscountAmount" value="${voucher.maxDiscountAmount != null ? voucher.maxDiscountAmount : 0}">
                </div>

                <div class="field full">
                    <label>Nhóm khách hàng mục tiêu</label>
                    <select id="targetGroup" name="targetGroup" required onchange="toggleGroupValue()">
                        <option value="ALL" ${voucher.targetGroup == 'ALL' ? 'selected' : ''}>Tất cả khách hàng</option>
                        <option value="VIP" ${voucher.targetGroup == 'VIP' ? 'selected' : ''}>Khách hàng VIP (Số lượng Booking)</option>
                        <option value="LONG_TERM" ${voucher.targetGroup == 'LONG_TERM' ? 'selected' : ''}>Khách hàng lâu năm (Thời gian)</option>
                    </select>
                </div>

                <div class="field full" id="groupValueField">
                    <label id="groupValueLabel">Giá trị điều kiện (Số lượng Booking hoặc Số ngày tham gia)</label>
                    <input type="number" id="groupValueInput" name="groupValue" value="${voucher.groupValue != null ? voucher.groupValue : 0}">
                    <small style="color: #64748b; margin-top: 4px;" id="groupValueHint">Điền số lượng booking (VD: 5, 10, 15) hoặc số ngày (VD: 365).</small>
                </div>

                <div class="field">
                    <label>Số lượng sử dụng tối đa</label>
                    <input type="number" name="usageLimit" value="${voucher.usageLimit != null ? voucher.usageLimit : 100}" required>
                </div>

                <div class="field">
                    <label>Thời hạn sử dụng (Expiry Date)</label>
                    <%
                        String expiryStr = "";
                        if (request.getAttribute("voucher") != null) {
                            com.mycompany.ltw.model.Voucher v = (com.mycompany.ltw.model.Voucher) request.getAttribute("voucher");
                            if (v.getExpiryDate() != null) {
                                expiryStr = v.getExpiryDate().toString().substring(0, 16).replace(' ', 'T');
                            }
                        }
                    %>
                    <input type="datetime-local" name="expiryDate" value="<%= expiryStr %>" required>
                </div>

                <div class="field full" style="margin-top: 10px;">
                    <label class="checkbox-lbl">
                        <input type="checkbox" name="isActive" value="true" ${voucher.isActive || empty voucher ? 'checked' : ''}>
                        Kích hoạt Voucher (Active)
                    </label>
                </div>
            </div>

            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/admin/voucher?action=list" class="btn">Hủy</a>
                <button type="submit" class="btn primary">Lưu Voucher</button>
            </div>
        </form>
    </div>
</main>

<script>
    function toggleGroupValue() {
        var targetSelect = document.getElementById('targetGroup');
        var groupField = document.getElementById('groupValueField');
        var groupLabel = document.getElementById('groupValueLabel');
        var groupHint = document.getElementById('groupValueHint');
        
        if (targetSelect.value === 'ALL') {
            groupField.style.display = 'none';
        } else {
            groupField.style.display = 'flex';
            if (targetSelect.value === 'VIP') {
                groupLabel.innerText = "Số lượng booking tối thiểu (VD: 5, 10, 15)";
                groupHint.innerText = "Khách hàng phải có số lượng booking lớn hơn hoặc bằng giá trị này.";
            } else if (targetSelect.value === 'LONG_TERM') {
                groupLabel.innerText = "Số ngày tham gia tối thiểu";
                groupHint.innerText = "Khách hàng phải tạo tài khoản cách đây số ngày truyền vào.";
            }
        }
    }

    // Initialize display on load
    window.onload = toggleGroupValue;
</script>
</body>
</html>
