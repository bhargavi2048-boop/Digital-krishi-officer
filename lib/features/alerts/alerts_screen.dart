import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/alert_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/empty_state_view.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  String _formatTime(DateTime dt) {
    return '${dt.day}/${dt.month} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  IconData _getAlertIcon(String type) {
    switch (type.toLowerCase()) {
      case 'weather': return Icons.cloud;
      case 'disease': return Icons.biotech;
      case 'pest': return Icons.bug_report;
      case 'scheme': return Icons.account_balance;
      case 'irrigation': return Icons.water_drop;
      default: return Icons.notifications;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical': return Colors.red.shade700;
      case 'warning': return Colors.orange.shade800;
      default: return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alertProv = Provider.of<AlertProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(context.tr('alertsTitle')),
        actions: [
          if (alertProv.alerts.isNotEmpty) ...[
            TextButton(
              onPressed: () => alertProv.markAllAsRead(),
              child: Text(
                context.tr('markAllRead'),
                style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear All',
              onPressed: () => alertProv.clearAll(),
            ),
          ],
        ],
      ),
      body: alertProv.alerts.isEmpty
          ? EmptyStateView(
              icon: Icons.notifications_off_outlined,
              title: 'No Active Farm Alerts',
              message: context.tr('noAlerts'),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: alertProv.alerts.length,
              itemBuilder: (context, idx) {
                final a = alertProv.alerts[idx];
                final color = _getSeverityColor(a.severity);

                return Card(
                  elevation: a.isRead ? 0.3 : 1.5,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: a.isRead ? Colors.grey.shade200 : color.withOpacity(0.5),
                      width: a.isRead ? 1 : 1.5,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => alertProv.markAsRead(a.id),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(_getAlertIcon(a.type), size: 16, color: color),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    a.type.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                  ),
                                  if (!a.isRead) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    _formatTime(a.timestamp),
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                                    onPressed: () => alertProv.deleteAlert(a.id),
                                    padding: const EdgeInsets.only(left: 6),
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            a.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: a.isRead ? FontWeight.w600 : FontWeight.bold,
                              color: const Color(0xFF1B381F),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            a.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade800,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
