import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/weather_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'forgot_password_dialog.dart';
import '../../app/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'farmer@krishi.in');
  final _passwordController = TextEditingController(text: 'farmer1234');
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      rememberMe: _rememberMe,
    );

    if (!mounted) return;

    if (success) {
      // Auto-detect user current location and update weather on login
      try {
        final weather = Provider.of<WeatherProvider>(context, listen: false);
        weather.detectAndLoadLocationWeather(profile: auth.currentUser);
      } catch (e) {
        debugPrint('Weather auto update on login error: $e');
      }

      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? context.tr('errLoginFailed')),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Icon & Header
                  Center(
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F8E9),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3), width: 2),
                      ),
                      child: const Center(
                        child: Icon(Icons.agriculture_rounded, size: 44, color: Color(0xFF1B5E20)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      context.tr('appName'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B381F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      context.tr('appTagline'),
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Email
                  CustomTextField(
                    controller: _emailController,
                    label: context.tr('email'),
                    hint: 'farmer@krishi.in',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (v) => (v == null || !v.contains('@')) ? context.tr('errInvalidEmail') : null,
                  ),
                  const SizedBox(height: 16),

                  // Password
                  CustomTextField(
                    controller: _passwordController,
                    label: context.tr('password'),
                    hint: '••••••••',
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? context.tr('errPasswordLength') : null,
                  ),
                  const SizedBox(height: 12),

                  // Remember Me & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: const Color(0xFF2E7D32),
                              onChanged: (v) => setState(() => _rememberMe = v ?? true),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.tr('rememberMe'),
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => const ForgotPasswordDialog(),
                          );
                        },
                        child: Text(
                          context.tr('forgotPassword'),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  CustomButton(
                    text: context.tr('login'),
                    isLoading: auth.isLoading,
                    icon: Icons.login,
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 16),

                  // Security notice
                  Center(
                    child: Text(
                      'Local device session authentication',
                      style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Create Account Link
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.register);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2E7D32)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: Text(
                        context.tr('noAccount'),
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Divider OR
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Guest Mode Login
                  OutlinedButton.icon(
                    onPressed: () async {
                      final success = await auth.loginAsGuest();
                      if (success && mounted) {
                        try {
                          final weather = Provider.of<WeatherProvider>(context, listen: false);
                          weather.detectAndLoadLocationWeather(profile: auth.currentUser);
                        } catch (_) {}
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      }
                    },
                    icon: const Icon(Icons.person_outline, color: Color(0xFF1B5E20)),
                    label: Text(
                      context.tr('continueAsGuest'),
                      style: const TextStyle(
                        color: Color(0xFF1B5E20),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF1B5E20), width: 1.5),
                      backgroundColor: const Color(0xFFF1F8E9),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
