package com.eventsphere.servlet;

import com.eventsphere.model.Event;
import com.eventsphere.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet({"/", "/index", "/home"})
public class HomeServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String path = request.getServletPath();
        if (path != null && (path.startsWith("/css/") || path.startsWith("/js/")
                || path.startsWith("/images/") || path.endsWith(".css") || path.endsWith(".js")
                || path.endsWith(".png") || path.endsWith(".jpg") || path.endsWith(".ico")
                || path.endsWith(".svg") || path.endsWith(".woff") || path.endsWith(".woff2"))) {
            request.getServletContext().getNamedDispatcher("default").forward(request, response);
            return;
        }

        // If logged in, redirect to appropriate dashboard
        if (SessionUtil.isLoggedIn(request)) {
            com.eventsphere.model.User user = SessionUtil.getCurrentUser(request);
            switch (user.getRole()) {
                case ADMIN:
                    redirect(request, response, "/admin/dashboard");
                    return;
                case ORGANIZER:
                    redirect(request, response, "/organizer/dashboard");
                    return;
                case ATTENDEE:
                    redirect(request, response, "/attendee/dashboard");
                    return;
            }
        }

        // Show featured/upcoming events for non-logged in users
        List<Event> upcomingEvents = eventDAO.findApprovedEvents().stream()
            .filter(e -> e.getEventDate() != null && !e.getEventDate().isBefore(LocalDate.now()))
            .limit(9)
            .collect(Collectors.toList());

        request.setAttribute("pageTitle", "Discover Amazing Events");
        request.setAttribute("upcomingEvents", upcomingEvents);
        forwardToJsp("/index.jsp", request, response);
    }
}
