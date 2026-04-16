<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h2>Form phòng</h2>

<form method="post" action="room">

    <input type="hidden" name="id" value="${room.id}"/>

    Số phòng: <input type="text" name="roomNumber" value="${room.roomNumber}"/><br>

    Ảnh: <input type="text" name="photo" value="${room.photo}"/><br>

    Trạng thái:
    <select name="status">
        <option>AVAILABLE</option>
        <option>OCCUPIED</option>
        <option>MAINTENANCE</option>
    </select><br>

    Loại phòng:
    <select name="roomTypeId">
        <c:forEach var="t" items="${roomTypes}">
            <option value="${t.id}">${t.name}</option>
        </c:forEach>
    </select><br>

    <button type="submit">Lưu</button>
</form>
<<<<<<< Updated upstream
<h2>Thêm / Sửa phòng</h2>

<form action="room" method="post">
    <input type="hidden" name="action" value="save"/>
    <input type="hidden" name="id" value="${room.id}"/>

    Số phòng:
    <input type="text" name="roomNumber" value="${room.roomNumber}"/><br/>

    Ảnh (url):
    <input type="text" name="photo" value="${room.photo}"/><br/>

    <button type="submit">Lưu</button>
</form>
    
=======
>>>>>>> Stashed changes
