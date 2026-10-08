package com.eventsphere.dao;

import com.eventsphere.model.Event;
import com.eventsphere.util.DatabaseUtil;
import jakarta.servlet.ServletContext;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class EventDAO {
    private final ServletContext context;

    public EventDAO(ServletContext context) {
        this.context = context;
    }

    private Connection getConnection() throws SQLException {
        return DatabaseUtil.getConnection(context);
    }

    private Event mapResultSet(ResultSet rs) throws SQLException {
        Event event = new Event();
        event.setId(rs.getLong("id"));
        event.setOrganizerId(rs.getLong("organizer_id"));
        event.setTitle(rs.getString("title"));
        event.setDescription(rs.getString("description"));
        event.setEventDate(rs.getDate("event_date") != null ? rs.getDate("event_date").toLocalDate() : null);
        event.setEventTime(rs.getTime("event_time") != null ? rs.getTime("event_time").toLocalTime() : null);
        event.setVenue(rs.getString("venue"));
        event.setCapacity(rs.getInt("capacity"));
        event.setStatus(Event.Status.valueOf(rs.getString("status")));
        event.setRejectionReason(rs.getString("rejection_reason"));
        long approvedById = rs.getLong("approved_by");
        if (!rs.wasNull()) {
            event.setApprovedBy(approvedById);
        }
        event.setApprovedAt(rs.getTimestamp("approved_at") != null ? rs.getTimestamp("approved_at").toLocalDateTime() : null);
        event.setCreatedAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        event.setUpdatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null);

        // Transient fields
        if (rs.findColumn("organizer_name") > 0) {
            event.setOrganizerName(rs.getString("organizer_name"));
        }
        if (rs.findColumn("available_tickets") > 0) {
            event.setAvailableTickets(rs.getInt("available_tickets"));
        }
        if (rs.findColumn("sold_tickets") > 0) {
            event.setSoldTickets(rs.getInt("sold_tickets"));
        }
        return event;
    }

    public Optional<Event> findById(Long id) {
        String sql = "SELECT e.*, u.full_name as organizer_name, " +
                "(SELECT COALESCE(SUM(tt.quantity - tt.sold_count), 0) FROM ticket_types tt WHERE tt.event_id = e.id) as available_tickets, " +
                "(SELECT COALESCE(SUM(tt.sold_count), 0) FROM ticket_types tt WHERE tt.event_id = e.id) as sold_tickets " +
                "FROM events e LEFT JOIN users u ON e.organizer_id = u.id WHERE e.id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding event by id", e);
        }
        return Optional.empty();
    }

    public List<Event> findByOrganizer(Long organizerId) {
        String sql = "SELECT e.*, u.full_name as organizer_name, " +
                "(SELECT COALESCE(SUM(tt.quantity - tt.sold_count), 0) FROM ticket_types tt WHERE tt.event_id = e.id) as available_tickets, " +
                "(SELECT COALESCE(SUM(tt.sold_count), 0) FROM ticket_types tt WHERE tt.event_id = e.id) as sold_tickets " +
                "FROM events e LEFT JOIN users u ON e.organizer_id = u.id WHERE e.organizer_id = ? ORDER BY e.created_at DESC";
        List<Event> events = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, organizerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    events.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding events by organizer", e);
        }
        return events;
    }

    public List<Event> findApprovedEvents() {
        String sql = "SELECT e.*, u.full_name as organizer_name, " +
                "(SELECT COALESCE(SUM(tt.quantity - tt.sold_count), 0) FROM ticket_types tt WHERE tt.event_id = e.id) as available_tickets, " +
                "(SELECT COALESCE(SUM(tt.sold_count), 0) FROM ticket_types tt WHERE tt.event_id = e.id) as sold_tickets " +
                "FROM events e LEFT JOIN users u ON e.organizer_id = u.id " +
                "WHERE e.status = 'APPROVED' AND e.event_date >= CURDATE() ORDER BY e.event_date ASC, e.event_time ASC";
        List<Event> events = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                events.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding approved events", e);
        }
        return events;
    }

    public List<Event> findPendingApproval() {
        String sql = "SELECT e.*, u.full_name as organizer_name, " +
                "(SELECT COALESCE(SUM(tt.quantity - tt.sold_count), 0) FROM ticket_types tt WHERE tt.event_id = e.id) as available_tickets, " +
                "(SELECT COALESCE(SUM(tt.sold_count), 0) FROM ticket_types tt WHERE tt.event_id = e.id) as sold_tickets " +
                "FROM events e LEFT JOIN users u ON e.organizer_id = u.id " +
                "WHERE e.status = 'PENDING_APPROVAL' ORDER BY e.created_at ASC";
        List<Event> events = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                events.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding pending events", e);
        }
        return events;
    }

    public List<Event> findAll() {
        String sql = "SELECT e.*, u.full_name as organizer_name, " +
                "(SELECT COALESCE(SUM(tt.quantity - tt.sold_count), 0) FROM ticket_types tt WHERE tt.event_id = e.id) as available_tickets, " +
                "(SELECT COALESCE(SUM(tt.sold_count), 0) FROM ticket_types tt WHERE tt.event_id = e.id) as sold_tickets " +
                "FROM events e LEFT JOIN users u ON e.organizer_id = u.id ORDER BY e.created_at DESC";
        List<Event> events = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                events.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding all events", e);
        }
        return events;
    }

    public List<Event> searchEvents(String keyword, LocalDate dateFrom, LocalDate dateTo) {
        StringBuilder sql = new StringBuilder("SELECT e.*, u.full_name as organizer_name, " +
                "(SELECT COALESCE(SUM(tt.quantity - tt.sold_count), 0) FROM ticket_types tt WHERE tt.event_id = e.id) as available_tickets, " +
                "(SELECT COALESCE(SUM(tt.sold_count), 0) FROM ticket_types tt WHERE tt.event_id = e.id) as sold_tickets " +
                "FROM events e LEFT JOIN users u ON e.organizer_id = u.id WHERE e.status = 'APPROVED'");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (e.title LIKE ? OR e.description LIKE ? OR e.venue LIKE ?)");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (dateFrom != null) {
            sql.append(" AND e.event_date >= ?");
            params.add(dateFrom);
        }
        if (dateTo != null) {
            sql.append(" AND e.event_date <= ?");
            params.add(dateTo);
        }
        sql.append(" ORDER BY e.event_date ASC, e.event_time ASC");

        List<Event> events = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    events.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error searching events", e);
        }
        return events;
    }

    public Event save(Event event) {
        String sql = "INSERT INTO events (organizer_id, title, description, event_date, event_time, venue, capacity, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, event.getOrganizerId());
            stmt.setString(2, event.getTitle());
            stmt.setString(3, event.getDescription());
            stmt.setDate(4, Date.valueOf(event.getEventDate()));
            stmt.setTime(5, Time.valueOf(event.getEventTime()));
            stmt.setString(6, event.getVenue());
            stmt.setInt(7, event.getCapacity());
            stmt.setString(8, event.getStatus() != null ? event.getStatus().name() : Event.Status.DRAFT.name());
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    event.setId(rs.getLong(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error saving event", e);
        }
        return event;
    }

    public Event update(Event event) {
        String sql = "UPDATE events SET title = ?, description = ?, event_date = ?, event_time = ?, venue = ?, capacity = ?, status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, event.getTitle());
            stmt.setString(2, event.getDescription());
            stmt.setDate(3, Date.valueOf(event.getEventDate()));
            stmt.setTime(4, Time.valueOf(event.getEventTime()));
            stmt.setString(5, event.getVenue());
            stmt.setInt(6, event.getCapacity());
            stmt.setString(7, event.getStatus() != null ? event.getStatus().name() : Event.Status.DRAFT.name());
            stmt.setLong(8, event.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating event", e);
        }
        return event;
    }

    public boolean approve(Long eventId, Long adminId) {
        String sql = "UPDATE events SET status = 'APPROVED', approved_by = ?, approved_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = ? AND status = 'PENDING_APPROVAL'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, adminId);
            stmt.setLong(2, eventId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error approving event", e);
        }
    }

    public boolean reject(Long eventId, Long adminId, String reason) {
        String sql = "UPDATE events SET status = 'REJECTED', approved_by = ?, approved_at = CURRENT_TIMESTAMP, rejection_reason = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ? AND status = 'PENDING_APPROVAL'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, adminId);
            stmt.setString(2, reason);
            stmt.setLong(3, eventId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error rejecting event", e);
        }
    }

    public boolean cancel(Long eventId) {
        String sql = "UPDATE events SET status = 'CANCELLED', updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, eventId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error cancelling event", e);
        }
    }

    public boolean delete(Long id) {
        String sql = "DELETE FROM events WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting event", e);
        }
    }

    public long countByStatus(Event.Status status) {
        String sql = "SELECT COUNT(*) FROM events WHERE status = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getLong(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting events by status", e);
        }
        return 0;
    }

    public long countTotal() {
        String sql = "SELECT COUNT(*) FROM events";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (SQLException e) {
            throw new RuntimeException("Error counting total events", e);
        }
        return 0;
    }

    public long countByOrganizer(Long organizerId) {
        String sql = "SELECT COUNT(*) FROM events WHERE organizer_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, organizerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getLong(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting events by organizer", e);
        }
        return 0;
    }
}
