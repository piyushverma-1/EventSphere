package com.eventsphere.dao;

import com.eventsphere.model.Event;
import com.eventsphere.model.Registration;
import com.eventsphere.model.TicketType;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import static org.junit.jupiter.api.Assertions.*;

public class ModelTest {

    @Test
    public void testEventModel() {
        Event event = new Event();
        event.setTitle("Test Event");
        event.setDescription("Test Description");
        event.setEventDate(LocalDate.now().plusDays(30));
        event.setEventTime(LocalTime.of(14, 30));
        event.setVenue("Test Venue");
        event.setCapacity(100);
        event.setStatus(Event.Status.DRAFT);

        assertEquals("Test Event", event.getTitle());
        assertTrue(event.isDraft());
        assertFalse(event.isApproved());
    }

    @Test
    public void testEventStatusTransitions() {
        Event event = new Event();
        event.setStatus(Event.Status.DRAFT);
        assertTrue(event.isDraft());
        assertFalse(event.isPending());

        event.setStatus(Event.Status.PENDING_APPROVAL);
        assertTrue(event.isPending());
        assertFalse(event.isApproved());

        event.setStatus(Event.Status.APPROVED);
        assertTrue(event.isApproved());
        assertFalse(event.isPending());
    }

    @Test
    public void testRegistrationModel() {
        Registration reg = new Registration();
        reg.setBookingReference("EVT-TEST123");
        reg.setQuantity(2);
        reg.setTotalPrice(new BigDecimal("100.00"));
        reg.setStatus(Registration.Status.CONFIRMED);
        reg.setPaymentStatus(Registration.PaymentStatus.PAID);

        assertEquals("EVT-TEST123", reg.getBookingReference());
        assertTrue(reg.isConfirmed());
        assertTrue(reg.canCancel());
    }

    @Test
    public void testRegistrationCancelLogic() {
        Registration reg = new Registration();
        reg.setStatus(Registration.Status.CONFIRMED);
        reg.setPaymentStatus(Registration.PaymentStatus.PAID);

        assertTrue(reg.canCancel());

        reg.setStatus(Registration.Status.CANCELLED);
        assertFalse(reg.canCancel());

        reg.setStatus(Registration.Status.CONFIRMED);
        reg.setPaymentStatus(Registration.PaymentStatus.REFUNDED);
        assertFalse(reg.canCancel());
    }

    @Test
    public void testTicketTypeAvailability() {
        TicketType ticket = new TicketType();
        ticket.setQuantity(100);
        ticket.setSoldCount(30);

        assertEquals(70, ticket.getAvailableCount());
        assertTrue(ticket.getAvailableCount() > 0);
    }

    @Test
    public void testTicketTypeOnSale() {
        TicketType ticket = new TicketType();
        ticket.setQuantity(100);
        ticket.setSoldCount(0);
        ticket.setSalesStart(LocalDateTime.now().minusHours(1));
        ticket.setSalesEnd(LocalDateTime.now().plusHours(24));

        assertTrue(ticket.isOnSale(LocalDateTime.now()));

        ticket.setSalesStart(LocalDateTime.now().plusHours(1));
        assertFalse(ticket.isOnSale(LocalDateTime.now()));

        ticket.setSalesStart(null);
        ticket.setSalesEnd(null);
        assertTrue(ticket.isOnSale(LocalDateTime.now()));
    }
}
