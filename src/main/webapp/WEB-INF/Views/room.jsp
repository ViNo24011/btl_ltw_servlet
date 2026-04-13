<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h2>Danh sách phòng</h2>

<a href="room?action=new">Thêm phòng</a>

<c:forEach var="r" items="${rooms}">
    <div style="border:1px solid #ccc; margin:10px; padding:10px;">
        <h3>Phòng ${r.roomNumber}</h3>

        <img src="${r.photo}" width="150"/>

        <p>Loại: ${r.roomType.name}</p>
        <p>Giá: ${r.roomType.basePrice}</p>
        <p>Sức chứa: ${r.roomType.maxCapacity}</p>

        <a href="room?action=detail&id=${r.id}">Chi tiết</a>
        <a href="room?action=edit&id=${r.id}">Sửa</a>
        <a href="room?action=delete&id=${r.id}">Xóa</a>
    </div>
</c:forEach>

<!-- PAGINATION -->
<div>
    <c:forEach begin="1" end="${totalPage}" var="i">
        <a href="room?page=${i}">${i}</a>
    </c:forEach>
</div>
