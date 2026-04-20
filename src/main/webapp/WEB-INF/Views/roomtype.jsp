<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>Room Type - Proj Hotel</title>
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
        .container-main {
            margin-top: 40px;
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

    <h2 class="mb-4">Room Types</h2>

    <!-- FORM -->
    <div class="card p-4 mb-4 shadow-sm">
        <h5 class="mb-3">Add Room Type</h5>

        <form method="post" action="roomtype">

            <div class="row mb-3">
                <div class="col">
                    <input name="name" class="form-control" placeholder="Tên">
                </div>
                <div class="col">
                    <input name="price" class="form-control" placeholder="Giá">
                </div>
            </div>

            <div class="row mb-3">
                <div class="col">
                    <input name="capacity" class="form-control" placeholder="Sức chứa">
                </div>
                <div class="col">
                    <input name="description" class="form-control" placeholder="Mô tả">
                </div>
            </div>

            <button type="submit" class="btn btn-custom">Thêm</button>

        </form>
    </div>
    <!-- LIST -->
    <div class="card p-4 shadow-sm">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Tên</th>
                    <th>Giá</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="t" items="${types}">
                    <tr>
                        <td>${t.name}</td>
                        <td>${t.basePrice}</td>
                        <td>
                            <a href="roomtype?action=delete&id=${t.id}" 
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Delete this type?')">
                               Xóa
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<!-- Footer -->
<footer class="text-center">
    <p class="mb-0">© 2026 Proj Hotel</p>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
