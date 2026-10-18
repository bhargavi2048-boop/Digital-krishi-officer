package com.krishiofficer.entity;

import jakarta.persistence.*;

/**
 * DiseaseRecord Entity - Stores historical AI diagnoses of crop symptoms.
 * Demonstrates Object-Oriented Entity Design, Encapsulation, and Inheritance.
 */
@Entity
@Table(name = "disease_records")
public class DiseaseRecord extends BaseEntity {

    @Column(name = "crop_name", nullable = false)
    private String cropName;

    @Column(name = "possible_issue", nullable = false)
    private String possibleIssue;

    @Column(name = "confidence_score")
    private Integer confidenceScore;

    @Column(name = "observed_symptoms", length = 2000)
    private String observedSymptoms;

    @Column(name = "possible_causes", length = 2000)
    private String possibleCauses;

    @Column(name = "recommended_action", length = 2000)
    private String recommendedAction;

    @Column(name = "prevention", length = 2000)
    private String prevention;

    @Column(name = "when_to_seek_expert", length = 1000)
    private String whenToSeekExpert;

    @Column(name = "is_video_analysis")
    private Boolean isVideoAnalysis = false;

    @Column(name = "farmer_id")
    private Long farmerId;

    public DiseaseRecord() {
        super();
    }

    public DiseaseRecord(String cropName, String possibleIssue, Integer confidenceScore,
                         String observedSymptoms, String possibleCauses, String recommendedAction,
                         String prevention, String whenToSeekExpert, Boolean isVideoAnalysis, Long farmerId) {
        super();
        this.cropName = cropName;
        this.possibleIssue = possibleIssue;
        this.confidenceScore = confidenceScore;
        this.observedSymptoms = observedSymptoms;
        this.possibleCauses = possibleCauses;
        this.recommendedAction = recommendedAction;
        this.prevention = prevention;
        this.whenToSeekExpert = whenToSeekExpert;
        this.isVideoAnalysis = isVideoAnalysis != null ? isVideoAnalysis : false;
        this.farmerId = farmerId;
    }

    // Getters and Setters
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

    public Long getFarmerId() {
        return farmerId;
    }

    public void setFarmerId(Long farmerId) {
        this.farmerId = farmerId;
    }

    @Override
    public String toString() {
        return "DiseaseRecord{" +
                "id=" + getId() +
                ", cropName='" + cropName + '\'' +
                ", possibleIssue='" + possibleIssue + '\'' +
                ", confidenceScore=" + confidenceScore +
                ", isVideoAnalysis=" + isVideoAnalysis +
                '}';
    }
}
