<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Admin - Room Form</title>

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
    </style>
</head>

<body>

<!-- ✅ NAVBAR ADMIN -->
<nav class="navbar navbar-light bg-light border-bottom">
    <div class="container d-flex justify-content-between">

        <a class="navbar-brand"
           href="${pageContext.request.contextPath}/admin/room">
            Admin Panel
        </a>

        <div>
            <c:if test="${not empty sessionScope.user}">
                <span class="me-3 fw-bold">
                    ${sessionScope.user.firstName}
                </span>

                
            </c:if>
        </div>

    </div>
</nav>

<!-- CONTENT -->
<div class="container container-main">

    <div class="card p-4 shadow-sm">
        <h3 class="mb-4">Sửa / Thêm Phòng</h3>

        <!-- ⚠️ SỬA ACTION -->
        <form method="post" action="${pageContext.request.contextPath}/admin/room">
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
                            ${room.roomType.id == t.id ? 'selected' : ''}>
                            ${t.name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- BUTTON -->
            <button type="submit" class="btn btn-custom">Lưu</button>

            <!-- ⚠️ SỬA LINK BACK -->
            <a href="${pageContext.request.contextPath}/admin/room"
               class="btn btn-secondary">
                Quay lại
            </a>

        </form>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
