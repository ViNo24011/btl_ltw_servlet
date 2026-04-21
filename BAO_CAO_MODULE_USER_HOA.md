# Báo Cáo Module 5.2 - User Module (Phụ trách: Hòa)

## 1. Phạm vi module

Module này phụ trách các chức năng:
- Quản lý hồ sơ cá nhân
- Xem thông tin cá nhân
- Chỉnh sửa thông tin cá nhân
- Xem danh sách voucher hiện có
- Tính ngày đăng ký và tổng số booking của user
- CRUD tài khoản ở màn hình admin

## 2. Danh sách file liên quan

### 2.1. File chính của module
- `src/main/java/com/mycompany/ltw/controller/UserServlet.java`
- `src/main/java/com/mycompany/ltw/dao/UserDAO.java`
- `src/main/webapp/WEB-INF/Views/profile.jsp`
- `src/main/webapp/WEB-INF/Views/user.jsp`
- `src/main/webapp/WEB-INF/Views/user-form.jsp`
- `src/main/webapp/WEB-INF/Views/voucher.jsp`

### 2.2. File liên quan để module chạy đúng
- `src/main/java/com/mycompany/ltw/utils/AuthFilter.java` (chặn quyền truy cập `/admin/*`, `/profile`)
- `src/main/webapp/WEB-INF/web.xml` (mapping URL đến UserServlet)
- `src/main/java/com/mycompany/ltw/model/User.java`
- `src/main/java/com/mycompany/ltw/model/Voucher.java`
- `src/main/java/com/mycompany/ltw/model/Role.java`
- `src/main/java/com/mycompany/ltw/utils/DBContext.java`
- `src/main/java/com/mycompany/ltw/controller/LoginServlet.java` (set session `user`)

## 3. Bảng dữ liệu module User sử dụng (suy ra từ SQL trong DAO)

- `user`: thông tin tài khoản (`id, first_name, last_name, email, password, is_active, created_at`)
- `role`: danh sách vai trò (`ROLE_ADMIN`, `ROLE_USER`)
- `user_roles`: bảng mapping user - role
- `booking`: đếm số booking theo `user_id`
- `voucher`: thông tin voucher
- `user_voucher_usage`: tracking voucher đã dùng của user

## 4. Mapping URL -> Servlet method -> JSP

- `GET /profile` -> `showProfile(..., false)` -> `profile.jsp`
- `GET /profile/edit` -> `showProfile(..., true)` -> `profile.jsp` (bật form edit)
- `POST /profile/edit` -> `updateProfile()` -> redirect `/profile?success=updated` hoặc quay lại `profile.jsp`
- `GET /vouchers` -> `showVouchers()` -> `voucher.jsp`
- `GET /admin/users` -> `showUsersForAdmin()` -> `user.jsp`
- `GET /admin/users/create` -> `showUserFormForAdmin(..., null)` -> `user-form.jsp`
- `POST /admin/users/create` -> `createUserByAdmin()` -> redirect `admin/users`
- `GET /admin/users/edit?id=...` -> `showUserFormForAdmin(..., id)` -> `user-form.jsp`
- `POST /admin/users/edit` -> `updateUserByAdmin()` -> redirect `admin/users`
- `POST /admin/users/delete` -> `deleteUserByAdmin()` -> redirect `admin/users`

## 5. Luồng dữ liệu cho từng chức năng

### 5.1. Xem hồ sơ cá nhân
1. User mở `/profile`.
2. `UserServlet.showProfile()` lấy `sessionUser` từ session.
3. Gọi DAO:
   - `findById(userId)` lấy thông tin user
   - `countBookingsByUserId(userId)` lấy tổng booking
   - `calculateCustomerGroup(userId)` tính nhóm khách hàng
4. Servlet đẩy dữ liệu vào request:
   - `profileUser`, `totalBookings`, `customerGroup`, `editMode`
5. `profile.jsp` render các biến trên giao diện.

### 5.2. Chỉnh sửa hồ sơ
1. User submit form `POST /profile/edit` (`firstName`, `lastName`, `email`).
2. `updateProfile()` check trùng email bằng `isEmailExists(email, currentUserId)`.
3. Nếu hợp lệ -> `UserDAO.updateProfile(...)` chạy SQL `UPDATE user ... WHERE id=?`.
4. Thành công -> reload user mới, cập nhật lại session `user`, redirect success.

### 5.3. Xem voucher + thông báo voucher mới
1. User mở `/vouchers`.
2. `showVouchers()` gọi:
   - `getAvailableVouchersForUser(userId)`
   - `calculateCustomerGroup(userId)`
3. Logic thông báo voucher mới:
   - So sánh `vouchers.size()` với session `lastVoucherCount`
   - Nếu tăng -> set `newVoucherMessage = "Bạn có voucher mới."`
4. Đẩy `customerGroup`, `vouchers`, `newVoucherMessage` sang `voucher.jsp`.

### 5.4. Admin CRUD user
- Danh sách user: `getAllUsers()` -> render bảng ở `user.jsp`
- Thêm user: form `user-form.jsp` -> `createUserByAdmin()` -> SQL `INSERT user` + `INSERT user_roles`
- Sửa user: `updateUserByAdmin()` -> SQL `UPDATE user` + reset role (`DELETE user_roles`, `INSERT user_roles`)
- Xóa user: `deleteUserByAdmin()` -> SQL `DELETE user_roles` trước, sau đó `DELETE user`

## 6. Trường hiển thị trên giao diện lấy từ đâu

### 6.1. `profile.jsp`
- `${profileUser.firstName}`, `${profileUser.lastName}`, `${profileUser.email}` <- từ `request.setAttribute("profileUser", user)`
- `${totalBookings}` <- từ `request.setAttribute("totalBookings", totalBookings)`
- `${profileUser.createdAt}` <- field `created_at` trong bảng `user`
- `${customerGroup}` <- kết quả `calculateCustomerGroup()`

### 6.2. `user.jsp`
- `${users}` <- `UserDAO.getAllUsers()`
- Mỗi dòng `${u.id}, ${u.firstName}, ${u.lastName}, ${u.email}, ${u.isActive}, ${u.createdAt}`
- Role hiển thị qua `${u.roles}` <- được map bởi `getUserRoles(userId)`

### 6.3. `user-form.jsp`
- `${formUser...}` <- set khi edit (`showUserFormForAdmin`)
- `${currentRole}` <- role hiện tại của user để pre-select combobox

### 6.4. `voucher.jsp`
- `${vouchers}` <- `UserDAO.getAvailableVouchersForUser(userId)`
- `${customerGroup}` <- `calculateCustomerGroup(userId)`
- `${newVoucherMessage}` <- logic session trong `showVouchers()`

## 7. Các đoạn code quan trọng để trả lời khi bị hỏi xoáy

### 7.1. "Đoạn nào lưu dữ liệu vào DB?"
- Cập nhật profile: `UserDAO.updateProfile()` -> SQL `UPDATE user`
- Admin tạo user: `UserDAO.createUserByAdmin()` -> SQL `INSERT user`, `INSERT user_roles`
- Admin sửa user: `UserDAO.updateUserByAdmin()` -> SQL `UPDATE user`, `DELETE/INSERT user_roles`
- Admin xóa user: `UserDAO.deleteUserByAdmin()` -> SQL `DELETE user_roles`, `DELETE user`

### 7.2. "Đoạn nào đọc DB để lên giao diện?"
- Profile: `findById`, `countBookingsByUserId`, `calculateCustomerGroup`
- User list: `getAllUsers` + `getUserRoles`
- Voucher list: `getAvailableVouchersForUser`
- Sau khi đọc xong: Servlet `setAttribute(...)` -> JSP đọc EL `${...}`

### 7.3. "Tại sao bảng có nhiều cột mà giao diện chỉ hiển thị vài cột?"
- DAO query có thể lấy nhiều cột để phục vụ business logic.
- Servlet chỉ `setAttribute` các dữ liệu cần hiển thị.
- JSP chỉ render các trường cần cho UI (ví dụ profile không hiển thị password).

### 7.4. "Dữ liệu từ form vào DB như thế nào?"
- JSP form `name="..."`
- Servlet `request.getParameter("...")`
- Map vào object `User`
- Gọi hàm DAO (PreparedStatement)
- DB commit

## 8. Bảo mật/quyền truy cập

- `AuthFilter` chặn các URL `/admin/*`, `/profile` nếu chưa login.
- Nếu vào `/admin/*` mà không có `ROLE_ADMIN` -> redirect `/access-denied.jsp`.
- Trong `UserServlet` vẫn check lại `isAdmin(...)` trước CRUD admin.

## 9. Checklist đầu ra để báo cáo

- [x] User xem được hồ sơ (`/profile`)
- [x] User chỉnh sửa được thông tin cá nhân (`POST /profile/edit`)
- [x] User xem được voucher hiện có (`/vouchers`) + thông báo voucher mới
- [x] Hệ thống lấy ngày đăng ký (`created_at`) và đếm tổng booking (`COUNT(*) booking`)
- [x] Admin xem được danh sách user (`/admin/users`)
- [x] Admin thêm/sửa/xóa user (`/admin/users/create|edit|delete`)

## 10. Script thuyết trình ngắn (1-2 phút)

"Em phụ trách User Module gồm profile, voucher và admin CRUD user. Luồng chính là: request vào UserServlet, servlet gọi UserDAO truy vấn DB, sau đó setAttribute đẩy sang JSP. Ở profile, em lấy thông tin user theo id, đếm booking, tính nhóm khách hàng dựa trên booking + số ngày thành viên. Ở vouchers, em lọc voucher còn hạn, còn lượt dùng, đúng nhóm khách hàng và chưa sử dụng. Ở admin, em làm CRUD user và mapping role qua bảng user_roles, có check trùng email và chặn xóa chính mình. Quyền được bảo vệ bởi AuthFilter và check ROLE_ADMIN trong servlet." 

## 11. Câu hỏi để tự ôn trước khi báo cáo

1. Tại sao update user cần update cả bảng `user_roles`?
2. Tại sao xóa user phải xóa `user_roles` trước?
3. Customer group được tính bằng điều kiện nào?
4. Voucher mới được phát hiện bằng cách nào?
5. Trên profile, join date lấy từ cột nào trong DB?
6. Tại sao không hiển thị password lên JSP?
7. Nếu email bị trùng thì check ở đâu?
8. Nếu user không có quyền admin mà vào `/admin/users` thì xử lý sao?