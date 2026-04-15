<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home | LakeSide Hotel</title>
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

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Plus Jakarta Sans", sans-serif;
            color: var(--ink);
            background: var(--bg-grad);
        }

        .page { width: min(1180px, 94%); margin: 26px auto; }

        .topbar {
            background: rgba(255, 255, 255, 0.94);
            border: 1px solid #dbeafe;
            border-radius: 24px;
            padding: 16px 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.08);
        }

        .brand {
            font-family: "Sora", sans-serif;
            font-size: 2rem;
            font-weight: 700;
        }

        .brand .accent { color: var(--accent); }

        .menu {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .menu a {
            text-decoration: none;
            color: #0f172a;
            border: 1px solid #bfdbfe;
            background: #f8fafc;
            border-radius: 999px;
            padding: 10px 18px;
            font-weight: 600;
            transition: 0.2s ease;
        }

        .menu a:hover {
            background: #eff6ff;
            transform: translateY(-1px);
        }

        .hero {
            margin-top: 20px;
            border-radius: 24px;
            overflow: hidden;
            border: 1px solid #dbeafe;
            box-shadow: 0 14px 36px rgba(15, 23, 42, 0.12);
            position: relative;
        }

        .hero img {
            width: 100%;
            height: 460px;
            object-fit: cover;
            display: block;
            filter: brightness(0.66);
        }

        .hero-content {
            position: absolute;
            inset: 0;
            display: grid;
            place-content: center;
            text-align: center;
            color: #f8fafc;
            padding: 18px;
        }

        .hero-content h1 {
            margin: 0;
            font-family: "Sora", sans-serif;
            font-size: clamp(2rem, 4.2vw, 3.4rem);
            line-height: 1.15;
        }

        .hero-content h1 .accent { color: #f9a8d4; }

        .hero-content p {
            margin: 12px 0 0;
            font-size: clamp(1rem, 1.8vw, 1.4rem);
            color: #e5e7eb;
            font-weight: 600;
        }

        .search-card {
            margin: 22px auto 0;
            background: rgba(255, 255, 255, 0.96);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 18px;
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
            box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
        }

        .field label {
            display: block;
            font-weight: 700;
            font-size: 0.9rem;
            margin-bottom: 6px;
        }

        .field input,
        .field select {
            width: 100%;
            border-radius: 12px;
            border: 1px solid #d1d5db;
            padding: 10px 12px;
            font: inherit;
            background: #fff;
        }

        .field input:focus,
        .field select:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(166, 77, 121, 0.16);
        }

        .search-btn {
            align-self: end;
            height: 44px;
            border: none;
            border-radius: 12px;
            background: linear-gradient(120deg, var(--accent), var(--accent-strong));
            color: #fff;
            font: inherit;
            font-weight: 700;
            cursor: pointer;
        }

        .section {
            margin-top: 24px;
            background: rgba(255, 255, 255, 0.92);
            border: 1px solid #dbeafe;
            border-radius: 20px;
            padding: 18px;
        }

        .section h2 {
            margin: 0 0 14px;
            font-size: 1.05rem;
            color: var(--accent-strong);
            text-decoration: underline;
            text-underline-offset: 4px;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
        }

        .room-card {
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            overflow: hidden;
            background: #fff;
        }

        .room-card img {
            width: 100%;
            height: 160px;
            object-fit: cover;
            display: block;
        }

        .room-card .content { padding: 12px; }

        .room-card h3 {
            margin: 0;
            font-size: 1.15rem;
            color: var(--accent);
        }

        .room-card p {
            margin: 6px 0 10px;
            color: #a3a363;
            font-weight: 700;
        }

        .room-card a {
            display: inline-block;
            text-decoration: none;
            background: linear-gradient(120deg, var(--accent), var(--accent-strong));
            color: #fff;
            padding: 8px 10px;
            border-radius: 8px;
            font-size: 0.88rem;
            font-weight: 700;
        }

        .booking-list .list-head {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 12px;
        }

        .filter-box {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 8px;
        }

        .filter-box label {
            font-weight: 700;
            color: #334155;
        }

        .filter-box select {
            min-width: 260px;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            padding: 10px 12px;
            font: inherit;
            background: #fff;
        }

        .btn {
            border: 1px solid #bfdbfe;
            background: #f8fafc;
            color: #0f172a;
            border-radius: 10px;
            padding: 9px 14px;
            font: inherit;
            font-weight: 700;
            cursor: pointer;
        }

        .btn.primary {
            border: none;
            color: #fff;
            background: linear-gradient(120deg, var(--accent), var(--accent-strong));
        }

        .pager {
            display: flex;
            gap: 6px;
            align-items: center;
        }

        .page-btn {
            border: 1px solid #cbd5e1;
            background: #fff;
            color: #334155;
            border-radius: 8px;
            width: 34px;
            height: 34px;
            font-weight: 700;
            cursor: pointer;
        }

        .page-btn.active {
            background: #2563eb;
            border-color: #2563eb;
            color: #fff;
        }

        .result-list {
            display: grid;
            gap: 12px;
        }

        .result-item {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 12px;
            display: grid;
            grid-template-columns: 160px 1fr auto;
            gap: 14px;
            align-items: center;
        }

        .result-item img {
            width: 160px;
            height: 94px;
            border-radius: 8px;
            object-fit: cover;
        }

        .result-item h3 {
            margin: 0;
            color: var(--accent);
            font-size: 1.35rem;
        }

        .price {
            margin-top: 4px;
            color: #a3a363;
            font-weight: 800;
            font-size: 1.15rem;
        }

        .desc {
            margin-top: 6px;
            color: #475569;
            line-height: 1.5;
        }

        .empty-state {
            text-align: center;
            color: var(--muted);
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 12px;
            padding: 24px;
            font-weight: 600;
        }

        .promo-bottom {
            margin-top: 24px;
            border-radius: 20px;
            overflow: hidden;
            position: relative;
            border: 1px solid #dbeafe;
        }

        .promo-bottom img {
            width: 100%;
            height: 340px;
            object-fit: cover;
            display: block;
            filter: brightness(0.76);
        }

        .promo-bottom .overlay {
            position: absolute;
            inset: 0;
            display: grid;
            place-content: center;
            text-align: center;
            color: #fff;
        }

        .promo-bottom h3 {
            margin: 0;
            font-size: clamp(1.7rem, 3.2vw, 2.8rem);
            font-family: "Sora", sans-serif;
            text-shadow: 0 3px 20px rgba(0, 0, 0, 0.3);
        }

        .promo-bottom h3 .accent { color: #f9a8d4; }

        .promo-bottom p {
            margin-top: 8px;
            font-size: clamp(1rem, 1.8vw, 1.4rem);
            font-weight: 600;
            text-shadow: 0 3px 20px rgba(0, 0, 0, 0.3);
        }

        .footer {
            margin: 24px 0 10px;
            text-align: center;
            color: #64748b;
            font-weight: 600;
        }

        @media (max-width: 980px) {
            .topbar { flex-direction: column; align-items: flex-start; }
            .menu { width: 100%; }
            .search-card { grid-template-columns: 1fr 1fr; }
            .cards { grid-template-columns: 1fr 1fr; }
            .result-item { grid-template-columns: 1fr; }
            .result-item img { width: 100%; height: 170px; }
            .result-item .cta { justify-self: start; }
        }

        @media (max-width: 640px) {
            .brand { font-size: 1.45rem; }
            .hero img { height: 340px; }
            .search-card { grid-template-columns: 1fr; }
            .cards { grid-template-columns: 1fr; }
            .filter-box select { min-width: 100%; }
            .pager { width: 100%; justify-content: flex-start; }
        }
    </style>
</head>
<body>
<main class="page">
    <header class="topbar">
        <div class="brand"><span class="accent">lake</span>Side Hotel</div>
        <nav class="menu">
            <a href="${pageContext.request.contextPath}/room">Browse all rooms</a>
            <c:set var="isAdmin" value="false" />
            <c:forEach var="role" items="${sessionScope.user.roles}">
                <c:if test="${role.name == 'ROLE_ADMIN'}">
                    <c:set var="isAdmin" value="true" />
                </c:if>
            </c:forEach>
            <c:if test="${isAdmin}">
                <a href="${pageContext.request.contextPath}/roomtype">Manage</a>
            </c:if>
            <a href="#bookings">Find my booking</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/profile">Profile</a>
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login">Account</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </header>

    <section class="hero">
        <img src="https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?auto=format&fit=crop&w=1600&q=80" alt="Hotel exterior">
        <div class="hero-content">
            <h1>Welcome to <span class="accent">lakeSide</span>-Hotel</h1>
            <p>Experience the Best Hospitality in Town</p>
        </div>
    </section>

    <section class="search-card">
        <div class="field">
            <label>Check-in Date</label>
            <input type="date">
        </div>
        <div class="field">
            <label>Check-out Date</label>
            <input type="date">
        </div>
        <div class="field">
            <label>Room Type</label>
            <select>
                <option>Select a room type</option>
                <option>Standard</option>
                <option>Deluxe</option>
                <option>Suite</option>
                <option>Family</option>
            </select>
        </div>
        <button class="search-btn" type="button">Search</button>
    </section>

    <section class="section" id="rooms">
        <a href="${pageContext.request.contextPath}/room"><h2>Browse Rooms</h2></a>
        <div class="cards">
            <c:forEach var="room" items="${allRooms}" begin="0" end="3">
                <article class="room-card">
                    <img src="${room.image}" alt="${room.roomNumber}">
                    <div class="content">
                        <h3>${room.roomNumber}</h3>
                        <p>$${room.basePrice}/night</p>
                        <a href="${pageContext.request.contextPath}/room?action=detail&id=${room.id}">View/Book Now</a>
                    </div>
                </article>
            </c:forEach>
        </div>
    </section>

    <section class="section booking-list" id="bookings">
        <div class="list-head">
            <div class="filter-box">
                <label for="roomFilter">Filter by room type:</label>
                <select id="roomFilter">
                    <option value="ALL">select a room type to filter...</option>
                    <c:forEach var="roomType" items="${roomTypes}">
                        <option value="${roomType.id}">${roomType.name}</option>
                    </c:forEach>
                </select>
                <button id="clearFilter" class="btn primary" type="button">Clear Filter</button>
            </div>
            <div class="pager" id="pager"></div>
        </div>

        <div class="result-list" id="resultList"></div>
    </section>

    <section class="promo-bottom">
        <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1600&q=80" alt="Hotel interior">
        <div class="overlay">
            <h3>Experience the best hospitality at <span class="accent">LTC</span> hotel</h3>
            <p>We offer the best services for all your needs.</p>
        </div>
    </section>

    <p class="footer">©2026 LakeSide hotel</p>
</main>

<script>
    // Lấy dữ liệu từ server thay vì hardcode
    const allRooms = [
        <c:forEach var="room" items="${allRooms}" varStatus="loop">
        {
            id: ${room.id},
            type: '${room.roomTypeId}',
            name: '${room.roomNumber}',
            price: '\\$${room.basePrice}/night',
            image: '${not empty room.image ? room.image : "https://images.unsplash.com/photo-1631049307264-da0ec9d70304?auto=format&fit=crop&w=800&q=80"}',
            desc: 'Room ${room.roomNumber} - Available for booking'
        }
        <c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const pageSize = 3;
    let currentPage = 1;
    let selectedType = 'ALL';

    const roomFilter = document.getElementById('roomFilter');
    const clearFilter = document.getElementById('clearFilter');
    const resultList = document.getElementById('resultList');
    const pager = document.getElementById('pager');

    function getFilteredRooms() {
        if (selectedType === 'ALL') {
            return allRooms;
        }
        return allRooms.filter(room => room.type === selectedType);
    }

    function renderRooms() {
        const filtered = getFilteredRooms();
        const totalPages = Math.max(1, Math.ceil(filtered.length / pageSize));

        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        const start = (currentPage - 1) * pageSize;
        const viewRooms = filtered.slice(start, start + pageSize);

        if (viewRooms.length === 0) {
            resultList.innerHTML = '<div class="empty-state">No rooms found for this filter. Try another room type.</div>';
        } else {
            resultList.innerHTML = viewRooms.map(room => {
                return '<article class="result-item">' +
                    '<img src="' + room.image + '" alt="' + room.name + '">' +
                    '<div>' +
                    '<h3>' + room.name + '</h3>' +
                    '<div class="price">' + room.price + '</div>' +
                    '<p class="desc">' + room.desc + '</p>' +
                    '</div>' +
                    '<div class="cta">' +
                    '<a href="${pageContext.request.contextPath}/room?action=detail&id=' + room.id + '" class="btn primary">View/Book Now</a>' +
                    '</div>' +
                    '</article>';
            }).join('');
        }

        renderPager(totalPages);
    }

    function renderPager(totalPages) {
        pager.innerHTML = '';
        for (let i = 1; i <= totalPages; i++) {
            const btn = document.createElement('button');
            btn.className = 'page-btn' + (i === currentPage ? ' active' : '');
            btn.textContent = i;
            btn.addEventListener('click', function() {
                currentPage = i;
                renderRooms();
            });
            pager.appendChild(btn);
        }
    }

    roomFilter.addEventListener('change', function(e) {
        selectedType = e.target.value;
        currentPage = 1;
        renderRooms();
    });

    clearFilter.addEventListener('click', function() {
        selectedType = 'ALL';
        roomFilter.value = 'ALL';
        currentPage = 1;
        renderRooms();
    });

    renderRooms();
</script>
</body>
</html>
