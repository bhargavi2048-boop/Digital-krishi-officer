@echo off
title Digital Krishi Officer - Java Spring Boot Backend Server
echo ======================================================================
echo    Starting Digital Krishi Officer Backend (Spring Boot 3 + Java 17)
echo ======================================================================
echo.
echo Database: In-memory H2 SQL Database (krishidb)
echo Swagger Documentation: http://localhost:8080/swagger-ui.html
echo H2 Web Console:        http://localhost:8080/h2-console
echo API Health Check:      http://localhost:8080/api/health
echo.
cd /d "%~dp0"
mvn spring-boot:run
pause
