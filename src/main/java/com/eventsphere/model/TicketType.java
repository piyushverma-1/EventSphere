package com.eventsphere.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class TicketType {
    private Long id;
    private Long eventId;
    private String name;
    private String description;
    private BigDecimal price;
    private Integer quantity;
    private Integer soldCount;
    private LocalDateTime salesStart;
    private LocalDateTime salesEnd;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Transient field
    private String eventTitle;

    public TicketType() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getEventId() { return eventId; }
    public void setEventId(Long eventId) { this.eventId = eventId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public Integer getSoldCount() { return soldCount; }
    public void setSoldCount(Integer soldCount) { this.soldCount = soldCount; }

    public LocalDateTime getSalesStart() { return salesStart; }
    public void setSalesStart(LocalDateTime salesStart) { this.salesStart = salesStart; }

    public LocalDateTime getSalesEnd() { return salesEnd; }
    public void setSalesEnd(LocalDateTime salesEnd) { this.salesEnd = salesEnd; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }

    public Integer getAvailableCount() {
        return quantity - soldCount;
    }

    public boolean isOnSale(LocalDateTime now) {
        if (salesStart != null && now.isBefore(salesStart)) return false;
        if (salesEnd != null && now.isAfter(salesEnd)) return false;
        return getAvailableCount() > 0;
    }
}
