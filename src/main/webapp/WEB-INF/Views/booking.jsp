<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Booking</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            flex-direction: column;
            padding: 40px 0;
        }

        .form-box {
            border: 1px solid #ccc;
            padding: 20px;
            border-radius: 10px;
            background: white;
            min-width: 400px;
            margin-bottom: 15px;
        }

        button {
            background-color: #a64d79;
            color: white;
            border-radius: 4px;
            border: none;
            padding: 8px 16px;
            display: block;
            margin: 15px auto 0;
            cursor: pointer;
        }

        label {
            color: #a64d79;
        }

        input {
            padding: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .form-group {
            display: grid;
            grid-template-columns: 120px 1fr;
            align-items: center;
            margin-bottom: 10px;
        }

        .info-text {
            margin-top: 10px;
        }

        table {
            border-collapse: collapse;
            margin-top: 15px;
            width: 100%;
        }

        td, th {
            padding: 6px 10px;
            text-align: center;
            border: 1px solid #ccc;
        }

        .table-container {
            max-height: 250px;
            overflow-y: auto;
            margin-top: 15px;
        }
        .voucher-tabe-container{
            border: 1px solid #ccc;
            padding: 20px;
            border-radius: 10px;
            background: white;
            min-width: 400px;
            margin-bottom: 15px;
            max-height: 250px;
            overflow-y: auto;
            margin-top: 15px;
        }

        .error-message {
            display: block;
            background-color: red;
            color: black;
            padding: 8px;
            border-radius: 6px;
            margin: 10px 0;
            text-align: center;
        }
    </style>
</head>
<body>
    <div>
        <label>
            Main menu
        </label>
    </div>
    <div style="border: 1px solid #ccc; padding: 50px; border-radius: 10px; background: white; min-width: 400px;">
        <!-- voucher -->
        <form class="form-box" action="booking" method="post">
            <input type="hidden" name="action" value="getVouchers">
            <div class="form-group">
                <label>Voucher:</label>
                <input type="text" name="voucherCode" placeholder="Enter voucher code" required>
            </div>
            <c:if test="${not empty voucherMessage}">
                <span class="error-message">${voucherMessage}</span>
            </c:if>
            <button type="submit">Apply Voucher</button>
            
        </form>
        <c:if test="${not empty voucher}">
            <div class="voucher-tabe-container">
                <table>
                    <tr>
                        <td><strong>Voucher Code</strong></td>
                        <td><strong>Expiry Date</strong></td>
                        <td><strong>Value</strong></td>   
                    </tr>
                    <tr>
                        <td>${voucher.code}</td>
                        <td>${voucher.expiryDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${voucher.isIsPercent()}">
                                    ${voucher.discountValue}%
                                </c:when>
                                <c:otherwise>
                                    ${voucher.discountValue}
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </table>
            

                <form action="booking" method="post">
                    <input type="hidden" name="action" value="removeVoucher">
                    <button type="submit" style="background-color: gray;">Remove Voucher</button>
                </form>
            </div>
        </c:if>
        <!-- Booking -->
        <form class="form-box" action="booking" method="post">
            <input type="hidden" name="action" value="createBooking">

            <div class="form-group">
                <label>First Name:</label>
                <input name="firstName" value="${sessionScope.user.firstName}" required>
            </div>

            <div class="form-group">
                <label>Last Name:</label>
                <input name="lastName" value="${sessionScope.user.lastName}" required>
            </div>

            <div class="form-group">
                <label>Email:</label>
                <input name="guestEmail" value="${sessionScope.user.email}" required>
            </div>

            <div class="info-text">
                <label>Total amount: ${totalAmount}</label><br>
            </div>

            <c:if test="${not empty bookingMessage}">
                <span class="error-message">${bookingMessage}</span>
            </c:if>

            <div class="table-container">
                <table>
                    <tr>
                        <th>Selected rooms</th>
                        <th>Number of adults</th>
                        <th>Number of children</th>
                        <th>Max capacity</th>
                    </tr>

                    <c:forEach var="room" items="${selectedRooms}">
                        <tr>
                            <td>${room.roomNumber}</td>
                            <td>
                                <input name="numAdults-${room.id}" type="number" value="0" min="0" required>
                            </td>
                            <td>
                                <input name="numChildren-${room.id}" type="number" value="0" min="0" required>
                            </td>
                            <td>${sessionScope.roomType.maxCapacity}</td>
                        </tr>
                    </c:forEach>
                </table>
            </div>

            <button type="submit">Proceed payment</button>
        </form>

    </div>

</body>

</html>