import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import '../language/language_selection_screen.dart';
import 'privacy_screen.dart';
import 'about_screen.dart';
import 'expert_escalation_screen.dart';
import '../../app/routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final langProv = Provider.of<LanguageProvider>(context);
    final authProv = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      appBar: AppBar(
        title: Text(context.tr('settingsTitle')),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Language Settings
          _buildSettingsCard(
            title: 'Preferences',
            children: [
              ListTile(
                leading: const Icon(Icons.language, color: Color(0xFF2E7D32)),
                title: Text(context.tr('languageSetting')),
                subtitle: Text(langProv.currentLanguageCode.toUpperCase()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LanguageSelectionScreen(isFromSettings: true),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined, color: Color(0xFF2E7D32)),
                title: Text(context.tr('darkMode')),
                subtitle: const Text('Eye-friendly dark theme for evening farm checks'),
                value: themeProv.isDarkMode,
                activeThumbColor: const Color(0xFF2E7D32),
                onChanged: (val) => themeProv.toggleTheme(val),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Escalation & Support Directory
          _buildSettingsCard(
            title: 'Support & Escalation',
            children: [
              ListTile(
                leading: const Icon(Icons.support_agent, color: Color(0xFF2E7D32)),
                title: Text(context.tr('expertHelpline')),
                subtitle: const Text('Kisan Call Center (1800-180-1551) & Extension Officers'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ExpertEscalationScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Legal & About
          _buildSettingsCard(
            title: 'Information & Safety',
            children: [
              ListTile(
                leading: const Icon(Icons.security, color: Color(0xFF2E7D32)),
                title: Text(context.tr('privacyPolicy')),
                subtitle: const Text('Local data policy and camera/mic permissions'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Color(0xFF2E7D32)),
                title: Text(context.tr('aboutApp')),
                subtitle: const Text('Version 1.0.0 • AI disclaimer & credits'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Logout Card
          _buildSettingsCard(
            title: 'Session',
            children: [
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text(
                  context.tr('logout'),
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  await authProv.logout();
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF78909C),
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
