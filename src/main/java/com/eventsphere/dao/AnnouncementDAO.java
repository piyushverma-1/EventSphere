package com.eventsphere.dao;

import com.eventsphere.model.Announcement;
import com.eventsphere.util.DatabaseUtil;
import jakarta.servlet.ServletContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class AnnouncementDAO {
    private final ServletContext context;

    public AnnouncementDAO(ServletContext context) {
        this.context = context;
    }

    private Connection getConnection() throws SQLException {
        return DatabaseUtil.getConnection(context);
    }

    private Announcement mapResultSet(ResultSet rs) throws SQLException {
        Announcement ann = new Announcement();
        ann.setId(rs.getLong("id"));
        ann.setEventId(rs.getLong("event_id"));
        ann.setOrganizerId(rs.getLong("organizer_id"));
        ann.setTitle(rs.getString("title"));
        ann.setMessage(rs.getString("message"));
        ann.setIsSent(rs.getBoolean("is_sent"));
        ann.setSentAt(rs.getTimestamp("sent_at") != null ? rs.getTimestamp("sent_at").toLocalDateTime() : null);
        ann.setCreatedAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);

        if (rs.findColumn("event_title") > 0) {
            ann.setEventTitle(rs.getString("event_title"));
        }
        if (rs.findColumn("organizer_name") > 0) {
            ann.setOrganizerName(rs.getString("organizer_name"));
        }
        return ann;
    }

    public Optional<Announcement> findById(Long id) {
        String sql = "SELECT a.*, e.title as event_title, u.full_name as organizer_name FROM announcements a LEFT JOIN events e ON a.event_id = e.id LEFT JOIN users u ON a.organizer_id = u.id WHERE a.id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding announcement by id", e);
        }
        return Optional.empty();
    }

    public List<Announcement> findByEvent(Long eventId) {
        String sql = "SELECT a.*, e.title as event_title, u.full_name as organizer_name FROM announcements a LEFT JOIN events e ON a.event_id = e.id LEFT JOIN users u ON a.organizer_id = u.id WHERE a.event_id = ? ORDER BY a.created_at DESC";
        List<Announcement> anns = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, eventId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    anns.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding announcements by event", e);
        }
        return anns;
    }

    public List<Announcement> findByOrganizer(Long organizerId) {
        String sql = "SELECT a.*, e.title as event_title, u.full_name as organizer_name FROM announcements a LEFT JOIN events e ON a.event_id = e.id LEFT JOIN users u ON a.organizer_id = u.id WHERE a.organizer_id = ? ORDER BY a.created_at DESC";
        List<Announcement> anns = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, organizerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    anns.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding announcements by organizer", e);
        }
        return anns;
    }

    public Announcement save(Announcement announcement) {
        String sql = "INSERT INTO announcements (event_id, organizer_id, title, message, is_sent) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setLong(1, announcement.getEventId());
            stmt.setLong(2, announcement.getOrganizerId());
            stmt.setString(3, announcement.getTitle());
            stmt.setString(4, announcement.getMessage());
            stmt.setBoolean(5, announcement.getIsSent() != null ? announcement.getIsSent() : false);
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    announcement.setId(rs.getLong(1));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error saving announcement", e);
        }
        return announcement;
    }

    public boolean markAsSent(Long id) {
        String sql = "UPDATE announcements SET is_sent = TRUE, sent_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error marking announcement as sent", e);
        }
    }

    public boolean delete(Long id) {
        String sql = "DELETE FROM announcements WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting announcement", e);
        }
    }
}
