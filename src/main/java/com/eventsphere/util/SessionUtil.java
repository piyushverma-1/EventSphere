package com.eventsphere.util;

import com.eventsphere.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SessionUtil {
    public static final String USER_SESSION_KEY = "currentUser";
    public static final String CSRF_TOKEN_KEY = "csrfToken";

    public static void login(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(true);
        session.setAttribute(USER_SESSION_KEY, user);
        session.setAttribute(CSRF_TOKEN_KEY, generateCsrfToken());
    }

    public static void logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute(USER_SESSION_KEY);
        }
        return null;
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }

    public static boolean hasRole(HttpServletRequest request, User.Role... roles) {
        User user = getCurrentUser(request);
        if (user == null) return false;
        for (User.Role role : roles) {
            if (user.getRole() == role) return true;
        }
        return false;
    }

    public static boolean isAdmin(HttpServletRequest request) {
        return hasRole(request, User.Role.ADMIN);
    }

    public static boolean isOrganizer(HttpServletRequest request) {
        return hasRole(request, User.Role.ORGANIZER);
    }

    public static boolean isAttendee(HttpServletRequest request) {
        return hasRole(request, User.Role.ATTENDEE);
    }

    public static String getCsrfToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            String token = (String) session.getAttribute(CSRF_TOKEN_KEY);
            if (token == null) {
                token = generateCsrfToken();
                session.setAttribute(CSRF_TOKEN_KEY, token);
            }
            return token;
        }
        return generateCsrfToken();
    }

    public static boolean validateCsrfToken(HttpServletRequest request, String token) {
        String sessionToken = getCsrfToken(request);
        return sessionToken != null && sessionToken.equals(token);
    }

    private static String generateCsrfToken() {
        return java.util.UUID.randomUUID().toString();
    }

    public static void updateUserInSession(HttpServletRequest request, User user) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.setAttribute(USER_SESSION_KEY, user);
        }
    }
}
