package com.krishiofficer.service;

import java.util.Map;

/**
 * WeatherService - Demonstrates Object-Oriented ABSTRACTION.
 * Contract for Weather forecasting and agronomic spray advice.
 */
public interface WeatherService {

    Map<String, Object> getWeatherForecast(Double latitude, Double longitude);
}
