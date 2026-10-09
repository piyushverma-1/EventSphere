package com.eventsphere.dao;

import com.eventsphere.model.Notification;
import com.eventsphere.util.DAOUtil;
import com.eventsphere.util.DatabaseUtil;
import jakarta.servlet.ServletContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class NotificationDAO {
    private final ServletContext context;

    public NotificationDAO(ServletContext context) {
        this.context = context;
    }

    private Connection getConnection() throws SQLException {
        return DatabaseUtil.getConnection(context);
    }

    private Notification mapResultSet(ResultSet rs) throws SQLException {
        Notification notif = new Notification();
        notif.setId(rs.getLong("id"));
        notif.setUserId(rs.getLong("user_id"));
        notif.setAnnouncementId(rs.getLong("announcement_id"));
        notif.setIsRead(rs.getBoolean("is_read"));
        notif.setReadAt(rs.getTimestamp("read_at") != null ? rs.getTimestamp("read_at").toLocalDateTime() : null);
        notif.setCreatedAt(rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);

        if (DAOUtil.hasColumn(rs, "title")) {
            notif.setTitle(rs.getString("title"));
        }
        if (DAOUtil.hasColumn(rs, "message")) {
            notif.setMessage(rs.getString("message"));
        }
        if (DAOUtil.hasColumn(rs, "event_title")) {
            notif.setEventTitle(rs.getString("event_title"));
        }
        return notif;
    }

    public List<Notification> findByUser(Long userId) {
        String sql = "SELECT n.*, a.title, a.message, e.title as event_title " +
                "FROM notifications n " +
                "LEFT JOIN announcements a ON n.announcement_id = a.id " +
                "LEFT JOIN events e ON a.event_id = e.id " +
                "WHERE n.user_id = ? ORDER BY n.created_at DESC";
        List<Notification> notifs = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifs.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding notifications by user", e);
        }
        return notifs;
    }

    public List<Notification> findUnreadByUser(Long userId) {
        String sql = "SELECT n.*, a.title, a.message, e.title as event_title " +
                "FROM notifications n " +
                "LEFT JOIN announcements a ON n.announcement_id = a.id " +
                "LEFT JOIN events e ON a.event_id = e.id " +
                "WHERE n.user_id = ? AND n.is_read = FALSE ORDER BY n.created_at DESC";
        List<Notification> notifs = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    notifs.add(mapResultSet(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding unread notifications", e);
        }
        return notifs;
    }

    public int countUnreadByUser(Long userId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting unread notifications", e);
        }
        return 0;
    }

    public void createForEventAttendees(Long announcementId, Long eventId) {
        String sql = "INSERT INTO notifications (user_id, announcement_id) " +
                "SELECT r.attendee_id, ? FROM registrations r " +
                "WHERE r.event_id = ? AND r.status = 'CONFIRMED' " +
                "AND NOT EXISTS (SELECT 1 FROM notifications n WHERE n.user_id = r.attendee_id AND n.announcement_id = ?)";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, announcementId);
            stmt.setLong(2, eventId);
            stmt.setLong(3, announcementId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error creating notifications for attendees", e);
        }
    }

    public boolean markAsRead(Long notificationId, Long userId) {
        String sql = "UPDATE notifications SET is_read = TRUE, read_at = CURRENT_TIMESTAMP WHERE id = ? AND user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, notificationId);
            stmt.setLong(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error marking notification as read", e);
        }
    }

    public boolean markAllAsRead(Long userId) {
        String sql = "UPDATE notifications SET is_read = TRUE, read_at = CURRENT_TIMESTAMP WHERE user_id = ? AND is_read = FALSE";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            throw new RuntimeException("Error marking all notifications as read", e);
        }
    }
}
