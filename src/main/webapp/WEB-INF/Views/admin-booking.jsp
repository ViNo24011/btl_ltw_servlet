<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Management | LakeSide Hotel</title>
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
        .page { width: min(1400px, 98%); margin: 26px auto; }

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
            transition: all 0.2s;
        }
        .menu a:hover { background: #eff6ff; }

        .toolbar {
            margin-top: 16px;
            background: rgba(255,255,255,0.95);
            border: 1px solid #dbeafe;
            border-radius: 18px;
            padding: 16px;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }

        .toolbar h1 {
            margin: 0;
            font-family: "Sora", sans-serif;
            font-size: clamp(1.2rem, 2.4vw, 1.8rem);
        }

        /* Filter Section Styling matching user request */
        .filter-bar {
            display: grid;
            grid-template-columns: minmax(200px, 2fr) minmax(150px, 1fr) minmax(150px, 1fr) minmax(150px, 1fr) auto auto;
            gap: 12px;
            align-items: end;
        }

        .filter-item {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .filter-item label {
            font-size: 0.85rem;
            font-weight: 700;
            color: #475569;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .filter-item input, .filter-item select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            background: #fff;
            font: inherit;
            outline: none;
        }

        .filter-item input:focus, .filter-item select:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.1);
        }

        .btn {
            border: 1px solid #bfdbfe;
            background: #f8fafc;
            color: #0f172a;
            border-radius: 10px;
            padding: 10px 16px;
            font: inherit;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            height: 42px;
        }

        .btn.primary {
            border: none;
            color: #fff;
            background: #7c3aed; /* Purplish hue to match filter button */
        }
        
        .btn.primary:hover {
            background: #6d28d9;
        }

        .btn.icon-only {
            padding: 0;
            width: 42px;
            font-size: 1.2rem;
            background: #fff;
            border-color: #cbd5e1;
            color: #64748b;
        }

        .table-wrap {
            margin-top: 14px;
            background: rgba(255,255,255,0.95);
            border: 1px solid #dbeafe;
            border-radius: 18px;
            overflow: auto; /* horizontally scrollable */
            box-shadow: 0 12px 26px rgba(15, 23, 42, 0.08);
            max-height: 70vh;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            white-space: nowrap;
        }

        thead {
            position: sticky;
            top: 0;
            z-index: 10;
        }

        thead th {
            text-align: left;
            background: #f8fafc;
            color: #334155;
            border-bottom: 2px solid var(--border);
            padding: 12px 14px;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }

        tbody td {
            padding: 12px 14px;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
            font-size: 0.95rem;
        }

        tbody tr:hover { background: #f0fdf4; }

        .status-badge {
            display: inline-block;
            border-radius: 999px;
            padding: 4px 10px;
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
        }
        
        .status-badge.paid { background: #fef08a; color: #854d0e; }
        .status-badge.checked-in { background: #bfdbfe; color: #1e3a8a; }
        .status-badge.checked-out { background: #bbf7d0; color: #14532d; }
        .status-badge.cancelled { background: #fecaca; color: #7f1d1d; }

        .time-subtext {
            display: block;
            font-size: 0.75rem;
            color: #64748b;
            margin-top: 4px;
        }

        .action-select {
            padding: 6px 8px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.85rem;
            border: 1px solid #cbd5e1;
            cursor: pointer;
            outline: none;
        }

        @media (max-width: 900px) {
            .filter-bar { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<main class="page">
    <header class="topbar">
        <div class="brand"><span class="accent">lake</span>Side Hotel</div>
        <nav class="menu">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="${pageContext.request.contextPath}/roomtype?action=list">Manage Room Type</a>
            <a href="${pageContext.request.contextPath}/admin/room?action=list">Manage Room</a>
            <a href="${pageContext.request.contextPath}/admin/voucher">Manage Voucher</a>
            <a href="${pageContext.request.contextPath}/admin/booking">Manage Booking</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>
    </header>

    <section class="toolbar">
        <h1>Booking Management</h1>
        
        <form method="get" action="${pageContext.request.contextPath}/admin/booking" class="filter-bar">
            <!-- Search Text -->
            <div class="filter-item">
                <label>🔍 Search</label>
                <input type="text" name="search" value="${search}" placeholder="Booking ID, guest name, phone...">
            </div>
            
            <!-- Status Dropdown -->
            <div class="filter-item">
                <label>🏷️ Status</label>
                <select name="status">
                    <option value="PAID" ${status == 'PAID' ? 'selected' : ''}>PAID</option>
                    <option value="CHECKED-IN" ${status == 'CHECKED-IN' ? 'selected' : ''}>CHECKED-IN</option>
                    <option value="CHECKED-OUT" ${status == 'CHECKED-OUT' ? 'selected' : ''}>CHECKED-OUT</option>
                    <option value="CANCELLED" ${status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                </select>
            </div>

            <!-- Date From -->
            <div class="filter-item">
                <label>📅 Date From</label>
                <input type="date" name="fromDate" value="${fromDate}">
            </div>

            <!-- Date To -->
            <div class="filter-item">
                <label>📅 Date To</label>
                <input type="date" name="toDate" value="${toDate}">
            </div>

            <!-- Buttons -->
            <button type="submit" class="btn primary">Filter Data</button>
            <a href="${pageContext.request.contextPath}/admin/booking" class="btn icon-only" title="Reset">↻</a>
        </form>
    </section>

    <section class="table-wrap">
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Booking ID</th>
                <th>Confirm Code</th>
                <th>Room ID/No</th>
                <th>Voucher ID</th>
                <th>Guest Name</th>
                <th>Email</th>
                <th>Guests (A/C)</th>
                <th>Check-In / Out</th>
                <th>Total Amount</th>
                <th>Current Status & Date</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="b" items="${bookings}">
                <tr>
                    <td>${b.id}</td>
                    <td>${b.bookingId}</td>
                    <td><strong>${b.confirmationCode}</strong></td>
                    <td>${b.roomNumber}</td>
                    <td>${b.voucherId != null ? b.voucherId : '-'}</td>
                    <td>${b.guestName}</td>
                    <td>${b.guestEmail}</td>
                    <td>
                        <div>${b.totalBookedGuests} Total</div>
                        <span class="time-subtext">${b.numAdults} Adult(s), ${b.numChildren} Child(ren)</span>
                    </td>
                    <td>
                        <div><fmt:parseDate value="${b.checkIn}" pattern="yyyy-MM-dd" var="ci" /> <fmt:formatDate value="${ci}" pattern="dd/MM/yyyy" /></div>
                        <div class="time-subtext">to <fmt:parseDate value="${b.checkOut}" pattern="yyyy-MM-dd" var="co" /> <fmt:formatDate value="${co}" pattern="dd/MM/yyyy" /></div>
                    </td>
                    <td><fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true" /> VND</td>
                    <td>
                        <c:choose>
                            <c:when test="${b.status == 'PAID'}"><span class="status-badge paid">${b.status}</span></c:when>
                            <c:when test="${b.status == 'CHECKED-IN'}"><span class="status-badge checked-in">${b.status}</span></c:when>
                            <c:when test="${b.status == 'CHECKED-OUT'}"><span class="status-badge checked-out">${b.status}</span></c:when>
                            <c:when test="${b.status == 'CANCELLED'}"><span class="status-badge cancelled">${b.status}</span></c:when>
                            <c:otherwise><span class="status-badge">${b.status}</span></c:otherwise>
                        </c:choose>
                        <span class="time-subtext"><fmt:formatDate value="${b.createdAt}" pattern="dd/MM/yyyy HH:mm" /></span>
                    </td>
                    <td>
                        <form method="post" action="${pageContext.request.contextPath}/admin/booking">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="id" value="${b.bookingId}">
                            <!-- Preserve filter parameters -->
                            <input type="hidden" name="search" value="${search}">
                            <input type="hidden" name="statusFilter" value="${status}">
                            <input type="hidden" name="fromDate" value="${fromDate}">
                            <input type="hidden" name="toDate" value="${toDate}">
                            
                            <select name="newStatus" class="action-select" onchange="this.form.submit()">
                                <option value="PAID" ${b.status == 'PAID' ? 'selected' : ''}>PAID</option>
                                <option value="CHECKED-IN" ${b.status == 'CHECKED-IN' ? 'selected' : ''}>CHECKED-IN</option>
                                <option value="CHECKED-OUT" ${b.status == 'CHECKED-OUT' ? 'selected' : ''}>CHECKED-OUT</option>
                                <option value="CANCELLED" ${b.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                            </select>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty bookings}">
                <tr>
                    <td colspan="12" style="text-align: center; padding: 24px; color: #64748b;">No bookings found matching your criteria.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>
