<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Room Detail</title>

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
        }

        .btn-custom {
            background-color: var(--main-color);
            color: white;
        }

        .btn-custom:hover {
            background-color: var(--hover-color);
            color: white;
        }

        .room-img {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 12px;
        }

        .room-box {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .price {
            color: #e91e63;
            font-size: 24px;
            font-weight: bold;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
    <div class="container">
        <a class="navbar-brand" href="room">Proj Hotel</a>
        <a class="nav-link" href="room">Back to rooms</a>
    </div>
</nav>

<!-- CONTENT -->
<div class="container mt-4">

    <div class="row">

        <!-- IMAGE -->
        <div class="col-md-7">
            <img class="room-img"
                 src="${pageContext.request.contextPath}/images/default-room.jpg"/>
        </div>

        <!-- INFO -->
        <div class="col-md-5">

            <div class="room-box">

                <h2>Room ${room.roomNumber}</h2>

                <p>Type: ${room.roomType.name}</p>

                <p class="price">
                    ${room.roomType.basePrice} VND / night
                </p>

                <p>
                    Capacity: ${room.roomType.maxCapacity} people
                </p>

                <hr/>

                <p>
                    ${room.roomType.description}
                </p>

                <a href="booking?action=create&roomId=${room.id}"
                   class="btn btn-custom w-100 mt-3">
                    Book this room
                </a>

            </div>

        </div>

    </div>

</div>

</body>
</html>0"/>
