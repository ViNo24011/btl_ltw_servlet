<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Room Form - Proj Hotel</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        .card {
            border-radius: 10px;
        }

        footer {
            background-color: #212529;
            color: white;
            padding: 15px 0;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
    </style>
</head>

<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
    <div class="container">
        <a class="navbar-brand" href="index">Proj Hotel</a>

        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="room">Browse all rooms</a>
                </li>
            </ul>

            <ul class="navbar-nav">
                <li class="nav-item"><a class="nav-link" href="find-booking">Find my booking</a></li>
                <li class="nav-item"><a class="nav-link" href="login">Login</a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- Content -->
<div class="container mt-4">

    <div class="card p-4 shadow-sm">
        <h3 class="mb-4">Thêm / Sửa phòng</h3>

        <form method="post" action="room">

            <input type="hidden" name="id" value="${room.id}"/>

            <!-- Room Number -->
            <div class="mb-3">
                <label class="form-label">Số phòng</label>
                <input type="text" name="roomNumber"
                       value="${room.roomNumber}">
            </div>

            <!-- Photo -->
            <div class="mb-3">
                <label class="form-label">Ảnh (URL)</label>
                <input type="text" name="photo"
                       value="${room.photo}">
            </div>

            <!-- Room Type -->
            <div class="mb-3">
                <label class="form-label">Loại phòng</label>
                <select name="roomTypeId" class="form-select">
                    <c:forEach var="t" items="${roomTypes}">
                        <option value="${t.id}"
                            ${room.roomTypeId == t.id ? 'selected' : ''}>
                            ${t.name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Button -->
            <button type="submit" class="btn btn-primary">Lưu</button>
            <a href="room" class="btn btn-secondary">Quay lại</a>

        </form>
    </div>

</div>

<!-- Footer -->
<footer class="text-center">
    <p class="mb-0">© 2026 Proj Hotel</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
