# ==============================================================================
# Root Dockerfile for Digital Krishi Officer - Java Spring Boot Backend
# Supports building whether Root Directory is empty or root
# ==============================================================================

FROM maven:3.9-eclipse-temurin-17-alpine AS builder
WORKDIR /app

# Copy backend pom and resolve dependencies
COPY backend/pom.xml .
RUN mvn dependency:go-offline -B

# Copy backend sources and build production jar
COPY backend/src ./src
RUN mvn clean package -DskipTests

# Production JRE runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/digital-krishi-officer-backend-1.0.0.jar app.jar

ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]
