package com.eventsphere.servlet;

import com.eventsphere.model.Notification;
import com.eventsphere.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/attendee/notifications/*")
public class AttendeeNotificationServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireAttendee(request, response)) return;

        String pathInfo = request.getPathInfo();
        Long userId = SessionUtil.getCurrentUser(request).getId();

        if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
            listNotifications(request, response, userId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+")) {
            viewNotification(request, response, Long.parseLong(pathInfo.substring(1)), userId);
        } else if ("/mark-all-read".equals(pathInfo)) {
            markAllRead(request, response, userId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireAttendee(request, response)) return;

        String pathInfo = request.getPathInfo();
        Long userId = SessionUtil.getCurrentUser(request).getId();

        if (pathInfo != null && pathInfo.matches("/\\d+/read")) {
            markAsRead(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 5)), userId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listNotifications(HttpServletRequest request, HttpServletResponse response, Long userId) 
            throws ServletException, IOException {
        String filter = request.getParameter("filter"); // all, unread
        List<Notification> notifications;

        if ("unread".equals(filter)) {
            notifications = notificationDAO.findUnreadByUser(userId);
        } else {
            notifications = notificationDAO.findByUser(userId);
        }

        int unreadCount = notificationDAO.countUnreadByUser(userId);
        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        request.setAttribute("filter", filter);
        forwardToJsp("/attendee/notifications/list.jsp", request, response);
    }

    private void viewNotification(HttpServletRequest request, HttpServletResponse response, Long id, Long userId) 
            throws ServletException, IOException {
        List<Notification> notifications = notificationDAO.findByUser(userId);
        notifications.stream()
            .filter(n -> n.getId().equals(id))
            .findFirst()
            .ifPresentOrElse(notif -> {
                request.setAttribute("notification", notif);
                // Mark as read
                if (!notif.getIsRead()) {
                    notificationDAO.markAsRead(id, userId);
                }
                try { forwardToJsp("/attendee/notifications/view.jsp", request, response); } catch (Exception e) {}
            }, () -> {
                try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
            });
    }

    private void markAsRead(HttpServletRequest request, HttpServletResponse response, Long id, Long userId) 
            throws IOException {
        if (notificationDAO.markAsRead(id, userId)) {
            addSuccessMessage(request, "Notification marked as read");
        } else {
            addErrorMessage(request, "Failed to mark as read");
        }
        redirect(request, response, "/attendee/notifications");
    }

    private void markAllRead(HttpServletRequest request, HttpServletResponse response, Long userId) 
            throws IOException {
        notificationDAO.markAllAsRead(userId);
        addSuccessMessage(request, "All notifications marked as read");
        redirect(request, response, "/attendee/notifications");
    }
}
