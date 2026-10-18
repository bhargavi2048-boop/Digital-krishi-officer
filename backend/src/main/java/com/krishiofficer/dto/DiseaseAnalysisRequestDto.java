package com.krishiofficer.dto;

import jakarta.validation.constraints.NotBlank;

/**
 * DiseaseAnalysisRequestDto - Request DTO for multimodal crop disease diagnostic.
 */
public class DiseaseAnalysisRequestDto {

    @NotBlank(message = "Crop name is required")
    private String cropName;

    private String description;
    private String mediaBase64;
    private String mediaMimeType;
    private Boolean isVideo = false;
    private String langCode = "en";
    private Long farmerId;

    public DiseaseAnalysisRequestDto() {
    }

    public DiseaseAnalysisRequestDto(String cropName, String description, String mediaBase64,
                                     String mediaMimeType, Boolean isVideo, String langCode, Long farmerId) {
        this.cropName = cropName;
        this.description = description;
        this.mediaBase64 = mediaBase64;
        this.mediaMimeType = mediaMimeType;
        this.isVideo = isVideo != null ? isVideo : false;
        this.langCode = langCode != null ? langCode : "en";
        this.farmerId = farmerId;
    }

    public String getCropName() {
        return cropName;
    }

    public void setCropName(String cropName) {
        this.cropName = cropName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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
}
