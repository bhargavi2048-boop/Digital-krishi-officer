package com.krishiofficer.dto;

import jakarta.validation.constraints.NotNull;

/**
 * ChatRequestDto - Data Transfer Object for AI Krishi Officer Chat.
 * Encapsulates the user prompt, optional media (image/video), language, and farmer context.
 */
public class ChatRequestDto {

    private String prompt;
    private String langCode = "en";
    private Long farmerId;
    private String mediaBase64;
    private String mediaMimeType;
    private Boolean isVideo = false;

    public ChatRequestDto() {
    }

    public ChatRequestDto(String prompt, String langCode, Long farmerId, String mediaBase64, String mediaMimeType, Boolean isVideo) {
        this.prompt = prompt;
        this.langCode = langCode != null ? langCode : "en";
        this.farmerId = farmerId;
        this.mediaBase64 = mediaBase64;
        this.mediaMimeType = mediaMimeType;
        this.isVideo = isVideo != null ? isVideo : false;
    }

    // Encapsulated Getters & Setters
    public String getPrompt() {
        return prompt;
    }

    public void setPrompt(String prompt) {
        this.prompt = prompt;
    }

    public String getLangCode() {
        return langCode;
    }

    public void setLangCode(String langCode) {
        this.langCode = langCode;
    }

    public Long getFarmerId() {
        return farmerId;
    }

    public void setFarmerId(Long farmerId) {
        this.farmerId = farmerId;
    }

    public String getMediaBase64() {
        return mediaBase64;
    }

    public void setMediaBase64(String mediaBase64) {
        this.mediaBase64 = mediaBase64;
    }

    public String getMediaMimeType() {
        return mediaMimeType;
    }

    public void setMediaMimeType(String mediaMimeType) {
        this.mediaMimeType = mediaMimeType;
    }

    public Boolean getIsVideo() {
        return isVideo;
    }

    public void setIsVideo(Boolean isVideo) {
        this.isVideo = isVideo;
    }
}
