<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>My Vouchers | LakeSide Hotel</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Sora:wght@600;700&display=swap"
                    rel="stylesheet">
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

                    * {
                        box-sizing: border-box;
                    }

                    body {
                        margin: 0;
                        font-family: "Plus Jakarta Sans", sans-serif;
                        background: var(--bg-grad);
                        color: var(--ink);
                    }

                    .page {
                        width: min(1120px, 94%);
                        margin: 28px auto;
                    }

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

                    .brand {
                        font-family: "Sora", sans-serif;
                        font-size: 1.4rem;
                    }

                    .brand .accent {
                        color: var(--accent);
                    }

                    .menu {
                        display: flex;
                        gap: 10px;
                        flex-wrap: wrap;
                    }

                    .menu a {
                        text-decoration: none;
                        color: #0f172a;
                        border: 1px solid #bfdbfe;
                        background: #f8fafc;
                        border-radius: 999px;
                        padding: 9px 14px;
                        font-weight: 600;
                    }

                    .summary {
                        margin-top: 16px;
                        background: rgba(255, 255, 255, 0.96);
                        border: 1px solid #dbeafe;
                        border-radius: 18px;
                        padding: 16px;
                        box-shadow: 0 10px 24px rgba(15, 23, 42, 0.08);
                    }

                    .summary h1 {
                        margin: 0;
                        font-family: "Sora", sans-serif;
                        font-size: clamp(1.3rem, 2.5vw, 1.9rem);
                    }

                    .summary p {
                        margin: 8px 0 0;
                        color: var(--muted);
                    }

                    .chip {
                        display: inline-block;
                        margin-top: 10px;
                        border-radius: 999px;
                        padding: 6px 12px;
                        color: #fff;
                        background: linear-gradient(120deg, var(--accent), var(--accent-strong));
                        font-size: 0.85rem;
                        font-weight: 700;
                    }

                    .notice {
                        margin-top: 12px;
                        border-radius: 12px;
                        padding: 10px 12px;
                        border: 1px solid #a7f3d0;
                        background: #ecfdf5;
                        color: #065f46;
                        font-weight: 700;
                    }

                    .grid {
                        margin-top: 16px;
                        display: grid;
                        grid-template-columns: repeat(3, minmax(0, 1fr));
                        gap: 14px;
                    }

                    .voucher-card {
                        background: rgba(255, 255, 255, 0.97);
                        border: 1px solid #dbeafe;
                        border-radius: 16px;
                        padding: 14px;
                        box-shadow: 0 8px 18px rgba(15, 23, 42, 0.08);
                        display: grid;
                        gap: 8px;
                    }

                    .voucher-card h3 {
                        margin: 0;
                        font-family: "Sora", sans-serif;
                        color: var(--accent);
                    }

                    .value {
                        font-size: 1.2rem;
                        font-weight: 800;
                    }

                    .meta {
                        font-size: 0.9rem;
                        color: #475569;
                        font-weight: 600;
                    }

                    .empty {
                        margin-top: 16px;
                        background: rgba(255, 255, 255, 0.96);
                        border: 1px dashed #bfdbfe;
                        border-radius: 16px;
                        padding: 24px;
                        text-align: center;
                        color: #64748b;
                        font-weight: 600;
                    }

                    @media (max-width: 900px) {
                        .topbar {
                            flex-direction: column;
                            align-items: flex-start;
                        }

                        .grid {
                            grid-template-columns: 1fr 1fr;
                        }
                    }

                    @media (max-width: 640px) {
                        .grid {
                            grid-template-columns: 1fr;
                        }
                    }
                </style>
            </head>

            <body>
                <main class="page">
                    <header class="topbar">
                        <div class="brand"><span class="accent">lake</span>Side Hotel</div>
                        <nav class="menu">
                            <a href="${pageContext.request.contextPath}/home">Home</a>
                            <a href="${pageContext.request.contextPath}/profile">Profile</a>
                            <a href="${pageContext.request.contextPath}/logout">Logout</a>
                        </nav>
                    </header>

                    <section class="summary">
                        <h1>Available Vouchers</h1>
                        <p>Personalized offers based on your profile and booking history.</p>
                        <span class="chip">Current group: ${customerGroup}</span>

                        <c:if test="${not empty newVoucherMessage}">
                            <div class="notice">${newVoucherMessage}</div>
                        </c:if>
                    </section>

                    <c:choose>
                        <c:when test="${empty vouchers}">
                            <section class="empty">No vouchers are currently available for your account.</section>
                        </c:when>
                        <c:otherwise>
                            <section class="grid">
                                <c:forEach var="v" items="${vouchers}">
                                    <article class="voucher-card">
                                        <h3>${v.code}</h3>
                                        <div class="value">
                                            <c:choose>
                                                <c:when test="${v.isPercent}">${v.discountValue}% OFF</c:when>
                                                <c:otherwise>
                                                    <fmt:formatNumber value="${v.discountValue}" type="number"
                                                        groupingUsed="true" /> OFF
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="meta">Target group: ${v.targetGroup}</div>
                                        <div class="meta">Usage: ${v.usedCount}/${v.usageLimit}</div>
                                        <div class="meta">Expires:
                                            <fmt:formatDate value="${v.expiryDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </div>
                                    </article>
                                </c:forEach>
                            </section>
                        </c:otherwise>
                    </c:choose>
                </main>
            </body>

            </html>
