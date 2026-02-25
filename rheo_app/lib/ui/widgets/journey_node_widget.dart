import 'package:flutter/material.dart';
import '../../data/journey_data.dart';

/// Premium 3D floating island node widget
/// Large, tappable, with strong 3D depth effect
class JourneyNodeWidget extends StatefulWidget {
  final LessonNode node;
  final Color chapterColor;
  final VoidCallback onTap;

  const JourneyNodeWidget({
    super.key,
    required this.node,
    required this.chapterColor,
    required this.onTap,
  });

  @override
  State<JourneyNodeWidget> createState() => _JourneyNodeWidgetState();
}

class _JourneyNodeWidgetState extends State<JourneyNodeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  // ── Colors ──
  static const _greenBright = Color(0xFF58CC02);
  static const _greenMid = Color(0xFF4CAF00);
  static const _greenDark = Color(0xFF2D6A00);
  static const _grey = Color(0xFF3C3C3C);
  static const _greyDark = Color(0xFF2A2A2A);
  static const _greyDarker = Color(0xFF1A1A1A);
  static const _gold = Color(0xFFFFC800);
  static const _goldDark = Color(0xFFCC9E00);

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    if (widget.node.status == NodeStatus.available) {
      _pulseCtrl.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(JourneyNodeWidget old) {
    super.didUpdateWidget(old);
    if (widget.node.status == NodeStatus.available && !_pulseCtrl.isAnimating) {
      _pulseCtrl.repeat(reverse: true);
    } else if (widget.node.status != NodeStatus.available && _pulseCtrl.isAnimating) {
      _pulseCtrl.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = widget.node;

    if (node.type == NodeType.chest) {
      return _buildChest(node);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulseCtrl,
          builder: (context, child) {
            if (node.status == NodeStatus.available) {
              return _buildActiveNode(node);
            }
            return child!;
          },
          child: _buildStaticNode(node),
        ),
        if (node.isCompleted) ...[
          const SizedBox(height: 4),
          _buildStars(node.stars),
        ],
        if (node.status == NodeStatus.available) ...[
          const SizedBox(height: 4),
          _buildEmptyStars(),
        ],
      ],
    );
  }

  /// Active node — large, glowing, pulsing
  Widget _buildActiveNode(LessonNode node) {
    final glowOpacity = 0.3 + (_pulseCtrl.value * 0.5);
    final scale = 1.0 + (_pulseCtrl.value * 0.05);

    return Transform.scale(
      scale: scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: _greenBright.withOpacity(glowOpacity * 0.6), blurRadius: 28, spreadRadius: 6),
                BoxShadow(color: _greenBright.withOpacity(glowOpacity * 0.25), blurRadius: 50, spreadRadius: 12),
              ],
            ),
          ),
          // Glow ring
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _greenBright.withOpacity(glowOpacity), width: 3),
            ),
          ),
          // 3D node
          _build3DNode(
            topColor: _greenBright,
            midColor: _greenMid,
            bottomColor: _greenDark,
            emoji: node.icon,
            size: 70,
          ),
        ],
      ),
    );
  }

  /// Static node (completed or locked)
  Widget _buildStaticNode(LessonNode node) {
    if (node.status == NodeStatus.completed) {
      return _build3DNode(
        topColor: _greenBright,
        midColor: _greenMid,
        bottomColor: _greenDark,
        emoji: node.icon,
        size: 66,
      );
    }
    return _buildLockedNode();
  }

  /// Locked node — grey, crystalline
  Widget _buildLockedNode() {
    return SizedBox(
      width: 66,
      height: 78,
      child: Stack(
        children: [
          // Deep shadow
          Positioned(
            top: 12,
            left: 3, right: 3,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _greyDarker,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 4))],
              ),
            ),
          ),
          // Mid
          Positioned(
            top: 6,
            left: 3, right: 3,
            child: Container(
              height: 60,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: _greyDark),
            ),
          ),
          // Top face
          Positioned(
            top: 0,
            left: 3, right: 3,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4A4A5A), _grey, _greyDark],
                ),
                border: Border.all(color: const Color(0xFF4A4A5A), width: 1),
              ),
              child: const Center(
                child: Icon(Icons.lock_rounded, color: Color(0xFF6A6A7A), size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ── 3D node with dome gradient + multi-layer depth ──
  Widget _build3DNode({
    required Color topColor,
    required Color midColor,
    required Color bottomColor,
    required String emoji,
    required double size,
  }) {
    return SizedBox(
      width: size,
      height: size + 12,
      child: Stack(
        children: [
          // Ground shadow
          Positioned(
            top: size - 2,
            left: size * 0.12, right: size * 0.12,
            child: Container(
              height: 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size),
                color: bottomColor.withOpacity(0.6),
                boxShadow: [BoxShadow(color: topColor.withOpacity(0.12), blurRadius: 12, spreadRadius: 2)],
              ),
            ),
          ),
          // Bottom depth
          Positioned(
            top: 10,
            child: Container(
              width: size, height: size,
              decoration: BoxDecoration(shape: BoxShape.circle, color: bottomColor),
            ),
          ),
          // Mid ring
          Positioned(
            top: 5,
            child: Container(
              width: size, height: size,
              decoration: BoxDecoration(shape: BoxShape.circle, color: midColor),
            ),
          ),
          // Top dome
          Positioned(
            top: 0,
            child: Container(
              width: size, height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.3),
                  radius: 0.9,
                  colors: [
                    Color.lerp(topColor, Colors.white, 0.25)!,
                    topColor,
                    midColor,
                  ],
                ),
                border: Border.all(color: Color.lerp(topColor, Colors.white, 0.15)!, width: 1.5),
              ),
              child: Center(
                child: Text(emoji, style: TextStyle(fontSize: size * 0.42, shadows: const [
                  Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                ])),
              ),
            ),
          ),
          // Highlight gloss
          Positioned(
            top: 5,
            left: size * 0.14,
            child: Container(
              width: size * 0.32,
              height: size * 0.14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size),
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 3D Treasure chest
  Widget _buildChest(LessonNode node) {
    final isLocked = node.status == NodeStatus.locked;
    final isCollected = node.isCompleted;

    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        children: [
          // Shadow
          Positioned(
            bottom: 0, left: 8, right: 8,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.3),
                boxShadow: isLocked ? null : [BoxShadow(color: _gold.withOpacity(0.2), blurRadius: 8)],
              ),
            ),
          ),
          // Chest body
          Positioned(
            top: 0, left: 4, right: 4,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isLocked
                      ? [const Color(0xFF4A4A5A), _greyDark]
                      : [const Color(0xFFD4923A), const Color(0xFFB07D42), const Color(0xFF7A5629)],
                ),
                border: Border.all(color: isLocked ? const Color(0xFF5A5A6A) : _goldDark, width: 2),
                boxShadow: [BoxShadow(color: (isLocked ? Colors.black : const Color(0xFF7A5629)).withOpacity(0.5), blurRadius: 4, offset: const Offset(0, 4))],
              ),
              child: Stack(
                children: [
                  // Band
                  Positioned(top: 22, left: 0, right: 0, child: Container(height: 6, color: (isLocked ? const Color(0xFF5A5A6A) : _goldDark).withOpacity(0.5))),
                  // Center icon
                  Center(
                    child: isCollected
                        ? const Text('✨', style: TextStyle(fontSize: 22))
                        : isLocked
                            ? const Icon(Icons.lock_rounded, color: Color(0xFF6A6A7A), size: 20)
                            : Container(
                                width: 20, height: 20,
                                decoration: BoxDecoration(
                                  color: _gold,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: _goldDark, width: 2),
                                  boxShadow: [BoxShadow(color: _gold.withOpacity(0.4), blurRadius: 6)],
                                ),
                                child: const Center(child: Text('💎', style: TextStyle(fontSize: 10))),
                              ),
                  ),
                  // Highlight
                  Positioned(
                    top: 3, left: 8,
                    child: Container(
                      width: 20, height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white.withOpacity(isLocked ? 0.05 : 0.15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStars(int stars) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Icon(
          i < stars ? Icons.star_rounded : Icons.star_border_rounded,
          color: i < stars ? _gold : const Color(0xFF4A4A5A),
          size: 16,
        ),
      )),
    );
  }

  Widget _buildEmptyStars() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 1),
        child: Icon(Icons.star_border_rounded, color: Color(0xFF4A4A5A), size: 16),
      )),
    );
  }
}
