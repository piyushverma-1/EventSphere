# Agent Instructions

## Build & Test
- Build: `mvn clean package`
- Run with embedded Tomcat: `mvn tomcat7:run` (requires `tomcat7-maven-plugin`)
- Deploy WAR to Tomcat server
- Run tests: `mvn test`

## Database Setup
1. Create database: `CREATE DATABASE eventsphere CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
2. Run schema: `mysql -u root -p < src/main/resources/database_schema.sql`
3. Default users:
   - Admin: admin@eventsphere.com (password: admin123)
   - Organizer: organizer@eventsphere.com (password: organizer123)
   - Attendee: attendee@eventsphere.com (password: attendee123)

## Development Notes
- All servlets extend BaseServlet for common functionality
- Database access through DAO pattern
- Passwords hashed with BCrypt (cost 12)
- CSRF protection enabled for all forms
- Session timeout: 30 minutes
- Use try-with-resources for database operations
- All JSTL tags use javax.servlet.jsp.jstl

## Project Structure
- `src/main/java/com/eventsphere/model/` - Domain models
- `src/main/java/com/eventsphere/dao/` - Data Access Objects
- `src/main/java/com/eventsphere/servlet/` - Servlet controllers
- `src/main/java/com/eventsphere/util/` - Utility classes
- `src/main/webapp/WEB-INF/views/` - JSP views
- `src/main/resources/` - Configuration and SQL scripts