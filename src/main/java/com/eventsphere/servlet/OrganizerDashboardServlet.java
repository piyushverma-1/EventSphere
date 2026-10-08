package com.eventsphere.servlet;

import com.eventsphere.model.Event;
import com.eventsphere.model.Registration;
import com.eventsphere.model.TicketType;
import com.eventsphere.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/organizer/dashboard")
public class OrganizerDashboardServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireOrganizer(request, response)) return;

        Long organizerId = SessionUtil.getCurrentUser(request).getId();
        List<Event> events = eventDAO.findByOrganizer(organizerId);

        long totalEvents = events.size();
        long draftEvents = events.stream().filter(e -> e.isDraft()).count();
        long pendingEvents = events.stream().filter(e -> e.isPending()).count();
        long approvedEvents = events.stream().filter(e -> e.isApproved()).count();
        long cancelledEvents = events.stream().filter(e -> e.isCancelled()).count();

        // Get registrations for organizer's events
        List<Registration> registrations = registrationDAO.findByOrganizerEvents(organizerId);
        long totalRegistrations = registrations.size();
        long confirmedRegs = registrations.stream().filter(r -> r.isConfirmed()).count();
        BigDecimal totalRevenue = registrations.stream()
            .filter(r -> r.isConfirmed())
            .map(Registration::getTotalPrice)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Upcoming events
        List<Event> upcomingEvents = events.stream()
            .filter(e -> e.getEventDate() != null && !e.getEventDate().isBefore(LocalDate.now()))
            .filter(e -> e.isApproved())
            .sorted((a, b) -> a.getEventDate().compareTo(b.getEventDate()))
            .limit(5)
            .collect(Collectors.toList());

        // Top events by registration
        Map<Long, Long> regCountByEvent = registrations.stream()
            .filter(r -> r.isConfirmed())
            .collect(Collectors.groupingBy(Registration::getEventId, Collectors.counting()));

        List<Event> topEvents = events.stream()
            .filter(e -> regCountByEvent.containsKey(e.getId()))
            .sorted((a, b) -> Long.compare(regCountByEvent.getOrDefault(b.getId(), 0L), regCountByEvent.getOrDefault(a.getId(), 0L)))
            .limit(5)
            .collect(Collectors.toList());

        request.setAttribute("totalEvents", totalEvents);
        request.setAttribute("draftEvents", draftEvents);
        request.setAttribute("pendingEvents", pendingEvents);
        request.setAttribute("approvedEvents", approvedEvents);
        request.setAttribute("cancelledEvents", cancelledEvents);
        request.setAttribute("totalRegistrations", totalRegistrations);
        request.setAttribute("confirmedRegistrations", confirmedRegs);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("upcomingEvents", upcomingEvents);
        request.setAttribute("topEvents", topEvents);
        request.setAttribute("regCountByEvent", regCountByEvent);
        request.setAttribute("events", events);

        forwardToJsp("/organizer/dashboard.jsp", request, response);
    }
}
