import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Wraps the application in a centered mobile viewport shell when running on
/// desktop browsers (Chrome/Edge/Web), while rendering full-width naturally on mobile devices.
class ResponsiveMobileShell extends StatelessWidget {
  final Widget child;

  const ResponsiveMobileShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If screen width is wider than 500px (Desktop browser testing), center inside a mobile frame
        if (constraints.maxWidth > 500) {
          const double targetMobileWidth = 414.0; // standard modern mobile width (390 - 430px)
          final double phoneHeight = constraints.maxHeight.clamp(600.0, 920.0);

          return Scaffold(
            backgroundColor: const Color(0xFF0F1710), // Elegant dark nature backdrop
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Subtle top banner indicating mobile test viewport
                  if (kIsWeb && constraints.maxHeight > 750) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone_android, size: 14, color: Color(0xFF81C784)),
                            SizedBox(width: 6),
                            Text(
                              'Digital Krishi Officer • Mobile Viewport (414px)',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Mobile phone shell frame
                  Container(
                    width: targetMobileWidth,
                    height: constraints.maxHeight > 750 ? phoneHeight : constraints.maxHeight,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 36,
                          spreadRadius: 6,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                        width: 2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        // Simulated mobile status bar for realistic look
                        Container(
                          height: 24,
                          color: Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '09:41',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B381F),
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.signal_cellular_4_bar, size: 12, color: Color(0xFF1B381F)),
                                  SizedBox(width: 4),
                                  Icon(Icons.wifi, size: 12, color: Color(0xFF1B381F)),
                                  SizedBox(width: 4),
                                  Icon(Icons.battery_full, size: 13, color: Color(0xFF1B381F)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // App Content with local MediaQuery overridden to mobile width
                        Expanded(
                          child: MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              size: Size(targetMobileWidth, constraints.maxHeight),
                            ),
                            child: child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // On actual mobile screens (<= 500px), use 100% full width naturally
        return child;
      },
    );
  }
}
