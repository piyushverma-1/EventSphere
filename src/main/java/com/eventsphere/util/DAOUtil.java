package com.eventsphere.util;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

public class DAOUtil {

    private DAOUtil() {}

    /**
     * Safely checks whether a result set contains a specific column name or label without
     * throwing a SQLException when the column is absent.
     */
    public static boolean hasColumn(ResultSet rs, String columnName) {
        if (rs == null || columnName == null || columnName.trim().isEmpty()) {
            return false;
        }
        try {
            ResultSetMetaData metaData = rs.getMetaData();
            int columns = metaData.getColumnCount();
            for (int i = 1; i <= columns; i++) {
                String label = metaData.getColumnLabel(i);
                String name = metaData.getColumnName(i);
                if (columnName.equalsIgnoreCase(label) || columnName.equalsIgnoreCase(name)) {
                    return true;
                }
            }
            return false;
        } catch (SQLException e) {
            return false;
        }
    }
}
