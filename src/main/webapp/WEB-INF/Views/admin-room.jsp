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

        .btn-custom {
            background: var(--main-color);
            color: white;
        }

        .btn-custom:hover {
            background: var(--hover-color);
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
    </style>
</head>

<body>

<div class="container mt-4">

    <!-- TITLE -->
    <div class="d-flex justify-content-between align-items-center mb-3">

        <h2>Room Management (ADMIN)</h2>

        <!-- ADD ROOM -->
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
                    <img class="card-img-top img-room"
                         src="${pageContext.request.contextPath}/${r.photo != null ? r.photo : 'images/default.jpg'}"/>

                    <div class="card-body">

                        <h5 class="card-title">
                            Room ${r.roomNumber}
                        </h5>

                        <p class="mb-1">
                            Type: ${r.roomType.name}
                        </p>

                        <p class="text-danger fw-bold">
                            ${r.roomType.basePrice} VND / night
                        </p>

                        <p class="mb-3">
                            Capacity: ${r.roomType.maxCapacity}
                        </p>

                        <!-- ACTION BUTTONS -->
                        <div class="d-flex justify-content-between">

                            <!-- DETAIL -->
                            <a class="btn btn-secondary btn-sm"
                               href="${pageContext.request.contextPath}/admin/room?action=detail&id=${r.id}">
                                Detail
                            </a>

                            <!-- EDIT -->
                            <a class="btn btn-warning btn-sm"
                               href="${pageContext.request.contextPath}/admin/room?action=edit&id=${r.id}">
                                Edit
                            </a>

                            <!-- DELETE -->
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

</body>
</html>
