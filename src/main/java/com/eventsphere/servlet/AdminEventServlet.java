package com.eventsphere.servlet;

import com.eventsphere.model.Event;
import com.eventsphere.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/events/*")
public class AdminEventServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) return;

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
            listEvents(request, response);
        } else if (pathInfo != null && pathInfo.matches("/\\d+")) {
            viewEvent(request, response, Long.parseLong(pathInfo.substring(1)));
        } else if ("/pending".equals(pathInfo)) {
            listPending(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) return;

        String pathInfo = request.getPathInfo();
        Long adminId = SessionUtil.getCurrentUser(request).getId();

        if (pathInfo != null && pathInfo.matches("/\\d+/approve")) {
            approveEvent(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 8)), adminId);
        } else if (pathInfo != null && pathInfo.matches("/\\d+/reject")) {
            rejectEvent(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 7)), adminId);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listEvents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String statusFilter = request.getParameter("status");
        List<Event> events = eventDAO.findAll();

        if (statusFilter != null && !statusFilter.isEmpty()) {
            try {
                Event.Status status = Event.Status.valueOf(statusFilter.toUpperCase());
                events = events.stream().filter(e -> e.getStatus() == status).collect(java.util.stream.Collectors.toList());
            } catch (IllegalArgumentException e) {}
        }

        request.setAttribute("events", events);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("totalEvents", eventDAO.countTotal());
        request.setAttribute("pendingCount", eventDAO.countByStatus(Event.Status.PENDING_APPROVAL));
        request.setAttribute("approvedCount", eventDAO.countByStatus(Event.Status.APPROVED));
        request.setAttribute("rejectedCount", eventDAO.countByStatus(Event.Status.REJECTED));

        forwardToJsp("/admin/events/list.jsp", request, response);
    }

    private void listPending(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Event> events = eventDAO.findPendingApproval();
        request.setAttribute("events", events);
        forwardToJsp("/admin/events/pending.jsp", request, response);
    }

    private void viewEvent(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws ServletException, IOException {
        eventDAO.findById(id).ifPresentOrElse(event -> {
            request.setAttribute("event", event);
            try { forwardToJsp("/admin/events/view.jsp", request, response); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void approveEvent(HttpServletRequest request, HttpServletResponse response, Long id, Long adminId) 
            throws IOException {
        if (eventDAO.approve(id, adminId)) {
            addSuccessMessage(request, "Event approved successfully!");
        } else {
            addErrorMessage(request, "Failed to approve event. It may not be in pending status.");
        }
        redirect(request, response, "/admin/events/pending");
    }

    private void rejectEvent(HttpServletRequest request, HttpServletResponse response, Long id, Long adminId) 
            throws IOException {
        String reason = request.getParameter("rejectionReason");
        if (reason == null || reason.trim().isEmpty()) {
            addErrorMessage(request, "Rejection reason is required");
            redirect(request, response, "/admin/events/pending");
            return;
        }

        if (eventDAO.reject(id, adminId, reason.trim())) {
            addSuccessMessage(request, "Event rejected successfully!");
        } else {
            addErrorMessage(request, "Failed to reject event. It may not be in pending status.");
        }
        redirect(request, response, "/admin/events/pending");
    }
}
