<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h2>Loại phòng</h2>

<form method="post" action="roomtype">
    Tên: <input name="name"/>
    Giá: <input name="price"/>
    Sức chứa: <input name="capacity"/>
    Mô tả: <input name="description"/>
    <button>Thêm</button>
</form>

<c:forEach var="t" items="${types}">
    <div>
        ${t.name} - ${t.basePrice}
        <a href="roomtype?action=delete&id=${t.id}">Xóa</a>
    </div>
</c:forEach>
