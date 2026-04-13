<%@ page contentType="text/html;charset=UTF-8" %>

<h2>Chi tiết phòng</h2>

<p>Số phòng: ${room.roomNumber}</p>
<p>Loại: ${room.roomType.name}</p>
<p>Giá: ${room.roomType.basePrice}</p>
<p>Sức chứa: ${room.roomType.maxCapacity}</p>
<p>Mô tả: ${room.roomType.description}</p>

<img src="${room.photo}" width="200"/>
