import 'package:flutter/material.dart';
import '../theme.dart';

/// Reusable Empty State Widget
/// Kullan─▒c─▒ hen├╝z veri olu┼şturmam─▒┼şsa g├Âsterilir
class EmptyStateWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with glow effect
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: RheoColors.primary.withAlpha(20),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: RheoColors.primary.withAlpha(30),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Text(
                icon,
                style: const TextStyle(fontSize: 48),
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                color: RheoColors.textMuted,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Optional action button
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: RheoColors.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  buttonText!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}