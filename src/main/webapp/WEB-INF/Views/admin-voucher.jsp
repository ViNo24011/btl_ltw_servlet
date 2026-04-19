<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voucher Management | LakeSide Hotel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Sora:wght@600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --ink: #1f2937;
            --muted: #6b7280;
            --panel: #ffffff;
            --border: #e5e7eb;
            --accent: #a64d79;
            --accent-strong: #8e3a64;
            --bg-grad: radial-gradient(circle at 8% 8%, #e0e7ff 0, transparent 30%),
                radial-gradient(circle at 92% 20%, #99f6e4 0, transparent 30%),
                linear-gradient(135deg, #dbeafe 0%, #eef2ff 45%, #ecfeff 100%);
        }

        * { box-sizing: border-box; }
        body { margin: 0; font-family: "Plus Jakarta Sans", sans-serif; background: var(--bg-grad); color: var(--ink); }
        .page { width: min(1180px, 95%); margin: 26px auto; }

        .topbar {
            background: rgba(255,255,255,0.94);
            border: 1px solid #dbeafe;
            border-radius: 22px;
            padding: 14px 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            box-shadow: 0 16px 34px rgba(15, 23, 42, 0.08);
        }

        .brand { font-family: "Sora", sans-serif; font-size: 1.4rem; }
        .brand .accent { color: var(--accent); }

        .menu { display: flex; gap: 10px; flex-wrap: wrap; }
        .menu a {
            text-decoration: none;
            color: #0f172a;
            border: 1px solid #bfdbfe;
            background: #f8fafc;
            border-radius: 999px;
            padding: 9px 14px;
            font-weight: 600;
        }

        .toolbar {
            margin-top: 16px;
            background: rgba(255,255,255,0.95);
            border: 1px solid #dbeafe;
            border-radius: 18px;
            padding: 14px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        .toolbar h1 {
            margin: 0;
            font-family: "Sora", sans-serif;
            font-size: clamp(1.2rem, 2.4vw, 1.8rem);
        }

        .btn {
            border: 1px solid #bfdbfe;
            background: #f8fafc;
            color: #0f172a;
            border-radius: 12px;
            padding: 9px 12px;
            font: inherit;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
        }

        .btn.primary {
            border: none;
            color: #fff;
            background: linear-gradient(120deg, var(--accent), var(--accent-strong));
        }

        .alert {
            margin-top: 12px;
            border-radius: 12px;
            padding: 10px 12px;
            border: 1px solid;
            font-weight: 600;
        }
        .alert.success { background: #ecfdf5; color: #065f46; border-color: #a7f3d0; }
        .alert.error { background: #fff1f2; color: #9f1239; border-color: #fecdd3; }

        .table-wrap {
            margin-top: 14px;
            background: rgba(255,255,255,0.95);
            border: 1px solid #dbeafe;
            border-radius: 18px;
            overflow: auto;
            box-shadow: 0 12px 26px rgba(15, 23, 42, 0.08);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 980px;
        }

        thead th {
            text-align: left;
            background: #f8fafc;
            color: #334155;
            border-bottom: 1px solid var(--border);
            padding: 12px 10px;
            font-size: 0.88rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        tbody td {
            padding: 12px 10px;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }

        tbody tr:hover { background: #f8fafc; }

        .pill {
            display: inline-block;
            border-radius: 999px;
            padding: 5px 10px;
            font-size: 0.8rem;
            font-weight: 700;
            white-space: nowrap;
        }

        .pill.target-vip { background: #fee2e2; color: #991b1b; }
        .pill.target-long { background: #ffedd5; color: #9a3412; }
        .pill.target-all { background: #e0f2fe; color: #075985; }

        .pill.active { background: #dcfce7; color: #166534; }
        .pill.inactive { background: #e5e7eb; color: #374151; }

        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        @media (max-width: 900px) {
            .topbar, .toolbar { flex-direction: column; align-items: flex-start; }
        }
    </style>
</head>
<body>
<main class="page">
    <header class="topbar">
        <div class="brand"><span class="accent">lake</span>Side Hotel</div>
        <nav class="menu">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="${pageContext.request.contextPath}/roomtype">Manage Room</a>
            <a href="${pageContext.request.contextPath}/admin/voucher">Manage Voucher</a>
            <a href="${pageContext.request.contextPath}/admin/booking">Manage Booking</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>
    </header>

    <section class="toolbar">
        <h1>Voucher Management</h1>
        <div style="display:flex; gap:8px;">
            <a class="btn" href="${pageContext.request.contextPath}/home">Back Home</a>
            <a class="btn primary" href="${pageContext.request.contextPath}/admin/voucher?action=new">Add Voucher</a>
        </div>
    </section>

    <section class="table-wrap">
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Code</th>
                <th>Discount</th>
                <th>Target Group</th>
                <th>Condition</th>
                <th>Usage</th>
                <th>Expires</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="v" items="${vouchers}">
                <tr>
                    <td>${v.id}</td>
                    <td><strong>${v.code}</strong></td>
                    <td>
                        <c:choose>
                            <c:when test="${v.isPercent}">${v.discountValue}%</c:when>
                            <c:otherwise><fmt:formatNumber value="${v.discountValue}" type="number" groupingUsed="true" /> VND</c:otherwise>
                        </c:choose>
                        <c:if test="${v.maxDiscountAmount > 0}">
                            <br><small>Max: <fmt:formatNumber value="${v.maxDiscountAmount}" /></small>
                        </c:if>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${v.targetGroup == 'VIP'}"><span class="pill target-vip">VIP</span></c:when>
                            <c:when test="${v.targetGroup == 'LONG_TERM'}"><span class="pill target-long">Long Term</span></c:when>
                            <c:otherwise><span class="pill target-all">All Customers</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${v.targetGroup == 'VIP'}">>= ${v.groupValue} bookings</c:when>
                            <c:when test="${v.targetGroup == 'LONG_TERM'}">>= ${v.groupValue} days joined</c:when>
                            <c:otherwise>None</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${v.usedCount} / ${v.usageLimit}</td>
                    <td><fmt:formatDate value="${v.expiryDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                    <td>
                        <c:choose>
                            <c:when test="${v.isActive}"><span class="pill active">Active</span></c:when>
                            <c:otherwise><span class="pill inactive">Inactive</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div class="actions">
                            <a class="btn" href="${pageContext.request.contextPath}/admin/voucher?action=edit&id=${v.id}">Edit</a>
                            <a href="${pageContext.request.contextPath}/admin/voucher?action=delete&id=${v.id}"
                               class="btn" style="border-color:#fecaca; color:#9f1239; background:#fff1f2;"
                               onclick="return confirm('Delete this voucher?');">Delete</a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>
