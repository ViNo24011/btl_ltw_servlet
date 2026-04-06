<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Register - lakeSide Hotel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
            :root {
        --main-color: #a64d79;
        --hover-color: #8e3a64;
    }

    body {
        background-color: #ffffff;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .navbar-brand {
        color: var(--main-color) !important;
        font-weight: bold;
        font-size: 1.5rem;
    }

    .btn-custom {
        background-color: var(--main-color);
        color: white;
        border: none;
        padding: 8px 20px;
    }

    .btn-custom:hover {
        background-color: var(--hover-color);
        color: white;
    }

    footer {
        background-color: #212529;
        color: white;
        padding: 20px 0;
        position: fixed;
        bottom: 0;
        width: 100%;
    }

    .form-container {
        margin-top: 80px;
        max-width: 500px;
    }
    </style>
    </head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
        <div class="container">
            <a class="navbar-brand" href="index">lakeSide Hotel</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link" href="rooms">Browse all rooms</a></li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item"><a class="nav-link" href="find-booking">Find my booking</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">Account</a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="login">Login</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container d-flex justify-content-center">
        <div class="form-container w-100">
            <h2 class="mb-4">Register</h2>
            
            <%-- Hiển thị lỗi nếu có --%>
            <p class="text-danger">${error}</p>

            <form action="register" method="post">
                <div class="row mb-3">
                    <label class="col-sm-3 col-form-label">First Name</label>
                    <div class="col-sm-9">
                        <input type="text" name="firstName" class="form-control" required>
                    </div>
                </div>
                <div class="row mb-3">
                    <label class="col-sm-3 col-form-label">Last Name</label>
                    <div class="col-sm-9">
                        <input type="text" name="lastName" class="form-control" required>
                    </div>
                </div>
                <div class="row mb-3">
                    <label class="col-sm-3 col-form-label">Email</label>
                    <div class="col-sm-9">
                        <input type="email" name="email" class="form-control" required>
                    </div>
                </div>
                <div class="row mb-3">
                    <label class="col-sm-3 col-form-label">Password</label>
                    <div class="col-sm-9">
                        <input type="password" name="password" class="form-control" required>
                    </div>
                </div>
                
                <div class="d-flex align-items-center">
                    <button type="submit" class="btn btn-custom me-3">Register</button>
                    <span>Already have an account? <a href="login" style="color: blue; text-decoration: underline;">Login</a></span>
                </div>
            </form>
        </div>
    </div>

    <footer class="text-center">
        <p class="mb-0">© 2026 lakeSide Hotel</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>