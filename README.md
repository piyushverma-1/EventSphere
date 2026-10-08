# EventSphere

A comprehensive **Event Management System** built with Java Servlets, JDBC, MySQL, HTML, CSS, and JavaScript.

[![Java](https://img.shields.io/badge/Java-11%2B-blue)](https://www.oracle.com/java/)
[![Maven](https://img.shields.io/badge/Maven-3.6%2B-red)](https://maven.apache.org/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-orange)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## 🚀 Quick Start Commands

### One-Liner to Run Everything (PowerShell):
```powershell
cd "C:\Users\piyus\OneDrive\Documents\vibe coding\javaprojects\EventSphere"; mysql -u root -ppiyush -e "CREATE DATABASE IF NOT EXISTS eventsphere;"; mysql -u root -ppiyush eventsphere < src\main\resources\database_schema.sql; mvn clean package jetty:run
```

### Individual Commands (Run in Order):
```powershell
# 1. Navigate to project
cd "C:\Users\piyus\OneDrive\Documents\vibe coding\javaprojects\EventSphere"

# 2. Set up database
mysql -u root -ppiyush -e "CREATE DATABASE IF NOT EXISTS eventsphere;"
mysql -u root -ppiyush eventsphere < src\main\resources\database_schema.sql

# 3. Build and run
mvn clean package
mvn jetty:run

# 4. Access in browser
# Open: http://localhost:8080/
```

### Default Login Credentials:
- **Admin**: admin@eventsphere.com / admin123
- **Organizer**: organizer@eventsphere.com / organizer123  
- **Attendee**: attendee@eventsphere.com / attendee123

---

## Table of Contents

- [Features](#features)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Running the Project: Complete Step-by-Step Guide](#running-the-project-complete-step-by-step-guide)
  - [Option 1: Quick Setup with Embedded Jetty (Recommended)](#option-1-quick-setup-with-embedded-jetty-recommended)
  - [Option 2: Production Deployment with Apache Tomcat](#option-2-production-deployment-with-apache-tomcat)
  - [Troubleshooting Common Issues](#troubleshooting-common-issues)
  - [Quick Command Reference](#quick-command-reference)
  - [Verification Checklist](#verification-checklist)
  - [Security Notes for Production](#security-notes-for-production)
- [Configuration](#configuration)
- [Default Accounts](#default-accounts)
- [Project Structure](#project-structure)
- [API Endpoints](#api-endpoints)
- [Security Features](#security-features)
- [Testing](#testing)
- [License](#license)

---

## Features

### Authentication & User Management
- User registration and login with **BCrypt password hashing** (cost factor 12)
- **Role-based access control**: Admin, Organizer, Attendee
- Secure session management with **CSRF protection**
- User profile management
- Admin user management (create, edit, activate/deactivate, delete)

### Event Creation & Administration
- Organizers create, edit, and delete events
- Event details: title, description, date, time, venue, capacity
- Submit events for admin approval
- Admin approval/rejection workflow with status tracking

### Ticketing & Event Registration
- Organizers create ticket types with prices and quantities
- Attendees browse and filter approved events
- Registration with ticket selection
- Ticket availability management with concurrency control
- Unique booking reference and digital ticket generation
- View and cancel eligible registrations

### Dashboards & Communication
- **Admin dashboard**: system statistics, pending approvals
- **Organizer dashboard**: event performance, sales data
- **Attendee dashboard**: upcoming events, ticket history
- Organizer-to-attendee announcements
- Notification system for event updates

### Testing, Security & Deployment
- Form validation and error handling
- Authorization checks on all protected operations
- CSRF protection for all forms
- Responsive layouts with Bootstrap 5
- Accessibility improvements

---

## Technology Stack

| Layer | Technology |
|-------|------------|
| **Backend** | Java 11+, Servlet API 5.0 (Jakarta EE 9+), JDBC |
| **Database** | MySQL 8.0+ |
| **Frontend** | HTML5, CSS3, JavaScript (ES6+), Bootstrap 5 |
| **Security** | BCrypt, CSRF tokens, Session management |
| **Build Tool** | Maven 3.6+ |
| **Server** | Embedded Jetty 11 / Apache Tomcat 9+ |

---

## Prerequisites

| Software | Version | Download |
|----------|---------|----------|
| Java JDK | 11 or higher | [Adoptium](https://adoptium.net/) / [Oracle](https://www.oracle.com/java/technologies/downloads/) |
| MySQL Server | 8.0 or higher | [MySQL Downloads](https://dev.mysql.com/downloads/mysql/) |
| Apache Maven | 3.6 or higher | [Maven Downloads](https://maven.apache.org/download.cgi) |
| Apache Tomcat (optional) | 9.0 or higher | [Tomcat Downloads](https://tomcat.apache.org/download-90.cgi) |

> **Verify installations:**
> ```cmd
> java -version
> mysql --version
> mvn -version
> ```

---

## Running the Project: Complete Step-by-Step Guide

This guide provides clear, step-by-step instructions to run EventSphere on your local machine.

### Prerequisites Check
First, verify you have all required software installed:
```powershell
# Check Java installation
java -version

# Check MySQL installation  
mysql --version

# Check Maven installation (if not installed, see installation instructions below)
mvn -version
```

---

### 📦 **Option 1: Quick Setup with Embedded Jetty (Recommended)**

Follow these steps in order:

#### **Step 1: Navigate to Project Directory**
```powershell
cd "C:\Users\piyus\OneDrive\Documents\vibe coding\javaprojects\EventSphere"
```

#### **Step 2: Set Up MySQL Database**

**A. Start MySQL Service (if not running):**
```powershell
# Check if MySQL is running
Get-Service -Name MySQL*

# If not running, start it (Run as Administrator if needed)
Start-Service -Name MySQL80
```

**B. Create Database and Import Schema:**
```powershell
# Create database (default password is 'piyush' - change if different)
mysql -u root -ppiyush -e "CREATE DATABASE IF NOT EXISTS eventsphere CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Import schema and seed data
mysql -u root -ppiyush eventsphere < src\main\resources\database_schema.sql

# Verify database was created
mysql -u root -ppiyush -e "SHOW DATABASES LIKE 'eventsphere';"
```

#### **Step 3: Configure Database Connection**

**Edit these files with your MySQL credentials:**

**File 1:** `src\main\webapp\WEB-INF\web.xml` (lines 13-15)
```xml
<context-param>
    <param-name>dbUrl</param-name>
    <param-value>jdbc:mysql://localhost:3306/eventsphere?useSSL=false&amp;serverTimezone=UTC&amp;allowPublicKeyRetrieval=true</param-value>
</context-param>
<context-param>
    <param-name>dbUser</param-name>
    <param-value>root</param-value>
</context-param>
<context-param>
    <param-name>dbPassword</param-name>
    <param-value>piyush</param-value>  <!-- Change to your MySQL password -->
</context-param>
```

**File 2:** `src\main\java\com\eventsphere\util\DatabaseUtil.java` (around line 24)
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/eventsphere?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
private static final String DB_USER = "root";
private static final String DB_PASSWORD = "piyush";  // Change to your MySQL password
```

> **⚠️ Important:** In XML files (`web.xml`), you MUST escape `&` as `&amp;`. In Java files, use plain `&`.

#### **Step 4: Install Maven (If Not Installed)**

If `mvn -version` fails, install Maven:

**For Windows (PowerShell):**
```powershell
# Download Maven
$mavenUrl = "https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.9/apache-maven-3.9.9-bin.zip"
$tempFile = "$env:TEMP\maven.zip"
$installDir = "$env:USERPROFILE\maven"

Invoke-WebRequest -Uri $mavenUrl -OutFile $tempFile
Expand-Archive -Path $tempFile -DestinationPath $installDir -Force

# Add to PATH
$mavenBin = "$installDir\apache-maven-3.9.9\bin"
$env:PATH += ";$mavenBin"
[Environment]::SetEnvironmentVariable("PATH", "$env:PATH;$mavenBin", "User")

# Verify installation
mvn -version
```

#### **Step 5: Build and Run the Project**

**A. Clean and Build:**
```powershell
# Clean previous builds
mvn clean

# Compile the project
mvn compile

# Run tests (optional)
mvn test

# Package as WAR file
mvn package
```

**B. Start the Jetty Server:**
```powershell
# Run the embedded Jetty server on port 8080
mvn jetty:run
```

**Expected Success Output:**
```
[INFO] Started ServerConnector@...{HTTP/1.1, (http/1.1)}{0.0.0.0:8080}
[INFO] Started Server@...{STARTING}[11.0.20,sto=0] @4972ms
[INFO] Automatic redeployment disabled...
```

#### **Step 6: Access the Application**

Once you see "Started ServerConnector", open your browser:

| Page | URL | Default Credentials |
|------|-----|-------------------|
| **Home Page** | http://localhost:8080/ | - |
| **Login Page** | http://localhost:8080/login | See table below |

**Default User Accounts:**
| Role | Email | Password |
|------|-------|----------|
| **Admin** | admin@eventsphere.com | admin123 |
| **Organizer** | organizer@eventsphere.com | organizer123 |
| **Attendee** | attendee@eventsphere.com | attendee123 |

#### **Step 7: Stop the Server**
- Press `Ctrl + C` in the terminal where Jetty is running
- Or close the terminal window

---

### 🏗️ **Option 2: Production Deployment with Apache Tomcat**

#### **Step 1: Install and Configure Tomcat**
```powershell
# Download Tomcat 9.x from https://tomcat.apache.org/download-90.cgi
# Extract to C:\tools\apache-tomcat-9.x.x

# Set environment variables
[Environment]::SetEnvironmentVariable("CATALINA_HOME", "C:\tools\apache-tomcat-9.x.x", "User")
$env:PATH += ";C:\tools\apache-tomcat-9.x.x\bin"
```

#### **Step 2: Create DataSource Configuration**
Create `src\main\webapp\META-INF\context.xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Context>
    <Resource name="jdbc/EventSphere"
              auth="Container"
              type="javax.sql.DataSource"
              driverClassName="com.mysql.cj.jdbc.Driver"
              url="jdbc:mysql://localhost:3306/eventsphere?useSSL=false&amp;serverTimezone=UTC&amp;allowPublicKeyRetrieval=true"
              username="root"
              password="piyush"
              maxTotal="20"
              maxIdle="10"
              maxWaitMillis="10000"/>
</Context>
```

#### **Step 3: Build and Deploy**
```powershell
# Build WAR file
mvn clean package

# Copy WAR to Tomcat webapps directory
Copy-Item target\EventSphere.war "C:\tools\apache-tomcat-9.x.x\webapps\"

# Start Tomcat
& "C:\tools\apache-tomcat-9.x.x\bin\startup.bat"

# Access at: http://localhost:8080/EventSphere

# To stop Tomcat
& "C:\tools\apache-tomcat-9.x.x\bin\shutdown.bat"
```

---

### 🔧 **Troubleshooting Common Issues**

#### **Issue 1: Port 8080 Already in Use**
```powershell
# Find process using port 8080
netstat -ano | findstr :8080

# Kill the process (replace <PID> with actual process ID)
taskkill /PID <PID> /F
```

#### **Issue 2: MySQL Connection Failed**
```powershell
# Verify MySQL service is running
Get-Service -Name MySQL80

# Test MySQL connection manually
mysql -u root -ppiyush eventsphere -e "SHOW TABLES;"

# Check database exists
mysql -u root -ppiyush -e "SHOW DATABASES;"
```

#### **Issue 3: XML Parse Error "The reference to entity must end with ';' delimiter"**
This means `&` is not escaped in XML files. Fix in `web.xml`:
- Change `&` to `&amp;` (in URL parameters)
- Example: `useSSL=false&serverTimezone=UTC` → `useSSL=false&amp;serverTimezone=UTC`

#### **Issue 4: Maven Not Found**
- Ensure Maven `bin` directory is in PATH
- Restart terminal after adding to PATH
- Use full path: `"$env:USERPROFILE\maven\apache-maven-3.9.9\bin\mvn.cmd"`

#### **Issue 5: Java Version Mismatch**
```powershell
# Check Java version (needs to be 11 or higher)
java -version

# Set JAVA_HOME if needed
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Java\jdk-11", "User")
```

---

### 📋 **Quick Command Reference**

```powershell
# Complete setup sequence (run in order):
cd "C:\Users\piyus\OneDrive\Documents\vibe coding\javaprojects\EventSphere"
mysql -u root -ppiyush -e "CREATE DATABASE IF NOT EXISTS eventsphere;"
mysql -u root -ppiyush eventsphere < src\main\resources\database_schema.sql
mvn clean compile
mvn package
mvn jetty:run

# Then access: http://localhost:8080/
```

---

### ✅ **Verification Checklist**

- [ ] MySQL service is running (`Get-Service MySQL80`)
- [ ] Database `eventsphere` exists (`mysql -u root -ppiyush -e "SHOW DATABASES;"`)
- [ ] Database credentials are correct in `web.xml` and `DatabaseUtil.java`
- [ ] `&` is escaped as `&amp;` in `web.xml`
- [ ] Maven is installed (`mvn -version`)
- [ ] Port 8080 is free
- [ ] Server starts without errors (`mvn jetty:run`)
- [ ] Application loads in browser (`http://localhost:8080/`)

---

### 🚨 **Security Notes for Production**

1. **Change default passwords** in MySQL and application
2. **Use strong passwords** for database accounts
3. **Enable SSL** for database connections in production
4. **Set `secure="true"`** in `web.xml` cookie configuration when using HTTPS
5. **Regularly update** dependencies for security patches

---

*Need help? Check the troubleshooting section in [Running the Project](#running-the-project-complete-step-by-step-guide) or open an issue.*

## Configuration

### Database Connection Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `dbUrl` | JDBC connection URL | `jdbc:mysql://localhost:3306/eventsphere` |
| `dbUser` | MySQL username | `root` |
| `dbPassword` | MySQL password | *(required)* |

### Session & Security
- **Session timeout**: 30 minutes (configurable in `web.xml`)
- **CSRF token**: Auto-generated per session
- **Password hashing**: BCrypt with cost factor 12

---

## Default Accounts

| Role | Email | Password |
|------|-------|----------|
| **Admin** | admin@eventsphere.com | admin123 |
| **Organizer** | organizer@eventsphere.com | organizer123 |
| **Attendee** | attendee@eventsphere.com | attendee123 |

> **Important:** Change default passwords after first login in production.

---

## Project Structure

```
EventSphere/
├── pom.xml                          # Maven configuration
├── README.md                        # This file
├── src/
│   ├── main/
│   │   ├── java/com/eventsphere/
│   │   │   ├── model/               # Domain models (User, Event, Ticket, etc.)
│   │   │   ├── dao/                 # Data Access Objects
│   │   │   ├── servlet/             # Servlet controllers
│   │   │   └── util/                # Utility classes (DB, CSRF, Validation)
│   │   ├── resources/
│   │   │   └── database_schema.sql  # Database schema + seed data
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── web.xml          # Deployment descriptor
│   │       │   └── views/           # JSP views
│   │       │       ├── auth/        # Login, Register
│   │       │       ├── admin/       # Admin pages
│   │       │       ├── organizer/   # Organizer pages
│   │       │       ├── attendee/    # Attendee pages
│   │       │       ├── error/       # Error pages
│   │       │       └── validation/  # Ticket scanning
│   │       ├── css/                 # Stylesheets
│   │       ├── js/                  # JavaScript files
│   │       └── images/              # Static assets
│   └── test/
│       └── java/                    # Unit & integration tests
└── target/                          # Build output (WAR, classes)
```

---

## API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET/POST | `/login` | User login |
| GET/POST | `/register` | User registration |
| GET | `/logout` | User logout |
| GET/POST | `/profile` | Profile management |

### Admin
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/admin/dashboard` | Admin dashboard |
| GET/POST | `/admin/users/*` | User management |
| GET | `/admin/events/*` | Event management |
| POST | `/admin/events/{id}/approve` | Approve event |
| POST | `/admin/events/{id}/reject` | Reject event |

### Organizer
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/organizer/dashboard` | Organizer dashboard |
| GET/POST | `/organizer/events/*` | Event CRUD |
| POST | `/organizer/events/{id}/submit` | Submit for approval |
| GET/POST | `/organizer/announcements/*` | Announcements |

### Attendee
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/attendee/dashboard` | Attendee dashboard |
| GET | `/events` | Browse events |
| GET/POST | `/events/{id}/register` | Register for event |
| GET | `/attendee/tickets/*` | View/manage tickets |
| GET/POST | `/attendee/notifications/*` | Notifications |

### Validation
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET/POST | `/validate-ticket` | Validate/scan tickets |

---

## Security Features

- **Password Hashing**: BCrypt (cost factor 12)
- **CSRF Protection**: Session-scoped tokens on all forms
- **Session Security**: HttpOnly cookies, 30-min timeout
- **Access Control**: Role-based (Admin/Organizer/Attendee)
- **Authorization**: Checks on all protected resources
- **Input Validation**: Server-side validation & sanitization
- **SQL Injection Prevention**: PreparedStatements exclusively

---



## Testing

```cmd
REM Run all tests
mvn test

REM Run with verbose output
mvn test -X

REM Generate test reports
mvn surefire-report:report
```

---

---

## Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Check existing issues before creating new ones
- Provide steps to reproduce, expected vs actual behavior, and environment details

---

*Built with ❤️ for learning and production use.*