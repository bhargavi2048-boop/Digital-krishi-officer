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

  /// Dispatches an emergency agricultural alert via WhatsApp
  static Future<bool> launchWhatsApp({
    BuildContext? context,
    String? phone,
    required String message,
  }) async {
    try {
      final cleanText = Uri.encodeComponent(message);
      final cleanPhone = (phone != null && phone.trim().isNotEmpty)
          ? phone.replaceAll(RegExp(r'\D'), '')
          : '';

      final String urlString;
      if (cleanPhone.length == 10) {
        urlString = 'https://wa.me/91$cleanPhone?text=$cleanText';
      } else if (cleanPhone.isNotEmpty) {
        urlString = 'https://wa.me/$cleanPhone?text=$cleanText';
      } else {
        urlString = 'https://wa.me/?text=$cleanText';
      }

      final uri = Uri.parse(urlString);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        return await launchUrl(uri);
      }
      return launched;
    } catch (e) {
      debugPrint('WhatsApp launch error: $e');
      return false;
    }
  }

  /// Dispatches an emergency agricultural alert via native SMS
  static Future<bool> launchSms({
    BuildContext? context,
    String? phone,
    required String message,
  }) async {
    try {
      final cleanText = Uri.encodeComponent(message);
      final cleanPhone = (phone != null && phone.trim().isNotEmpty)
          ? phone.replaceAll(RegExp(r'\D'), '')
          : '';

      final Uri uri;
      if (cleanPhone.isNotEmpty) {
        uri = Uri.parse('sms:$cleanPhone?body=$cleanText');
      } else {
        uri = Uri.parse('sms:?body=$cleanText');
      }

      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        return await launchUrl(uri);
      }
      return launched;
    } catch (e) {
      debugPrint('SMS launch error: $e');
      return false;
    }
  }
}
