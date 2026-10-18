package com.krishiofficer.controller;

import com.krishiofficer.dto.ChatRequestDto;
import com.krishiofficer.dto.ChatResponseDto;
import com.krishiofficer.dto.DiseaseAnalysisRequestDto;
import com.krishiofficer.dto.DiseaseAnalysisResponseDto;
import com.krishiofficer.service.AiAdvisoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * AiAdvisoryController - REST Controller for AI Krishi Officer Consultations & Disease Diagnosis.
 */
@RestController
@RequestMapping("/api/ai")
@Tag(name = "AI Advisory Controller", description = "AI Krishi Officer Multimodal Advisory & Diagnostics")
public class AiAdvisoryController {

    private final AiAdvisoryService aiAdvisoryService;

    public AiAdvisoryController(AiAdvisoryService aiAdvisoryService) {
        this.aiAdvisoryService = aiAdvisoryService;
    }

    @PostMapping("/chat")
    @Operation(summary = "Ask AI Krishi Officer a question (supports text, leaf image, or video clip)")
    public ResponseEntity<ChatResponseDto> askKrishiOfficer(@RequestBody ChatRequestDto request) {
        ChatResponseDto response = aiAdvisoryService.generateAdvisory(request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/diagnose")
    @Operation(summary = "Perform multimodal plant disease diagnosis on crop photo or video")
    public ResponseEntity<DiseaseAnalysisResponseDto> diagnoseDisease(@Valid @RequestBody DiseaseAnalysisRequestDto request) {
        DiseaseAnalysisResponseDto response = aiAdvisoryService.diagnoseDisease(request);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/diagnose/history")
    @Operation(summary = "Get diagnosis history for a farmer")
    public ResponseEntity<List<DiseaseAnalysisResponseDto>> getHistory(@RequestParam(required = false) Long farmerId) {
        return ResponseEntity.ok(aiAdvisoryService.getDiseaseHistory(farmerId));
    }
}
