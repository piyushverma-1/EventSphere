USE eventsphere;
UPDATE users SET password_hash = '$2a$12$uWRBNrOD9CupQuIwR7vWmuY52Y8RdQXkYz4t11d5oaNCiw6JLwa5m' WHERE email = 'admin@eventsphere.com';
UPDATE users SET password_hash = '$2a$12$4PN7klZU.lpuMqkLHKrqZu7RL0BSSwN9HHdoeUgRFHXd2oqFD8uiC' WHERE email = 'organizer@eventsphere.com';
UPDATE users SET password_hash = '$2a$12$IkPHUsydIPM2tay/b1qy9O42xDSvj3BcFJifqYU1PyX.BM1HXJEAq' WHERE email = 'attendee@eventsphere.com';
