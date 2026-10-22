package com.krishiofficer.service.impl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.krishiofficer.service.WeatherService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;

/**
 * WeatherServiceImpl - Fetches live weather from OpenWeatherMap REST API with Open-Meteo fallback.
 * Demonstrates Polymorphism and external REST service integration in Java.
 */
@Service
public class WeatherServiceImpl implements WeatherService {

    private static final Logger log = LoggerFactory.getLogger(WeatherServiceImpl.class);
    private final ObjectMapper objectMapper;
    private final HttpClient httpClient;

    @Value("${weather.api.key:671d789ae40566e427e7762d4d80fa58}")
    private String weatherApiKey;

    public WeatherServiceImpl(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    @Override
    public Map<String, Object> getWeatherForecast(Double latitude, Double longitude) {
        double lat = latitude != null ? latitude : 10.7870; // Default: Thanjavur, Tamil Nadu (Cauvery delta)
        double lon = longitude != null ? longitude : 79.1378;

        // 1. Try OpenWeatherMap REST API first
        if (weatherApiKey != null && !weatherApiKey.isBlank() && !weatherApiKey.equals("YOUR_WEATHER_API_KEY")) {
            try {
                String owmUrl = String.format("https://api.openweathermap.org/data/2.5/weather?lat=%.4f&lon=%.4f&appid=%s&units=metric", lat, lon, weatherApiKey.trim());
                HttpRequest request = HttpRequest.newBuilder()
                        .uri(URI.create(owmUrl))
                        .timeout(Duration.ofSeconds(10))
                        .GET()
                        .build();

                HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
                if (response.statusCode() == 200) {
                    JsonNode root = objectMapper.readTree(response.body());
                    JsonNode main = root.path("main");
                    JsonNode wind = root.path("wind");

                    double temp = main.path("temp").asDouble(28.5);
                    int humidity = main.path("humidity").asInt(65);
                    double windKmh = wind.path("speed").asDouble(3.2) * 3.6; // m/s to km/h
                    double rain1h = root.path("rain").path("1h").asDouble(0.0);
                    String weatherMain = root.path("weather").isArray() && root.path("weather").size() > 0
                            ? root.path("weather").get(0).path("main").asText("Clear")
                            : "Clear";
                    boolean isRainExpected = rain1h > 0.5 || weatherMain.equalsIgnoreCase("Rain") || weatherMain.equalsIgnoreCase("Thunderstorm");

                    Map<String, Object> result = new HashMap<>();
                    result.put("temperature", temp);
                    result.put("humidity", humidity);
                    result.put("precipitation", rain1h);
                    result.put("windSpeed", windKmh);
                    result.put("condition", weatherMain);
                    result.put("isRainExpected", isRainExpected);
                    result.put("provider", "OpenWeatherMap");

                    String sprayAdvice = (isRainExpected || windKmh > 20.0)
                            ? "⚠️ Avoid chemical or pesticide spraying today due to wind/rain."
                            : "✅ Weather is favorable for foliar spray and fertilizer application.";
                    result.put("sprayAdvice", sprayAdvice);
                    result.put("status", "SUCCESS");
                    log.info("Successfully fetched weather from OpenWeatherMap for lat={}, lon={}", lat, lon);
                    return result;
                }
            } catch (Exception e) {
                log.warn("OpenWeatherMap API error: {}, falling back to Open-Meteo", e.getMessage());
            }
        }

        // 2. Fallback to Open-Meteo REST API
        String url = String.format("https://api.open-meteo.com/v1/forecast?latitude=%.4f&longitude=%.4f&current=temperature_2m,relative_humidity_2m,precipitation,weather_code,wind_speed_10m", lat, lon);
        Map<String, Object> result = new HashMap<>();

        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .timeout(Duration.ofSeconds(15))
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                JsonNode root = objectMapper.readTree(response.body());
                JsonNode current = root.path("current");

                double temp = current.path("temperature_2m").asDouble(28.5);
                int humidity = current.path("relative_humidity_2m").asInt(65);
                double precipitation = current.path("precipitation").asDouble(0.0);
                double wind = current.path("wind_speed_10m").asDouble(12.0);

                result.put("temperature", temp);
                result.put("humidity", humidity);
                result.put("precipitation", precipitation);
                result.put("windSpeed", wind);
                result.put("isRainExpected", precipitation > 0.5);
                result.put("provider", "Open-Meteo");

                // Agronomic spray advice
                String sprayAdvice = (precipitation > 0.5 || wind > 20.0)
                        ? "⚠️ Avoid chemical or pesticide spraying today due to wind/rain."
                        : "✅ Weather is favorable for foliar spray and fertilizer application.";
                result.put("sprayAdvice", sprayAdvice);
                result.put("status", "SUCCESS");
                return result;
            }
        } catch (Exception e) {
            log.warn("Open-Meteo Weather API exception: {}", e.getMessage());
        }

        // Fallback realistic weather data for agriculture
        result.put("temperature", 29.0);
        result.put("humidity", 62);
        result.put("precipitation", 0.0);
        result.put("windSpeed", 11.5);
        result.put("isRainExpected", false);
        result.put("sprayAdvice", "✅ Favorable conditions for morning crop inspection and irrigation.");
        result.put("status", "FALLBACK");
        return result;
    }
}
