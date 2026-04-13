package com.mycompany.ltw.model;

public class Room {
    private Long id;
    private Long roomTypeId;
    private String roomNumber;
    private String photo;
    private String status; // AVAILABLE, OCCUPIED, MAINTENANCE...

    public Room() {}

    // Getters and Setters
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
    
    // RoomType object for display purposes
    private RoomType roomType;
    public RoomType getRoomType() { return roomType; }
    public void setRoomType(RoomType roomType) { this.roomType = roomType; }
}