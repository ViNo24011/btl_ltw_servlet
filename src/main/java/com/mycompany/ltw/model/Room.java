package com.mycompany.ltw.model;

public class Room {
    private Long id;

    // ✔ giữ lại để insert/update DB
    private Long roomTypeId;

    private String roomNumber;
    private String photo;
    private String status;

    // 🔥 thêm để JOIN + hiển thị
    private RoomType roomType;

    public Room() {}

    // ===== Getter / Setter =====

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getRoomTypeId() { return roomTypeId; }
    public void setRoomTypeId(Long roomTypeId) { this.roomTypeId = roomTypeId; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // 🔥 phần mới
    public RoomType getRoomType() { return roomType; }
    public void setRoomType(RoomType roomType) { this.roomType = roomType; }
}
