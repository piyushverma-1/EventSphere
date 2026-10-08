package com.eventsphere.servlet;

import com.eventsphere.model.Event;
import com.eventsphere.model.Registration;
import com.eventsphere.model.DigitalTicket;
import com.eventsphere.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@WebServlet("/attendee/tickets/*")
public class AttendeeTicketServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireAttendee(request, response)) return;

        String pathInfo = request.getPathInfo();
        Long userId = SessionUtil.getCurrentUser(request).getId();

        if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
            listTickets(request, response, userId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+")) {
            viewTicket(request, response, Long.parseLong(pathInfo.substring(1)), userId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+/cancel")) {
            cancelRegistration(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 7)), userId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireAttendee(request, response)) return;

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.matches("/\\d+/cancel")) {
            cancelRegistration(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 7)), SessionUtil.getCurrentUser(request).getId());
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listTickets(HttpServletRequest request, HttpServletResponse response, Long userId) 
            throws ServletException, IOException {
        List<Registration> registrations = registrationDAO.findByAttendee(userId);

        List<Registration> upcoming = registrations.stream()
            .filter(r -> r.isConfirmed())
            .filter(r -> eventDAO.findById(r.getEventId())
                .map(e -> e.getEventDate() != null && !e.getEventDate().isBefore(LocalDate.now()))
                .orElse(false))
            .collect(Collectors.toList());

        List<Registration> past = registrations.stream()
            .filter(r -> r.isConfirmed())
            .filter(r -> eventDAO.findById(r.getEventId())
                .map(e -> e.getEventDate() != null && e.getEventDate().isBefore(LocalDate.now()))
                .orElse(false))
            .collect(Collectors.toList());

        List<Registration> cancelled = registrations.stream()
            .filter(Registration::isCancelled)
            .collect(Collectors.toList());

        // Load digital tickets
        List<Long> regIds = registrations.stream().map(Registration::getId).collect(Collectors.toList());
        List<DigitalTicket> digitalTickets = digitalTicketDAO.findByRegistrationIds(regIds);

        request.setAttribute("upcomingTickets", upcoming);
        request.setAttribute("pastTickets", past);
        request.setAttribute("cancelledTickets", cancelled);
        request.setAttribute("digitalTickets", digitalTickets);

        forwardToJsp("/attendee/tickets/list.jsp", request, response);
    }

    private void viewTicket(HttpServletRequest request, HttpServletResponse response, Long regId, Long userId) 
            throws ServletException, IOException {
        registrationDAO.findById(regId).ifPresentOrElse(reg -> {
            if (!reg.getAttendeeId().equals(userId)) {
                try { response.sendError(HttpServletResponse.SC_FORBIDDEN); } catch (Exception e) {}
                return;
            }

            Optional<DigitalTicket> ticket = digitalTicketDAO.findByRegistration(regId);
            request.setAttribute("registration", reg);
            request.setAttribute("digitalTicket", ticket.orElse(null));
            try { forwardToJsp("/attendee/tickets/view.jsp", request, response); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void cancelRegistration(HttpServletRequest request, HttpServletResponse response, Long regId, Long userId) 
            throws IOException {
        registrationDAO.findById(regId).ifPresentOrElse(reg -> {
            if (!reg.getAttendeeId().equals(userId)) {
                try { response.sendError(HttpServletResponse.SC_FORBIDDEN); } catch (Exception e) {}
                return;
            }

            if (!reg.canCancel()) {
                try { addErrorMessage(request, "This registration cannot be cancelled"); redirect(request, response, "/attendee/tickets"); } catch (Exception e) {}
                return;
            }

            String reason = request.getParameter("cancellationReason");
            if (reason == null || reason.trim().isEmpty()) {
                try { addErrorMessage(request, "Cancellation reason is required"); redirect(request, response, "/attendee/tickets/" + regId); } catch (Exception e) {}
                return;
            }

            if (registrationDAO.cancel(regId, reason.trim())) {
                // Decrement ticket sold count
                ticketTypeDAO.decrementSoldCount(reg.getTicketTypeId(), reg.getQuantity());
                try { addSuccessMessage(request, "Registration cancelled successfully"); } catch (Exception e) {}
            } else {
                try { addErrorMessage(request, "Failed to cancel registration"); } catch (Exception e) {}
            }
            try { redirect(request, response, "/attendee/tickets"); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }
}
