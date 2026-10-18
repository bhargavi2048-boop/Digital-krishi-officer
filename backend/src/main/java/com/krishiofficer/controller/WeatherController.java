package com.krishiofficer.controller;

import com.krishiofficer.service.WeatherService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * WeatherController - REST Controller for Live Weather & Agronomic Spray Forecasts.
 */
@RestController
@RequestMapping("/api/weather")
@Tag(name = "Weather Controller", description = "Live Weather & Agronomic Spray Advisory APIs")
public class WeatherController {

    private final WeatherService weatherService;

    public WeatherController(WeatherService weatherService) {
        this.weatherService = weatherService;
    }

    @GetMapping("/forecast")
    @Operation(summary = "Get live temperature, humidity, rain forecast and spray advice")
    public ResponseEntity<Map<String, Object>> getForecast(@RequestParam(required = false) Double latitude,
                                                           @RequestParam(required = false) Double longitude) {
        return ResponseEntity.ok(weatherService.getWeatherForecast(latitude, longitude));
    }
}
