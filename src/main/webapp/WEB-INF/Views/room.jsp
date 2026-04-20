<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Rooms - Proj Hotel</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --main-color: #a64d79;
            --hover-color: #8e3a64;
        }

        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .navbar-brand {
            color: var(--main-color) !important;
            font-weight: bold;
            font-size: 1.5rem;
        }

        .btn-custom {
            background-color: var(--main-color);
            color: white;
            border: none;
        }

        .btn-custom:hover {
            background-color: var(--hover-color);
            color: white;
        }

        .room-title {
            margin: 30px 0;
            text-align: center;
        }

        .room-card {
            border-radius: 12px;
        }

        .room-img {
            height: 180px;
            object-fit: cover;
        }

        footer {
            background-color: #212529;
            color: white;
            padding: 20px 0;
            margin-top: 40px;
        }
    </style>
</head>

<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            Proj Hotel
        </a>

        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/room">
                        Browse Rooms
                    </a>
                </li>
            </ul>

            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/booking">
                        My Booking
                    </a>
                </li>

                <c:if test="${not empty sessionScope.user}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                            ${sessionScope.user.firstName}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Profile</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        </ul>
                    </li>
                </c:if>

                <c:if test="${empty sessionScope.user}">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/login">
                            Login
                        </a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<!-- Title -->
<div class="container">
    <h2 class="room-title">Available Rooms</h2>

    <div class="row">
        <c:forEach var="r" items="${rooms}">
            <div class="col-md-4 mb-4">

                <div class="card room-card shadow-sm">

                    <img class="card-img-top room-img"
                         src="${r.photo != null ? r.photo : 'https://via.placeholder.com/300'}"/>

                    <div class="card-body">

                        <h5 class="card-title">
                            Room ${r.roomNumber}
                        </h5>

                        <p class="card-text">
                            Type: ${r.roomType.name}
                        </p>

                        <p class="text-danger fw-bold">
                            ${r.roomType.basePrice} VND / night
                        </p>

                        <p>
                            Capacity: ${r.roomType.maxCapacity}
                        </p>

                        <div class="d-flex justify-content-between">

                            <a href="${pageContext.request.contextPath}/room?action=detail&id=${r.id}"
                               class="btn btn-secondary btn-sm">
                                Detail
                            </a>

                            <form action="room" method="post" class="m-0">
                                <input type="hidden" name="action" value="bookRooms">
                                <input type="hidden" name="roomId" value="${r.id}">
                                <input type="hidden" name="currentPage" value="${currentPage}">
                                <button type="submit" class="btn btn-custom btn-sm">
                                    Book
                                </button>
                            </form>

                        </div>

                    </div>
                </div>

            </div>
        </c:forEach>
    </div>

    <!-- Pagination -->
    <div class="text-center mt-4">
        <c:forEach begin="1" end="${totalPages}" var="i">
            <a href="${pageContext.request.contextPath}/room?page=${i}"
               class="btn btn-sm ${i == currentPage ? 'btn-dark' : 'btn-outline-dark'}">
                ${i}
            </a>
        </c:forEach>
    </div>

</div>

<!-- Footer -->
<footer class="text-center">
    <p class="mb-0">© 2026 Proj Hotel</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
