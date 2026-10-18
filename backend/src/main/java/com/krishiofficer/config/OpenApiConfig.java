package com.krishiofficer.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * OpenApiConfig - Swagger OpenAPI Documentation Configuration.
 */
@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Digital Krishi Officer API")
                        .version("1.0.0")
                        .description("Object-Oriented Java Spring Boot REST API for AI-Powered Farmer Advisory System. " +
                                "Developed for College Mini Project (Object-Oriented Programming using Java).")
                        .contact(new Contact()
                                .name("Digital Krishi Officer Development Team")
                                .email("krishiofficer@agriculture.gov.in")));
    }
}
