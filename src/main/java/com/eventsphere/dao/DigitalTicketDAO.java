package com.eventsphere.dao;

import com.eventsphere.model.DigitalTicket;
import com.eventsphere.util.DatabaseUtil;
import jakarta.servlet.ServletContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class DigitalTicketDAO {
    private final ServletContext context;

    public DigitalTicketDAO(ServletContext context) {
        this.context = context;
    }

    private Connection getConnection() throws SQLException {
        return DatabaseUtil.getConnection(context);
    }

    private DigitalTicket mapResultSet(ResultSet rs) throws SQLException {
        DigitalTicket ticket = new DigitalTicket();
        ticket.setId(rs.getLong("id"));
        ticket.setRegistrationId(rs.getLong("registration_id"));
        ticket.setTicketCode(rs.getString("ticket_code"));
        ticket.setQrCodeData(rs.getString("qr_code_data"));
        ticket.setIsUsed(rs.getBoolean("is_used"));
        ticket.setUsedAt(rs.getTimestamp("used_at") != null ? rs.getTimestamp("used_at").toLocalDateTime() : null);
        ticket.setCreatedAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        return ticket;
    }

    public Optional<DigitalTicket> findByRegistration(Long registrationId) {
        String sql = "SELECT * FROM digital_tickets WHERE registration_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, registrationId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding digital ticket by registration", e);
        }
        return Optional.empty();
    }

    public Optional<DigitalTicket> findByTicketCode(String ticketCode) {
        String sql = "SELECT * FROM digital_tickets WHERE ticket_code = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ticketCode);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding digital ticket by code", e);
        }
        return Optional.empty();
    }

    public List<DigitalTicket> findByRegistrationIds(List<Long> registrationIds) {
        if (registrationIds == null || registrationIds.isEmpty()) return new ArrayList<>();
        String placeholders = String.join(",", registrationIds.stream().map(id -> "?").toArray(String[]::new));
        String sql = "SELECT * FROM digital_tickets WHERE registration_id IN (" + placeholders + ")";
        List<DigitalTicket> tickets = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < registrationIds.size(); i++) {
                stmt.setLong(i + 1, registrationIds.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    tickets.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding digital tickets by registrations", e);
        }
        return tickets;
    }

    public DigitalTicket createForRegistration(Long registrationId, String eventTitle, String attendeeName, String ticketTypeName) {
        String ticketCode = "TKT-" + UUID.randomUUID().toString().substring(0, 12).toUpperCase();
        String qrData = String.format("EventSphere|%s|%s|%s|%s", ticketCode, eventTitle, attendeeName, ticketTypeName);

        String sql = "INSERT INTO digital_tickets (registration_id, ticket_code, qr_code_data) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, registrationId);
            stmt.setString(2, ticketCode);
            stmt.setString(3, qrData);
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    DigitalTicket ticket = new DigitalTicket();
                    ticket.setId(rs.getLong(1));
                    ticket.setRegistrationId(registrationId);
                    ticket.setTicketCode(ticketCode);
                    ticket.setQrCodeData(qrData);
                    ticket.setIsUsed(false);
                    ticket.setCreatedAt(LocalDateTime.now());
                    return ticket;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating digital ticket", e);
        }
        return null;
    }

    public boolean markAsUsed(String ticketCode) {
        String sql = "UPDATE digital_tickets SET is_used = TRUE, used_at = CURRENT_TIMESTAMP WHERE ticket_code = ? AND is_used = FALSE";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ticketCode);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error marking ticket as used", e);
        }
    }

    public boolean validateTicket(String ticketCode) {
        String sql = "SELECT dt.*, r.status as reg_status, e.event_date, e.event_time " +
                "FROM digital_tickets dt " +
                "JOIN registrations r ON dt.registration_id = r.id " +
                "JOIN events e ON r.event_id = e.id " +
                "WHERE dt.ticket_code = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ticketCode);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    boolean isUsed = rs.getBoolean("is_used");
                    String regStatus = rs.getString("reg_status");
                    LocalDateTime eventDateTime = null;
                    if (rs.getDate("event_date") != null && rs.getTime("event_time") != null) {
                        eventDateTime = rs.getDate("event_date").toLocalDate().atTime(rs.getTime("event_time").toLocalTime());
                    }
                    return !isUsed && "CONFIRMED".equals(regStatus) && eventDateTime != null && eventDateTime.isAfter(LocalDateTime.now().minusHours(2));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error validating ticket", e);
        }
        return false;
    }
}
