import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _inputController = TextEditingController();
  bool _submitted = false;
  bool _resetSuccess = false;
  String? _statusMessage;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) {
      setState(() => _statusMessage = 'Please enter your email or 10-digit mobile number.');
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.resetPassword(
      emailOrMobile: input,
      newPassword: 'farmer1234',
    );

    setState(() {
      _submitted = true;
      _resetSuccess = success;
      if (success) {
        _statusMessage = 'Your password has been successfully reset to:\nfarmer1234\n\nYou can now log in using this password.';
      } else {
        _statusMessage = 'No account was found with "$input". Please check your email or mobile number, or create a new account.';
      }
    });
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
                Icon(
                  _resetSuccess ? Icons.check_circle : Icons.error_outline,
                  color: _resetSuccess ? const Color(0xFF2E7D32) : Colors.orange,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  _resetSuccess ? 'Password Reset Successful' : 'Account Not Found',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  _statusMessage ?? '',
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
                  'Enter your registered email address or 10-digit mobile number to reset your password.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                    labelText: 'Email or Mobile Number',
                    hintText: 'farmer@krishi.in or 9876543210',
                    prefixIcon: Icon(Icons.person_outline, size: 20),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _handleReset(),
                ),
                if (_statusMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(_statusMessage!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                ],
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('close'), style: const TextStyle(color: Colors.grey)),
        ),
        if (!_submitted)
          ElevatedButton(
            onPressed: _handleReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Reset Password'),
          ),
      ],
    );
  }
}
