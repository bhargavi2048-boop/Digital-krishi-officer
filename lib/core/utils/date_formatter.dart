import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDisplayDate(DateTime dt) {
    return DateFormat('dd MMM yyyy').format(dt);
  }

  static String formatShortDate(DateTime dt) {
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  static String formatTime(DateTime dt) {
    return DateFormat('hh:mm a').format(dt);
  }

  static String formatRelative(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes <= 1) return 'Just now';
        return '${difference.inMinutes} mins ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatShortDate(dt);
    }
  }
}
