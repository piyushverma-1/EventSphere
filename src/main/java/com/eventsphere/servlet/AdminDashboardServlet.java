package com.eventsphere.servlet;

import com.eventsphere.model.Event;
import com.eventsphere.model.Registration;
import com.eventsphere.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) return;

        long totalUsers = userDAO.countTotal();
        long adminCount = userDAO.countByRole(User.Role.ADMIN);
        long organizerCount = userDAO.countByRole(User.Role.ORGANIZER);
        long attendeeCount = userDAO.countByRole(User.Role.ATTENDEE);

        long totalEvents = eventDAO.countTotal();
        long pendingEvents = eventDAO.countByStatus(Event.Status.PENDING_APPROVAL);
        long approvedEvents = eventDAO.countByStatus(Event.Status.APPROVED);
        long rejectedEvents = eventDAO.countByStatus(Event.Status.REJECTED);

        List<Event> recentEvents = eventDAO.findAll().stream().limit(5).collect(Collectors.toList());
        List<User> recentUsers = userDAO.findAll().stream().limit(5).collect(Collectors.toList());
        List<Event> pendingApproval = eventDAO.findPendingApproval().stream().limit(10).collect(Collectors.toList());

        // Registration stats
        List<Registration> allRegs = registrationDAO.findAll();
        long totalRegistrations = allRegs.size();
        long confirmedRegs = allRegs.stream().filter(r -> r.isConfirmed()).count();
        BigDecimal totalRevenue = allRegs.stream()
            .filter(r -> r.isConfirmed())
            .map(Registration::getTotalPrice)
            .reduce(BigDecimal.ZERO, BigDecimal::add);

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("adminCount", adminCount);
        request.setAttribute("organizerCount", organizerCount);
        request.setAttribute("attendeeCount", attendeeCount);
        request.setAttribute("totalEvents", totalEvents);
        request.setAttribute("pendingEvents", pendingEvents);
        request.setAttribute("approvedEvents", approvedEvents);
        request.setAttribute("rejectedEvents", rejectedEvents);
        request.setAttribute("recentEvents", recentEvents);
        request.setAttribute("recentUsers", recentUsers);
        request.setAttribute("pendingApproval", pendingApproval);
        request.setAttribute("totalRegistrations", totalRegistrations);
        request.setAttribute("confirmedRegistrations", confirmedRegs);
        request.setAttribute("totalRevenue", totalRevenue);

        forwardToJsp("/admin/dashboard.jsp", request, response);
    }
}
