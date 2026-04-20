<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Room Types</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    body {
        background-color: #ffffff;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .container-main {
        margin-top: 40px;
    }

    .card {
        border-radius: 10px;
    }
</style>
</head>

<body>

<div class="container container-main">

    <h2 class="mb-4">Room Types</h2>

    <!-- FORM -->
    <div class="card p-4 mb-4 shadow-sm">
        <h5 class="mb-3">Add Room Type</h5>

        <form method="post" action="roomtype">

            <div class="row mb-3">
                <div class="col">
                    <input name="name" class="form-control" placeholder="Tên">
                </div>
                <div class="col">
                    <input name="price" class="form-control" placeholder="Giá">
                </div>
            </div>

            <div class="row mb-3">
                <div class="col">
                    <input name="capacity" class="form-control" placeholder="Sức chứa">
                </div>
                <div class="col">
                    <input name="description" class="form-control" placeholder="Mô tả">
                </div>
            </div>

            <button class="btn btn-primary">Thêm</button>

        </form>
    </div>

    <!-- LIST -->
    <div class="card p-4 shadow-sm">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Tên</th>
                    <th>Giá</th>
                    <th>Hành động</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="t" items="${types}">
                    <tr>
                        <td>${t.name}</td>
                        <td>${t.basePrice}</td>
                        <td>
                            <a href="roomtype?action=delete&id=${t.id}"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Delete this type?')">
                               Xóa
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</div>

</body>
</html>
