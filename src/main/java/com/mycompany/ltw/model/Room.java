package com.mycompany.ltw.model;

<<<<<<< Updated upstream
import java.math.BigDecimal;

public class Room {
=======
import java.io.Serializable;

public class Room implements Serializable{
>>>>>>> Stashed changes
    private Long id;

    // ✔ giữ lại để insert/update DB
    private Long roomTypeId;

    private String roomNumber;
    private String photo;
    private String status;

    // 🔥 thêm để JOIN + hiển thị
    private RoomType roomType;
    
    // 🔥 thêm để truy cập giá từ JSP
    private BigDecimal basePrice;

    public Room() {}

<<<<<<< Updated upstream
    // ===== Getter / Setter =====

=======
    public Room(Long id, Long roomTypeId, String roomNumber, String photo, String status) {
        this.id = id;
        this.roomTypeId = roomTypeId;
        this.roomNumber = roomNumber;
        this.photo = photo;
        this.status = status;

    }

    // Getters and Setters
>>>>>>> Stashed changes
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
    
    // Alias cho photo (tên khác để dễ dùng trong JSP)
    public String getImage() { return photo; }
    public void setImage(String image) { this.photo = image; }
    
    // Base price từ room type
    public BigDecimal getBasePrice() { 
        return basePrice != null ? basePrice : (roomType != null ? roomType.getBasePrice() : null); 
    }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }
}
