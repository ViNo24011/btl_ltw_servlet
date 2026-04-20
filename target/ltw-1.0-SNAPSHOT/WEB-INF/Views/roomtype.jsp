<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Room Types | Admin</title>

<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&family=Sora:wght@600;700&display=swap" rel="stylesheet">

<style>
:root {
    --accent: #a64d79;
    --accent-strong: #8e3a64;
    --border: #e5e7eb;
    --bg: linear-gradient(135deg,#dbeafe,#eef2ff,#ecfeff);
}

body {
    margin: 0;
    font-family: "Plus Jakarta Sans", sans-serif;
    background: var(--bg);
}

.page {
    width: min(1100px, 94%);
    margin: 24px auto;
}

/* HEADER */
.topbar {
    background: #fff;
    border-radius: 20px;
    padding: 14px 18px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 10px 25px rgba(0,0,0,0.08);
}

.brand {
    font-family: "Sora";
    font-size: 1.6rem;
    font-weight: 700;
}

.brand span { color: var(--accent); }

/* FORM */
.form-card {
    margin-top: 20px;
    background: #fff;
    padding: 18px;
    border-radius: 16px;
    border: 1px solid var(--border);
    box-shadow: 0 10px 25px rgba(0,0,0,0.08);
}

.form-card h3 {
    margin-top: 0;
    color: var(--accent);
}

.form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 10px;
}

input {
    padding: 10px;
    border-radius: 10px;
    border: 1px solid #d1d5db;
}

/* BUTTON GROUP */
.btn-group {
    margin-top: 10px;
    display: flex;
    gap: 10px;
}

.add-btn, .back-btn {
    padding: 10px 16px;
    border-radius: 10px;
    border: none;
    font-weight: 700;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}

/* ADD */
.add-btn {
    background: linear-gradient(120deg,var(--accent),var(--accent-strong));
    color: #fff;
}

/* BACK */
.btn {
    padding: 10px 16px;
    border-radius: 10px; /* bo góc */
    font-weight: 700;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border: none;
    cursor: pointer;
    transition: 0.25s;
}

/* màu secondary (xám đẹp) */
.btn-secondary {
    background: linear-gradient(120deg, #6b7280, #4b5563);
    color: #fff;
}

/* hover effect */
.btn-secondary:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 15px rgba(0,0,0,0.15);
}

/* LIST */
.section-title {
    margin-top: 24px;
    font-weight: 700;
    color: var(--accent-strong);
}

.grid {
    margin-top: 10px;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 14px;
}

.card {
    background: #fff;
    border-radius: 14px;
    border: 1px solid var(--border);
    padding: 14px;
    transition: 0.25s;
}

.card:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 25px rgba(0,0,0,0.1);
}

.card h4 {
    margin: 0;
    color: var(--accent);
}

.price {
    margin: 6px 0;
    font-weight: 800;
    color: #b45309;
}

.meta {
    font-size: 0.9rem;
    color: #64748b;
}

.delete-btn {
    margin-top: 10px;
    display: inline-block;
    padding: 6px 10px;
    border-radius: 8px;
    background: #ef4444;
    color: #fff;
    text-decoration: none;
    font-size: 0.8rem;
    font-weight: 700;
}

/* FOOTER */
.footer {
    margin-top: 30px;
    text-align: center;
    color: #64748b;
    font-weight: 600;
}

/* RESPONSIVE */
@media (max-width: 900px) {
    .grid { grid-template-columns: 1fr 1fr; }
}

@media (max-width: 600px) {
    .grid { grid-template-columns: 1fr; }
    .form-grid { grid-template-columns: 1fr; }
}
</style>
</head>

<body>

<div class="page">

    <div class="topbar">
        <div class="brand"><span>Admin</span> Room Types</div>
    </div>

    <!-- FORM -->
    <div class="form-card">
        <h3>Add Room Type</h3>

        <form method="post" action="${pageContext.request.contextPath}/roomtype">
            <div class="form-grid">
                <input name="name" placeholder="Room type name" required>
                <input name="price" placeholder="Price" required>
                <input name="capacity" placeholder="Capacity" required>
                <input name="description" placeholder="Description">
            </div>

            <div class="btn-group">
                <button type="submit" class="add-btn">Add</button>

                <!-- BACK FIXED -->
                <a href="${pageContext.request.contextPath}/admin/room"
               class="btn btn-secondary">
                Quay lại
            </a>
            </div>
        </form>
    </div>

    <!-- LIST -->
    <div class="section-title">All Room Types</div>

    <div class="grid">
        <c:forEach var="t" items="${types}">
            <div class="card">

                <h4>${t.name}</h4>

                <div class="price">
                    ${t.basePrice} VND
                </div>

                <div class="meta">
                    Capacity: ${t.maxCapacity} people
                </div>

                <div class="meta">
                    ${t.description}
                </div>

                <a href="${pageContext.request.contextPath}/roomtype?action=delete&id=${t.id}"
                   onclick="return confirm('Delete this type?')"
                   class="delete-btn">
                    Delete
                </a>

            </div>
        </c:forEach>
    </div>

    <div class="footer">© 2026 LakeSide Hotel</div>

</div>

</body>
</html>
