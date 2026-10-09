package com.eventsphere.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import jakarta.servlet.ServletContext;
import java.sql.Connection;
import java.sql.SQLException;
import javax.sql.DataSource;

public class DatabaseUtil {
    private static volatile HikariDataSource dataSource;

    private DatabaseUtil() {}

    public static DataSource getDataSource(ServletContext context) {
        if (dataSource == null || dataSource.isClosed()) {
            synchronized (DatabaseUtil.class) {
                if (dataSource == null || dataSource.isClosed()) {
                    String url = context != null ? context.getInitParameter("dbUrl") : null;
                    String user = context != null ? context.getInitParameter("dbUser") : null;
                    String password = context != null ? context.getInitParameter("dbPassword") : null;

                    if (url == null || url.trim().isEmpty()) {
                        url = "jdbc:mysql://localhost:3306/eventsphere?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
                    }
                    if (user == null || user.trim().isEmpty()) {
                        user = "root";
                    }
                    if (password == null) {
                        password = "piyush";
                    }

                    HikariConfig config = new HikariConfig();
                    config.setDriverClassName("com.mysql.cj.jdbc.Driver");
                    config.setJdbcUrl(url);
                    config.setUsername(user);
                    config.setPassword(password);
                    config.setMaximumPoolSize(10);
                    config.setMinimumIdle(2);
                    config.setIdleTimeout(30000);
                    config.setConnectionTimeout(10000);
                    config.setValidationTimeout(3000);

                    dataSource = new HikariDataSource(config);
                }
            }
        }
        return dataSource;
    }

    public static Connection getConnection(ServletContext context) throws SQLException {
        return getDataSource(context).getConnection();
    }

    public static synchronized void closeDataSource() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            dataSource = null;
        }
    }
}
