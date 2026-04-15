<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Room Form - Proj Hotel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --main-color: #a64d79;
            --hover-color: #8e3a64;
        }

        body {
            background-color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .navbar-brand {
            color: var(--main-color) !important;
            font-weight: bold;
        }

        .btn-custom {
            background-color: var(--main-color);
            color: white;
        }

        .btn-custom:hover {
            background-color: var(--hover-color);
        }

        .container-main {
            margin-top: 40px;
            max-width: 700px;
        }

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
<div class="container container-main">

    <div class="card p-4 shadow-sm">
        <h3 class="mb-4">Thêm / Sửa phòng</h3>

        <form method="post" action="room">
            <input type="hidden" name="id" value="${room.id}"/>

            <!-- Room Number -->
            <div class="mb-3">
                <label class="form-label">Số phòng</label>
                <input type="text" name="roomNumber" 
                       value="${room.roomNumber}" 
                       class="form-control" required>
            </div>

            <!-- Photo -->
            <div class="mb-3">
                <label class="form-label">Ảnh (URL)</label>
                <input type="text" name="photo" 
                       value="${room.photo}" 
                       class="form-control">
            </div>

            <!-- Status -->
            <div class="mb-3">
                <label class="form-label">Trạng thái</label>
                <select name="status" class="form-select">
                    <option value="AVAILABLE" ${room.status == 'AVAILABLE' ? 'selected' : ''}>AVAILABLE</option>
                    <option value="OCCUPIED" ${room.status == 'OCCUPIED' ? 'selected' : ''}>OCCUPIED</option>
                    <option value="MAINTENANCE" ${room.status == 'MAINTENANCE' ? 'selected' : ''}>MAINTENANCE</option>
                </select>
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
            <button type="submit" class="btn btn-custom">Lưu</button>
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
