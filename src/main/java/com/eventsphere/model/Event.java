package com.eventsphere.model;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Event {
    private Long id;
    private Long organizerId;
    private String title;
    private String description;
    private LocalDate eventDate;
    private LocalTime eventTime;
    private String venue;
    private Integer capacity;
    private Status status;
    private String rejectionReason;
    private Long approvedBy;
    private LocalDateTime approvedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Transient fields for display
    private String organizerName;
    private Integer availableTickets;
    private Integer soldTickets;
    private String category = "Technology";

    public String getCategory() { return category != null ? category : "Technology"; }
    public void setCategory(String category) { this.category = category; }

    public String getStartTime() { return getFormattedEventTime(); }
    public String getEndTime() {
        if (eventTime == null) return "";
        return eventTime.plusHours(2).format(DateTimeFormatter.ofPattern("h:mm a"));
    }

    public enum Status {
        DRAFT, PENDING_APPROVAL, APPROVED, REJECTED, CANCELLED
    }

    public Event() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getOrganizerId() { return organizerId; }
    public void setOrganizerId(Long organizerId) { this.organizerId = organizerId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDate getEventDate() { return eventDate; }
    public void setEventDate(LocalDate eventDate) { this.eventDate = eventDate; }

    public LocalTime getEventTime() { return eventTime; }
    public void setEventTime(LocalTime eventTime) { this.eventTime = eventTime; }

    public String getVenue() { return venue; }
    public void setVenue(String venue) { this.venue = venue; }

    public Integer getCapacity() { return capacity; }
    public void setCapacity(Integer capacity) { this.capacity = capacity; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = rejectionReason; }

    public Long getApprovedBy() { return approvedBy; }
    public void setApprovedBy(Long approvedBy) { this.approvedBy = approvedBy; }

    public LocalDateTime getApprovedAt() { return approvedAt; }
    public void setApprovedAt(LocalDateTime approvedAt) { this.approvedAt = approvedAt; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getOrganizerName() { return organizerName; }
    public void setOrganizerName(String organizerName) { this.organizerName = organizerName; }

    public Integer getAvailableTickets() { return availableTickets; }
    public void setAvailableTickets(Integer availableTickets) { this.availableTickets = availableTickets; }

    public Integer getSoldTickets() { return soldTickets; }
    public void setSoldTickets(Integer soldTickets) { this.soldTickets = soldTickets; }

    public boolean isApproved() { return status == Status.APPROVED; }
    public boolean isPending() { return status == Status.PENDING_APPROVAL; }
    public boolean isDraft() { return status == Status.DRAFT; }
    public boolean isRejected() { return status == Status.REJECTED; }
    public boolean isCancelled() { return status == Status.CANCELLED; }

    // Helper methods for JSP date formatting
    public String getFormattedEventDate() {
        if (eventDate == null) return "";
        return eventDate.format(DateTimeFormatter.ofPattern("MMM d, yyyy"));
    }

    public String getFormattedEventTime() {
        if (eventTime == null) return "";
        return eventTime.format(DateTimeFormatter.ofPattern("h:mm a"));
    }

    public String getFormattedEventDateTime() {
        if (eventDate == null) return "";
        String dateStr = getFormattedEventDate();
        String timeStr = getFormattedEventTime();
        if (timeStr.isEmpty()) return dateStr;
        return dateStr + " at " + timeStr;
    }

    public String getFormattedApprovedAt() {
        if (approvedAt == null) return "";
        return approvedAt.format(DateTimeFormatter.ofPattern("MMM d, yyyy 'at' h:mm a"));
    }

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "";
        return createdAt.format(DateTimeFormatter.ofPattern("MMM d, yyyy 'at' h:mm a"));
    }
}
