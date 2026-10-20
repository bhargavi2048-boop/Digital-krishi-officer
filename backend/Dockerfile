# ==============================================================================
# Dockerfile for Digital Krishi Officer - Java Spring Boot Backend
# Multi-stage build for optimal performance and minimal image size
# ==============================================================================

# Stage 1: Build the application using Maven & Eclipse Temurin JDK 17
FROM maven:3.9-eclipse-temurin-17-alpine AS builder
WORKDIR /app

# Cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build production jar
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Production JRE runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy built JAR from builder stage (using wildcard to ensure exact match)
COPY --from=builder /app/target/*.jar app.jar

# Render assigns dynamic port via PORT environment variable
ENV PORT=8080
EXPOSE 8080

# Shell wrapper ensures ${PORT} and 0.0.0.0 are bound accurately in any container environment
ENTRYPOINT ["sh", "-c", "java -Djava.security.egd=file:/dev/./urandom -Dserver.port=${PORT:-8080} -Dserver.address=0.0.0.0 -jar app.jar"]
