package com.mycompany.ltw.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class RoomType implements Serializable{
    private Long id;
    private String name;
    private BigDecimal basePrice;
    private int maxCapacity;
    private String description;

    public RoomType() {}

    public RoomType(Long id, String name, BigDecimal basePrice, int maxCapacity, String description) {
        this.id = id;
        this.name = name;
        this.basePrice = basePrice;
        this.maxCapacity = maxCapacity;
        this.description = description;
    }

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
