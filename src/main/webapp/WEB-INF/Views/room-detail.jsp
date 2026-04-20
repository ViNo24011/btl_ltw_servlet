<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Room Detail | LakeSide Hotel</title>

    <!-- FONT -->
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&family=Sora:wght@600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --accent: #a64d79;
            --accent-strong: #8e3a64;
            --border: #e5e7eb;
            --bg: linear-gradient(135deg,#dbeafe,#eef2ff,#ecfeff);
        }

        body {
            margin: 0;
            font-family: "Plus Jakarta Sans", sans-serif;
            background: var(--bg);
        }

        .page {
            width: min(1180px, 94%);
            margin: 24px auto;
        }

        /* HEADER */
        .topbar {
            background: #fff;
            border-radius: 20px;
            padding: 14px 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
        }

        .brand {
            font-family: "Sora";
            font-size: 1.8rem;
            font-weight: 700;
        }

        .brand span { color: var(--accent); }

        .menu a {
            text-decoration: none;
            margin-left: 10px;
            padding: 8px 14px;
            border-radius: 999px;
            background: #f1f5f9;
            font-weight: 600;
            color: #111;
        }

        /* MAIN LAYOUT */
        .detail-grid {
            margin-top: 24px;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }

        /* IMAGE */
        .image-box img {
            width: 100%;
            height: 420px;
            object-fit: cover;
            border-radius: 18px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.15);
        }

        /* INFO CARD */
        .info-box {
            background: #fff;
            padding: 20px;
            border-radius: 18px;
            border: 1px solid var(--border);
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
        }

        .info-box h2 {
            margin: 0;
            color: var(--accent);
        }

        .price {
            margin: 10px 0;
            font-size: 1.5rem;
            font-weight: 800;
            color: #b45309;
        }

        .meta {
            color: #475569;
            margin: 6px 0;
        }

        .desc {
            margin-top: 12px;
            line-height: 1.6;
            color: #334155;
        }

        .btn-book {
            margin-top: 16px;
            width: 100%;
            padding: 12px;
            border-radius: 12px;
            border: none;
            font-weight: 700;
            background: linear-gradient(120deg,var(--accent),var(--accent-strong));
            color: #fff;
            cursor: pointer;
        }

        .btn-book:hover {
            opacity: 0.9;
        }

        .footer {
            margin-top: 30px;
            text-align: center;
            color: #64748b;
            font-weight: 600;
        }

        /* MOBILE */
        @media (max-width: 900px) {
            .detail-grid {
                grid-template-columns: 1fr;
            }

            .image-box img {
                height: 260px;
            }
        }
    </style>
</head>

<body>

<div class="page">

    <!-- HEADER -->
    <div class="topbar">
        <div class="brand"><span>lake</span>Side Hotel</div>

        <div class="menu">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="${pageContext.request.contextPath}/room">Rooms</a>

            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/profile">
                        ${sessionScope.user.firstName}
                    </a>
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login">Login</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- CONTENT -->
    <div class="detail-grid">

        <!-- IMAGE -->
        <div class="image-box">

            <c:set var="imgIndex" value="${(room.id % 6) + 1}" />

            <img src="${room.photo != null 
                ? room.photo 
                : pageContext.request.contextPath.concat('/images/room').concat(imgIndex).concat('.jpg')}" />

        </div>

        <!-- INFO -->
        <div class="info-box">

            <h2>Room ${room.roomNumber}</h2>

            <div class="price">
                ${room.roomType.basePrice} VND / night
            </div>

            <div class="meta">
                Type: ${room.roomType.name}
            </div>

            <div class="meta">
                Capacity: ${room.roomType.maxCapacity} people
            </div>

            <div class="desc">
                ${room.roomType.description}
            </div>

            <a href="${pageContext.request.contextPath}/booking?action=create&roomId=${room.id}">
                <button class="btn-book">
                    Book this room
                </button>
            </a>

        </div>

    </div>

    <div class="footer">© 2026 LakeSide Hotel</div>

</div>

</body>
</html>
