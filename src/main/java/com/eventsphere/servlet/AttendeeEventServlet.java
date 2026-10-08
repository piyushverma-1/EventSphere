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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@WebServlet("/events/*")
public class AttendeeEventServlet extends BaseServlet {

    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        System.out.println("DEBUG: pathInfo = " + pathInfo);
        System.out.println("DEBUG: requestURI = " + request.getRequestURI());
        System.out.println("DEBUG: contextPath = " + request.getContextPath());
        System.out.println("DEBUG: servletPath = " + request.getServletPath());

        if (pathInfo == null || "/".equals(pathInfo) || "/browse".equals(pathInfo)) {
            System.out.println("DEBUG: Calling browseEvents");
            browseEvents(request, response);
        } else if (pathInfo != null && pathInfo.matches("/\\d+")) {
            System.out.println("DEBUG: Calling viewEvent");
            viewEvent(request, response, Long.parseLong(pathInfo.substring(1)));
        } else if (pathInfo != null && pathInfo.matches("/\\d+/register")) {
            System.out.println("DEBUG: Calling showRegistrationForm");
            showRegistrationForm(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 9)));
        } else {
            System.out.println("DEBUG: 404 - no match for pathInfo: " + pathInfo);
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.matches("/\\d+/register") && "register".equals(request.getParameter("action"))) {
            processRegistration(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 9)));
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void browseEvents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String keyword = request.getParameter("search");
        String dateFromStr = request.getParameter("dateFrom");
        String dateToStr = request.getParameter("dateTo");

        LocalDate dateFrom = null;
        LocalDate dateTo = null;

        try { if (dateFromStr != null && !dateFromStr.isEmpty()) dateFrom = LocalDate.parse(dateFromStr, DATE_FORMAT); } catch (Exception e) {}
        try { if (dateToStr != null && !dateToStr.isEmpty()) dateTo = LocalDate.parse(dateToStr, DATE_FORMAT); } catch (Exception e) {}

        List<Event> events;
        try {
            events = eventDAO.searchEvents(keyword, dateFrom, dateTo);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading events: " + e.getMessage(), e);
        }
        request.setAttribute("events", events);
        request.setAttribute("search", keyword);
        request.setAttribute("dateFrom", dateFromStr);
        request.setAttribute("dateTo", dateToStr);

        forwardToJsp("/attendee/events/browse.jsp", request, response);
    }

    private void viewEvent(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws ServletException, IOException {
        eventDAO.findById(id).ifPresentOrElse(event -> {
            if (!event.isApproved()) {
                try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
                return;
            }

            List<TicketType> tickets = ticketTypeDAO.findAvailableByEvent(id, LocalDateTime.now());
            request.setAttribute("event", event);
            request.setAttribute("tickets", tickets);

            // Check if user is logged in and has existing registration
            if (SessionUtil.isLoggedIn(request) && SessionUtil.isAttendee(request)) {
                Long userId = SessionUtil.getCurrentUser(request).getId();
                List<Registration> userRegs = registrationDAO.findByAttendee(userId);
                Optional<Registration> existingReg = userRegs.stream()
                    .filter(r -> r.getEventId().equals(id) && r.isConfirmed())
                    .findFirst();
                request.setAttribute("existingRegistration", existingReg.orElse(null));
            }

            try { forwardToJsp("/attendee/events/view.jsp", request, response); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void showRegistrationForm(HttpServletRequest request, HttpServletResponse response, Long eventId) 
            throws ServletException, IOException {
        if (!requireAttendee(request, response)) return;

        eventDAO.findById(eventId).ifPresentOrElse(event -> {
            if (!event.isApproved()) {
                try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
                return;
            }

            List<TicketType> tickets = ticketTypeDAO.findAvailableByEvent(eventId, LocalDateTime.now());
            if (tickets.isEmpty()) {
                try { addErrorMessage(request, "No tickets available for this event"); redirect(request, response, "/events/" + eventId); } catch (Exception e) {}
                return;
            }

            // Check existing registration
            Long userId = SessionUtil.getCurrentUser(request).getId();
            List<Registration> userRegs = registrationDAO.findByAttendee(userId);
            Optional<Registration> existingReg = userRegs.stream()
                .filter(r -> r.getEventId().equals(eventId) && r.isConfirmed())
                .findFirst();
            if (existingReg.isPresent()) {
                try { addErrorMessage(request, "You are already registered for this event"); redirect(request, response, "/events/" + eventId); } catch (Exception e) {}
                return;
            }

            request.setAttribute("event", event);
            request.setAttribute("tickets", tickets);
            try { forwardToJsp("/attendee/events/register.jsp", request, response); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void processRegistration(HttpServletRequest request, HttpServletResponse response, Long eventId) 
            throws ServletException, IOException {
        if (!requireAttendee(request, response)) return;

        Long userId = SessionUtil.getCurrentUser(request).getId();

        eventDAO.findById(eventId).ifPresentOrElse(event -> {
            if (!event.isApproved()) {
                try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
                return;
            }

            String ticketTypeIdStr = request.getParameter("ticketTypeId");
            String quantityStr = request.getParameter("quantity");

            if (ticketTypeIdStr == null || quantityStr == null) {
                try { addErrorMessage(request, "Please select a ticket type and quantity"); redirect(request, response, "/events/" + eventId + "/register"); } catch (Exception e) {}
                return;
            }

            Long ticketTypeId;
            int quantity;
            try {
                ticketTypeId = Long.parseLong(ticketTypeIdStr);
                quantity = Integer.parseInt(quantityStr);
            } catch (NumberFormatException e) {
                try { addErrorMessage(request, "Invalid selection"); redirect(request, response, "/events/" + eventId + "/register"); } catch (Exception ex) {}
                return;
            }

            if (quantity <= 0) {
                try { addErrorMessage(request, "Quantity must be at least 1"); redirect(request, response, "/events/" + eventId + "/register"); } catch (Exception e) {}
                return;
            }

            ticketTypeDAO.findById(ticketTypeId).ifPresentOrElse(ticketType -> {
                if (!ticketType.getEventId().equals(eventId)) {
                    try { addErrorMessage(request, "Invalid ticket type"); redirect(request, response, "/events/" + eventId + "/register"); } catch (Exception e) {}
                    return;
                }

                if (ticketType.getAvailableCount() < quantity) {
                    try { addErrorMessage(request, "Not enough tickets available. Only " + ticketType.getAvailableCount() + " left."); redirect(request, response, "/events/" + eventId + "/register"); } catch (Exception e) {}
                    return;
                }

                if (!ticketType.isOnSale(LocalDateTime.now())) {
                    try { addErrorMessage(request, "Ticket sales are not currently open"); redirect(request, response, "/events/" + eventId + "/register"); } catch (Exception e) {}
                    return;
                }

                BigDecimal totalPrice = ticketType.getPrice().multiply(BigDecimal.valueOf(quantity));

                Registration registration = new Registration();
                registration.setAttendeeId(userId);
                registration.setEventId(eventId);
                registration.setTicketTypeId(ticketTypeId);
                registration.setQuantity(quantity);
                registration.setTotalPrice(totalPrice);
                registration.setStatus(Registration.Status.CONFIRMED);
                registration.setPaymentStatus(Registration.PaymentStatus.PAID); // Simplified - assume paid

                try {
                    // Use transaction-like approach: increment sold count first
                    if (ticketTypeDAO.incrementSoldCount(ticketTypeId, quantity)) {
                        registrationDAO.save(registration);
                        
                        // Create digital ticket
                        digitalTicketDAO.createForRegistration(
                            registration.getId(), 
                            event.getTitle(), 
                            SessionUtil.getCurrentUser(request).getFullName(),
                            ticketType.getName()
                        );

                        addSuccessMessage(request, "Registration successful! Your booking reference: " + registration.getBookingReference());
                        redirect(request, response, "/attendee/tickets");
                    } else {
                        addErrorMessage(request, "Registration failed - tickets may have sold out");
                        redirect(request, response, "/events/" + eventId + "/register");
                    }
                } catch (Exception e) {
                    // Rollback sold count on error
                    ticketTypeDAO.decrementSoldCount(ticketTypeId, quantity);
                    try { addErrorMessage(request, "Registration failed: " + e.getMessage()); redirect(request, response, "/events/" + eventId + "/register"); } catch (Exception ex) {}
                }
            }, () -> {
                try { addErrorMessage(request, "Ticket type not found"); redirect(request, response, "/events/" + eventId + "/register"); } catch (Exception e) {}
            });
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }
}
