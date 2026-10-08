package com.eventsphere.util;

import jakarta.servlet.ServletContext;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import javax.sql.DataSource;

public class DatabaseUtil {
    private DatabaseUtil() {}

    public static DataSource getDataSource(ServletContext context) {
        String url = context.getInitParameter("dbUrl");
        String user = context.getInitParameter("dbUser");
        String password = context.getInitParameter("dbPassword");
        
        if (url != null && user != null && password != null) {
            return new SimpleDataSource(url, user, password);
        }
        
        // Default fallback
        return new SimpleDataSource(
            "jdbc:mysql://localhost:3306/eventsphere?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
            "root",
            "piyush"
        );
    }

    public static Connection getConnection(ServletContext context) throws SQLException {
        return getDataSource(context).getConnection();
    }

    public static void closeDataSource() {}

    static class SimpleDataSource implements DataSource {
        private final String url;
        private final String user;
        private final String password;

        SimpleDataSource(String url, String user, String password) {
            this.url = url;
            this.user = user;
            this.password = password;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                throw new RuntimeException("MySQL JDBC Driver not found", e);
            }
        }

        @Override
        public Connection getConnection() throws SQLException {
            return DriverManager.getConnection(url, user, password);
        }

        @Override
        public Connection getConnection(String username, String password) throws SQLException {
            return DriverManager.getConnection(url, username, password);
        }

        @Override
        public <T> T unwrap(Class<T> iface) throws java.sql.SQLException { return null; }

        @Override
        public boolean isWrapperFor(Class<?> iface) throws java.sql.SQLException { return false; }

        @Override
        public java.io.PrintWriter getLogWriter() throws java.sql.SQLException { return null; }

        @Override
        public void setLogWriter(java.io.PrintWriter out) throws java.sql.SQLException {}

        @Override
        public void setLoginTimeout(int seconds) throws java.sql.SQLException {}

        @Override
        public int getLoginTimeout() throws java.sql.SQLException { return 0; }

        @Override
        public java.util.logging.Logger getParentLogger() { return null; }
    }
}
