import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _emailController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.lock_reset, color: Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Text(context.tr('forgotPassword'), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ],
      ),
      content: _submitted
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 48),
                const SizedBox(height: 12),
                const Text(
                  'Password Reset Link Generated',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  'Because this app operates locally without a backend server, your local password has been reset to: farmer1234',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your registered email address to recover your local account profile.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: context.tr('email'),
                    hintText: 'farmer@krishi.in',
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  ),
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('close'), style: const TextStyle(color: Colors.grey)),
        ),
        if (!_submitted)
          ElevatedButton(
            onPressed: () {
              if (_emailController.text.contains('@')) {
                setState(() => _submitted = true);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(context.tr('submit')),
          ),
      ],
    );
  }
}
