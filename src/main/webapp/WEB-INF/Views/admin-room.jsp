<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
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

        .card-room img {
            height: 180px;
            object-fit: cover;
        }
    </style>
</head>

<body>

<div class="container mt-4">

    <!-- TITLE + ADD -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Room Management (ADMIN)</h2>

        <a href="${pageContext.request.contextPath}/admin/room?action=new"
           class="btn btn-custom">
            + Add Room
        </a>
    </div>

    <!-- ROOM LIST -->
    <div class="row">

        <c:forEach var="r" items="${rooms}">
            <div class="col-md-4 mb-4">

                <div class="card card-room">

                    <!-- IMAGE -->
                    <img class="card-img-top"
                         src="${not empty r.photo ? r.photo : 'https://via.placeholder.com/300'}"/>

                    <div class="card-body">

                        <h5 class="card-title">
                            Room ${r.roomNumber}
                        </h5>

                        <p>
                            Type: ${r.roomType.name}
                        </p>

                        <p class="text-danger fw-bold">
                            ${r.roomType.basePrice} VND / night
                        </p>

                        <p>
                            Capacity: ${r.roomType.maxCapacity}
                        </p>

                        <!-- ACTION -->
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
</html>
