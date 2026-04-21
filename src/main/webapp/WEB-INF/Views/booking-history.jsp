<%-- 
    Document   : booking-history
    Created on : 20 Apr 2026, 07:09:51
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Profile | LakeSide Hotel</title>
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
                background: var(--bg-grad);
                color: var(--ink);
            }

            .page { width: min(1120px, 94%); margin: 28px auto; }

            .topbar {
                background: rgba(255, 255, 255, 0.94);
                border: 1px solid #dbeafe;
                border-radius: 22px;
                padding: 14px 18px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 12px;
                box-shadow: 0 16px 34px rgba(15, 23, 42, 0.08);
            }

            .brand { font-family: "Sora", sans-serif; font-size: 1.45rem; }
            .brand .accent { color: var(--accent); }

            .menu { display: flex; gap: 10px; flex-wrap: wrap; }
            .menu a {
                text-decoration: none;
                color: #0f172a;
                border: 1px solid #bfdbfe;
                background: #f8fafc;
                border-radius: 999px;
                padding: 9px 15px;
                font-weight: 600;
            }

            .alert {
                margin-top: 14px;
                border-radius: 12px;
                padding: 11px 13px;
                font-weight: 600;
                border: 1px solid;
            }
            .alert.success { background: #ecfdf5; color: #065f46; border-color: #a7f3d0; }
            .alert.error { background: #fff1f2; color: #9f1239; border-color: #fecdd3; }

            .grid {
                margin-top: 18px;
                display: grid;
                grid-template-columns: 1.1fr 0.9fr;
                gap: 16px;
            }

            .card {
                background: rgba(255, 255, 255, 0.95);
                border: 1px solid #dbeafe;
                border-radius: 20px;
                padding: 20px;
                box-shadow: 0 10px 22px rgba(15, 23, 42, 0.08);
            }

            .hero {
                color: #f8fafc;
                background: linear-gradient(160deg, #111827, #0f766e 60%, #0284c7);
            }

            .hero h1 {
                margin: 0;
                font-family: "Sora", sans-serif;
                font-size: clamp(1.7rem, 3vw, 2.6rem);
                line-height: 1.16;
            }

            .hero p {
                margin: 12px 0 0;
                color: #e2e8f0;
                line-height: 1.7;
                font-size: 1.05rem;
            }

            .label {
                font-size: 0.84rem;
                color: #64748b;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                margin-top: 14px;
            }

            .value {
                font-size: 1rem;
                font-weight: 700;
                margin-top: 4px;
            }

            .kpis {
                margin-top: 14px;
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 10px;
            }

            .kpi {
                border: 1px solid #dbeafe;
                border-radius: 12px;
                background: #f8fafc;
                padding: 10px;
            }

            .kpi .num { font-size: 1.2rem; font-weight: 800; }
            .kpi .txt { color: #64748b; font-size: 0.9rem; font-weight: 600; }

            .badge {
                display: inline-block;
                margin-top: 8px;
                border-radius: 999px;
                padding: 6px 12px;
                color: #fff;
                background: linear-gradient(120deg, var(--accent), var(--accent-strong));
                font-weight: 700;
                font-size: 0.86rem;
            }

            .actions { margin-top: 14px; display: grid; gap: 10px; }
            .btn {
                border: 1px solid #bfdbfe;
                background: #f8fafc;
                color: #0f172a;
                border-radius: 12px;
                padding: 10px 12px;
                font: inherit;
                font-weight: 700;
                text-decoration: none;
                text-align: center;
                cursor: pointer;
            }

            .btn.primary {
                color: #fff;
                border: none;
                background: linear-gradient(120deg, var(--accent), var(--accent-strong));
            }



            @media (max-width: 900px) {
                .topbar { flex-direction: column; align-items: flex-start; }
                .grid { grid-template-columns: 1fr; }
            }
            
            .form-box {
                border: 1px solid #ccc;
                padding: 20px;
                border-radius: 10px;
                background: white;
                min-width: 400px;
                margin-top: 15px;
            }
            td, th {
                padding: 6px 10px;
                text-align: center;
                border: 1px solid #ccc;
            }

            .table-container {
                max-height: 400px;
                overflow-y: auto;
                margin-top: 15px;
            }
            .pagination {
                display: flex;
                justify-content: center;
                gap: 8px;
                margin-top: 20px;
                flex-wrap: wrap;
            }

            .pagination a {
                text-decoration: none;
                padding: 8px 14px;
                border-radius: 10px;
                border: 1px solid #e5e7eb;
                background: #f8fafc;
                color: #1f2937;
                font-weight: 600;
                transition: all 0.2s ease;
            }

            /* hover */
            .pagination a:hover {
                background: #e0e7ff;
                border-color: #c7d2fe;
            }

            /* active page */
            .pagination a.active {
                background: linear-gradient(120deg, #a64d79, #8e3a64);
                color: white;
                border: none;
            }
            .brand {
                font-family: "Sora", sans-serif;
                font-size: 2rem;
                font-weight: 700;
            }
            label {
                color: #a64d79;
            }
            .hidden-table-border{
                border: hidden;
            }
            button {
                background-color: #a64d79;
                color: white;
                border-radius: 4px;
                border: none;
                padding: 8px 16px;
                display: block;
                cursor: pointer;
            }
            td form {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 10px;
                margin: 0; /* remove extra spacing */
            }
        </style>
    </head>
    <body>
        <main class="page">
            <header class="topbar">
                <div class="brand"><span class="accent">lake</span>Side Hotel</div>
                <nav class="menu">
                    <a href="${pageContext.request.contextPath}/home">Home</a>
                    <a href="${pageContext.request.contextPath}/vouchers">Vouchers</a>
                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                    
                </nav>
            </header>
            <div style="border: 1px solid #ccc; padding: 50px;margin-top: 10px; border-radius: 10px; background: white; min-width: 400px;">
                <label class="brand"><strong>Booking History</strong></label><br>
                <label style="color: black;"><strong>You can continue the payment process or cancel paid bookings before check in date.</strong></label>

                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Check in</th>
                                <th>Check out</th>
                                <th>Confirmation code</th>
                                <th>Total guests</th>
                                <th>Total amount</th>
                                <th>Status</th>
                                <th>Created at</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${bookingHistory}">
                                <tr>
                                    <td>${booking.id}</td>
                                    <td>${booking.checkIn}</td>
                                    <td>${booking.checkOut}</td>
                                    <td>${booking.confirmationCode}</td>
                                    <td>${booking.totalGuests}</td>
                                    <td>${booking.totalAmount}</td>
                                    <td>${booking.status}</td>
                                    <td>${booking.createdAt.toString().replace('T',' ')}</td>
                                    <td>
                                        <c:if test="${now.isBefore(booking.checkIn) && booking.status == 'PAID'}">
                                            <form action="booking" method="post" style="display:flex; gap:10px; align-items:center; margin-top: 10px;">                                         
                                                <input type="hidden" name="action" value="cancelBooking">
                                                <input type="hidden" name="cancelBookingId" value="${booking.id}">
                                                <button onclick="return confirm('Are you sure you want to cancel?')">Cancel</button>
                                            </form>
                                        </c:if>  
                                        <c:if test="${now.isBefore(booking.checkIn) && booking.status == 'UNPAID'}">
                                            <form action="payment" method="get" style="display:flex; gap:10px; align-items:center; margin-top: 10px;">                                         
                                                <input type="hidden" name="action" value="continuePayment">
                                                <input type="hidden" name="selectedBookingId" value="${booking.id}">
                                                <button style="background-color: green;">Continue payment</button>
                                            </form>
                                        </c:if>   
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>           
            </div>  
            <div class="pagination">
                <c:if test="${totalPages > 1}">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="${pageContext.request.contextPath}/booking-history?page=${i}"
                           class="${i == currentPage ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>
                </c:if>
            </div>
        </main>
        
    </body>
</html> 