import 'package:flutter/material.dart';
import '../../../core/services/speech_service.dart';
import '../../../l10n/app_localizations.dart';

class VoiceInputSheet extends StatefulWidget {
  final String langCode;
  final Function(String text) onTextReady;

  const VoiceInputSheet({
    super.key,
    required this.langCode,
    required this.onTextReady,
  });

  @override
  State<VoiceInputSheet> createState() => _VoiceInputSheetState();
}

class _VoiceInputSheetState extends State<VoiceInputSheet> {
  final SpeechService _speech = SpeechService();
  final TextEditingController _textController = TextEditingController();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _startRecording();
  }

  Future<void> _startRecording() async {
    setState(() => _isListening = true);
    await _speech.startListening(
      langCode: widget.langCode,
      onResult: (words) {
        if (mounted) {
          setState(() {
            _textController.text = words;
          });
        }
      },
    );
  }

  Future<void> _stopRecording() async {
    await _speech.stopListening();
    if (mounted) {
      setState(() => _isListening = false);
    }
  }

  @override
  void dispose() {
    _speech.stopListening();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('voiceInput'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B381F),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Listening Microphone Animation
          GestureDetector(
            onTap: () {
              if (_isListening) {
                _stopRecording();
              } else {
                _startRecording();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _isListening ? Colors.red.shade600 : const Color(0xFF2E7D32),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? Colors.red : const Color(0xFF2E7D32)).withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: 4,
                  )
                ],
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            _isListening ? context.tr('listening') : 'Tap microphone to speak or type query below',
            style: TextStyle(
              fontSize: 13,
              color: _isListening ? Colors.red.shade700 : Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          // Editable transcribed text
          TextField(
            controller: _textController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Recognized agricultural question will appear here... (You can edit it)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),

          // Quick prompt chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickChip('Paddy fertilizer schedule'),
                const SizedBox(width: 6),
                _buildQuickChip('Tomato yellow leaf curl'),
                const SizedBox(width: 6),
                _buildQuickChip('Cotton bollworm cure'),
                const SizedBox(width: 6),
                _buildQuickChip('Organic pest spray formula'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Send Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                final query = _textController.text.trim();
                if (query.isNotEmpty) {
                  widget.onTextReady(query);
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.send, size: 18),
              label: Text(context.tr('askAi')),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String label) {
    return ActionChip(
      avatar: const Icon(Icons.record_voice_over_outlined, size: 14, color: Color(0xFF2E7D32)),
      label: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF1B381F))),
      backgroundColor: const Color(0xFFE8F5E9),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: () {
        setState(() {
          _textController.text = label;
        });
      },
    );
  }
}
