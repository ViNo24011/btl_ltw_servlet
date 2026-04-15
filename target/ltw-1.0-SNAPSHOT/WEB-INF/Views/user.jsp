<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Qu?n lý ngu?i dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Danh sách User</h2>
        <div>
            <a class="btn btn-success" href="${pageContext.request.contextPath}/admin/users/create">Thêm tài kho?n</a>
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/home">Trang ch?</a>
        </div>
    </div>

    <c:if test="${not empty param.success}">
        <div class="alert alert-success">Thao tác thành công: ${param.success}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger">Có l?i: ${param.error}</div>
    </c:if>

    <table class="table table-bordered table-hover align-middle">
        <thead class="table-light">
        <tr>
            <th>ID</th>
            <th>H?</th>
            <th>Tên</th>
            <th>Email</th>
            <th>Vai trò</th>
            <th>Tr?ng thái</th>
            <th width="220">Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="u" items="${users}">
            <tr>
                <td>${u.id}</td>
                <td>${u.firstName}</td>
                <td>${u.lastName}</td>
                <td>${u.email}</td>
                <td>
                    <c:forEach var="r" items="${u.roles}">
                        <span class="badge text-bg-info">${r.name}</span>
                    </c:forEach>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${u.isActive}"><span class="badge text-bg-success">Active</span></c:when>
                        <c:otherwise><span class="badge text-bg-secondary">Inactive</span></c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <a class="btn btn-sm btn-primary" href="${pageContext.request.contextPath}/admin/users/edit?id=${u.id}">S?a</a>
                    <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/users/delete" onsubmit="return confirm('Xác nh?n xóa user này?');">
                        <input type="hidden" name="id" value="${u.id}">
                        <button type="submit" class="btn btn-sm btn-danger">Xóa</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
