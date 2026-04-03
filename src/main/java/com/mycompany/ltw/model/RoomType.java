package com.mycompany.ltw.model;

import java.math.BigDecimal;

public class RoomType {
    private Long id;
    private String name;
    private BigDecimal basePrice;
    private int maxCapacity;
    private String description;

    public RoomType() {}

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }
    public int getMaxCapacity() { return maxCapacity; }
    public void setMaxCapacity(int maxCapacity) { this.maxCapacity = maxCapacity; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}