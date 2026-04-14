package com.mycompany.ltw.utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {
    
    private final String serverName = "localhost";
    private final String dbName = "LTW";
    private final String portNumber = "3306";
    private final String userID = "root";
    private final String password = "123456"; // Thay pass vào đây

    public Connection getConnection() throws Exception {
        String url = "jdbc:mysql://" + serverName + ":" + portNumber + "/" + dbName;
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(url, userID, password);
    }

    // Test kết nối
    public static void main(String[] args) {
        try {
            System.out.println(new DBContext().getConnection());
            System.out.println("Kết nối thành công!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
