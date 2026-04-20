<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Admin - Room Management</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        :root {
            --main-color: #a64d79;
            --hover-color: #8e3a64;
        }

        body {
            background: #f8f9fa;
        }

        .navbar-brand {
            color: var(--main-color) !important;
            font-weight: bold;
        }

        .btn-custom {
            background: var(--main-color);
            color: white;
            border: none;
        }

        .btn-custom:hover {
            background: var(--hover-color);
            color: white;
        }

        .card-room {
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: 0.3s;
        }

        .card-room:hover {
            transform: translateY(-5px);
        }

        .img-room {
            height: 180px;
            object-fit: cover;
        }

        .btn-roomtype {
            background: linear-gradient(120deg, #a64d79, #8e3a64);
            color: white;
            border: none;
        }

        .btn-roomtype:hover {
            opacity: 0.9;
            color: white;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-light bg-light border-bottom">
    <div class="container d-flex justify-content-between align-items-center">

        <!-- ✅ CLICK VỀ HOME -->
        <a class="navbar-brand"
           href="${pageContext.request.contextPath}/home">
            Admin Panel
        </a>

        <div class="d-flex align-items-center">

            <c:if test="${not empty sessionScope.user}">
                <span class="me-3 fw-bold">
                    ${sessionScope.user.firstName}
                </span>
            </c:if>

            <a class="btn btn-roomtype me-2"
               href="${pageContext.request.contextPath}/roomtype">
                Manage Room Types
            </a>

            <a class="btn btn-custom me-2"
               href="${pageContext.request.contextPath}/admin/room?action=new">
                Add Room
            </a>

            <c:if test="${not empty sessionScope.user}">
                <a class="btn btn-danger"
                   href="${pageContext.request.contextPath}/logout">
                    Logout
                </a>
            </c:if>

        </div>

    </div>
</nav>

<div class="container mt-4">

    <div class="mb-3">
        <h2>Room Management (ADMIN)</h2>
    </div>

    <div class="row">

        <c:forEach var="r" items="${rooms}">
            <div class="col-md-4 mb-4">

                <div class="card card-room">

                    <!-- ✅ FIX ẢNH CHUẨN -->
                    <img class="card-img-top img-room"
                         src="${not empty r.photo ? r.photo : 'https://via.placeholder.com/300'}"
                         alt="Room Image"/>

                    <div class="card-body">

                        <h5 class="card-title">
                            Room ${r.roomNumber}
                        </h5>

                        <p>Type: ${r.roomType.name}</p>

                        <p class="text-danger fw-bold">
                            ${r.roomType.basePrice} VND / night
                        </p>

                        <p>Capacity: ${r.roomType.maxCapacity}</p>

                        <div class="d-flex justify-content-between">

                            <a class="btn btn-secondary btn-sm"
                               href="${pageContext.request.contextPath}/admin/room?action=detail&id=${r.id}">
                                Detail
                            </a>

                            <a class="btn btn-warning btn-sm"
                               href="${pageContext.request.contextPath}/admin/room?action=edit&id=${r.id}">
                                Edit
                            </a>

                            <a class="btn btn-danger btn-sm"
                               onclick="return confirm('Are you sure to delete this room?')"
                               href="${pageContext.request.contextPath}/admin/room?action=delete&id=${r.id}">
                                Delete
                            </a>

                        </div>

                    </div>

                </div>

            </div>
        </c:forEach>

    </div>

    <!-- PAGINATION -->
    <div class="text-center mt-4">

        <c:if test="${totalPages > 1}">
            <c:forEach begin="1" end="${totalPages}" var="i">

                <a href="${pageContext.request.contextPath}/admin/room?action=list&page=${i}"
                   class="btn btn-sm ${i == currentPage ? 'btn-dark' : 'btn-outline-dark'}">
                    ${i}
                </a>

            </c:forEach>
        </c:if>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>admin-roo
