package com.eventsphere.dao;

import com.eventsphere.model.TicketType;
import com.eventsphere.util.DatabaseUtil;
import jakarta.servlet.ServletContext;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class TicketTypeDAO {
    private final ServletContext context;

    public TicketTypeDAO(ServletContext context) {
        this.context = context;
    }

    private Connection getConnection() throws SQLException {
        return DatabaseUtil.getConnection(context);
    }

    private TicketType mapResultSet(ResultSet rs) throws SQLException {
        TicketType tt = new TicketType();
        tt.setId(rs.getLong("id"));
        tt.setEventId(rs.getLong("event_id"));
        tt.setName(rs.getString("name"));
        tt.setDescription(rs.getString("description"));
        tt.setPrice(rs.getBigDecimal("price"));
        tt.setQuantity(rs.getInt("quantity"));
        tt.setSoldCount(rs.getInt("sold_count"));
        tt.setSalesStart(rs.getTimestamp("sales_start") != null ? rs.getTimestamp("sales_start").toLocalDateTime() : null);
        tt.setSalesEnd(rs.getTimestamp("sales_end") != null ? rs.getTimestamp("sales_end").toLocalDateTime() : null);
        tt.setCreatedAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        tt.setUpdatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null);

        if (rs.findColumn("event_title") > 0) {
            tt.setEventTitle(rs.getString("event_title"));
        }
        return tt;
    }

    public Optional<TicketType> findById(Long id) {
        String sql = "SELECT tt.*, e.title as event_title FROM ticket_types tt LEFT JOIN events e ON tt.event_id = e.id WHERE tt.id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding ticket type by id", e);
        }
        return Optional.empty();
    }

    public List<TicketType> findByEvent(Long eventId) {
        String sql = "SELECT tt.*, e.title as event_title FROM ticket_types tt LEFT JOIN events e ON tt.event_id = e.id WHERE tt.event_id = ? ORDER BY tt.price ASC";
        List<TicketType> types = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, eventId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    types.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding ticket types by event", e);
        }
        return types;
    }

    public List<TicketType> findAvailableByEvent(Long eventId, LocalDateTime now) {
        String sql = "SELECT tt.*, e.title as event_title FROM ticket_types tt LEFT JOIN events e ON tt.event_id = e.id " +
                "WHERE tt.event_id = ? AND tt.quantity > tt.sold_count " +
                "AND (tt.sales_start IS NULL OR tt.sales_start <= ?) " +
                "AND (tt.sales_end IS NULL OR tt.sales_end >= ?) ORDER BY tt.price ASC";
        List<TicketType> types = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, eventId);
            stmt.setTimestamp(2, Timestamp.valueOf(now));
            stmt.setTimestamp(3, Timestamp.valueOf(now));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    types.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding available ticket types", e);
        }
        return types;
    }

    public TicketType save(TicketType ticketType) {
        String sql = "INSERT INTO ticket_types (event_id, name, description, price, quantity, sold_count, sales_start, sales_end) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, ticketType.getEventId());
            stmt.setString(2, ticketType.getName());
            stmt.setString(3, ticketType.getDescription());
            stmt.setBigDecimal(4, ticketType.getPrice() != null ? ticketType.getPrice() : BigDecimal.ZERO);
            stmt.setInt(5, ticketType.getQuantity() != null ? ticketType.getQuantity() : 0);
            stmt.setInt(6, ticketType.getSoldCount() != null ? ticketType.getSoldCount() : 0);
            stmt.setTimestamp(7, ticketType.getSalesStart() != null ? Timestamp.valueOf(ticketType.getSalesStart()) : null);
            stmt.setTimestamp(8, ticketType.getSalesEnd() != null ? Timestamp.valueOf(ticketType.getSalesEnd()) : null);
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    ticketType.setId(rs.getLong(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error saving ticket type", e);
        }
        return ticketType;
    }

    public TicketType update(TicketType ticketType) {
        String sql = "UPDATE ticket_types SET name = ?, description = ?, price = ?, quantity = ?, sales_start = ?, sales_end = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ticketType.getName());
            stmt.setString(2, ticketType.getDescription());
            stmt.setBigDecimal(3, ticketType.getPrice() != null ? ticketType.getPrice() : BigDecimal.ZERO);
            stmt.setInt(4, ticketType.getQuantity() != null ? ticketType.getQuantity() : 0);
            stmt.setTimestamp(5, ticketType.getSalesStart() != null ? Timestamp.valueOf(ticketType.getSalesStart()) : null);
            stmt.setTimestamp(6, ticketType.getSalesEnd() != null ? Timestamp.valueOf(ticketType.getSalesEnd()) : null);
            stmt.setLong(7, ticketType.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating ticket type", e);
        }
        return ticketType;
    }

    public boolean incrementSoldCount(Long ticketTypeId, int quantity) {
        String sql = "UPDATE ticket_types SET sold_count = sold_count + ?, updated_at = CURRENT_TIMESTAMP WHERE id = ? AND (quantity - sold_count) >= ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantity);
            stmt.setLong(2, ticketTypeId);
            stmt.setInt(3, quantity);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error incrementing sold count", e);
        }
    }

    public boolean decrementSoldCount(Long ticketTypeId, int quantity) {
        String sql = "UPDATE ticket_types SET sold_count = sold_count - ?, updated_at = CURRENT_TIMESTAMP WHERE id = ? AND sold_count >= ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantity);
            stmt.setLong(2, ticketTypeId);
            stmt.setInt(3, quantity);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error decrementing sold count", e);
        }
    }

    public boolean delete(Long id) {
        String sql = "DELETE FROM ticket_types WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting ticket type", e);
        }
    }

    public boolean deleteByEvent(Long eventId) {
        String sql = "DELETE FROM ticket_types WHERE event_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, eventId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting ticket types by event", e);
        }
    }
}
