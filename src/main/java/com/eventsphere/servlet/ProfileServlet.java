package com.eventsphere.servlet;

import com.eventsphere.model.User;
import com.eventsphere.util.PasswordUtil;
import com.eventsphere.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet("/profile")
public class ProfileServlet extends BaseServlet {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^\\+?[0-9\\s\\-()]{10,20}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireLogin(request, response)) return;
        forwardToJsp("/profile-content.jsp", request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireLogin(request, response)) return;

        String action = request.getParameter("action");
        User currentUser = SessionUtil.getCurrentUser(request);

        if ("updateProfile".equals(action)) {
            updateProfile(request, response, currentUser);
        } else if ("changePassword".equals(action)) {
            changePassword(request, response, currentUser);
        } else {
            forwardToJsp("/profile-content.jsp", request, response);
        }
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        StringBuilder errors = new StringBuilder();

        if (email == null || email.trim().isEmpty()) {
            errors.append("Email is required. ");
        } else if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            errors.append("Invalid email format. ");
        } else if (!email.trim().toLowerCase().equals(currentUser.getEmail())) {
            if (userDAO.findByEmail(email.trim().toLowerCase()).isPresent()) {
                errors.append("Email already in use. ");
            }
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            errors.append("Full name is required. ");
        }

        if (phone != null && !phone.trim().isEmpty() && !PHONE_PATTERN.matcher(phone.trim()).matches()) {
            errors.append("Invalid phone number format. ");
        }

        if (errors.length() > 0) {
            addErrorMessage(request, errors.toString());
            forwardToJsp("/profile-content.jsp", request, response);
            return;
        }

        currentUser.setEmail(email.trim().toLowerCase());
        currentUser.setFullName(fullName.trim());
        currentUser.setPhone(phone != null ? phone.trim() : null);
        currentUser.setAddress(address != null ? address.trim() : null);
        userDAO.update(currentUser);
        SessionUtil.updateUserInSession(request, currentUser);

        addSuccessMessage(request, "Profile updated successfully!");
        forwardToJsp("/profile-content.jsp", request, response);
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response, User currentUser) 
            throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        StringBuilder errors = new StringBuilder();

        if (currentPassword == null || currentPassword.isEmpty()) {
            errors.append("Current password is required. ");
        } else if (!PasswordUtil.verifyPassword(currentPassword, currentUser.getPasswordHash())) {
            errors.append("Current password is incorrect. ");
        }

        if (newPassword == null || newPassword.length() < 8) {
            errors.append("New password must be at least 8 characters. ");
        }

        if (!newPassword.equals(confirmPassword)) {
            errors.append("New passwords do not match. ");
        }

        if (errors.length() > 0) {
            addErrorMessage(request, errors.toString());
            forwardToJsp("/profile-content.jsp", request, response);
            return;
        }

        userDAO.updatePassword(currentUser.getId(), PasswordUtil.hashPassword(newPassword));
        addSuccessMessage(request, "Password changed successfully!");
        forwardToJsp("/profile-content.jsp", request, response);
    }
}
