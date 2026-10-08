package com.eventsphere.servlet;

import com.eventsphere.model.Event;
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
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/organizer/events/*")
public class OrganizerEventServlet extends BaseServlet {

    private static final DateTimeFormatter DATE_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    private static final DateTimeFormatter TIME_FORMAT = DateTimeFormatter.ofPattern("HH:mm");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireOrganizer(request, response)) return;

        String pathInfo = request.getPathInfo();
        Long organizerId = SessionUtil.getCurrentUser(request).getId();

        if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
            listEvents(request, response, organizerId);
        } else if ("/create".equals(pathInfo)) {
            showCreateForm(request, response);
        } else if (pathInfo != null && pathInfo.matches("/\\d+")) {
            viewEvent(request, response, Long.parseLong(pathInfo.substring(1)), organizerId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+/edit")) {
            showEditForm(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 5)), organizerId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+/tickets")) {
            manageTickets(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 8)), organizerId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+/submit")) {
            submitForApproval(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 8)), organizerId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+/cancel")) {
            cancelEvent(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 7)), organizerId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+/delete")) {
            deleteEvent(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 7)), organizerId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireOrganizer(request, response)) return;

        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");
        Long organizerId = SessionUtil.getCurrentUser(request).getId();

        if ("/create".equals(pathInfo) || ("/".equals(pathInfo) && "create".equals(action))) {
            createEvent(request, response, organizerId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+/edit") && "update".equals(action)) {
            updateEvent(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 5)), organizerId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+/tickets") && "saveTickets".equals(action)) {
            saveTickets(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 8)), organizerId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listEvents(HttpServletRequest request, HttpServletResponse response, Long organizerId) 
            throws ServletException, IOException {
        List<Event> events = eventDAO.findByOrganizer(organizerId);
        request.setAttribute("events", events);
        forwardToJsp("/organizer/events/list.jsp", request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        forwardToJsp("/organizer/events/form.jsp", request, response);
    }

    private void createEvent(HttpServletRequest request, HttpServletResponse response, Long organizerId) 
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String eventDateStr = request.getParameter("eventDate");
        String eventTimeStr = request.getParameter("eventTime");
        String venue = request.getParameter("venue");
        String capacityStr = request.getParameter("capacity");
        String action = request.getParameter("action"); // save or submit

        StringBuilder errors = new StringBuilder();
        Event event = new Event();
        event.setOrganizerId(organizerId);

        if (title == null || title.trim().isEmpty()) {
            errors.append("Title is required. ");
        } else {
            event.setTitle(title.trim());
        }

        if (description != null) {
            event.setDescription(description.trim());
        }

        if (eventDateStr == null || eventDateStr.isEmpty()) {
            errors.append("Event date is required. ");
        } else {
            try { event.setEventDate(LocalDate.parse(eventDateStr, DATE_FORMAT)); } 
            catch (Exception e) { errors.append("Invalid date format. "); }
        }

        if (eventTimeStr == null || eventTimeStr.isEmpty()) {
            errors.append("Event time is required. ");
        } else {
            try { event.setEventTime(LocalTime.parse(eventTimeStr, TIME_FORMAT)); } 
            catch (Exception e) { errors.append("Invalid time format. "); }
        }

        if (venue == null || venue.trim().isEmpty()) {
            errors.append("Venue is required. ");
        } else {
            event.setVenue(venue.trim());
        }

        if (capacityStr == null || capacityStr.isEmpty()) {
            errors.append("Capacity is required. ");
        } else {
            try { 
                int capacity = Integer.parseInt(capacityStr);
                if (capacity <= 0) errors.append("Capacity must be positive. ");
                event.setCapacity(capacity);
            } catch (NumberFormatException e) { errors.append("Invalid capacity. "); }
        }

        if (errors.length() > 0) {
            addErrorMessage(request, errors.toString());
            request.setAttribute("event", event);
            forwardToJsp("/organizer/events/form.jsp", request, response);
            return;
        }

        if ("submit".equals(action)) {
            event.setStatus(Event.Status.PENDING_APPROVAL);
        } else {
            event.setStatus(Event.Status.DRAFT);
        }

        eventDAO.save(event);
        addSuccessMessage(request, "Event " + ("submit".equals(action) ? "submitted for approval" : "saved as draft") + "!");
        redirect(request, response, "/organizer/events");
    }

    private void viewEvent(HttpServletRequest request, HttpServletResponse response, Long id, Long organizerId) 
            throws ServletException, IOException {
        eventDAO.findById(id).ifPresentOrElse(event -> {
            if (!event.getOrganizerId().equals(organizerId)) {
                try { response.sendError(HttpServletResponse.SC_FORBIDDEN); } catch (Exception e) {}
                return;
            }
            List<TicketType> tickets = ticketTypeDAO.findByEvent(id);
            request.setAttribute("event", event);
            request.setAttribute("tickets", tickets);
            try { forwardToJsp("/organizer/events/view.jsp", request, response); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, Long id, Long organizerId) 
            throws ServletException, IOException {
        eventDAO.findById(id).ifPresentOrElse(event -> {
            if (!event.getOrganizerId().equals(organizerId)) {
                try { response.sendError(HttpServletResponse.SC_FORBIDDEN); } catch (Exception e) {}
                return;
            }
            if (!event.isDraft() && !event.isRejected()) {
                try { 
                    addErrorMessage(request, "Can only edit draft or rejected events");
                    redirect(request, response, "/organizer/events");
                } catch (Exception e) {}
                return;
            }
            request.setAttribute("event", event);
            request.setAttribute("isEdit", true);
            try { forwardToJsp("/organizer/events/form.jsp", request, response); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void updateEvent(HttpServletRequest request, HttpServletResponse response, Long id, Long organizerId) 
            throws ServletException, IOException {
        eventDAO.findById(id).ifPresentOrElse(event -> {
            if (!event.getOrganizerId().equals(organizerId) || (!event.isDraft() && !event.isRejected())) {
                try { response.sendError(HttpServletResponse.SC_FORBIDDEN); } catch (Exception e) {}
                return;
            }

            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String eventDateStr = request.getParameter("eventDate");
            String eventTimeStr = request.getParameter("eventTime");
            String venue = request.getParameter("venue");
            String capacityStr = request.getParameter("capacity");
            String action = request.getParameter("action");

            StringBuilder errors = new StringBuilder();

            if (title == null || title.trim().isEmpty()) errors.append("Title is required. ");
            else event.setTitle(title.trim());

            if (description != null) event.setDescription(description.trim());

            if (eventDateStr == null || eventDateStr.isEmpty()) errors.append("Event date is required. ");
            else { try { event.setEventDate(LocalDate.parse(eventDateStr, DATE_FORMAT)); } catch (Exception e) { errors.append("Invalid date format. "); }}

            if (eventTimeStr == null || eventTimeStr.isEmpty()) errors.append("Event time is required. ");
            else { try { event.setEventTime(LocalTime.parse(eventTimeStr, TIME_FORMAT)); } catch (Exception e) { errors.append("Invalid time format. "); }}

            if (venue == null || venue.trim().isEmpty()) errors.append("Venue is required. ");
            else event.setVenue(venue.trim());

            if (capacityStr == null || capacityStr.isEmpty()) errors.append("Capacity is required. ");
            else { try { 
                int cap = Integer.parseInt(capacityStr); 
                if (cap <= 0) errors.append("Capacity must be positive. "); 
                event.setCapacity(cap); 
            } catch (NumberFormatException e) { errors.append("Invalid capacity. "); }}

            if (errors.length() > 0) {
                try { addErrorMessage(request, errors.toString()); request.setAttribute("event", event); forwardToJsp("/organizer/events/form.jsp", request, response); } catch (Exception e) {}
                return;
            }

            if ("submit".equals(action)) {
                event.setStatus(Event.Status.PENDING_APPROVAL);
            }

            eventDAO.update(event);
            try {
                addSuccessMessage(request, "Event " + ("submit".equals(action) ? "submitted for approval" : "updated") + "!");
                redirect(request, response, "/organizer/events");
            } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void manageTickets(HttpServletRequest request, HttpServletResponse response, Long eventId, Long organizerId) 
            throws ServletException, IOException {
        eventDAO.findById(eventId).ifPresentOrElse(event -> {
            if (!event.getOrganizerId().equals(organizerId)) {
                try { response.sendError(HttpServletResponse.SC_FORBIDDEN); } catch (Exception e) {}
                return;
            }
            List<TicketType> tickets = ticketTypeDAO.findByEvent(eventId);
            request.setAttribute("event", event);
            request.setAttribute("tickets", tickets);
            try { forwardToJsp("/organizer/events/tickets.jsp", request, response); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void saveTickets(HttpServletRequest request, HttpServletResponse response, Long eventId, Long organizerId) 
            throws ServletException, IOException {
        eventDAO.findById(eventId).ifPresentOrElse(event -> {
            if (!event.getOrganizerId().equals(organizerId)) {
                try { response.sendError(HttpServletResponse.SC_FORBIDDEN); } catch (Exception e) {}
                return;
            }

            String[] names = request.getParameterValues("ticketName");
            String[] descriptions = request.getParameterValues("ticketDescription");
            String[] prices = request.getParameterValues("ticketPrice");
            String[] quantities = request.getParameterValues("ticketQuantity");
            String[] salesStarts = request.getParameterValues("ticketSalesStart");
            String[] salesEnds = request.getParameterValues("ticketSalesEnd");
            String[] ids = request.getParameterValues("ticketId");

            // Delete existing tickets not in the list
            List<Long> keepIds = new ArrayList<>();
            if (ids != null) {
                for (String idStr : ids) {
                    if (idStr != null && !idStr.isEmpty()) {
                        try { keepIds.add(Long.parseLong(idStr)); } catch (NumberFormatException e) {}
                    }
                }
            }
            List<TicketType> existing = ticketTypeDAO.findByEvent(eventId);
            for (TicketType t : existing) {
                if (!keepIds.contains(t.getId())) {
                    ticketTypeDAO.delete(t.getId());
                }
            }

            // Save/update tickets
            if (names != null) {
                for (int i = 0; i < names.length; i++) {
                    String name = names[i];
                    if (name == null || name.trim().isEmpty()) continue;

                    TicketType tt = new TicketType();
                    tt.setEventId(eventId);
                    tt.setName(name.trim());
                    tt.setDescription(descriptions != null && i < descriptions.length ? descriptions[i] : "");

                    try { tt.setPrice(new BigDecimal(prices != null && i < prices.length ? prices[i] : "0")); } 
                    catch (Exception e) { tt.setPrice(BigDecimal.ZERO); }

                    try { tt.setQuantity(Integer.parseInt(quantities != null && i < quantities.length ? quantities[i] : "0")); } 
                    catch (Exception e) { tt.setQuantity(0); }

                    if (salesStarts != null && i < salesStarts.length && salesStarts[i] != null && !salesStarts[i].isEmpty()) {
                        try { tt.setSalesStart(LocalDateTime.parse(salesStarts[i] + "T00:00")); } catch (Exception e) {}
                    }
                    if (salesEnds != null && i < salesEnds.length && salesEnds[i] != null && !salesEnds[i].isEmpty()) {
                        try { tt.setSalesEnd(LocalDateTime.parse(salesEnds[i] + "T23:59")); } catch (Exception e) {}
                    }

                    if (ids != null && i < ids.length && ids[i] != null && !ids[i].isEmpty()) {
                        try { 
                            tt.setId(Long.parseLong(ids[i])); 
                            ticketTypeDAO.update(tt);
                        } catch (NumberFormatException e) { ticketTypeDAO.save(tt); }
                    } else {
                        ticketTypeDAO.save(tt);
                    }
                }
            }

            try {
                addSuccessMessage(request, "Ticket types saved successfully!");
                redirect(request, response, "/organizer/events/" + eventId + "/tickets");
            } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void submitForApproval(HttpServletRequest request, HttpServletResponse response, Long id, Long organizerId) 
            throws IOException {
        eventDAO.findById(id).ifPresentOrElse(event -> {
            if (!event.getOrganizerId().equals(organizerId)) {
                try { response.sendError(HttpServletResponse.SC_FORBIDDEN); } catch (Exception e) {}
                return;
            }
            if (event.isDraft() || event.isRejected()) {
                // Check if event has ticket types
                List<TicketType> tickets = ticketTypeDAO.findByEvent(id);
                if (tickets.isEmpty()) {
                    try { addErrorMessage(request, "Event must have at least one ticket type before submission"); redirect(request, response, "/organizer/events"); } catch (Exception e) {}
                    return;
                }
                event.setStatus(Event.Status.PENDING_APPROVAL);
                eventDAO.update(event);
                try { addSuccessMessage(request, "Event submitted for approval!"); } catch (Exception e) {}
            }
            try { redirect(request, response, "/organizer/events"); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void cancelEvent(HttpServletRequest request, HttpServletResponse response, Long id, Long organizerId) 
            throws IOException {
        eventDAO.findById(id).ifPresentOrElse(event -> {
            if (!event.getOrganizerId().equals(organizerId)) {
                try { response.sendError(HttpServletResponse.SC_FORBIDDEN); } catch (Exception e) {}
                return;
            }
            if (event.isApproved() || event.isPending()) {
                event.setStatus(Event.Status.CANCELLED);
                eventDAO.update(event);
                try { addSuccessMessage(request, "Event cancelled successfully!"); } catch (Exception e) {}
            } else {
                try { addErrorMessage(request, "Can only cancel approved or pending events"); } catch (Exception e) {}
            }
            try { redirect(request, response, "/organizer/events"); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void deleteEvent(HttpServletRequest request, HttpServletResponse response, Long id, Long organizerId) 
            throws IOException {
        eventDAO.findById(id).ifPresentOrElse(event -> {
            if (!event.getOrganizerId().equals(organizerId)) {
                try { response.sendError(HttpServletResponse.SC_FORBIDDEN); } catch (Exception e) {}
                return;
            }
            if (event.isDraft() || event.isRejected() || event.isCancelled()) {
                ticketTypeDAO.deleteByEvent(id);
                eventDAO.delete(id);
                try { addSuccessMessage(request, "Event deleted successfully!"); } catch (Exception e) {}
            } else {
                try { addErrorMessage(request, "Can only delete draft, rejected, or cancelled events"); } catch (Exception e) {}
            }
            try { redirect(request, response, "/organizer/events"); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }
}
