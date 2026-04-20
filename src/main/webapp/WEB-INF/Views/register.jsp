<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | LakeSide Hotel</title>
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
            --bg-grad: radial-gradient(circle at 10% 10%, #fce7f3 0, transparent 30%),
                radial-gradient(circle at 90% 18%, #e0f2fe 0, transparent 30%),
                linear-gradient(145deg, #f9fafb 0%, #fdf2f8 55%, #f8fafc 100%);
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
            width: min(1080px, 92%);
            margin: 28px auto;
            display: grid;
            grid-template-columns: 1fr 1fr;
            border: 1px solid var(--border);
            border-radius: 24px;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.96);
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.12);
            animation: lift 0.55s ease-out;
        }

        .promo {
            padding: 44px 40px;
            background: linear-gradient(165deg, #111827, #374151 56%, #4b5563);
            color: #f9fafb;
        }

        .promo h1 {
            margin: 0 0 14px;
            font-family: "Sora", sans-serif;
            font-size: clamp(1.55rem, 2.8vw, 2.2rem);
            line-height: 1.2;
        }

        .promo p {
            margin: 0;
            line-height: 1.7;
            color: #e5e7eb;
        }

        .promo .facts {
            margin-top: 26px;
            display: grid;
            gap: 10px;
        }

        .chip {
            padding: 10px 12px;
            border-radius: 11px;
            background: rgba(255, 255, 255, 0.14);
            font-size: 0.9rem;
            border: 1px solid rgba(255, 255, 255, 0.32);
        }

        .form-wrap {
            padding: 38px 34px 34px;
            background: var(--panel);
        }

        .brand {
            font-family: "Sora", sans-serif;
            font-size: 1.15rem;
            color: var(--accent);
            margin-bottom: 16px;
        }

        .title {
            margin: 0 0 8px;
            font-family: "Sora", sans-serif;
            font-size: 1.65rem;
        }

        .sub {
            margin: 0 0 20px;
            color: var(--muted);
            font-size: 0.95rem;
        }

        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .field {
            margin-bottom: 12px;
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
            margin-top: 15px;
            text-align: center;
            color: #475569;
            font-size: 0.92rem;
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

        @keyframes lift {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 920px) {
            .shell {
                grid-template-columns: 1fr;
                margin: 20px auto;
            }
            .promo, .form-wrap {
                padding: 28px 22px;
            }
            .grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <main class="shell">
        <section class="promo">
            <h1>Create your account in one step</h1>
            <p>Join LakeSide Hotel and unlock quick bookings, easier profile management, and smoother check-in planning.</p>
            <div class="facts">
                <div class="chip">Personal dashboard for your reservations</div>
                <div class="chip">Get updates and manage bookings faster</div>
                <div class="chip">Secure account access from any device</div>
            </div>
        </section>

        <section class="form-wrap">
            <div class="brand">LakeSide Hotel</div>
            <h2 class="title">Create account</h2>
            <p class="sub">Fill your details to start booking rooms.</p>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null && !error.trim().isEmpty()) {
            %>
            <p class="msg error"><%= error %></p>
            <%
                }
            %>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="grid">
                    <div class="field">
                        <label for="firstName">First name</label>
                        <input id="firstName" type="text" name="firstName" required autocomplete="given-name">
                    </div>
                    <div class="field">
                        <label for="lastName">Last name</label>
                        <input id="lastName" type="text" name="lastName" required autocomplete="family-name">
                    </div>
                </div>
                <div class="field">
                    <label for="email">Email</label>
                    <input id="email" type="email" name="email" required autocomplete="email">
                </div>
                <div class="field">
                    <label for="password">Password</label>
                    <input id="password" type="password" name="password" required autocomplete="new-password">
                </div>

                <button class="btn" type="submit">Create Account</button>
            </form>

            <p class="note">
                Already have an account?
                <a href="${pageContext.request.contextPath}/login">Log in now</a>
            </p>
        </section>
    </main>
</body>
</html>
