package com.eventsphere.servlet;

import com.eventsphere.model.Event;
import com.eventsphere.model.Notification;
import com.eventsphere.model.Registration;
import com.eventsphere.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/attendee/dashboard")
public class AttendeeDashboardServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireAttendee(request, response)) return;

        Long userId = SessionUtil.getCurrentUser(request).getId();
        List<Registration> registrations = registrationDAO.findByAttendee(userId);

        long totalRegistrations = registrations.size();

        // Get event details for registrations to check dates
        List<Registration> upcomingRegs = registrations.stream()
            .filter(r -> r.isConfirmed())
            .filter(r -> {
                return eventDAO.findById(r.getEventId())
                    .map(e -> e.getEventDate() != null && !e.getEventDate().isBefore(LocalDate.now()))
                    .orElse(false);
            })
            .limit(5)
            .collect(Collectors.toList());

        List<Registration> pastRegs = registrations.stream()
            .filter(r -> r.isConfirmed())
            .filter(r -> {
                return eventDAO.findById(r.getEventId())
                    .map(e -> e.getEventDate() != null && e.getEventDate().isBefore(LocalDate.now()))
                    .orElse(false);
            })
            .limit(5)
            .collect(Collectors.toList());

        List<Registration> cancelledRegs = registrations.stream()
            .filter(r -> r.isCancelled())
            .limit(5)
            .collect(Collectors.toList());

        // Get all approved upcoming events for browsing
        List<Event> allUpcomingEvents = eventDAO.findApprovedEvents();

        // Notifications
        List<Notification> notifications = notificationDAO.findUnreadByUser(userId);
        int unreadCount = notifications.size();
        List<Notification> recentNotifications = notifications.stream().limit(5).collect(Collectors.toList());

        request.setAttribute("totalRegistrations", totalRegistrations);
        request.setAttribute("upcomingCount", upcomingRegs.size());
        request.setAttribute("pastCount", pastRegs.size());
        request.setAttribute("upcomingRegistrations", upcomingRegs);
        request.setAttribute("pastRegistrations", pastRegs);
        request.setAttribute("cancelledRegistrations", cancelledRegs);
        request.setAttribute("allUpcomingEvents", allUpcomingEvents);
        request.setAttribute("notifications", recentNotifications);
        request.setAttribute("unreadCount", unreadCount);

        forwardToJsp("/attendee/dashboard.jsp", request, response);
    }
}
