package com.mycompany.ltw.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class BookingRoom implements Serializable{
    private Long id;
    private Long bookingId;
    private Long roomId;
    private BigDecimal priceAtBooking;
    private int numAdults;
    private int numChildren;

    public BookingRoom() {}

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getBookingId() { return bookingId; }
    public void setBookingId(Long bookingId) { this.bookingId = bookingId; }
    public Long getRoomId() { return roomId; }
    public void setRoomId(Long roomId) { this.roomId = roomId; }
    public BigDecimal getPriceAtBooking() { return priceAtBooking; }
    public void setPriceAtBooking(BigDecimal priceAtBooking) { this.priceAtBooking = priceAtBooking; }
    public int getNumAdults() { return numAdults; }
    public void setNumAdults(int numAdults) { this.numAdults = numAdults; }
    public int getNumChildren() { return numChildren; }
    public void setNumChildren(int numChildren) { this.numChildren = numChildren; }
}