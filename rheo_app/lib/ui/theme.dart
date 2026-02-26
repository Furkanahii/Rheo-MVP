import 'package:flutter/material.dart';
import 'dart:ui';
import '../logic/language_service.dart';
import '../logic/storage_service.dart';

/// Centralized theme system for Rheo
/// Supports light/dark mode and language-specific coloring
class RheoTheme {
  static bool get isDark => storageService.progress.isDarkMode;

  // ÔöÇÔöÇ Language accent colors (dark variants for text) ÔöÇÔöÇ
  static Color langAccent(ProgrammingLanguage lang) {
    switch (lang) {
      case ProgrammingLanguage.python:
        return const Color(0xFF121B99); // User-specified Python blue
      case ProgrammingLanguage.java:
        return const Color(0xFFA85502); // User-specified Java orange
      case ProgrammingLanguage.javascript:
        return const Color(0xFF029C25); // User-specified JS green
    }
  }

  // ÔöÇÔöÇ Language light bg colors ÔöÇÔöÇ
  static Color langLightBg(ProgrammingLanguage lang) {
    switch (lang) {
      case ProgrammingLanguage.python:
        return const Color(0xFFE8EAFF); // Light blue tinted with #121b99
      case ProgrammingLanguage.java:
        return const Color(0xFFFFF0E0); // Light orange tinted with #a85502
      case ProgrammingLanguage.javascript:
        return const Color(0xFFE0F5E6); // Light green tinted with #029c25
    }
  }

  // ÔöÇÔöÇ Language dark bg colors (for dark mode) ÔöÇÔöÇ
  static Color langDarkBg(ProgrammingLanguage lang) {
    switch (lang) {
      case ProgrammingLanguage.python:
        return const Color(0xFF080D40); // Deep blue from #121b99
      case ProgrammingLanguage.java:
        return const Color(0xFF3A1E00); // Deep orange from #a85502
      case ProgrammingLanguage.javascript:
        return const Color(0xFF003610); // Deep green from #029c25
    }
  }

  // ÔöÇÔöÇ Language light accent colors (for dark mode text) ÔöÇÔöÇ
  static Color langLightAccent(ProgrammingLanguage lang) {
    switch (lang) {
      case ProgrammingLanguage.python:
        return const Color(0xFFE8EAFF); // Light blue pastel ÔÇö dark mode accent
      case ProgrammingLanguage.java:
        return const Color(0xFFFFF0E0); // Light orange pastel ÔÇö dark mode accent
      case ProgrammingLanguage.javascript:
        return const Color(0xFFE0F5E6); // Light green pastel ÔÇö dark mode accent
    }
  }

  // ÔöÇÔöÇ Main scaffold bg = language color ÔöÇÔöÇ
  static Color scaffoldBg([ProgrammingLanguage? lang]) {
    final l = lang ?? languageService.selected;
    return isDark ? langDarkBg(l) : langLightBg(l);
  }

  // ÔöÇÔöÇ Card / button bg = white (or dark surface) ÔöÇÔöÇ
  static Color get cardBg => isDark ? const Color(0xFF1E1E2E) : Colors.white;

  // ÔöÇÔöÇ All regular text = black (or white in dark) ÔöÇÔöÇ
  static Color get textColor => isDark ? Colors.white : Colors.black;

  // ÔöÇÔöÇ Muted text ÔöÇÔöÇ
  static Color get textMuted => isDark ? const Color(0xFF999999) : const Color(0xFF666666);

  // ÔöÇÔöÇ Language label text (stays dark accent) ÔöÇÔöÇ
  static Color langText([ProgrammingLanguage? lang]) {
    final l = lang ?? languageService.selected;
    return isDark ? langLightAccent(l) : langAccent(l);
  }

  // ÔöÇÔöÇ Border color for cards (language-tinted) ÔöÇÔöÇ
  static Color get cardBorder {
    final lang = languageService.selected;
    final accent = isDark ? langLightAccent(lang) : langAccent(lang);
    return accent.withAlpha(isDark ? 80 : 50);
  }

  // ÔöÇÔöÇ Button border color (more visible) ÔöÇÔöÇ
  static Color get buttonBorder {
    final lang = languageService.selected;
    final accent = isDark ? langLightAccent(lang) : langAccent(lang);
    return accent.withAlpha(isDark ? 120 : 80);
  }

  // ÔöÇÔöÇ Logo brand palette (for Settings, Profile, Leaderboard, Achievements, Rank) ÔöÇÔöÇ
  static const Color brandNavy = Color(0xFF0D1B2A);
  static const Color brandBlue = Color(0xFF1565C0);
  static const Color brandCyan = Color(0xFF4DD0E1);

  // ÔöÇÔöÇ Brand scaffold bg ÔöÇÔöÇ
  static Color get brandScaffoldBg => isDark ? const Color(0xFF0A1420) : const Color(0xFFECF5F8);

  // ÔöÇÔöÇ Brand card bg ÔöÇÔöÇ
  static Color get brandCardBg => isDark ? const Color(0xFF0D1B2A) : Colors.white;

  // ÔöÇÔöÇ Brand text ÔöÇÔöÇ
  static Color get brandText => isDark ? Colors.white : brandNavy;

  // ÔöÇÔöÇ Brand muted ÔöÇÔöÇ
  static Color get brandMuted => isDark ? const Color(0xFF8899AA) : const Color(0xFF5A6B7D);

  // ÔöÇÔöÇ Brand accent ÔöÇÔöÇ
  static Color get brandAccent => isDark ? brandCyan : brandBlue;

  // ÔöÇÔöÇ Brand card border ÔöÇÔöÇ
  static Color get brandCardBorder => isDark ? brandCyan.withAlpha(60) : brandBlue.withAlpha(40);

  // ÔöÇÔöÇ Code block colors (for quiz/bug-hunt/time-attack screens) ÔöÇÔöÇ
  static Color get codeBg => isDark
      ? const Color(0xFF1E1E2E)   // Catppuccin Mocha base
      : const Color(0xFFF5F5F9);  // Soft lavender-gray

  static Color get codeHeaderBg => isDark
      ? const Color(0xFF181825)   // Catppuccin Mocha mantle
      : const Color(0xFFEBEBF2);  // Slightly darker header

  static Color get codeBorder => isDark
      ? const Color(0xFF313244)   // Catppuccin Mocha surface0
      : const Color(0xFFD0D0DD);  // Subtle cool border

  static Color get codeLineNumber => isDark
      ? const Color(0xFF585b70)   // Catppuccin Mocha overlay0
      : const Color(0xFF9090A0);  // Muted number color

  static Color get codeHeaderText => isDark
      ? const Color(0xFF6c7086)   // Catppuccin Mocha overlay1
      : const Color(0xFF8080A0);  // Muted header text

  // ÔöÇÔöÇ Answer option colors (transparent glass style) ÔöÇÔöÇ
  static Color get optionBg => isDark
      ? const Color(0x14FFFFFF)   // 8% white (same as glassLight)
      : const Color(0x18000000);  // ~9% black ÔÇö subtle on light bg

  static Color get optionBorder => isDark
      ? const Color(0x1AFFFFFF)   // 10% white (same as glassBorder)
      : const Color(0x22000000);  // ~13% black

  static Color get optionText => isDark
      ? Colors.white
      : Colors.black;
}

/// Legacy color constants (kept for backward compatibility)
class RheoColors {
  // Primary brand colors
  static const Color primary = Color(0xFF00D9FF);       // Cyan
  static const Color secondary = Color(0xFFFF6B35);     // Orange
  static const Color accent = Color(0xFF7C4DFF);        // Purple
  
  // Background gradient colors
  static const Color bgTop = Color(0xFF0D1B2A);         // Deep navy
  static const Color bgBottom = Color(0xFF1B2838);      // Dark blue-gray
  
  // Light theme scaffold background
  static const Color scaffoldBg = Color(0xFFF0F5F4);
  static const Color textDark = Color(0xFF1A237E);
  
  // Surface colors
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceLight = Color(0xFF2D2D2D);
  static const Color card = Color(0xFF252525);
  
  // Glass effect colors
  static const Color glassLight = Color(0x14FFFFFF);    // 8% white
  static const Color glassBorder = Color(0x1AFFFFFF);   // 10% white
  
  // Rank colors
  static const Color bronze = Color(0xFFCD7F32);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color gold = Color(0xFFFFD700);
  static const Color platinum = Color(0xFFE5E4E2);
  static const Color diamond = Color(0xFFB9F2FF);
  
  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  
  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF808080);
}

/// Premium gradient backgrounds
class RheoGradients {
  static const LinearGradient background = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [RheoColors.bgTop, RheoColors.bgBottom],
  );
  
  static const LinearGradient primaryButton = LinearGradient(
    colors: [Color(0xFF00D9FF), Color(0xFF00B4D8)],
  );
  
  static const LinearGradient orangeButton = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFE55A2B)],
  );
  
  static LinearGradient cardGlow(Color color) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      color.withAlpha(30),
      color.withAlpha(10),
    ],
  );
}

/// Glass morphism card widget
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final double blur;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.blur = 10,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(16);
    
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: RheoColors.glassLight,
            borderRadius: radius,
            border: Border.all(
              color: borderColor ?? RheoColors.glassBorder,
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Gradient background widget
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RheoGradients.background,
      ),
      child: child,
    );
  }
}

/// Animated gradient button
class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Gradient gradient;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.gradient = RheoGradients.primaryButton,
    this.icon,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: RheoColors.primary.withAlpha(80),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmer loading placeholder
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: RheoColors.surfaceLight,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}