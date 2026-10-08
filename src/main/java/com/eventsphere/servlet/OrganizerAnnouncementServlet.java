package com.eventsphere.servlet;

import com.eventsphere.model.Announcement;
import com.eventsphere.model.Event;
import com.eventsphere.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/organizer/announcements/*")
public class OrganizerAnnouncementServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireOrganizer(request, response)) return;

        String pathInfo = request.getPathInfo();
        Long organizerId = SessionUtil.getCurrentUser(request).getId();

        if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
            listAnnouncements(request, response, organizerId);
        } else if ("/create".equals(pathInfo)) {
            showCreateForm(request, response, organizerId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+")) {
            viewAnnouncement(request, response, Long.parseLong(pathInfo.substring(1)), organizerId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+/send")) {
            sendAnnouncement(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 5)), organizerId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+/delete")) {
            deleteAnnouncement(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 7)), organizerId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireOrganizer(request, response)) return;

        String pathInfo = request.getPathInfo();
        Long organizerId = SessionUtil.getCurrentUser(request).getId();

        if ("/create".equals(pathInfo) || ("/".equals(pathInfo) && "create".equals(request.getParameter("action")))) {
            createAnnouncement(request, response, organizerId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listAnnouncements(HttpServletRequest request, HttpServletResponse response, Long organizerId) 
            throws ServletException, IOException {
        List<Announcement> announcements = announcementDAO.findByOrganizer(organizerId);
        request.setAttribute("announcements", announcements);
        forwardToJsp("/organizer/announcements/list.jsp", request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response, Long organizerId) 
            throws ServletException, IOException {
        List<Event> events = eventDAO.findByOrganizer(organizerId).stream()
            .filter(Event::isApproved)
            .collect(java.util.stream.Collectors.toList());
        request.setAttribute("events", events);
        forwardToJsp("/organizer/announcements/form.jsp", request, response);
    }

    private void createAnnouncement(HttpServletRequest request, HttpServletResponse response, Long organizerId) 
            throws ServletException, IOException {
        String eventIdStr = request.getParameter("eventId");
        String title = request.getParameter("title");
        String message = request.getParameter("message");
        String sendNow = request.getParameter("sendNow");

        StringBuilder errors = new StringBuilder();

        if (eventIdStr == null || eventIdStr.isEmpty()) {
            errors.append("Event is required. ");
        }

        if (title == null || title.trim().isEmpty()) {
            errors.append("Title is required. ");
        }

        if (message == null || message.trim().isEmpty()) {
            errors.append("Message is required. ");
        }

        if (errors.length() > 0) {
            addErrorMessage(request, errors.toString());
            showCreateForm(request, response, organizerId);
            return;
        }

        Long eventId = Long.parseLong(eventIdStr);
        Event event = eventDAO.findById(eventId).orElse(null);
        if (event == null || !event.getOrganizerId().equals(organizerId) || !event.isApproved()) {
            addErrorMessage(request, "Invalid event selected");
            showCreateForm(request, response, organizerId);
            return;
        }

        Announcement announcement = new Announcement();
        announcement.setEventId(eventId);
        announcement.setOrganizerId(organizerId);
        announcement.setTitle(title.trim());
        announcement.setMessage(message.trim());
        announcement.setIsSent(false);
        announcementDAO.save(announcement);

        if ("on".equals(sendNow)) {
            sendAnnouncementInternal(announcement, event);
            addSuccessMessage(request, "Announcement created and sent to attendees!");
        } else {
            addSuccessMessage(request, "Announcement saved as draft!");
        }
        redirect(request, response, "/organizer/announcements");
    }

    private void viewAnnouncement(HttpServletRequest request, HttpServletResponse response, Long id, Long organizerId) 
            throws ServletException, IOException {
        announcementDAO.findById(id).ifPresentOrElse(ann -> {
            if (!ann.getOrganizerId().equals(organizerId)) {
                try { response.sendError(HttpServletResponse.SC_FORBIDDEN); } catch (Exception e) {}
                return;
            }
            request.setAttribute("announcement", ann);
            try { forwardToJsp("/organizer/announcements/view.jsp", request, response); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void sendAnnouncement(HttpServletRequest request, HttpServletResponse response, Long id, Long organizerId) 
            throws IOException {
        announcementDAO.findById(id).ifPresentOrElse(ann -> {
            if (!ann.getOrganizerId().equals(organizerId)) {
                try { response.sendError(HttpServletResponse.SC_FORBIDDEN); } catch (Exception e) {}
                return;
            }
            Event event = eventDAO.findById(ann.getEventId()).orElse(null);
            if (event != null) {
                sendAnnouncementInternal(ann, event);
                try { addSuccessMessage(request, "Announcement sent to attendees!"); } catch (Exception e) {}
            } else {
                try { addErrorMessage(request, "Event not found"); } catch (Exception e) {}
            }
            try { redirect(request, response, "/organizer/announcements"); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void sendAnnouncementInternal(Announcement announcement, Event event) {
        // Create notifications for all confirmed attendees
        notificationDAO.createForEventAttendees(announcement.getId(), event.getId());
        announcementDAO.markAsSent(announcement.getId());
    }

    private void deleteAnnouncement(HttpServletRequest request, HttpServletResponse response, Long id, Long organizerId) 
            throws IOException {
        announcementDAO.findById(id).ifPresentOrElse(ann -> {
            if (!ann.getOrganizerId().equals(organizerId)) {
                try { response.sendError(HttpServletResponse.SC_FORBIDDEN); } catch (Exception e) {}
                return;
            }
            if (announcementDAO.delete(id)) {
                try { addSuccessMessage(request, "Announcement deleted successfully!"); } catch (Exception e) {}
            } else {
                try { addErrorMessage(request, "Failed to delete announcement"); } catch (Exception e) {}
            }
            try { redirect(request, response, "/organizer/announcements"); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }
}
