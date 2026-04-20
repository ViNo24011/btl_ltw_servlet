<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile | LakeSide Hotel</title>
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

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Plus Jakarta Sans", sans-serif;
            background: var(--bg-grad);
            color: var(--ink);
        }

        .page { width: min(1120px, 94%); margin: 28px auto; }

        .topbar {
            background: rgba(255, 255, 255, 0.94);
            border: 1px solid #dbeafe;
            border-radius: 22px;
            padding: 14px 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            box-shadow: 0 16px 34px rgba(15, 23, 42, 0.08);
        }

        .brand { font-family: "Sora", sans-serif; font-size: 1.45rem; }
        .brand .accent { color: var(--accent); }

        .menu { display: flex; gap: 10px; flex-wrap: wrap; }
        .menu a {
            text-decoration: none;
            color: #0f172a;
            border: 1px solid #bfdbfe;
            background: #f8fafc;
            border-radius: 999px;
            padding: 9px 15px;
            font-weight: 600;
        }

        .alert {
            margin-top: 14px;
            border-radius: 12px;
            padding: 11px 13px;
            font-weight: 600;
            border: 1px solid;
        }
        .alert.success { background: #ecfdf5; color: #065f46; border-color: #a7f3d0; }
        .alert.error { background: #fff1f2; color: #9f1239; border-color: #fecdd3; }

        .grid {
            margin-top: 18px;
            display: grid;
            grid-template-columns: 1.1fr 0.9fr;
            gap: 16px;
        }

        .card {
            background: rgba(255, 255, 255, 0.95);
            border: 1px solid #dbeafe;
            border-radius: 20px;
            padding: 20px;
            box-shadow: 0 10px 22px rgba(15, 23, 42, 0.08);
        }

        .hero {
            color: #f8fafc;
            background: linear-gradient(160deg, #111827, #0f766e 60%, #0284c7);
        }

        .hero h1 {
            margin: 0;
            font-family: "Sora", sans-serif;
            font-size: clamp(1.7rem, 3vw, 2.6rem);
            line-height: 1.16;
        }

        .hero p {
            margin: 12px 0 0;
            color: #e2e8f0;
            line-height: 1.7;
            font-size: 1.05rem;
        }

        .label {
            font-size: 0.84rem;
            color: #64748b;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-top: 14px;
        }

        .value {
            font-size: 1rem;
            font-weight: 700;
            margin-top: 4px;
        }

        .kpis {
            margin-top: 14px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .kpi {
            border: 1px solid #dbeafe;
            border-radius: 12px;
            background: #f8fafc;
            padding: 10px;
        }

        .kpi .num { font-size: 1.2rem; font-weight: 800; }
        .kpi .txt { color: #64748b; font-size: 0.9rem; font-weight: 600; }

        .badge {
            display: inline-block;
            margin-top: 8px;
            border-radius: 999px;
            padding: 6px 12px;
            color: #fff;
            background: linear-gradient(120deg, var(--accent), var(--accent-strong));
            font-weight: 700;
            font-size: 0.86rem;
        }

        .actions { margin-top: 14px; display: grid; gap: 10px; }
        .btn {
            border: 1px solid #bfdbfe;
            background: #f8fafc;
            color: #0f172a;
            border-radius: 12px;
            padding: 10px 12px;
            font: inherit;
            font-weight: 700;
            text-decoration: none;
            text-align: center;
            cursor: pointer;
        }

        .btn.primary {
            color: #fff;
            border: none;
            background: linear-gradient(120deg, var(--accent), var(--accent-strong));
        }

        form .field { margin-bottom: 12px; }
        form label { display: block; margin-bottom: 6px; font-size: 0.9rem; font-weight: 700; }
        form input {
            width: 100%;
            border-radius: 12px;
            border: 1px solid #d1d5db;
            padding: 11px 12px;
            font: inherit;
        }

        form input:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(166, 77, 121, 0.16);
        }

        .form-actions { display: flex; gap: 10px; margin-top: 12px; }

        @media (max-width: 900px) {
            .topbar { flex-direction: column; align-items: flex-start; }
            .grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<main class="page">
    <header class="topbar">
        <div class="brand"><span class="accent">lake</span>Side Hotel</div>
        <nav class="menu">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="${pageContext.request.contextPath}/vouchers">Vouchers</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
        </nav>
    </header>

    <c:if test="${param.success == 'updated'}">
        <div class="alert success">Profile updated successfully.</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert error">${error}</div>
    </c:if>

    <section class="grid">
        <article class="card hero">
            <h1>Your stay starts here</h1>
            <p>Search rooms, manage bookings, and keep every travel plan organized in one clean dashboard.</p>
            <div class="label">Signed in as</div>
            <div class="value">${empty profileUser.firstName ? 'Guest' : profileUser.firstName} ${empty profileUser.lastName ? '' : profileUser.lastName}</div>
            <div class="value" style="color:#cbd5e1; font-size:.95rem; font-weight:600;">${empty profileUser.email ? 'No email in session' : profileUser.email}</div>
        </article>

        <article class="card">
            <h2 style="margin:0; font-family:'Sora',sans-serif;">Account Overview</h2>
            <div class="kpis">
                <div class="kpi">
                    <div class="num">${totalBookings}</div>
                    <div class="txt">Total bookings</div>
                </div>
                <div class="kpi">
                    <div class="num"><fmt:formatDate value="${profileUser.createdAt}" pattern="dd/MM/yyyy" /></div>
                    <div class="txt">Join date</div>
                </div>
            </div>

            <div class="label">Customer Group</div>
            <span class="badge">${customerGroup}</span>

            <div class="actions">
                <a class="btn" href="${pageContext.request.contextPath}/room">Browse all rooms</a>
                <a class="btn" href="${pageContext.request.contextPath}/vouchers">View available vouchers</a>
                <a class="btn" href="${pageContext.request.contextPath}/profile/edit">Edit your profile</a>
            </div>
        </article>
    </section>

    <c:if test="${editMode}">
        <section class="card" style="margin-top:16px;">
            <h2 style="margin:0 0 12px; font-family:'Sora',sans-serif;">Edit Profile</h2>
            <form method="post" action="${pageContext.request.contextPath}/profile/edit">
                <div class="field">
                    <label for="firstName">First name</label>
                    <input id="firstName" type="text" name="firstName" value="${profileUser.firstName}" required>
                </div>
                <div class="field">
                    <label for="lastName">Last name</label>
                    <input id="lastName" type="text" name="lastName" value="${profileUser.lastName}" required>
                </div>
                <div class="field">
                    <label for="email">Email</label>
                    <input id="email" type="email" name="email" value="${profileUser.email}" required>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn primary">Save changes</button>
                    <a href="${pageContext.request.contextPath}/profile" class="btn">Cancel</a>
                </div>
            </form>
        </section>
    </c:if>

    <section class="grid" style="grid-template-columns:repeat(3,1fr); margin-top:16px;">
        <article class="card">
            <h3 style="margin:0; font-family:'Sora',sans-serif;">Discover Rooms</h3>
            <p style="margin:10px 0 0; color:var(--muted); line-height:1.6;">Filter room types and check details quickly before booking.</p>
        </article>
        <article class="card">
            <h3 style="margin:0; font-family:'Sora',sans-serif;">Manage Account</h3>
            <p style="margin:10px 0 0; color:var(--muted); line-height:1.6;">Keep your profile updated for a smoother check-in process.</p>
        </article>
        <article class="card">
            <h3 style="margin:0; font-family:'Sora',sans-serif;">Track Reservations</h3>
            <p style="margin:10px 0 0; color:var(--muted); line-height:1.6;">Find and review your booking status whenever you need.</p>
        </article>
    </section>
</main>
</body>
</html>
