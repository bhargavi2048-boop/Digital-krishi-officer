import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  /// Opens a URL in external browser/application safely
  static Future<bool> launchExternalUrl(BuildContext context, String urlString) async {
    try {
      final cleanUrl = urlString.trim();
      if (cleanUrl.isEmpty) return false;

      final uri = Uri.parse(cleanUrl.startsWith('http://') || cleanUrl.startsWith('https://')
          ? cleanUrl
          : 'https://$cleanUrl');

      final canLaunch = await canLaunchUrl(uri);
      if (canLaunch) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to platform default
        return await launchUrl(uri);
      }
    } catch (e) {
      debugPrint('Error launching URL ($urlString): $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: $urlString'),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return false;
    }
  }
}
