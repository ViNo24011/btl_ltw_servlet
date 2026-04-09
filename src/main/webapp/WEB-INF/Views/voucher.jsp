<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Voucher c?a tôi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Danh sách Voucher hi?n có</h2>
        <div>
            <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/profile">H? so cá nhân</a>
            <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/home">Trang ch?</a>
        </div>
    </div>

    <div class="alert alert-info">Nhóm khách hàng hi?n t?i: <strong>${customerGroup}</strong></div>

    <c:if test="${not empty newVoucherMessage}">
        <div class="alert alert-success">${newVoucherMessage}</div>
    </c:if>

    <table class="table table-bordered table-hover">
        <thead class="table-light">
        <tr>
            <th>Mã voucher</th>
            <th>Gi?m giá</th>
            <th>Nhóm áp d?ng</th>
            <th>Ðã dùng/Gi?i h?n</th>
            <th>H?n s? d?ng</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
            <c:when test="${empty vouchers}">
                <tr>
                    <td colspan="5" class="text-center">Hi?n chua có voucher kh? d?ng.</td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="v" items="${vouchers}">
                    <tr>
                        <td><strong>${v.code}</strong></td>
                        <td>
                            <c:choose>
                                <c:when test="${v.isPercent}">${v.discountValue}%</c:when>
                                <c:otherwise><fmt:formatNumber value="${v.discountValue}" type="number" groupingUsed="true" /></c:otherwise>
                            </c:choose>
                        </td>
                        <td>${v.targetGroup}</td>
                        <td>${v.usedCount}/${v.usageLimit}</td>
                        <td><fmt:formatDate value="${v.expiryDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>
</div>
</body>
</html>
