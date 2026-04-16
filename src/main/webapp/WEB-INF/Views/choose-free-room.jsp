<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Choose Room</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .main-box {
            border: 1px solid #ccc;
            padding: 20px;
            border-radius: 10px;
        }

        form {
            width: 500px;
            border: 1px solid #ccc;
            padding: 15px;
            border-radius: 10px;
        }

        button {
            background-color: #a64d79;
            color: white;
            border-radius: 2px;
            border: none;
            display: block;
            margin: 10px auto 0;
            padding: 6px 12px;
            cursor: pointer;
        }

        label {
            color: #a64d79;
        }

        input {
            padding: 4px;
        }

        /* Grid alignment */
        .form-group {
            display: grid;
            grid-template-columns: 130px 1fr;
            align-items: center;
            margin-bottom: 10px;
        }

        .room-box {
            width: 40px;
            height: 40px;
            border: 1px solid #333;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border-radius: 8px;
            user-select: none;
            transition: 0.2s;
        }

        .room-box:hover {
            background-color: #f0f0f0;
        }

        .room-box input:checked + span,
        .room-box:has(input:checked) {
            background-color: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
        .room-container {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            max-height: 200px;
            overflow-y: auto;
        }
        .error-message {
            display: block;
            background-color: red;  /* same as button */
            color: black;
            padding: 8px;
            border-radius: 6px;
            margin: 10px 0;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="main-box">

    <!-- Form 1 -->
    <form action="booking" method="post">
        <input type="hidden" name="action" value="getFreeRoom">

        <div class="form-group">
            <label>Check in date:</label>
            <input type="date" name="checkIn" value="${sessionScope.checkIn}" required>
        </div>

        <div class="form-group">
            <label>Check out date:</label>
            <input type="date" name="checkOut" value="${sessionScope.checkOut}" required>
        </div>
        <label>Room price: ${sessionScope.roomType.basePrice}</label>
        <c:if test="${not empty message}">
            <span class="error-message">${message}</span>
        </c:if>
        

        <button type="submit">Check</button>
    </form>

    <br>

    <!-- Form 2 -->
    <form action="booking" method="post">
        <input type="hidden" name="action" value="chooseRooms">

        <div class="room-container">
            <c:forEach var="room" items="${freeRooms}">
                <label class="room-box">
                    <input type="checkbox" name="roomIds" value="${room.id}" hidden>
                    <span>${room.roomNumber}</span>
                </label>
            </c:forEach>
        </div>

        <button type="submit">Booking</button>
    </form>

</div>
</body>
</html>