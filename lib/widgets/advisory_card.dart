import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../core/services/tts_service.dart';
import '../providers/language_provider.dart';

class AdvisoryCard extends StatelessWidget {
  final String advisoryText;
  final VoidCallback? onAskAi;

  const AdvisoryCard({
    super.key,
    required this.advisoryText,
    this.onAskAi,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: const Color(0xFF2E7D32).withOpacity(0.2)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFF1F8E9),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.eco,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.tr('todayAdvisory'),
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              advisoryText.isNotEmpty
                  ? advisoryText
                  : 'Favorable field conditions today. Maintain scheduled irrigation and inspect foliage for early pest symptoms.',
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Color(0xFF2E3D30),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: TtsService().isPlayingNotifier,
                    builder: (context, isPlaying, _) {
                      final effectiveText = advisoryText.isNotEmpty
                          ? advisoryText
                          : 'Favorable field conditions today. Maintain scheduled irrigation and inspect foliage for early pest symptoms.';
                      final currentText = TtsService().currentTextNotifier.value;
                      final isThisSpeaking = isPlaying && currentText == effectiveText;
                      return TextButton.icon(
                        onPressed: () {
                          if (isThisSpeaking) {
                            TtsService().stop();
                          } else {
                            final langProv = Provider.of<LanguageProvider>(context, listen: false);
                            TtsService().speak(effectiveText, langCode: langProv.currentLanguageCode);
                          }
                        },
                        icon: Icon(
                          isThisSpeaking ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
                          size: 16,
                          color: isThisSpeaking ? Colors.red.shade700 : const Color(0xFF2E7D32),
                        ),
                        label: Text(
                          isThisSpeaking ? context.tr('stopVoice') : context.tr('listenAdvisory'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: isThisSpeaking ? Colors.red.shade700 : const Color(0xFF2E7D32),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: isThisSpeaking ? Colors.red.shade50 : const Color(0xFF2E7D32).withValues(alpha: 0.08),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          visualDensity: VisualDensity.compact,
                        ),
                      );
                    },
                  ),
                ),
                if (onAskAi != null) ...[
                  const SizedBox(width: 6),
                  Flexible(
                    child: TextButton.icon(
                      onPressed: onAskAi,
                      icon: const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF2E7D32)),
                      label: Text(
                        context.tr('askAi'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
