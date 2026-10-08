package com.eventsphere.dao;

import com.eventsphere.model.User;
import com.eventsphere.util.PasswordUtil;
import org.junit.jupiter.api.*;

import jakarta.servlet.ServletContext;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class UserDAOTest {

    private static ServletContext mockContext;

    @BeforeAll
    static void setupContext() {
        mockContext = mock(ServletContext.class);
        when(mockContext.getInitParameter("dbUrl")).thenReturn("jdbc:mysql://localhost:3306/eventsphere_test?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
        when(mockContext.getInitParameter("dbUser")).thenReturn("test_user");
        when(mockContext.getInitParameter("dbPassword")).thenReturn("test_pass");
    }

    @Test
    public void testPasswordHashing() {
        String password = "testPassword123";
        String hash = PasswordUtil.hashPassword(password);
        Assertions.assertTrue(hash.startsWith("$2a$"));
        Assertions.assertTrue(PasswordUtil.verifyPassword(password, hash));
        Assertions.assertFalse(PasswordUtil.verifyPassword("wrongPassword", hash));
    }

    @Test
    public void testPasswordNull() {
        String hash = PasswordUtil.hashPassword("testPass");
        Assertions.assertFalse(PasswordUtil.verifyPassword(null, hash));
        Assertions.assertFalse(PasswordUtil.verifyPassword("testPass", null));
    }

    @Test
    public void testUserCreation() {
        User user = new User();
        user.setEmail("test@example.com");
        user.setPasswordHash(PasswordUtil.hashPassword("password123"));
        user.setFullName("Test User");
        user.setRole(User.Role.ATTENDEE);
        user.setIsActive(true);

        Assertions.assertEquals("test@example.com", user.getEmail());
        Assertions.assertTrue(PasswordUtil.verifyPassword("password123", user.getPasswordHash()));
        Assertions.assertTrue(user.isAttendee());
        Assertions.assertTrue(user.getIsActive());
    }

    @Test
    public void testUserRoleChecks() {
        User admin = new User("admin@test.com", "hash", "Admin User", User.Role.ADMIN);
        User organizer = new User("org@test.com", "hash", "Org User", User.Role.ORGANIZER);
        User attendee = new User("att@test.com", "hash", "Att User", User.Role.ATTENDEE);

        Assertions.assertTrue(admin.isAdmin());
        Assertions.assertFalse(admin.isAttendee());

        Assertions.assertTrue(organizer.isOrganizer());
        Assertions.assertFalse(organizer.isAdmin());

        Assertions.assertTrue(attendee.isAttendee());
        Assertions.assertFalse(attendee.isOrganizer());
    }
}
