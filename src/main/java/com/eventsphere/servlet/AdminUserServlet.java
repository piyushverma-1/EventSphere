package com.eventsphere.servlet;

import com.eventsphere.model.User;
import com.eventsphere.util.PasswordUtil;
import com.eventsphere.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@WebServlet("/admin/users/*")
public class AdminUserServlet extends BaseServlet {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^\\+?[0-9\\s\\-()]{10,20}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) return;

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || "/".equals(pathInfo) || "/list".equals(pathInfo)) {
            listUsers(request, response);
        } else if (pathInfo.matches("/\\d+")) {
            viewUser(request, response, Long.parseLong(pathInfo.substring(1)));
        } else if ("/create".equals(pathInfo)) {
            showCreateForm(request, response);
        } else if (pathInfo.matches("/\\d+/edit")) {
            showEditForm(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 5)));
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) return;

        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

        if ("/create".equals(pathInfo) || ("/".equals(pathInfo) && "create".equals(action))) {
            createUser(request, response);
        } else if (pathInfo != null && pathInfo.matches("/\\d+/edit") && "update".equals(action)) {
            updateUser(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 5)));
        } else if (pathInfo != null && pathInfo.matches("/\\d+/toggle")) {
            toggleUserStatus(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 7)));
        } else if (pathInfo != null && pathInfo.matches("/\\d+/delete")) {
            deleteUser(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 7)));
        } else if (pathInfo != null && pathInfo.matches("/\\d+/reset-password")) {
            resetPassword(request, response, Long.parseLong(pathInfo.substring(1, pathInfo.length() - 14)));
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String roleFilter = request.getParameter("role");
        String statusFilter = request.getParameter("status");
        String search = request.getParameter("search");

        List<User> users;
        if (search != null && !search.trim().isEmpty()) {
            users = userDAO.findAll().stream()
                .filter(u -> u.getEmail().toLowerCase().contains(search.toLowerCase()) 
                          || u.getFullName().toLowerCase().contains(search.toLowerCase()))
                .collect(Collectors.toList());
        } else if (roleFilter != null && !roleFilter.isEmpty()) {
            users = userDAO.findByRole(User.Role.valueOf(roleFilter.toUpperCase()));
        } else {
            users = userDAO.findAll();
        }

        if (statusFilter != null && !statusFilter.isEmpty()) {
            boolean active = "active".equals(statusFilter);
            users = users.stream().filter(u -> u.getIsActive() == active).collect(Collectors.toList());
        }

        request.setAttribute("users", users);
        request.setAttribute("roleFilter", roleFilter);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("search", search);
        request.setAttribute("totalUsers", userDAO.countTotal());
        request.setAttribute("adminCount", userDAO.countByRole(User.Role.ADMIN));
        request.setAttribute("organizerCount", userDAO.countByRole(User.Role.ORGANIZER));
        request.setAttribute("attendeeCount", userDAO.countByRole(User.Role.ATTENDEE));

        forwardToJsp("/admin/users/list.jsp", request, response);
    }

    private void viewUser(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws ServletException, IOException {
        userDAO.findById(id).ifPresentOrElse(user -> {
            request.setAttribute("user", user);
            try { forwardToJsp("/admin/users/view.jsp", request, response); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        forwardToJsp("/admin/users/form.jsp", request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws ServletException, IOException {
        userDAO.findById(id).ifPresentOrElse(user -> {
            request.setAttribute("user", user);
            request.setAttribute("isEdit", true);
            try { forwardToJsp("/admin/users/form.jsp", request, response); } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String roleParam = request.getParameter("role");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String isActiveParam = request.getParameter("isActive");

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

        if (fullName == null || fullName.trim().isEmpty()) {
            errors.append("Full name is required. ");
        }

        if (phone != null && !phone.trim().isEmpty() && !PHONE_PATTERN.matcher(phone.trim()).matches()) {
            errors.append("Invalid phone number format. ");
        }

        User.Role role = User.Role.ATTENDEE;
        if (roleParam != null) {
            try { role = User.Role.valueOf(roleParam.toUpperCase()); } catch (IllegalArgumentException e) {}
        }

        if (errors.length() > 0) {
            addErrorMessage(request, errors.toString());
            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("address", address);
            request.setAttribute("role", role.name());
            forwardToJsp("/admin/users/form.jsp", request, response);
            return;
        }

        User user = new User(email.trim().toLowerCase(), PasswordUtil.hashPassword(password), fullName.trim(), role);
        user.setPhone(phone != null ? phone.trim() : null);
        user.setAddress(address != null ? address.trim() : null);
        user.setIsActive(isActiveParam != null && "on".equals(isActiveParam));
        userDAO.save(user);

        addSuccessMessage(request, "User created successfully!");
        redirect(request, response, "/admin/users");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws ServletException, IOException {
        userDAO.findById(id).ifPresentOrElse(user -> {
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String roleParam = request.getParameter("role");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String isActiveParam = request.getParameter("isActive");

            StringBuilder errors = new StringBuilder();

            if (email == null || email.trim().isEmpty()) {
                errors.append("Email is required. ");
            } else if (!EMAIL_PATTERN.matcher(email.trim()).matches()) {
                errors.append("Invalid email format. ");
            } else if (!email.trim().toLowerCase().equals(user.getEmail())) {
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
                try {
                    addErrorMessage(request, errors.toString());
                    request.setAttribute("user", user);
                    request.setAttribute("isEdit", true);
                    forwardToJsp("/admin/users/form.jsp", request, response);
                } catch (Exception e) {}
                return;
            }

            user.setEmail(email.trim().toLowerCase());
            user.setFullName(fullName.trim());
            if (roleParam != null) {
                try { user.setRole(User.Role.valueOf(roleParam.toUpperCase())); } catch (IllegalArgumentException e) {}
            }
            user.setPhone(phone != null ? phone.trim() : null);
            user.setAddress(address != null ? address.trim() : null);
            user.setIsActive(isActiveParam != null && "on".equals(isActiveParam));
            userDAO.update(user);

            try {
                addSuccessMessage(request, "User updated successfully!");
                redirect(request, response, "/admin/users");
            } catch (Exception e) {}
        }, () -> {
            try { response.sendError(HttpServletResponse.SC_NOT_FOUND); } catch (Exception e) {}
        });
    }

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        User currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser.getId().equals(id)) {
            addErrorMessage(request, "Cannot deactivate your own account");
            redirect(request, response, "/admin/users");
            return;
        }

        userDAO.findById(id).ifPresent(user -> {
            user.setIsActive(!user.getIsActive());
            userDAO.update(user);
            try {
                addSuccessMessage(request, "User " + (user.getIsActive() ? "activated" : "deactivated") + " successfully!");
                redirect(request, response, "/admin/users");
            } catch (Exception e) {}
        });
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        User currentUser = SessionUtil.getCurrentUser(request);
        if (currentUser.getId().equals(id)) {
            addErrorMessage(request, "Cannot delete your own account");
            redirect(request, response, "/admin/users");
            return;
        }

        if (userDAO.delete(id)) {
            addSuccessMessage(request, "User deleted successfully!");
        } else {
            addErrorMessage(request, "Failed to delete user");
        }
        redirect(request, response, "/admin/users");
    }

    private void resetPassword(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws IOException {
        userDAO.findById(id).ifPresent(user -> {
            String newPassword = "TempPass" + System.currentTimeMillis() % 10000;
            userDAO.updatePassword(id, PasswordUtil.hashPassword(newPassword));
            try {
                addSuccessMessage(request, "Password reset to: " + newPassword + " (Share securely)");
                redirect(request, response, "/admin/users");
            } catch (Exception e) {}
        });
    }
}
