package com.krishiofficer.dto;

/**
 * DiseaseAnalysisResponseDto - Encapsulates structured AI vision diagnostic results.
 */
public class DiseaseAnalysisResponseDto {

    private Long id;
    private String cropName;
    private String possibleIssue;
    private Integer confidenceScore;
    private String observedSymptoms;
    private String possibleCauses;
    private String recommendedAction;
    private String prevention;
    private String whenToSeekExpert;
    private Boolean isVideoAnalysis;

    public DiseaseAnalysisResponseDto() {
    }

    public DiseaseAnalysisResponseDto(Long id, String cropName, String possibleIssue, Integer confidenceScore,
                                      String observedSymptoms, String possibleCauses, String recommendedAction,
                                      String prevention, String whenToSeekExpert, Boolean isVideoAnalysis) {
        this.id = id;
        this.cropName = cropName;
        this.possibleIssue = possibleIssue;
        this.confidenceScore = confidenceScore;
        this.observedSymptoms = observedSymptoms;
        this.possibleCauses = possibleCauses;
        this.recommendedAction = recommendedAction;
        this.prevention = prevention;
        this.whenToSeekExpert = whenToSeekExpert;
        this.isVideoAnalysis = isVideoAnalysis;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCropName() {
        return cropName;
    }

    public void setCropName(String cropName) {
        this.cropName = cropName;
    }

    public String getPossibleIssue() {
        return possibleIssue;
    }

    public void setPossibleIssue(String possibleIssue) {
        this.possibleIssue = possibleIssue;
    }

    public Integer getConfidenceScore() {
        return confidenceScore;
    }

    public void setConfidenceScore(Integer confidenceScore) {
        this.confidenceScore = confidenceScore;
    }

    public String getObservedSymptoms() {
        return observedSymptoms;
    }

    public void setObservedSymptoms(String observedSymptoms) {
        this.observedSymptoms = observedSymptoms;
    }

    public String getPossibleCauses() {
        return possibleCauses;
    }

    public void setPossibleCauses(String possibleCauses) {
        this.possibleCauses = possibleCauses;
    }

    public String getRecommendedAction() {
        return recommendedAction;
    }

    public void setRecommendedAction(String recommendedAction) {
        this.recommendedAction = recommendedAction;
    }

    public String getPrevention() {
        return prevention;
    }

    public void setPrevention(String prevention) {
        this.prevention = prevention;
    }

    public String getWhenToSeekExpert() {
        return whenToSeekExpert;
    }

    public void setWhenToSeekExpert(String whenToSeekExpert) {
        this.whenToSeekExpert = whenToSeekExpert;
    }

    public Boolean getIsVideoAnalysis() {
        return isVideoAnalysis;
    }

    public void setIsVideoAnalysis(Boolean isVideoAnalysis) {
        this.isVideoAnalysis = isVideoAnalysis;
    }
}
