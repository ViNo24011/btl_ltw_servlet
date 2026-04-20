<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | LakeSide Hotel</title>
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
            --card-shadow: 0 16px 34px rgba(15, 23, 42, 0.08);
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
            box-shadow: var(--card-shadow);
            margin-bottom: 24px;
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

        .metric-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 24px;
        }

        .metric-card {
            background: #fff;
            border-radius: 20px;
            padding: 24px;
            border: 1px solid #dbeafe;
            box-shadow: var(--card-shadow);
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .metric-title { font-size: 0.95rem; font-weight: 700; color: #475569; text-transform: uppercase; letter-spacing: 0.05em; }
        .metric-value { font-size: 2.5rem; font-weight: 800; font-family: "Sora", sans-serif; color: var(--accent); }

        .section-card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 24px;
            border: 1px solid #dbeafe;
            box-shadow: var(--card-shadow);
            margin-bottom: 24px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 16px;
        }

        h2 { margin: 0; font-family: "Sora", sans-serif; font-size: 1.6rem; color: #1e293b; }

        .filter-form {
            display: flex;
            gap: 12px;
            align-items: flex-end;
            flex-wrap: wrap;
        }

        .filter-item { display: flex; flex-direction: column; gap: 4px; }
        .filter-item label { font-size: 0.8rem; font-weight: 700; color: #64748b; }
        .filter-item input, .filter-item select {
            padding: 10px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font: inherit;
        }

        .btn {
            border: none;
            background: linear-gradient(120deg, #7c3aed, #6d28d9);
            color: #fff;
            border-radius: 8px;
            padding: 10px 16px;
            font: inherit;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }
        
        .btn-reset {
            background: #f1f5f9;
            color: #334155;
            border: 1px solid #cbd5e1;
            height: 40px;
        }

        .revenue-big {
            font-size: 2.8rem;
            font-weight: 800;
            color: #10b981;
            font-family: "Sora", sans-serif;
            text-align: right;
            margin-bottom: 16px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        th { text-align: left; background: #f8fafc; padding: 12px; border-bottom: 2px solid #e2e8f0; color: #475569; }
        td { padding: 12px; border-bottom: 1px solid #f1f5f9; }
        .table-wrap { overflow-x: auto; max-height: 400px; }


        .badge {
            display: inline-block;
            border-radius: 999px;
            padding: 4px 10px;
            font-size: 0.75rem;
            font-weight: 800;
            background: #bbf7d0; color: #14532d;
        }

    </style>
</head>
<body>
<main class="page">
    <header class="topbar">
        <div class="brand"><span class="accent">lake</span>Side Hotel</div>
        <nav class="menu">
            <a href="${pageContext.request.contextPath}/home" style="background:#eff6ff; border-color:#93c5fd;">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/room">Manage Room</a>
            <a href="${pageContext.request.contextPath}/roomtype">Manage Room Type</a>
            <a href="${pageContext.request.contextPath}/admin/voucher">Manage Voucher</a>
            <a href="${pageContext.request.contextPath}/admin/booking">Manage Booking</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>
    </header>

    <div class="metric-grid">
        <div class="metric-card">
            <div class="metric-title">Total Rooms</div>
            <div class="metric-value">${totalRooms}</div>
        </div>
        <div class="metric-card">
            <div class="metric-title">Total Bookings</div>
            <div class="metric-value">${totalBookings}</div>
        </div>
        <div class="metric-card" style="border-left: 6px solid #fef08a;">
            <div class="metric-title">Paid Orders (Pending check-in)</div>
            <div class="metric-value" style="color: #ca8a04;">${pendingBookings}</div>
        </div>
        <div class="metric-card" style="border-left: 6px solid #bbf7d0;">
            <div class="metric-title">Completed (Checked-Out)</div>
            <div class="metric-value" style="color: #16a34a;">${completedBookings}</div>
        </div>
    </div>

    <section class="section-card">
        <div class="section-header">
            <h2>Revenue Overview</h2>
            <form method="get" action="${pageContext.request.contextPath}/home" class="filter-form">
                <div class="filter-item">
                    <label>From Date</label>
                    <input type="date" name="fromDate" value="${fromDate}">
                </div>
                <div class="filter-item">
                    <label>To Date</label>
                    <input type="date" name="toDate" value="${toDate}">
                </div>
                <button type="submit" class="btn">Filter</button>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-reset">Reset</a>
            </form>
        </div>
        
        <div class="revenue-big">
            <fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true" /> VND
        </div>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Rooms Filtered</th>
                        <th>Guest Name</th>
                        <th>Check In / Out</th>
                        <th>Status</th>
                        <th style="text-align: right;">Total Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${recentBookings}">
                        <tr>
                            <td><strong>${b.confirmationCode}</strong></td>
                            <td>${b.roomNumber}</td>
                            <td>${b.guestName}</td>
                            <td>
                                <fmt:parseDate value="${b.checkIn}" pattern="yyyy-MM-dd" var="ci" /> <fmt:formatDate value="${ci}" pattern="dd/MM/yyyy" />
                                - 
                                <fmt:parseDate value="${b.checkOut}" pattern="yyyy-MM-dd" var="co" /> <fmt:formatDate value="${co}" pattern="dd/MM/yyyy" />
                            </td>
                            <td><span class="badge" style="${b.status != 'PAID' ? 'background:#fef08a;color:#854d0e;' : ''}">${b.status}</span></td>
                            <td style="text-align: right; font-weight:700;"><fmt:formatNumber value="${b.totalAmount}" type="number" groupingUsed="true" /> đ</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentBookings}">
                        <tr><td colspan="6" style="text-align: center; color: #94a3b8;">No bookings found for the selected period.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </section>

    
    <section class="section-card" style="margin-top: 24px;">
        <div class="section-header">
            <h2>Room Performance Matrix</h2>
            <form method="get" action="${pageContext.request.contextPath}/home" class="filter-form">
                <input type="hidden" name="fromDate" value="${fromDate}">
                <input type="hidden" name="toDate" value="${toDate}">
                <div class="filter-item">
                    <label>Filter by Room Type</label>
                    <select name="roomTypeId" onchange="this.form.submit()">
                        <option value="">All Room Types</option>
                        <c:forEach var="rt" items="${roomTypes}">
                            <option value="${rt.id}" ${rt.id == selectedRoomTypeId ? 'selected' : ''}>${rt.name}</option>
                        </c:forEach>
                    </select>
                </div>
            </form>
        </div>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Room Number</th>
                        <th>Times Booked (Paid)</th>
                        <th style="text-align:right;">Generated Revenue (Base Price)</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${roomPerf}">
                        <tr>
                            <td><strong>Room ${r.roomNumber}</strong></td>
                            <td>${r.bookingCount}</td>
                            <td style="text-align:right; font-weight: 700; color: #10b981;">
                                <fmt:formatNumber value="${r.revenue}" type="number" groupingUsed="true" /> VND
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </section>
</main>

</body>
</html>
