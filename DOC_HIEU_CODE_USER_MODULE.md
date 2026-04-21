# Tài Liệu Đọc Hiểu Code User Module (Input/Output + Mục đích)

## 1) Mục tiêu tài liệu
Tài liệu này giúp đọc nhanh module User theo góc nhìn:
- File này dùng để làm gì?
- Input lấy từ đâu?
- Output trả về đâu?
- Dữ liệu lưu/đọc từ bảng nào trong database?

---

## 2) Tổng quan luồng dữ liệu
Luồng chung của module:
1. Trình duyệt gọi URL (ví dụ `/profile`, `/admin/users`).
2. `UserServlet` nhận request, phân nhánh theo `getServletPath()`.
3. `UserServlet` gọi `UserDAO` để truy vấn/cập nhật DB.
4. `UserServlet` đưa dữ liệu sang JSP bằng `request.setAttribute(...)`.
5. JSP hiển thị dữ liệu bằng `${...}`.

---

## 3) File: `UserServlet.java`
Đường dẫn: `src/main/java/com/mycompany/ltw/controller/UserServlet.java`

### 3.1 Mục đích
- Điều phối toàn bộ chức năng User/Profile/Voucher/Admin User CRUD.
- Là lớp trung gian giữa giao diện JSP và `UserDAO`.

### 3.2 URL mà servlet xử lý
- `/profile`
- `/profile/edit`
- `/vouchers`
- `/admin/users`
- `/admin/users/create`
- `/admin/users/edit`
- `/admin/users/delete`

### 3.3 Input chính
- Từ URL path: `request.getServletPath()`
- Từ form:
  - `firstName`, `lastName`, `email`, `password`, `roleName`, `isActive`, `id`
- Từ session:
  - `session.getAttribute("user")`

### 3.4 Output chính
- Forward đến JSP:
  - `profile.jsp`, `voucher.jsp`, `user.jsp`, `user-form.jsp`
- Hoặc redirect URL:
  - `/profile?success=updated`, `/admin/users?success=...`, `/login`, `/home`

### 3.5 Biến đẩy sang JSP (output dữ liệu hiển thị)
- `profileUser`, `totalBookings`, `customerGroup`, `editMode`, `error`
- `vouchers`, `newVoucherMessage`
- `users`
- `formUser`, `currentRole`

### 3.6 Các hàm quan trọng
- `showProfile(...)`: đọc hồ sơ + tổng booking + nhóm khách hàng.
- `updateProfile(...)`: cập nhật họ tên/email user hiện tại.
- `showVouchers(...)`: lấy voucher phù hợp + thông báo voucher mới.
- `showUsersForAdmin(...)`: lấy danh sách user cho admin.
- `createUserByAdmin(...)`: thêm user mới.
- `updateUserByAdmin(...)`: sửa user + role.
- `deleteUserByAdmin(...)`: xóa user (không cho xóa chính mình).

---

## 4) File: `UserDAO.java`
Đường dẫn: `src/main/java/com/mycompany/ltw/dao/UserDAO.java`

### 4.1 Mục đích
- Chứa toàn bộ SQL cho module User.
- Thực hiện đọc/ghi database qua JDBC.

### 4.2 Input của DAO
- Tham số hàm từ servlet (email, id, user object, roleName...).
- Kết nối DB từ `DBContext.getConnection()`.

### 4.3 Output của DAO
- Trả object `User`, `List<User>`, `List<Voucher>`, `boolean`, `int`, `long`, `String`.

### 4.4 Các hàm + input/output + ý nghĩa
- `login(email, password)`
  - Input: email, password
  - Output: `User` hoặc `null`
  - Ý nghĩa: đăng nhập user đang active.

- `findById(userId)`
  - Input: `Long userId`
  - Output: `User` hoặc `null`
  - Ý nghĩa: lấy hồ sơ user theo id.

- `getAllUsers()`
  - Input: không
  - Output: `List<User>`
  - Ý nghĩa: dữ liệu bảng user cho admin.

- `register(user)`
  - Input: object `User`
  - Output: `boolean`
  - Ý nghĩa: tạo user mới và gán role mặc định ROLE_USER.

- `updateProfile(user)`
  - Input: object `User` (id, firstName, lastName, email)
  - Output: `boolean`
  - Ý nghĩa: cập nhật hồ sơ cá nhân.

- `createUserByAdmin(user, roleName)`
  - Input: object user + tên role
  - Output: `boolean`
  - Ý nghĩa: admin tạo user + gán role.

- `updateUserByAdmin(user, roleName, newPassword)`
  - Input: thông tin user + role + mật khẩu mới (có thể rỗng)
  - Output: `boolean`
  - Ý nghĩa: admin cập nhật thông tin, trạng thái active, role, mật khẩu.

- `deleteUserByAdmin(userId)`
  - Input: `Long userId`
  - Output: `boolean`
  - Ý nghĩa: xóa role mapping và xóa user.

- `isEmailExists(email, excludeUserId)`
  - Input: email, id loại trừ (có thể null)
  - Output: `boolean`
  - Ý nghĩa: kiểm tra email trùng.

- `countBookingsByUserId(userId)`
  - Input: userId
  - Output: `int`
  - Ý nghĩa: đếm số booking của user.

- `getMembershipDays(userId)`
  - Input: userId
  - Output: `long`
  - Ý nghĩa: số ngày từ ngày đăng ký tới hiện tại.

- `calculateCustomerGroup(userId)`
  - Input: userId
  - Output: `String` (`VIP`, `LONG_TERM`, `ALL`)
  - Ý nghĩa: phân nhóm khách hàng.

- `getAvailableVouchersForUser(userId)`
  - Input: userId
  - Output: `List<Voucher>`
  - Ý nghĩa: lấy voucher còn hạn, còn lượt dùng, đúng nhóm, chưa dùng.

- `getUserRoles(userId)`
  - Input: userId
  - Output: `List<Role>`
  - Ý nghĩa: lấy role của user để phân quyền.

---

## 5) File: `profile.jsp`
Đường dẫn: `src/main/webapp/WEB-INF/Views/profile.jsp`

### 5.1 Mục đích
- Hiển thị hồ sơ người dùng và form sửa hồ sơ.

### 5.2 Input của trang (nhận từ servlet)
- `profileUser`
- `totalBookings`
- `customerGroup`
- `editMode`
- `error`
- `param.success`

### 5.3 Output của trang
- Hiển thị thông tin ra HTML.
- Khi submit form edit -> gửi `POST /profile/edit` với:
  - `firstName`, `lastName`, `email`

---

## 6) File: `user.jsp`
Đường dẫn: `src/main/webapp/WEB-INF/Views/user.jsp`

### 6.1 Mục đích
- Trang danh sách user cho admin.

### 6.2 Input
- `users` (list)
- `param.success`, `param.error`

### 6.3 Output
- Bảng user hiển thị ID, tên, email, role, trạng thái, ngày tạo.
- Nút:
  - Edit -> `GET /admin/users/edit?id=...`
  - Delete -> `POST /admin/users/delete` (gửi hidden `id`)

---

## 7) File: `user-form.jsp`
Đường dẫn: `src/main/webapp/WEB-INF/Views/user-form.jsp`

### 7.1 Mục đích
- Form thêm/sửa user cho admin.

### 7.2 Input
- `formUser` (nếu là màn hình edit)
- `currentRole`
- `error`

### 7.3 Output
- Submit đến:
  - Tạo mới: `POST /admin/users/create`
  - Chỉnh sửa: `POST /admin/users/edit`
- Field gửi lên:
  - `id` (khi edit), `firstName`, `lastName`, `email`, `password`, `roleName`, `isActive`

---

## 8) File: `voucher.jsp`
Đường dẫn: `src/main/webapp/WEB-INF/Views/voucher.jsp`

### 8.1 Mục đích
- Hiển thị danh sách voucher khả dụng của user.

### 8.2 Input
- `customerGroup`
- `newVoucherMessage`
- `vouchers`

### 8.3 Output
- Danh sách voucher (mã, giá trị giảm, nhóm áp dụng, lượt dùng, hạn dùng).

---

## 9) File: `AuthFilter.java`
Đường dẫn: `src/main/java/com/mycompany/ltw/utils/AuthFilter.java`

### 9.1 Mục đích
- Chặn truy cập trái phép.

### 9.2 Input
- URL request hiện tại
- Session `user`

### 9.3 Output
- Nếu chưa login: redirect `/login`
- Nếu vào `/admin/*` mà không phải admin: redirect `/access-denied.jsp`
- Nếu hợp lệ: cho đi tiếp (`chain.doFilter`)

---

## 10) File: `web.xml`
Đường dẫn: `src/main/webapp/WEB-INF/web.xml`

### Mục đích
- Khai báo mapping URL đến `UserServlet`:
  - `/profile`, `/profile/edit`, `/vouchers`, `/admin/users`, `/admin/users/create`, `/admin/users/edit`, `/admin/users/delete`

---

## 11) Input/Output kiểu “thầy hỏi nhanh”

### Câu hỏi: Input lấy từ đâu?
- Từ form: `request.getParameter(...)`
- Từ session: `session.getAttribute("user")`
- Từ URL query/path: `request.getParameter("id")`, `getServletPath()`

### Câu hỏi: Output đẩy đi đâu?
- Sang JSP bằng `request.setAttribute(...)`
- Sang URL khác bằng `response.sendRedirect(...)`
- Sang DB bằng các hàm DAO (`INSERT/UPDATE/DELETE`)

### Câu hỏi: Dòng nào lưu DB?
- Nằm ở `UserDAO` trong các hàm `updateProfile`, `createUserByAdmin`, `updateUserByAdmin`, `deleteUserByAdmin`, `register`.

### Câu hỏi: Dòng nào đọc DB để hiển thị UI?
- Nằm ở `UserDAO` (`findById`, `getAllUsers`, `getAvailableVouchersForUser`, ...),
- rồi `UserServlet` gọi `setAttribute`,
- JSP đọc `${...}` để render.

---

## 12) Gợi ý cách đọc code nhanh trước buổi báo cáo
1. Đọc `UserServlet` trước để nắm luồng tổng.
2. Từ mỗi hàm servlet, nhảy xuống hàm DAO tương ứng để xem SQL.
3. Quay lại JSP để xem biến nào được render ra giao diện.
4. Thuộc 4 điểm cốt lõi:
   - Input lấy ở đâu
   - SQL chạy ở đâu
   - Output hiển thị ở đâu
   - Điều kiện phân quyền ở đâu