package com.eventsphere.dao;

import com.eventsphere.model.Registration;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

public class RegistrationTest {

    @Test
    public void testRegistrationStatus() {
        Registration reg = new Registration();
        reg.setStatus(Registration.Status.CONFIRMED);
        assertTrue(reg.isConfirmed());
        
        reg.setStatus(Registration.Status.CANCELLED);
        assertTrue(reg.isCancelled());
        
        reg.setStatus(Registration.Status.WAITLISTED);
        assertTrue(reg.isWaitlisted());
    }

    @Test
    public void testCanCancelLogic() {
        Registration reg = new Registration();
        reg.setStatus(Registration.Status.CONFIRMED);
        reg.setPaymentStatus(Registration.PaymentStatus.PAID);
        assertTrue(reg.canCancel());

        // Cannot cancel if already refunded
        reg.setPaymentStatus(Registration.PaymentStatus.REFUNDED);
        assertFalse(reg.canCancel());

        // Cannot cancel if cancelled
        reg.setPaymentStatus(Registration.PaymentStatus.PAID);
        reg.setStatus(Registration.Status.CANCELLED);
        assertFalse(reg.canCancel());

        // Cannot cancel if waitlisted
        reg.setStatus(Registration.Status.WAITLISTED);
        assertFalse(reg.canCancel());
    }

    @Test
    public void testTotalPriceCalculation() {
        BigDecimal price = new BigDecimal("99.99");
        int quantity = 3;
        BigDecimal total = price.multiply(BigDecimal.valueOf(quantity));
        assertEquals(new BigDecimal("299.97"), total);
    }
}
