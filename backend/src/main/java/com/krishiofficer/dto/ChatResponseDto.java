package com.krishiofficer.dto;

import java.time.LocalDateTime;

/**
 * ChatResponseDto - DTO encapsulating the AI Krishi Officer reply.
 */
public class ChatResponseDto {

    private String response;
    private LocalDateTime timestamp;
    private boolean isOfflineFallback;

    public ChatResponseDto() {
        this.timestamp = LocalDateTime.now();
    }

    public ChatResponseDto(String response, boolean isOfflineFallback) {
        this.response = response;
        this.isOfflineFallback = isOfflineFallback;
        this.timestamp = LocalDateTime.now();
    }

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public boolean isOfflineFallback() {
        return isOfflineFallback;
    }

    public void setOfflineFallback(boolean offlineFallback) {
        isOfflineFallback = offlineFallback;
    }
}
