package com.eventsphere.servlet;

import com.eventsphere.model.DigitalTicket;
import com.eventsphere.model.Event;
import com.eventsphere.model.Registration;
import com.eventsphere.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/validate-ticket")
public class TicketValidationServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Show validation form for organizers
        if (SessionUtil.isLoggedIn(request) && (SessionUtil.isOrganizer(request) || SessionUtil.isAdmin(request))) {
            forwardToJsp("/validation/scan.jsp", request, response);
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String ticketCode = request.getParameter("ticketCode");
        String action = request.getParameter("action");

        if (ticketCode == null || ticketCode.trim().isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().write("{\"valid\":false,\"message\":\"Ticket code is required\"}");
            return;
        }

        ticketCode = ticketCode.trim().toUpperCase();

        if ("check".equals(action)) {
            // Just check validity without marking as used
            boolean valid = digitalTicketDAO.validateTicket(ticketCode);
            if (valid) {
                DigitalTicket ticket = digitalTicketDAO.findByTicketCode(ticketCode).orElse(null);
                if (ticket != null) {
                    Registration reg = registrationDAO.findById(ticket.getRegistrationId()).orElse(null);
                    if (reg != null) {
                        Event event = eventDAO.findById(reg.getEventId()).orElse(null);
                        response.setContentType("application/json");
                        response.getWriter().write(String.format(
                            "{\"valid\":true,\"message\":\"Valid ticket\",\"event\":\"%s\",\"attendee\":\"%s\",\"ticketType\":\"%s\",\"used\":%s}",
                            event != null ? event.getTitle().replace("\"", "\\\"") : "Unknown",
                            reg.getAttendeeName() != null ? reg.getAttendeeName().replace("\"", "\\\"") : "Unknown",
                            reg.getTicketTypeName() != null ? reg.getTicketTypeName().replace("\"", "\\\"") : "Unknown",
                            ticket.getIsUsed()
                        ));
                        return;
                    }
                }
            }
            response.setContentType("application/json");
            response.getWriter().write("{\"valid\":false,\"message\":\"Invalid or expired ticket\"}");
        } else if ("scan".equals(action)) {
            // Mark as used (check-in)
            if (!SessionUtil.isLoggedIn(request) || (!SessionUtil.isOrganizer(request) && !SessionUtil.isAdmin(request))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"message\":\"Unauthorized\"}");
                return;
            }

            boolean success = digitalTicketDAO.markAsUsed(ticketCode);
            if (success) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":true,\"message\":\"Check-in successful!\"}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false,\"message\":\"Ticket already used or invalid\"}");
            }
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"valid\":false,\"message\":\"Invalid action\"}");
        }
    }
}
