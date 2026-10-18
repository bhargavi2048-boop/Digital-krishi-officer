package com.krishiofficer.service;

import com.krishiofficer.dto.ChatRequestDto;
import com.krishiofficer.dto.ChatResponseDto;
import com.krishiofficer.dto.DiseaseAnalysisRequestDto;
import com.krishiofficer.dto.DiseaseAnalysisResponseDto;

import java.util.List;

/**
 * AiAdvisoryService - Demonstrates Object-Oriented ABSTRACTION.
 * Contract for AI Agricultural consultation and Multimodal crop disease diagnosis.
 */
public interface AiAdvisoryService {

    ChatResponseDto generateAdvisory(ChatRequestDto request);

    DiseaseAnalysisResponseDto diagnoseDisease(DiseaseAnalysisRequestDto request);

    List<DiseaseAnalysisResponseDto> getDiseaseHistory(Long farmerId);
}
