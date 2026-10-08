package com.eventsphere.util;

import com.eventsphere.model.User;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class PasswordUtilTest {

    @Test
    public void testHashPassword() {
        String password = "testPassword123";
        String hash = PasswordUtil.hashPassword(password);
        
        assertNotNull(hash);
        assertTrue(hash.startsWith("$2a$"));
        assertTrue(hash.length() >= 59);
    }

    @Test
    public void testVerifyPasswordCorrect() {
        String password = "mySecretPassword";
        String hash = PasswordUtil.hashPassword(password);
        
        assertTrue(PasswordUtil.verifyPassword(password, hash));
    }

    @Test
    public void testVerifyPasswordIncorrect() {
        String password = "mySecretPassword";
        String hash = PasswordUtil.hashPassword(password);
        
        assertFalse(PasswordUtil.verifyPassword("wrongPassword", hash));
    }

    @Test
    public void testVerifyPasswordNullInputs() {
        String hash = PasswordUtil.hashPassword("test");
        
        assertFalse(PasswordUtil.verifyPassword(null, hash));
        assertFalse(PasswordUtil.verifyPassword("test", null));
        assertFalse(PasswordUtil.verifyPassword(null, null));
    }

    @Test
    public void testInvalidHash() {
        assertFalse(PasswordUtil.verifyPassword("test", "invalid-hash"));
    }
}
