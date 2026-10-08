# EventSphere - Quick Start Guide

## Essential Commands to Run the Project

### Prerequisites Check:
```powershell
java -version        # Should show Java 11+
mysql --version      # Should show MySQL 8+
mvn -version         # Should show Maven 3.6+
```

### Complete Setup (Run in Order):

#### 1. Navigate to Project:
```powershell
cd "C:\Users\piyus\OneDrive\Documents\vibe coding\javaprojects\EventSphere"
```

#### 2. Setup Database:
```powershell
# Create database (password: piyush)
mysql -u root -ppiyush -e "CREATE DATABASE IF NOT EXISTS eventsphere CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Import schema and data
mysql -u root -ppiyush eventsphere < src\main\resources\database_schema.sql

# Verify database
mysql -u root -ppiyush -e "SHOW DATABASES LIKE 'eventsphere';"
```

#### 3. Build and Run:
```powershell
# Clean and build
mvn clean compile

# Package as WAR
mvn package

# Start Jetty server on port 8080
mvn jetty:run
```

#### 4. Access Application:
- **URL**: http://localhost:8080/
- **Login Page**: http://localhost:8080/login

### Default Login Credentials:
| Role | Email | Password |
|------|-------|----------|
| **Admin** | admin@eventsphere.com | admin123 |
| **Organizer** | organizer@eventsphere.com | organizer123 |
| **Attendee** | attendee@eventsphere.com | attendee123 |

### One-Liner Command (Run Everything):
```powershell
cd "C:\Users\piyus\OneDrive\Documents\vibe coding\javaprojects\EventSphere" && mysql -u root -ppiyush -e "CREATE DATABASE IF NOT EXISTS eventsphere;" && mysql -u root -ppiyush eventsphere < src\main\resources\database_schema.sql && mvn clean package jetty:run
```

### Troubleshooting Quick Fixes:

1. **Port 8080 in use**: 
   ```powershell
   netstat -ano | findstr :8080
   taskkill /PID <PID> /F
   ```

2. **MySQL not running**:
   ```powershell
   Get-Service -Name MySQL80
   Start-Service -Name MySQL80
   ```

3. **XML parse error**: Change `&` to `&amp;` in `web.xml`

4. **Maven not found**: Use full path: `"$env:USERPROFILE\maven\apache-maven-3.9.9\bin\mvn.cmd"`

### Stop the Server:
- Press `Ctrl + C` in the terminal running Jetty

---

**For detailed instructions, see [README.md](README.md)**