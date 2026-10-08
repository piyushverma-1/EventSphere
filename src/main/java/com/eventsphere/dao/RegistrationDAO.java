package com.eventsphere.dao;

import com.eventsphere.model.Registration;
import com.eventsphere.util.DatabaseUtil;
import jakarta.servlet.ServletContext;
import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class RegistrationDAO {
    private final ServletContext context;

    public RegistrationDAO(ServletContext context) {
        this.context = context;
    }

    private Connection getConnection() throws SQLException {
        return DatabaseUtil.getConnection(context);
    }

    private Registration mapResultSet(ResultSet rs) throws SQLException {
        Registration reg = new Registration();
        reg.setId(rs.getLong("id"));
        reg.setBookingReference(rs.getString("booking_reference"));
        reg.setAttendeeId(rs.getLong("attendee_id"));
        reg.setEventId(rs.getLong("event_id"));
        reg.setTicketTypeId(rs.getLong("ticket_type_id"));
        reg.setQuantity(rs.getInt("quantity"));
        reg.setTotalPrice(rs.getBigDecimal("total_price"));
        reg.setStatus(Registration.Status.valueOf(rs.getString("status")));
        reg.setPaymentStatus(Registration.PaymentStatus.valueOf(rs.getString("payment_status")));
        reg.setCancelledAt(rs.getTimestamp("cancelled_at") != null ? rs.getTimestamp("cancelled_at").toLocalDateTime() : null);
        reg.setCancellationReason(rs.getString("cancellation_reason"));
        reg.setCreatedAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        reg.setUpdatedAt(rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null);

        if (rs.findColumn("attendee_name") > 0) {
            reg.setAttendeeName(rs.getString("attendee_name"));
        }
        if (rs.findColumn("attendee_email") > 0) {
            reg.setAttendeeEmail(rs.getString("attendee_email"));
        }
        if (rs.findColumn("event_title") > 0) {
            reg.setEventTitle(rs.getString("event_title"));
        }
        if (rs.findColumn("ticket_type_name") > 0) {
            reg.setTicketTypeName(rs.getString("ticket_type_name"));
        }
        if (rs.findColumn("ticket_code") > 0) {
            reg.setTicketCode(rs.getString("ticket_code"));
        }
        return reg;
    }

    public Optional<Registration> findById(Long id) {
        String sql = "SELECT r.*, u.full_name as attendee_name, u.email as attendee_email, e.title as event_title, tt.name as ticket_type_name, dt.ticket_code " +
                "FROM registrations r " +
                "LEFT JOIN users u ON r.attendee_id = u.id " +
                "LEFT JOIN events e ON r.event_id = e.id " +
                "LEFT JOIN ticket_types tt ON r.ticket_type_id = tt.id " +
                "LEFT JOIN digital_tickets dt ON dt.registration_id = r.id " +
                "WHERE r.id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding registration by id", e);
        }
        return Optional.empty();
    }

    public Optional<Registration> findByBookingReference(String bookingRef) {
        String sql = "SELECT r.*, u.full_name as attendee_name, u.email as attendee_email, e.title as event_title, tt.name as ticket_type_name, dt.ticket_code " +
                "FROM registrations r " +
                "LEFT JOIN users u ON r.attendee_id = u.id " +
                "LEFT JOIN events e ON r.event_id = e.id " +
                "LEFT JOIN ticket_types tt ON r.ticket_type_id = tt.id " +
                "LEFT JOIN digital_tickets dt ON dt.registration_id = r.id " +
                "WHERE r.booking_reference = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, bookingRef);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding registration by booking reference", e);
        }
        return Optional.empty();
    }

    public List<Registration> findByAttendee(Long attendeeId) {
        String sql = "SELECT r.*, u.full_name as attendee_name, u.email as attendee_email, e.title as event_title, tt.name as ticket_type_name, dt.ticket_code " +
                "FROM registrations r " +
                "LEFT JOIN users u ON r.attendee_id = u.id " +
                "LEFT JOIN events e ON r.event_id = e.id " +
                "LEFT JOIN ticket_types tt ON r.ticket_type_id = tt.id " +
                "LEFT JOIN digital_tickets dt ON dt.registration_id = r.id " +
                "WHERE r.attendee_id = ? ORDER BY r.created_at DESC";
        List<Registration> regs = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, attendeeId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    regs.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding registrations by attendee", e);
        }
        return regs;
    }

    public List<Registration> findByEvent(Long eventId) {
        String sql = "SELECT r.*, u.full_name as attendee_name, u.email as attendee_email, e.title as event_title, tt.name as ticket_type_name, dt.ticket_code " +
                "FROM registrations r " +
                "LEFT JOIN users u ON r.attendee_id = u.id " +
                "LEFT JOIN events e ON r.event_id = e.id " +
                "LEFT JOIN ticket_types tt ON r.ticket_type_id = tt.id " +
                "LEFT JOIN digital_tickets dt ON dt.registration_id = r.id " +
                "WHERE r.event_id = ? ORDER BY r.created_at DESC";
        List<Registration> regs = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, eventId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    regs.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding registrations by event", e);
        }
        return regs;
    }

    public List<Registration> findByOrganizerEvents(Long organizerId) {
        String sql = "SELECT r.*, u.full_name as attendee_name, u.email as attendee_email, e.title as event_title, tt.name as ticket_type_name, dt.ticket_code " +
                "FROM registrations r " +
                "LEFT JOIN users u ON r.attendee_id = u.id " +
                "LEFT JOIN events e ON r.event_id = e.id " +
                "LEFT JOIN ticket_types tt ON r.ticket_type_id = tt.id " +
                "LEFT JOIN digital_tickets dt ON dt.registration_id = r.id " +
                "WHERE e.organizer_id = ? ORDER BY r.created_at DESC";
        List<Registration> regs = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, organizerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    regs.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding registrations by organizer", e);
        }
        return regs;
    }

    public List<Registration> findAll() {
        String sql = "SELECT r.*, u.full_name as attendee_name, u.email as attendee_email, e.title as event_title, tt.name as ticket_type_name, dt.ticket_code " +
                "FROM registrations r " +
                "LEFT JOIN users u ON r.attendee_id = u.id " +
                "LEFT JOIN events e ON r.event_id = e.id " +
                "LEFT JOIN ticket_types tt ON r.ticket_type_id = tt.id " +
                "LEFT JOIN digital_tickets dt ON dt.registration_id = r.id " +
                "ORDER BY r.created_at DESC";
        List<Registration> regs = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                regs.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding all registrations", e);
        }
        return regs;
    }

    public Registration save(Registration registration) {
        String sql = "INSERT INTO registrations (booking_reference, attendee_id, event_id, ticket_type_id, quantity, total_price, status, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            String bookingRef = "EVT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            registration.setBookingReference(bookingRef);
            
            stmt.setString(1, bookingRef);
            stmt.setLong(2, registration.getAttendeeId());
            stmt.setLong(3, registration.getEventId());
            stmt.setLong(4, registration.getTicketTypeId());
            stmt.setInt(5, registration.getQuantity());
            stmt.setBigDecimal(6, registration.getTotalPrice());
            stmt.setString(7, registration.getStatus() != null ? registration.getStatus().name() : Registration.Status.CONFIRMED.name());
            stmt.setString(8, registration.getPaymentStatus() != null ? registration.getPaymentStatus().name() : Registration.PaymentStatus.PENDING.name());
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    registration.setId(rs.getLong(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error saving registration", e);
        }
        return registration;
    }

    public Registration update(Registration registration) {
        String sql = "UPDATE registrations SET status = ?, payment_status = ?, cancelled_at = ?, cancellation_reason = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, registration.getStatus() != null ? registration.getStatus().name() : Registration.Status.CONFIRMED.name());
            stmt.setString(2, registration.getPaymentStatus() != null ? registration.getPaymentStatus().name() : Registration.PaymentStatus.PENDING.name());
            stmt.setTimestamp(3, registration.getCancelledAt() != null ? Timestamp.valueOf(registration.getCancelledAt()) : null);
            stmt.setString(4, registration.getCancellationReason());
            stmt.setLong(5, registration.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error updating registration", e);
        }
        return registration;
    }

    public boolean cancel(Long registrationId, String reason) {
        String sql = "UPDATE registrations SET status = 'CANCELLED', payment_status = 'REFUNDED', cancelled_at = CURRENT_TIMESTAMP, cancellation_reason = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ? AND status = 'CONFIRMED'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, reason);
            stmt.setLong(2, registrationId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error cancelling registration", e);
        }
    }

    public long countByEvent(Long eventId) {
        String sql = "SELECT COUNT(*) FROM registrations WHERE event_id = ? AND status = 'CONFIRMED'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, eventId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getLong(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting registrations by event", e);
        }
        return 0;
    }

    public BigDecimal getTotalRevenueByEvent(Long eventId) {
        String sql = "SELECT COALESCE(SUM(total_price), 0) FROM registrations WHERE event_id = ? AND status = 'CONFIRMED'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, eventId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error getting total revenue", e);
        }
        return BigDecimal.ZERO;
    }

    public long countByAttendee(Long attendeeId) {
        String sql = "SELECT COUNT(*) FROM registrations WHERE attendee_id = ? AND status = 'CONFIRMED'";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, attendeeId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getLong(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting registrations by attendee", e);
        }
        return 0;
    }
}
