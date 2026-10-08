package com.eventsphere.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Registration {
    private Long id;
    private String bookingReference;
    private Long attendeeId;
    private Long eventId;
    private Long ticketTypeId;
    private Integer quantity;
    private BigDecimal totalPrice;
    private Status status;
    private PaymentStatus paymentStatus;
    private LocalDateTime cancelledAt;
    private String cancellationReason;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Transient fields for display
    private String attendeeName;
    private String attendeeEmail;
    private String eventTitle;
    private String ticketTypeName;
    private String ticketCode;

    public enum Status {
        CONFIRMED, CANCELLED, WAITLISTED
    }

    public enum PaymentStatus {
        PENDING, PAID, REFUNDED, FAILED
    }

    public Registration() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getBookingReference() { return bookingReference; }
    public void setBookingReference(String bookingReference) { this.bookingReference = bookingReference; }

    public Long getAttendeeId() { return attendeeId; }
    public void setAttendeeId(Long attendeeId) { this.attendeeId = attendeeId; }

    public Long getEventId() { return eventId; }
    public void setEventId(Long eventId) { this.eventId = eventId; }

    public Long getTicketTypeId() { return ticketTypeId; }
    public void setTicketTypeId(Long ticketTypeId) { this.ticketTypeId = ticketTypeId; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public PaymentStatus getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(PaymentStatus paymentStatus) { this.paymentStatus = paymentStatus; }

    public LocalDateTime getCancelledAt() { return cancelledAt; }
    public void setCancelledAt(LocalDateTime cancelledAt) { this.cancelledAt = cancelledAt; }

    public String getCancellationReason() { return cancellationReason; }
    public void setCancellationReason(String cancellationReason) { this.cancellationReason = cancellationReason; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getAttendeeName() { return attendeeName; }
    public void setAttendeeName(String attendeeName) { this.attendeeName = attendeeName; }

    public String getAttendeeEmail() { return attendeeEmail; }
    public void setAttendeeEmail(String attendeeEmail) { this.attendeeEmail = attendeeEmail; }

    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }

    public String getTicketTypeName() { return ticketTypeName; }
    public void setTicketTypeName(String ticketTypeName) { this.ticketTypeName = ticketTypeName; }

    public String getTicketCode() { return ticketCode; }
    public void setTicketCode(String ticketCode) { this.ticketCode = ticketCode; }

    public boolean isConfirmed() { return status == Status.CONFIRMED; }
    public boolean isCancelled() { return status == Status.CANCELLED; }
    public boolean isWaitlisted() { return status == Status.WAITLISTED; }
    public boolean canCancel() {
        return status == Status.CONFIRMED && paymentStatus != PaymentStatus.REFUNDED;
    }

    // Helper methods for JSP date formatting
    public String getFormattedCreatedAt() {
        if (createdAt == null) return "";
        return createdAt.format(java.time.format.DateTimeFormatter.ofPattern("MMM d, yyyy"));
    }

    public String getFormattedCancelledAt() {
        if (cancelledAt == null) return "";
        return cancelledAt.format(java.time.format.DateTimeFormatter.ofPattern("MMM d, yyyy 'at' h:mm a"));
    }
}
