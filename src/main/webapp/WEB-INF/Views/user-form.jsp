<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Form</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4" style="max-width: 720px;">
    <h2 class="mb-3">
        <c:choose>
            <c:when test="${not empty formUser}">C?p nh?t tài kho?n</c:when>
            <c:otherwise>Thêm tài kho?n m?i</c:otherwise>
        </c:choose>
    </h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}${not empty formUser ? '/admin/users/edit' : '/admin/users/create'}">
        <c:if test="${not empty formUser}">
            <input type="hidden" name="id" value="${formUser.id}">
        </c:if>

        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label">H?</label>
                <input type="text" class="form-control" name="firstName" value="${formUser.firstName}" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">Tên</label>
                <input type="text" class="form-control" name="lastName" value="${formUser.lastName}" required>
            </div>
            <div class="col-12">
                <label class="form-label">Email</label>
                <input type="email" class="form-control" name="email" value="${formUser.email}" required>
            </div>
            <div class="col-12">
                <label class="form-label">M?t kh?u <c:if test="${not empty formUser}">(d? tr?ng n?u không d?i)</c:if></label>
                <input type="password" class="form-control" name="password" ${empty formUser ? 'required' : ''}>
            </div>
            <div class="col-md-6">
                <label class="form-label">Vai trò</label>
                <select class="form-select" name="roleName" required>
                    <option value="ROLE_USER" ${currentRole == 'ROLE_USER' ? 'selected' : ''}>ROLE_USER</option>
                    <option value="ROLE_ADMIN" ${currentRole == 'ROLE_ADMIN' ? 'selected' : ''}>ROLE_ADMIN</option>
                </select>
            </div>
            <div class="col-md-6 d-flex align-items-end">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" name="isActive" id="isActive"
                           ${empty formUser || formUser.isActive ? 'checked' : ''}>
                    <label class="form-check-label" for="isActive">Kích ho?t tài kho?n</label>
                </div>
            </div>
        </div>

        <div class="mt-4">
            <button type="submit" class="btn btn-primary">Luu</button>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/admin/users">Quay l?i</a>
        </div>
    </form>
</div>
</body>
</html>
