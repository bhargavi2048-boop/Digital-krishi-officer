package com.krishiofficer;

import com.krishiofficer.entity.Crop;
import com.krishiofficer.entity.Farmer;
import com.krishiofficer.repository.CropRepository;
import com.krishiofficer.repository.FarmerRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import java.time.LocalDate;

/**
 * DigitalKrishiOfficerApplication - Main Application Entry Point.
 * Demonstrates Object-Oriented System initialization in Spring Boot.
 */
@SpringBootApplication
public class DigitalKrishiOfficerApplication {

    private static final Logger log = LoggerFactory.getLogger(DigitalKrishiOfficerApplication.class);

    public static void main(String[] args) {
        SpringApplication.run(DigitalKrishiOfficerApplication.class, args);
        log.info("==================================================================");
        log.info("🌱 Digital Krishi Officer Java Spring Boot Backend Started!");
        log.info("🚀 API Server:       http://localhost:8080");
        log.info("📖 Swagger UI Docs:  http://localhost:8080/swagger-ui.html");
        log.info("🗄️ H2 Database UI:   http://localhost:8080/h2-console");
        log.info("==================================================================");
    }

    /**
     * Seeds initial agricultural data into H2 in-memory database for college evaluation.
     */
    @Bean
    public CommandLineRunner seedInitialData(FarmerRepository farmerRepository, CropRepository cropRepository) {
        return args -> {
            if (farmerRepository.count() == 0) {
                // Seed initial Farmer entity
                Farmer demoFarmer = new Farmer(
                        "Murugan K",
                        "9876543210",
                        "Tamil Nadu",
                        "Thanjavur",
                        "Kumbakonam",
                        "Paddy (Rice)",
                        3.5,
                        "Clay Loam (Alluvial)",
                        "Canal & Borewell",
                        "en"
                );
                Farmer savedFarmer = farmerRepository.save(demoFarmer);
                log.info("Seeded initial farmer: {}", savedFarmer.getFullName());
            }
        };
    }
}
