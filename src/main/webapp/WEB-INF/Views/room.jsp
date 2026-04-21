<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Rooms | LakeSide Hotel</title>

            <!-- FONT giống Home -->
            <link
                href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&family=Sora:wght@600;700&display=swap"
                rel="stylesheet">

            <style>
                :root {
                    --accent: #a64d79;
                    --accent-strong: #8e3a64;
                    --border: #e5e7eb;
                    --bg: linear-gradient(135deg, #dbeafe, #eef2ff, #ecfeff);
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

                /* HEADER giống Home */
                .topbar {
                    background: #fff;
                    border-radius: 20px;
                    padding: 14px 18px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
                }

                .brand {
                    font-family: "Sora";
                    font-size: 1.8rem;
                    font-weight: 700;
                }

                .brand span {
                    color: var(--accent);
                }

                .menu a {
                    text-decoration: none;
                    margin-left: 10px;
                    padding: 8px 14px;
                    border-radius: 999px;
                    background: #f1f5f9;
                    font-weight: 600;
                    color: #111;
                }

                .menu a:hover {
                    background: #e2e8f0;
                }

                /* TITLE */
                .title {
                    margin: 26px 0 16px;
                    font-size: 1.6rem;
                    font-weight: 700;
                    color: var(--accent-strong);
                }

                /* GRID ROOMS */
                .grid {
                    display: grid;
                    grid-template-columns: repeat(3, 1fr);
                    gap: 16px;
                }

                .card {
                    background: #fff;
                    border-radius: 16px;
                    overflow: hidden;
                    border: 1px solid var(--border);
                    transition: 0.25s;
                }

                .card:hover {
                    transform: translateY(-6px);
                    box-shadow: 0 12px 28px rgba(0, 0, 0, 0.12);
                }

                .card img {
                    width: 100%;
                    height: 170px;
                    object-fit: cover;
                }

                .card-body {
                    padding: 14px;
                }

                .card h3 {
                    margin: 0;
                    color: var(--accent);
                }

                .price {
                    margin: 6px 0;
                    font-weight: 800;
                    color: #b45309;
                }

                .meta {
                    font-size: 0.9rem;
                    color: #64748b;
                }

                .actions {
                    margin-top: 10px;
                    display: flex;
                    justify-content: space-between;
                }

                .btn {
                    text-decoration: none;
                    padding: 7px 10px;
                    border-radius: 8px;
                    font-size: 0.85rem;
                    font-weight: 700;
                }

                .btn.detail {
                    background: #e5e7eb;
                    color: #111;
                }

                .btn.book {
                    background: linear-gradient(120deg, var(--accent), var(--accent-strong));
                    color: #fff;
                    border: hidden;
                }

                /* PAGINATION */
                .pagination {
                    margin-top: 20px;
                    text-align: center;
                }

                .page-btn {
                    display: inline-block;
                    padding: 8px 12px;
                    margin: 3px;
                    border-radius: 8px;
                    border: 1px solid #cbd5e1;
                    background: #fff;
                    font-weight: 700;
                    text-decoration: none;
                    color: #334155;
                }

                .page-btn.active {
                    background: var(--accent);
                    color: #fff;
                    border-color: var(--accent);
                }

                /* FOOTER */
                .footer {
                    margin-top: 30px;
                    text-align: center;
                    color: #64748b;
                    font-weight: 600;
                }

                /* RESPONSIVE */
                @media (max-width: 900px) {
                    .grid {
                        grid-template-columns: 1fr 1fr;
                    }
                }

                @media (max-width: 600px) {
                    .grid {
                        grid-template-columns: 1fr;
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
                        <a href="${pageContext.request.contextPath}/booking">My Booking</a>

                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/profile">
                                    Profile
                                </a>
                                <a href="${pageContext.request.contextPath}/logout">Logout</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login">Login</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- TITLE -->
                <div class="title">Available Rooms</div>

                <!-- ROOM LIST -->
                <div class="grid">

                    <c:forEach var="r" items="${rooms}">
                        <div class="card">

                            <img
                                src="${r.photo != null ? r.photo : 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304'}">

                            <div class="card-body">
                                <h3>Room ${r.roomNumber}</h3>

                                <div class="price">
                                    ${r.roomType.basePrice} VND / night
                                </div>

                                <div class="meta">
                                    Type: ${r.roomType.name} <br>
                                    Capacity: ${r.roomType.maxCapacity}
                                </div>

                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/room?action=detail&id=${r.id}"
                                        class="btn detail">
                                        Detail
                                    </a>

                                    <form action="room" method="post" class="m-0 p-0">
                                        <input type="hidden" name="action" value="bookRooms">
                                        <input type="hidden" name="roomId" value="${r.id}">
                                        <input type="hidden" name="currentPage" value="${currentPage}">
                                        <button type="submit" class="btn book"
                                            onclick="return confirm('The room you've selected is now in My Booking');">
                                            Book
                                        </button>
                                    </form>
                                </div>
                            </div>

                        </div>
                    </c:forEach>

                </div>

                <!-- PAGINATION -->
                <div class="pagination">
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="${pageContext.request.contextPath}/room?page=${i}"
                            class="page-btn ${i == currentPage ? 'active' : ''}">
                            ${i}
                        </a>
                    </c:forEach>
                </div>

                <div class="footer">© 2026 LakeSide Hotel</div>

            </div>

        </body>

        </html>