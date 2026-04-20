# LakeSide Hotel - URL Mapping & Application Flow Test Guide

## 📋 Registered URL Mappings

### Public URLs (No Login Required)
| URL | Servlet | Action | View | Status |
|-----|---------|--------|------|--------|
| `/home` | HomeServlet | GET | index.jsp | ✅ Fixed |
| `/login` | LoginServlet | GET | login.jsp | ✅ Fixed |
| `/login` | LoginServlet | POST | (auto redirect) | ✅ Fixed |
| `/register` | RegisterServlet | GET | register.jsp | ✅ Fixed |
| `/register` | RegisterServlet | POST | (auto redirect) | ✅ Fixed |
| `/logout` | LogoutServlet | GET | (redirect /login) | ✅ Fixed |

### Room URLs (List & Detail)
| URL | Servlet | Action | View | Status |
|-----|---------|--------|------|--------|
| `/room` | RoomServlet | GET (default=list) | room.jsp | ✅ Working |
| `/room?page=N` | RoomServlet | GET (list with pagination) | room.jsp | ✅ Working |
| `/room?action=detail&id=X` | RoomServlet | GET (view detail) | room-detail.jsp | ✅ Fixed |
| `/room?action=new` | RoomServlet | GET (create form) | room-form.jsp | ⚠️ Admin Only |
| `/room?action=edit&id=X` | RoomServlet | POST (update) | - | ⚠️ Admin Only |
| `/admin/room` | RoomServlet | GET (admin list) | room.jsp | ⚠️ Admin Only |

### User & Profile URLs
| URL | Servlet | Action | View | Status |
|-----|---------|--------|------|--------|
| `/profile` | UserServlet | GET | profile.jsp | ✅ Working |
| `/profile/edit` | UserServlet | GET | profile.jsp (edit mode) | ✅ Working |
| `/profile/edit` | UserServlet | POST (update) | - | ✅ Working |
| `/vouchers` | UserServlet | GET | voucher.jsp | ✅ Working |
| `/admin/users` | UserServlet | GET | user.jsp | ⚠️ Admin Only |
| `/admin/users/create` | UserServlet | GET | user-form.jsp | ⚠️ Admin Only |
| `/admin/users/create` | UserServlet | POST | - | ⚠️ Admin Only |
| `/admin/users/edit` | UserServlet | GET | user-form.jsp | ⚠️ Admin Only |
| `/admin/users/edit` | UserServlet | POST (update) | - | ⚠️ Admin Only |
| `/admin/users/delete` | UserServlet | POST | - | ⚠️ Admin Only |

### Room Type Management
| URL | Servlet | Action | View | Status |
|-----|---------|--------|------|--------|
| `/roomtype` | RoomTypeServlet | GET | roomtype.jsp | ⚠️ Admin Only |

---

## 🔄 Application Flow

### 1️⃣ **Anonymous User Flow**
```
localhost:8080/ltw/
    ↓
(No session) redirect to /login
    ↓
LoginServlet.doGet()
    ↓
Show login.jsp with:
  - Email/Password form
  - Link to register
```

### 2️⃣ **User Registration Flow**
```
/login page → Click "Create one"
    ↓
RegisterServlet.doGet() → Show register.jsp
    ↓
Fill: First Name | Last Name | Email | Password
    ↓
Submit POST to /register
    ↓
RegisterServlet.doPost()
    ├─ Insert user to DB
    ├─ Assign ROLE_USER
    ├─ Auto login (call dao.login())
    └─ Redirect to /home with session
```

### 3️⃣ **User Login Flow**
```
/login.jsp → Fill Email + Password
    ↓
LoginServlet.doPost()
    ├─ UserDAO.login(email, pass)
    ├─ Check user.is_active = 1
    ├─ Load user roles
    └─ Success → Create session
         └─ Check role:
            ├─ ROLE_ADMIN → redirect /home (admin view)
            └─ ROLE_USER → redirect /home (user view)
         └─ Failure → Show error + reload login.jsp
```

### 4️⃣ **Home Page Flow (After Login)**
```
/home
    ↓
HomeServlet.doGet()
    ├─ Load allRooms from DB (first 4 shown in preview)
    ├─ Load roomTypes for filter dropdown
    └─ Forward to index.jsp
    ↓
index.jsp displays:
    ├─ Top Nav with user menu:
    │  ├─ "Browse all rooms" → scroll to #rooms section
    │  ├─ "Manage Rooms" (Admin only) → /roomtype
    │  ├─ "Find my booking" → scroll to #bookings section
    │  ├─ "Profile" → /profile
    │  └─ "Logout" → /logout
    │
    ├─ "Browse rooms" section:
    │  └─ Show 4 room cards from DB
    │     └─ Click "View/Book Now" → /room?action=detail&id={id}
    │
    └─ "Find booking" section:
       ├─ Filter dropdown (populated from roomTypes)
       ├─ Room list with pagination
       └─ Each room has "View/Book Now" button
```

### 5️⃣ **Room Detail View**
```
/room?action=detail&id=5
    ↓
RoomServlet.doGet(action=detail)
    ├─ Load Room by ID with RoomType info
    └─ Forward to room-detail.jsp
    ↓
room-detail.jsp shows:
    ├─ Room image
    ├─ Room number
    ├─ Room type (capacity, price, description)
    ├─ Status
    └─ "Book Now" button → /booking?action=create&roomId=5
```

### 6️⃣ **User Profile**
```
Header → "Profile"
    ↓
/profile
    ↓
UserServlet.doGet("/profile")
    ├─ Check user is logged in
    ├─ Load user data + booking stats
    └─ Forward to profile.jsp (view mode)
    ↓
profile.jsp shows:
    ├─ Personal info (read-only initially)
    ├─ Total bookings count
    ├─ Customer group status
    └─ "Edit Profile" button → /profile/edit
    
/profile/edit (Click Edit button)
    ↓
UserServlet.doGet("/profile/edit")
    └─ Forward to profile.jsp (edit mode)
    ↓
profile.jsp shows:
    ├─ Editable form: First name | Last name | Email
    └─ "Save" button → POST /profile/edit
```

### 7️⃣ **Logout Flow**
```
Header → "Logout"
    ↓
/logout
    ↓
LogoutServlet.doGet()
    ├─ Invalidate session
    └─ Redirect /login?message=logged_out
    ↓
login.jsp shows success message
    └─ Can login again
```

### 8️⃣ **Admin Functions (Require ROLE_ADMIN)**

#### Admin Manage Rooms
```
/home → "Manage Rooms" button
    ↓
Check isAdmin? → Yes
    ↓
/roomtype
    ↓
RoomTypeServlet.doGet()
    ├─ Load all room types
    └─ Forward to roomtype.jsp
    ↓
roomtype.jsp shows room type management
```

#### Admin Manage Users
```
/home (admin account logged in)
    ↓
Admin panel link → /admin/users
    ↓
UserServlet.doGet("/admin/users")
    ├─ Check isAdmin? → Yes
    ├─ Load all users
    └─ Forward to user.jsp
    ↓
user.jsp shows:
    ├─ User list table
    ├─ Edit user → /admin/users/edit?id=X
    ├─ Delete user → /admin/users/delete?id=X POST
    └─ Create new user → /admin/users/create
```

---

## ✅ Testing Checklist

### Phase 1: Authentication
- [ ] Can access `/login` without login
- [ ] Can access `/register` without login  
- [ ] Register new account works (data saved to DB)
- [ ] Login with registered account works
- [ ] Session created after login (check cookies)
- [ ] Wrong password shows error message
- [ ] Logout clears session and redirects to login
- [ ] Cannot access admin URLs without ROLE_ADMIN

### Phase 2: Home & Room Browsing
- [ ] Access `/home` shows room list from DB
- [ ] "Browse all rooms" scrolls to room list
- [ ] Room cards display: image, name, price from DB
- [ ] "View/Book Now" button links to detail view
- [ ] Filter dropdown populated with room types
- [ ] Filter works (shows only selected room type)
- [ ] Pagination works (if >9 rooms)
- [ ] "Clear Filter" button resets filter

### Phase 3: Room Detail
- [ ] Click "View/Book Now" shows room detail
- [ ] Detail page shows room info correctly
- [ ] "Book Now" button visible (if user logged in)

### Phase 4: User Profile
- [ ] Click "Profile" shows user info
- [ ] Shows correct personal data
- [ ] Shows total bookings count
- [ ] Click "Edit Profile" enables form
- [ ] Edit form fields: firstName, lastName, email
- [ ] Save changes (POST to /profile/edit)
- [ ] Changes reflected on reload

### Phase 5: Admin Features
- [ ] Login with admin account
- [ ] "Manage Rooms" button visible
- [ ] Click leads to room type management
- [ ] Admin can see all users list
- [ ] Can create new user
- [ ] Can edit user info
- [ ] Can delete user (except self)

---

## 🔧 Database Data Needed

For testing, ensure DB has:

```sql
-- Room Types
INSERT INTO room_type (name, base_price, max_capacity, description) VALUES
('Standard', 100.00, 2, 'Basic room with essential amenities'),
('Deluxe', 150.00, 2, 'Spacious room with premium features'),
('Suite', 200.00, 4, 'Large suite with living area'),
('Family', 300.00, 6, 'Multi-bed room for families');

-- Rooms
INSERT INTO room (room_type_id, room_number, photo, status) VALUES
(1, '101', 'https://images.unsplash.com/...', 'AVAILABLE'),
(1, '102', 'https://images.unsplash.com/...', 'AVAILABLE'),
(2, '201', 'https://images.unsplash.com/...', 'AVAILABLE'),
(3, '301', 'https://images.unsplash.com/...', 'MAINTENANCE');

-- Test User (Admin)
INSERT INTO user (first_name, last_name, email, password, is_active) VALUES
('Admin', 'User', 'admin@hotel.com', 'admin123', 1);
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1); -- ROLE_ADMIN

-- Test User (Regular)
INSERT INTO user (first_name, last_name, email, password, is_active) VALUES
('John', 'Doe', 'john@example.com', 'password123', 1);
INSERT INTO user_roles (user_id, role_id) VALUES (2, 2); -- ROLE_USER
```

---

## 🚀 Next Steps

1. **Build & Deploy:**
   ```powershell
   cd d:\ltw
   mvn clean install -DskipTests
   ```

2. **NetBeans:** Clean and Build → Run (F6)

3. **Test URL:** `http://localhost:8080/ltw/home` or `http://localhost:8080/ltw/`

4. **Report Issues:** Check browser console for JS errors & server logs for 404/500 errors

---

## 📝 Notes

- All URLs require session for user-specific actions
- Admin checks done in each servlet's doGet/doPost
- Failed login redirects to login page with error message
- Images are external URLs from Unsplash (can be stored locally if needed)
- Pagination default: 9 items per page
- Room filtering works on room_type_id

