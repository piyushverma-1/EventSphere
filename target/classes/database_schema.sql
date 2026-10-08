-- EventSphere Database Schema
-- Run this script to create the database and all tables

DROP DATABASE IF EXISTS eventsphere;
CREATE DATABASE eventsphere CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE eventsphere;

-- Users table
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'ORGANIZER', 'ATTENDEE') NOT NULL DEFAULT 'ATTENDEE',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_active (is_active)
);

-- Events table
CREATE TABLE events (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    organizer_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    event_date DATE NOT NULL,
    event_time TIME NOT NULL,
    venue VARCHAR(500) NOT NULL,
    capacity INT NOT NULL DEFAULT 0,
    status ENUM('DRAFT', 'PENDING_APPROVAL', 'APPROVED', 'REJECTED', 'CANCELLED') NOT NULL DEFAULT 'DRAFT',
    rejection_reason TEXT,
    approved_by BIGINT NULL,
    approved_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (organizer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_organizer (organizer_id),
    INDEX idx_status (status),
    INDEX idx_event_date (event_date),
    INDEX idx_created (created_at)
);

-- Ticket Types table
CREATE TABLE ticket_types (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    event_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    quantity INT NOT NULL DEFAULT 0,
    sold_count INT NOT NULL DEFAULT 0,
    sales_start TIMESTAMP NULL,
    sales_end TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    INDEX idx_event (event_id)
);

-- Registrations/Bookings table
CREATE TABLE registrations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_reference VARCHAR(36) NOT NULL UNIQUE,
    attendee_id BIGINT NOT NULL,
    event_id BIGINT NOT NULL,
    ticket_type_id BIGINT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('CONFIRMED', 'CANCELLED', 'WAITLISTED') NOT NULL DEFAULT 'CONFIRMED',
    payment_status ENUM('PENDING', 'PAID', 'REFUNDED', 'FAILED') NOT NULL DEFAULT 'PENDING',
    cancelled_at TIMESTAMP NULL,
    cancellation_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (attendee_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (ticket_type_id) REFERENCES ticket_types(id) ON DELETE CASCADE,
    INDEX idx_attendee (attendee_id),
    INDEX idx_event (event_id),
    INDEX idx_booking_ref (booking_reference),
    INDEX idx_status (status),
    INDEX idx_created (created_at)
);

-- Digital Tickets table
CREATE TABLE digital_tickets (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    registration_id BIGINT NOT NULL,
    ticket_code VARCHAR(50) NOT NULL UNIQUE,
    qr_code_data TEXT,
    is_used BOOLEAN NOT NULL DEFAULT FALSE,
    used_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (registration_id) REFERENCES registrations(id) ON DELETE CASCADE,
    INDEX idx_registration (registration_id),
    INDEX idx_ticket_code (ticket_code)
);

-- Announcements table
CREATE TABLE announcements (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    event_id BIGINT NOT NULL,
    organizer_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_sent BOOLEAN NOT NULL DEFAULT FALSE,
    sent_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (organizer_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_event (event_id),
    INDEX idx_organizer (organizer_id)
);

-- Notifications table (for attendees)
CREATE TABLE notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    announcement_id BIGINT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    read_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (announcement_id) REFERENCES announcements(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_read (is_read)
);

-- Insert default admin user (password: admin123)
-- BCrypt hash for 'admin123' with cost 12
INSERT INTO users (email, password_hash, full_name, role, is_active) VALUES
('admin@eventsphere.com', '$2a$12$uWRBNrOD9CupQuIwR7vWmuY52Y8RdQXkYz4t11d5oaNCiw6JLwa5m', 'System Administrator', 'ADMIN', TRUE);

-- Insert sample organizer (password: organizer123)
INSERT INTO users (email, password_hash, full_name, role, is_active) VALUES
('organizer@eventsphere.com', '$2a$12$4PN7klZU.lpuMqkLHKrqZu7RL0BSSwN9HHdoeUgRFHXd2oqFD8uiC', 'Sample Organizer', 'ORGANIZER', TRUE);

-- Insert sample attendee (password: attendee123)
INSERT INTO users (email, password_hash, full_name, role, is_active) VALUES
('attendee@eventsphere.com', '$2a$12$IkPHUsydIPM2tay/b1qy9O42xDSvj3BcFJifqYU1PyX.BM1HXJEAq', 'Sample Attendee', 'ATTENDEE', TRUE);