<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | LakeSide Hotel</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;700;800&family=Sora:wght@600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --ink: #1f2937;
            --muted: #6b7280;
            --panel: #ffffff;
            --border: #e5e7eb;
            --accent: #a64d79;
            --accent-strong: #8e3a64;
            --bg-grad: radial-gradient(circle at 12% 12%, #fce7f3 0, transparent 30%),
                radial-gradient(circle at 88% 16%, #e0f2fe 0, transparent 30%),
                linear-gradient(140deg, #f8fafc 0%, #fdf2f8 55%, #f9fafb 100%);
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: "Plus Jakarta Sans", sans-serif;
            color: var(--ink);
            background: var(--bg-grad);
        }

        .shell {
            width: min(1040px, 92%);
            margin: 32px auto;
            display: grid;
            grid-template-columns: 1.05fr 0.95fr;
            border: 1px solid var(--border);
            border-radius: 24px;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.96);
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.12);
            animation: rise 0.55s ease-out;
        }

        .promo {
            padding: 48px 42px;
            background: linear-gradient(160deg, #111827, #374151 55%, #4b5563);
            color: #f9fafb;
        }

        .promo h1 {
            margin: 0 0 14px;
            font-family: "Sora", sans-serif;
            font-size: clamp(1.6rem, 2.8vw, 2.2rem);
            line-height: 1.2;
        }

        .promo p {
            margin: 0;
            color: #e5e7eb;
            line-height: 1.7;
        }

        .promo ul {
            margin: 26px 0 0;
            padding-left: 20px;
            display: grid;
            gap: 8px;
            color: #f3f4f6;
        }

        .form-wrap {
            padding: 42px 36px 36px;
            background: var(--panel);
        }

        .brand {
            font-family: "Sora", sans-serif;
            letter-spacing: 0.3px;
            font-size: 1.15rem;
            color: var(--accent);
            margin-bottom: 18px;
        }

        .title {
            margin: 0 0 8px;
            font-size: 1.7rem;
            font-family: "Sora", sans-serif;
        }

        .sub {
            margin: 0 0 24px;
            color: var(--muted);
            font-size: 0.95rem;
        }

        .field {
            margin-bottom: 14px;
        }

        .field label {
            display: block;
            margin-bottom: 6px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .field input {
            width: 100%;
            padding: 12px 13px;
            border: 1px solid #d1d5db;
            border-radius: 12px;
            font: inherit;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .field input:focus {
            outline: none;
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(166, 77, 121, 0.18);
        }

        .btn {
            margin-top: 8px;
            width: 100%;
            border: none;
            border-radius: 12px;
            padding: 13px;
            font: inherit;
            font-weight: 700;
            color: #fff;
            background: linear-gradient(120deg, var(--accent), #8e3a64);
            cursor: pointer;
            transition: transform 0.15s ease, filter 0.2s ease;
        }

        .btn:hover {
            filter: brightness(0.95);
            transform: translateY(-1px);
        }

        .note {
            margin-top: 16px;
            color: #475569;
            font-size: 0.92rem;
            text-align: center;
        }

        .note a {
            color: var(--accent-strong);
            font-weight: 700;
            text-decoration: none;
        }

        .msg {
            margin: 0 0 12px;
            border-radius: 10px;
            padding: 10px 12px;
            font-size: 0.88rem;
        }

        .msg.error {
            background: #fff1f2;
            color: #be123c;
            border: 1px solid #fecdd3;
        }

        .msg.success {
            background: #ecfdf5;
            color: #047857;
            border: 1px solid #a7f3d0;
        }

        @keyframes rise {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 880px) {
            .shell {
                grid-template-columns: 1fr;
                margin: 20px auto;
            }
            .promo, .form-wrap {
                padding: 28px 22px;
            }
        }
    </style>
</head>
<body>
    <main class="shell">
        <section class="promo">
            <h1>Welcome back to LakeSide Hotel</h1>
            <p>Book smarter, manage your stays quickly, and keep every reservation in one secure place.</p>
            <ul>
                <li>Fast room search with clear pricing</li>
                <li>Simple profile and booking management</li>
                <li>Secure sign-in for your account</li>
            </ul>
        </section>

        <section class="form-wrap">
            <div class="brand">LakeSide Hotel</div>
            <h2 class="title">Sign in</h2>
            <p class="sub">Enter your account details to continue.</p>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null && !error.trim().isEmpty()) {
            %>
            <p class="msg error"><%= error %></p>
            <%
                }
                String message = request.getParameter("message");
                if ("success".equals(message)) {
            %>
            <p class="msg success">Registration successful. Please log in.</p>
            <%
                }
            %>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="field">
                    <label for="email">Email</label>
                    <input id="email" type="email" name="email" required autocomplete="email">
                </div>
                <div class="field">
                    <label for="password">Password</label>
                    <input id="password" type="password" name="password" required autocomplete="current-password">
                </div>
                <button class="btn" type="submit">Log In</button>
            </form>

            <p class="note">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/register">Create one</a>
            </p>
        </section>
    </main>
</body>
</html>
