<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Form | LakeSide Hotel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Sora:wght@600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --ink: #1f2937;
            --muted: #6b7280;
            --panel: #ffffff;
            --border: #e5e7eb;
            --accent: #a64d79;
            --accent-strong: #8e3a64;
            --bg-grad: radial-gradient(circle at 8% 8%, #e0e7ff 0, transparent 30%),
                radial-gradient(circle at 92% 20%, #99f6e4 0, transparent 30%),
                linear-gradient(135deg, #dbeafe 0%, #eef2ff 45%, #ecfeff 100%);
        }

        * { box-sizing: border-box; }
        body { margin: 0; font-family: "Plus Jakarta Sans", sans-serif; background: var(--bg-grad); color: var(--ink); }
        .page { width: min(780px, 94%); margin: 28px auto; }

        .card {
            background: rgba(255,255,255,0.96);
            border: 1px solid #dbeafe;
            border-radius: 20px;
            padding: 22px;
            box-shadow: 0 14px 30px rgba(15, 23, 42, 0.1);
        }

        h1 {
            margin: 0 0 16px;
            font-family: "Sora", sans-serif;
            font-size: clamp(1.3rem, 2.5vw, 1.9rem);
        }

        .alert {
            border-radius: 12px;
            padding: 10px 12px;
            border: 1px solid #fecdd3;
            background: #fff1f2;
            color: #9f1239;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .field { margin-bottom: 12px; }
        .field label { display: block; margin-bottom: 6px; font-size: 0.9rem; font-weight: 700; }

        .field input,
        .field select {
            width: 100%;
            border-radius: 12px;
            border: 1px solid #d1d5db;
            padding: 11px 12px;
            font: inherit;
            background: #fff;
        }

        .field input:focus,
        .field select:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(166, 77, 121, 0.16);
        }

        .check {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 10px;
            color: #334155;
            font-weight: 600;
        }

        .actions {
            margin-top: 18px;
            display: flex;
            gap: 10px;
        }

        .btn {
            border: 1px solid #bfdbfe;
            background: #f8fafc;
            color: #0f172a;
            border-radius: 12px;
            padding: 10px 14px;
            font: inherit;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
        }

        .btn.primary {
            color: #fff;
            border: none;
            background: linear-gradient(120deg, var(--accent), var(--accent-strong));
        }

        .top-link {
            display: inline-flex;
            text-decoration: none;
            margin-bottom: 12px;
            color: #334155;
            font-weight: 700;
        }

        @media (max-width: 700px) {
            .grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<main class="page">
    <a class="top-link" href="${pageContext.request.contextPath}/admin/users">? Back to user list</a>

    <section class="card">
        <h1>
            <c:choose>
                <c:when test="${not empty formUser}">Update account</c:when>
                <c:otherwise>Create new account</c:otherwise>
            </c:choose>
        </h1>

        <c:if test="${not empty error}">
            <div class="alert">${error}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}${not empty formUser ? '/admin/users/edit' : '/admin/users/create'}">
            <c:if test="${not empty formUser}">
                <input type="hidden" name="id" value="${formUser.id}">
            </c:if>

            <div class="grid">
                <div class="field">
                    <label for="firstName">First name</label>
                    <input id="firstName" type="text" name="firstName" value="${formUser.firstName}" required>
                </div>
                <div class="field">
                    <label for="lastName">Last name</label>
                    <input id="lastName" type="text" name="lastName" value="${formUser.lastName}" required>
                </div>
            </div>

            <div class="field">
                <label for="email">Email</label>
                <input id="email" type="email" name="email" value="${formUser.email}" required>
            </div>

            <div class="field">
                <label for="password">Password <c:if test="${not empty formUser}">(leave blank if unchanged)</c:if></label>
                <input id="password" type="password" name="password" ${empty formUser ? 'required' : ''}>
            </div>

            <div class="grid">
                <div class="field">
                    <label for="roleName">Role</label>
                    <select id="roleName" name="roleName" required>
                        <option value="ROLE_USER" ${currentRole == 'ROLE_USER' ? 'selected' : ''}>ROLE_USER</option>
                        <option value="ROLE_ADMIN" ${currentRole == 'ROLE_ADMIN' ? 'selected' : ''}>ROLE_ADMIN</option>
                    </select>
                </div>
                <div class="check">
                    <input type="checkbox" name="isActive" id="isActive" ${empty formUser || formUser.isActive ? 'checked' : ''}>
                    <label for="isActive">Active account</label>
                </div>
            </div>

            <div class="actions">
                <button type="submit" class="btn primary">Save</button>
                <a class="btn" href="${pageContext.request.contextPath}/admin/users">Cancel</a>
            </div>
        </form>
    </section>
</main>
</body>
</html>
