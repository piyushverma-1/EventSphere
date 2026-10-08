package com.eventsphere.servlet;

import com.eventsphere.model.User;
import com.eventsphere.util.PasswordUtil;
import com.eventsphere.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (SessionUtil.isLoggedIn(request)) {
            redirectBasedOnRole(request, response);
            return;
        }
        forwardToJsp("/auth/login.jsp", request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            addErrorMessage(request, "Email and password are required");
            forwardToJsp("/auth/login.jsp", request, response);
            return;
        }

        userDAO.findByEmail(email.trim().toLowerCase()).ifPresentOrElse(user -> {
            if (!user.getIsActive()) {
                addErrorMessage(request, "Account is deactivated. Contact administrator.");
                try { forwardToJsp("/auth/login.jsp", request, response); } catch (Exception e) {}
                return;
            }

            if (PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
                userDAO.updateLastLogin(user.getId());
                SessionUtil.login(request, user);
                if ("on".equals(remember)) {
                    request.getSession().setMaxInactiveInterval(30 * 24 * 60 * 60); // 30 days
                }
                try {
                    redirectBasedOnRole(request, response);
                } catch (IOException e) {
                    throw new RuntimeException("Failed to redirect", e);
                }
            } else {
                addErrorMessage(request, "Invalid email or password");
                try { forwardToJsp("/auth/login.jsp", request, response); } catch (Exception e) {}
            }
        }, () -> {
            addErrorMessage(request, "Invalid email or password");
            try { forwardToJsp("/auth/login.jsp", request, response); } catch (Exception e) {}
        });
    }

    private void redirectBasedOnRole(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = SessionUtil.getCurrentUser(request);
        switch (user.getRole()) {
            case ADMIN:
                redirect(request, response, "/admin/dashboard");
                break;
            case ORGANIZER:
                redirect(request, response, "/organizer/dashboard");
                break;
            case ATTENDEE:
            default:
                redirect(request, response, "/attendee/dashboard");
                break;
        }
    }
}
