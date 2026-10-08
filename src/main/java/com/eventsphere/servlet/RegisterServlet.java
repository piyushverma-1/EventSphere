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

@WebServlet("/register")
public class RegisterServlet extends BaseServlet {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^\\+?[0-9\\s\\-()]{10,20}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (SessionUtil.isLoggedIn(request)) {
            redirectBasedOnRole(request, response);
            return;
        }
        forwardToJsp("/auth/register.jsp", request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String roleParam = request.getParameter("role");

        // Validation
        StringBuilder errors = new StringBuilder();

        if (email == null || email.trim().isEmpty()) {
            errors.append("Email is required. ");
        } else if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
            errors.append("Invalid email format. ");
        } else if (userDAO.findByEmail(email.trim().toLowerCase()).isPresent()) {
            errors.append("Email already registered. ");
        }

        if (password == null || password.length() < 8) {
            errors.append("Password must be at least 8 characters. ");
        }

        if (!password.equals(confirmPassword)) {
            errors.append("Passwords do not match. ");
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            errors.append("Full name is required. ");
        }

        if (phone != null && !phone.trim().isEmpty() && !PHONE_PATTERN.matcher(phone.trim()).matches()) {
            errors.append("Invalid phone number format. ");
        }

        User.Role role = User.Role.ATTENDEE;
        if (roleParam != null) {
            try {
                role = User.Role.valueOf(roleParam.toUpperCase());
            } catch (IllegalArgumentException e) {
                role = User.Role.ATTENDEE;
            }
        }

        if (errors.length() > 0) {
            addErrorMessage(request, errors.toString());
            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.setAttribute("role", role.name());
            forwardToJsp("/auth/register.jsp", request, response);
            return;
        }

        User user = new User(email.trim().toLowerCase(), PasswordUtil.hashPassword(password), fullName.trim(), role);
        user.setPhone(phone != null ? phone.trim() : null);
        user.setAddress(address != null ? address.trim() : null);
        userDAO.save(user);

        addSuccessMessage(request, "Registration successful! Please login.");
        redirect(request, response, "/login");
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
