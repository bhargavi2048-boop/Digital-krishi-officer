# 🌱 Digital Krishi Officer — Java Spring Boot Backend

> **Course:** Object-Oriented Programming (OOP) using Java (2nd Year Mini Project)  
> **Tech Stack:** Java 17, Spring Boot 3.3.4, Spring Data JPA / Hibernate, H2 In-Memory SQL Database, SpringDoc OpenAPI (Swagger UI), JUnit 5.

---

## 📌 Architecture & OOP Concepts Demonstrated

This backend exemplifies textbook Object-Oriented Programming principles:

| OOP Concept | Implementation in Project | File Path |
|---|---|---|
| **Encapsulation** | Private fields, validation annotations (`@NotNull`, `@NotBlank`), public getters/setters, DTO objects separating persistence from presentation | `entity/Farmer.java`<br>`entity/Crop.java`<br>`dto/*.java` |
| **Inheritance** | Common audit fields (`id`, `createdAt`, `updatedAt`) factored into abstract superclass `@MappedSuperclass public abstract class BaseEntity` | `entity/BaseEntity.java`<br>`entity/Farmer.java`<br>`entity/Crop.java`<br>`entity/DiseaseRecord.java` |
| **Polymorphism & Abstraction** | Service interfaces decouples contracts from implementation. Runtime dynamic dispatch allows swapping advisory engines | `service/FarmerService.java`<br>`service/impl/FarmerServiceImpl.java`<br>`service/AiAdvisoryService.java`<br>`service/impl/GeminiAdvisoryServiceImpl.java` |
| **Exception Handling** | Custom runtime exceptions and centralized `@ControllerAdvice` global exception handling with structured JSON responses | `exception/ResourceNotFoundException.java`<br>`exception/GlobalExceptionHandler.java` |
| **Collections & Streams** | Java `List`, `Map`, `Stream` API used for filtering, mapping entities to DTOs, and agronomic calculations | `service/impl/WeatherServiceImpl.java`<br>`service/impl/CropServiceImpl.java` |

---

## 🚀 How to Run

### Option 1: Quick Batch Script (Windows)
Double-click `run-backend.bat` in this folder.

### Option 2: Maven Command Line
```powershell
mvn spring-boot:run
```

### Option 3: Pre-packaged Executable JAR
```powershell
java -jar target/digital-krishi-officer-backend-1.0.0.jar
```

---

## 🌐 Endpoints & Interactive Portals

Once started (port 8080):
- **Interactive Swagger Documentation:** [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)
- **H2 In-Memory Database Web Console:** [http://localhost:8080/h2-console](http://localhost:8080/h2-console)
  - JDBC URL: `jdbc:h2:mem:krishidb`
  - User Name: `sa`
  - Password: *(leave blank)*
- **Health Check:** [http://localhost:8080/api/health](http://localhost:8080/api/health)

### Key REST Endpoints:
- `POST /api/ai/chat` — Multimodal AI advisory queries with image and video support.
- `POST /api/ai/diagnose` — Multimodal leaf disease diagnosis with confidence scoring.
- `GET  /api/crops` & `POST /api/crops` — Crop lifecycle management.
- `GET  /api/farmers` & `POST /api/farmers` — Farmer profile records.
- `GET  /api/weather/forecast` — Real-time Open-Meteo weather with spray feasibility index.
