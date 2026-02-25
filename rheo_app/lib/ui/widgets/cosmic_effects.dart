import 'dart:math';
import 'package:flutter/material.dart';

/// Cosmic nebula background with stars and floating particles
/// Creates the anti-gravity space atmosphere
class CosmicBackground extends StatefulWidget {
  final Widget child;
  const CosmicBackground({super.key, required this.child});

  @override
  State<CosmicBackground> createState() => _CosmicBackgroundState();
}

class _CosmicBackgroundState extends State<CosmicBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return CustomPaint(
          painter: _NebulaPainter(_ctrl.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _NebulaPainter extends CustomPainter {
  final double t;
  final Random _rng = Random(42);

  _NebulaPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // ── Deep space base ──
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF0A0E1A),
    );

    // ── Nebula clouds ──
    _drawNebula(canvas, size, const Color(0xFF1A0A3A), 0.1, 0.3);
    _drawNebula(canvas, size, const Color(0xFF0A1A3A), 0.4, 0.6);
    _drawNebula(canvas, size, const Color(0xFF2A0A2A), 0.7, 0.9);

    // ── Stars ──
    for (int i = 0; i < 80; i++) {
      final x = _rng.nextDouble() * size.width;
      final y = _rng.nextDouble() * size.height;
      final radius = 0.5 + _rng.nextDouble() * 1.5;
      final twinkle = 0.4 + 0.6 * sin((t * 2 * pi) + (i * 0.7));

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = Colors.white.withOpacity(twinkle * 0.8)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
      );
    }

    // ── Floating particles (sparkles) ──
    for (int i = 0; i < 20; i++) {
      final baseX = _rng.nextDouble() * size.width;
      final baseY = _rng.nextDouble() * size.height;
      final speed = 0.3 + _rng.nextDouble() * 0.7;
      final phase = _rng.nextDouble() * 2 * pi;

      final px = baseX + sin(t * 2 * pi * speed + phase) * 20;
      final py = (baseY - t * size.height * 0.1 * speed) % size.height;
      final opacity = 0.2 + 0.5 * sin(t * 2 * pi * speed + phase).abs();

      final colors = [
        const Color(0xFF58CC02),
        const Color(0xFF1CB0F6),
        const Color(0xFFCE82FF),
        const Color(0xFFFFC800),
      ];
      final color = colors[i % colors.length];

      canvas.drawCircle(
        Offset(px, py),
        1.5 + _rng.nextDouble(),
        Paint()
          ..color = color.withOpacity(opacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
  }

  void _drawNebula(Canvas canvas, Size size, Color color, double yStart, double yEnd) {
    final rect = Rect.fromLTWH(0, size.height * yStart, size.width, size.height * (yEnd - yStart));
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          -0.5 + sin(t * 2 * pi * 0.1) * 0.3,
          -0.3 + cos(t * 2 * pi * 0.15) * 0.2,
        ),
        radius: 1.2,
        colors: [
          color.withOpacity(0.3),
          color.withOpacity(0.1),
          Colors.transparent,
        ],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _NebulaPainter old) => true;
}

/// Floating animation wrapper — makes child hover up and down
class FloatingWidget extends StatefulWidget {
  final Widget child;
  final double amplitude;
  final Duration duration;
  final double delay;

  const FloatingWidget({
    super.key,
    required this.child,
    this.amplitude = 6,
    this.duration = const Duration(seconds: 3),
    this.delay = 0,
  });

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: widget.duration, vsync: this);

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -widget.amplitude + widget.amplitude * 2 * _ctrl.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Glow effect wrapper
class GlowEffect extends StatelessWidget {
  final Widget child;
  final Color color;
  final double blurRadius;
  final double spreadRadius;

  const GlowEffect({
    super.key,
    required this.child,
    required this.color,
    this.blurRadius = 20,
    this.spreadRadius = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      child: child,
    );
  }
}
