package com.mycompany.ltw.model;

import java.sql.Timestamp;
import java.util.List;

public class User {
    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private boolean isActive;
    private Timestamp createdAt; // Thêm để check khách hàng lâu năm
    private List<Role> roles;    // Chứa danh sách quyền (ROLE_USER, ROLE_ADMIN)

    public User() {}

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public boolean isIsActive() { return isActive; }
    public void setIsActive(boolean isActive) { this.isActive = isActive; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public List<Role> getRoles() { return roles; }
    public void setRoles(List<Role> roles) { this.roles = roles; }
}