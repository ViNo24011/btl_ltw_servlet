<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Booking</title>
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
            color: #a64d79;
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


        .form-box {
            border: 1px solid #ccc;
            padding: 20px;
            border-radius: 10px;
            background: white;
            min-width: 400px;
            margin-top: 15px;
        }

        button {
            background-color: #a64d79;
            color: white;
            border-radius: 4px;
            border: none;
            padding: 8px 16px;
            display: block;
            margin: 15px auto 0;
            cursor: pointer;
        }

        

        input {
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .form-group {
            display: grid;
            grid-template-columns: 120px 1fr;
            align-items: center;
            height: 50px;
        }

        .info-text {
            margin-top: 10px;
        }

        table {
            border-collapse: collapse;
            margin-top: 15px;
            width: 100%;
        }

        td, th {
            padding: 6px 10px;
            text-align: center;
            border: 1px solid #ccc;
        }

        .table-container {
            max-height: 250px;
            overflow-y: auto;
            margin-top: 15px;
        }
        .voucher-tabe-container{
            border: 1px solid #ccc;
            padding: 20px;
            border-radius: 10px;
            background: white;
            min-width: 400px;
            margin-bottom: 15px;
            max-height: 250px;
            overflow-y: auto;
            margin-top: 15px;
        }

        .error-message {
            display: block;
            background-color: gray;
            color: white;
            padding: 8px;
            border-radius: 6px;
            margin: 10px 0;
            text-align: center;
        }
        .info-table {
            width: 100%;
            border-collapse: collapse;
            border: none;

        }

        .info-table td,
        .info-table th {
            border: none ;
            text-align: left;
        }
        .payment-container{
            display: grid;
            grid-template-columns: 3fr 1fr;
        }
    </style>
</head>
<body>
    <main class="page">
    <header class="topbar">
        <div class="brand"><a href="${pageContext.request.contextPath}/home" style="text-decoration: none; color: black;"><span class="accent">lake</span>Side Hotel</a></div>
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
                <a href="${pageContext.request.contextPath}/admin/voucher">Manage Voucher</a>
                <a href="${pageContext.request.contextPath}/admin/booking">Manage Booking</a>
            </c:if>
            <a href="${pageContext.request.contextPath}/booking">My Booking</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/home">Home</a>
                    <a href="${pageContext.request.contextPath}/profile">Profile</a>
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login">Account</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </header>
    
        <div style="border: 1px solid #ccc; padding: 50px;margin-top: 10px; border-radius: 10px; background: white; min-width: 400px;">
            <label class="brand"><strong>Payment</strong></label>
            <div class="payment-container">
                <div class="info-box">
                    <div class="info-box">
                    <table class="info-table">
                        <tr>
                            <td><strong>First name:</strong></td>
                            <td>${sessionScope.guestName}</td>

                            <td></td>
                            <td></td>
                        </tr>

                        <tr>
                            <td><strong>Email:</strong></td>
                            <td>${sessionScope.guestEmail}</td>

                            <td><strong>Confirmation code:</strong></td>
                            <td>${sessionScope.confirmationCode}</td>
                        </tr>

                        <tr>
                            <td><strong>Check in:</strong></td>
                            <td>${sessionScope.checkIn}</td>

                            <td><strong>Check out:</strong></td>
                            <td>${sessionScope.checkOut}</td>
                        </tr>

                        <tr>
                            <td><strong>Total guests:</strong></td>
                            <td>${sessionScope.totalGuest}</td>

                            <td><strong>Total amount:</strong></td>
                            <td>${sessionScope.totalAmount} VND</td>
                        </tr>

                        <tr>
                             <c:if test="${not empty sessionScope.voucher}">
                                <tr>
                                    <td><strong>Voucher:</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${sessionScope.voucher.isPercent}">
                                                ${sessionScope.voucher.discountValue}%
                                            </c:when>
                                            <c:otherwise>
                                                -${sessionScope.voucher.discountValue} VND
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td></td>
                                    <td></td>
                                </tr>
                            </c:if>                               
                            <td></td>
                            <td></td>
                        </tr>
                       
                    </table>
                </div>                   
                    
                </div>
                <div class="qr">
                    <img style="width: 300px;height: 300px;" src="${qrUrl}" />
                </div>
            </div>
            
            <c:if test="${not empty paymentMessage}">
                <span class="error-message">${paymentMessage}</span>
            </c:if>
            <form action="payment" method="post">
                <input type="hidden" name="action" value="confirmPayment">
                <button type="submit">Confirm payment</button>
            </form> 
        <!-- voucher -->
       
       
    </div>
    </div>
    
</main>
</body>

</html>