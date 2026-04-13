<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>H? so cá nhân</h2>
        <div>
            <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/vouchers">Voucher c?a tôi</a>
            <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/home">Trang ch?</a>
        </div>
    </div>

    <c:if test="${param.success == 'updated'}">
        <div class="alert alert-success">C?p nh?t h? so thành công.</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="card mb-3">
        <div class="card-body">
            <h5 class="card-title">Thông tin tài kho?n</h5>
            <p class="mb-1"><strong>H?:</strong> ${profileUser.firstName}</p>
            <p class="mb-1"><strong>Tên:</strong> ${profileUser.lastName}</p>
            <p class="mb-1"><strong>Email:</strong> ${profileUser.email}</p>
            <p class="mb-1"><strong>Ngày dang ký:</strong> <fmt:formatDate value="${profileUser.createdAt}" pattern="dd/MM/yyyy HH:mm" /></p>
            <p class="mb-1"><strong>T?ng booking:</strong> ${totalBookings}</p>
            <p class="mb-0"><strong>Nhóm khách hàng:</strong> ${customerGroup}</p>
        </div>
    </div>

    <c:choose>
        <c:when test="${editMode}">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Ch?nh s?a h? so</h5>
                    <form method="post" action="${pageContext.request.contextPath}/profile/edit">
                        <div class="mb-3">
                            <label class="form-label">H?</label>
                            <input type="text" name="firstName" class="form-control" value="${profileUser.firstName}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Tên</label>
                            <input type="text" name="lastName" class="form-control" value="${profileUser.lastName}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" value="${profileUser.email}" required>
                        </div>
                        <button type="submit" class="btn btn-primary">Luu thay d?i</button>
                        <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary">H?y</a>
                    </form>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/profile/edit" class="btn btn-primary">Ch?nh s?a h? so</a>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
