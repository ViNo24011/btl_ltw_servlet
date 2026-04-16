package com.mycompany.ltw.utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {
    
<<<<<<< Updated upstream
    private static final String serverName = "localhost";
    private static final String dbName = "hotel_booking_db";
    private static final String portNumber = "3306";
    private static final String userID = "root";
    private static final String password = "241105"; // Thay pass vào đây

    public static Connection getConnection() throws Exception {
=======
    private final String serverName = "localhost";
    private final String dbName = "hotel_booking_db";
    private final String portNumber = "3306";
    private final String userID = "root";
    private final String password = "123456789"; // Thay pass vào đây

    public DBContext() {
    }
    
    public Connection getConnection() throws Exception {
>>>>>>> Stashed changes
        String url = "jdbc:mysql://" + serverName + ":" + portNumber + "/" + dbName;
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, userID, password);
    }

    // Test kết nối
    public static void main(String[] args) {
        try {
            System.out.println(getConnection());
            System.out.println("Kết nối thành công!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
