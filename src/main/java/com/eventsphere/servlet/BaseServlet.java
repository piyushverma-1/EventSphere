package com.eventsphere.servlet;

import com.eventsphere.dao.*;
import com.eventsphere.util.DatabaseUtil;
import com.eventsphere.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public abstract class BaseServlet extends HttpServlet {
    protected UserDAO userDAO;
    protected EventDAO eventDAO;
    protected TicketTypeDAO ticketTypeDAO;
    protected RegistrationDAO registrationDAO;
    protected AnnouncementDAO announcementDAO;
    protected NotificationDAO notificationDAO;
    protected DigitalTicketDAO digitalTicketDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO(getServletContext());
        eventDAO = new EventDAO(getServletContext());
        ticketTypeDAO = new TicketTypeDAO(getServletContext());
        registrationDAO = new RegistrationDAO(getServletContext());
        announcementDAO = new AnnouncementDAO(getServletContext());
        notificationDAO = new NotificationDAO(getServletContext());
        digitalTicketDAO = new DigitalTicketDAO(getServletContext());
    }

    @Override
    public void destroy() {
        DatabaseUtil.closeDataSource();
        super.destroy();
    }

    protected void forwardToJsp(String path, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views" + path).forward(request, response);
    }

    protected void redirect(HttpServletRequest request, HttpServletResponse response, String url) throws IOException {
        response.sendRedirect(request.getContextPath() + url);
    }

    protected boolean requireLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    protected boolean requireRole(HttpServletRequest request, HttpServletResponse response, com.eventsphere.model.User.Role... roles) throws IOException {
        if (!requireLogin(request, response)) return false;
        if (!SessionUtil.hasRole(request, roles)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return false;
        }
        return true;
    }

    protected boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        return requireRole(request, response, com.eventsphere.model.User.Role.ADMIN);
    }

    protected boolean requireOrganizer(HttpServletRequest request, HttpServletResponse response) throws IOException {
        return requireRole(request, response, com.eventsphere.model.User.Role.ORGANIZER);
    }

    protected boolean requireAttendee(HttpServletRequest request, HttpServletResponse response) throws IOException {
        return requireRole(request, response, com.eventsphere.model.User.Role.ATTENDEE);
    }

    protected void addErrorMessage(HttpServletRequest request, String message) {
        request.setAttribute("errorMessage", message);
    }

    protected void addSuccessMessage(HttpServletRequest request, String message) {
        request.setAttribute("successMessage", message);
    }
}
