import 'package:flutter/material.dart';

/// Premium bottom navigation bar — all 5 tabs work
class JourneyBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const JourneyBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _bg = Color(0xFF0D1820);
  static const _border = Color(0xFF1E3340);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: _bg,
        border: const Border(top: BorderSide(color: _border, width: 1)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Journey',
              isActive: currentIndex == 0,
              activeColor: const Color(0xFF58CC02),
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.inventory_2_rounded,
              label: 'Quests',
              isActive: currentIndex == 1,
              activeColor: const Color(0xFFFFC800),
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.emoji_events_rounded,
              label: 'League',
              isActive: currentIndex == 2,
              activeColor: const Color(0xFF1CB0F6),
              onTap: () => onTap(2),
            ),
            _NavItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              isActive: currentIndex == 3,
              activeColor: const Color(0xFFCE82FF),
              onTap: () => onTap(3),
            ),
            _NavItem(
              icon: Icons.more_horiz_rounded,
              label: 'More',
              isActive: currentIndex == 4,
              activeColor: Colors.white,
              onTap: () => onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : const Color(0xFF4B5563);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        height: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Active indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 40 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: color,
                boxShadow: isActive ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 6)] : null,
              ),
            ),
            // Icon container
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isActive ? color.withOpacity(0.15) : Colors.transparent,
                border: isActive
                    ? Border.all(color: color.withOpacity(0.4), width: 1.5)
                    : null,
                boxShadow: isActive ? [BoxShadow(color: color.withOpacity(0.15), blurRadius: 8)] : null,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
