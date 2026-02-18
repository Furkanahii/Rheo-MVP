import 'package:flutter/material.dart';
import '../logic/storage_service.dart';
import '../logic/elo_calculator.dart';
import '../data/achievements.dart';
import 'achievements_screen.dart';
import 'rank_screen.dart';
import 'customize_profile_screen.dart';
import 'theme.dart';
import 'animations.dart';


/// Available avatar options (emoji-based)
class AvatarData {
  static const List<String> avatars = [
    '🐶', '🐱', '🐼', '🦊', '🐸', '🦉', '🐰',
    '🐻', '🦁', '🐺', '🐯', '🐨', '🦋', '🐬',
  ];

  static const List<Color> avatarColors = [
    Color(0xFF8D6E63), Color(0xFFFF9800), Color(0xFF4CAF50),
    Color(0xFFFF5722), Color(0xFF8BC34A), Color(0xFF9C27B0),
    Color(0xFFE91E63), Color(0xFF795548), Color(0xFFFF6F00),
    Color(0xFF607D8B), Color(0xFFFF7043), Color(0xFF78909C),
    Color(0xFF7C4DFF), Color(0xFF0097A7),
  ];
}



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final progress = storageService.progress;
    final rankColor = Color(EloCalculator.getRankColor(progress.elo));
    final rankTitle = EloCalculator.getRankTitle(progress.elo);
    final safeIndex = progress.selectedAvatarIndex < AvatarData.avatars.length
        ? progress.selectedAvatarIndex : 0;
    final avatarColor = AvatarData.avatarColors[safeIndex];

    // Achievement counts
    final achievementProgress = AchievementProgress(
      totalQuestions: progress.totalQuestions,
      totalCorrect: progress.totalCorrect,
      elo: progress.elo,
      bestStreak: progress.bestStreak,
      currentStreak: progress.currentStreak,
    );
    final unlockedCount = Achievements.getUnlockedCount(achievementProgress);
    final totalCount = Achievements.all.length;

    return Scaffold(
      backgroundColor: RheoTheme.brandScaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: RheoTheme.textColor),
          onPressed: () {
            HapticService.lightTap();
            Navigator.pop(context);
          },
        ),
        title: Text('Profil', style: TextStyle(color: RheoTheme.textColor, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // === Profile Header: Puan — Avatar — Lig ===
              StaggeredFadeIn(
                index: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // PUAN (left)
                    Expanded(
                      child: _ProfileHoverButton(
                        onTap: () {
                          HapticService.lightTap();
                          Navigator.push(
                            context,
                            PageTransitions.slideRight(const RankScreen()),
                          ).then((_) => setState(() {}));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    rankColor.withAlpha(50),
                                    rankColor.withAlpha(20),
                                  ],
                                ),
                                border: Border.all(
                                  color: rankColor.withAlpha(120),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  EloCalculator.getRankEmoji(progress.elo),
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(rankTitle,
                              style: TextStyle(fontSize: 14, color: rankColor, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text('${progress.elo}',
                              style: TextStyle(fontSize: 11, color: RheoTheme.textMuted, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),

                    // AVATAR (center)
                    Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                avatarColor.withAlpha(180),
                                avatarColor.withAlpha(80),
                              ],
                            ),
                            border: Border.all(
                              color: avatarColor.withAlpha(200),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: avatarColor.withAlpha(50),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              AvatarData.avatars[safeIndex],
                              style: const TextStyle(fontSize: 56),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          progress.nickname,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: RheoTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _ProfileHoverButton(
                          onTap: () {
                            HapticService.lightTap();
                            Navigator.push(
                              context,
                              PageTransitions.slideRight(const CustomizeProfileScreen()),
                            ).then((_) => setState(() {}));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: RheoTheme.textColor.withAlpha(15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: RheoTheme.textColor.withAlpha(40)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, size: 13, color: RheoTheme.textColor.withAlpha(160)),
                                const SizedBox(width: 4),
                                Text('Özelleştir',
                                  style: TextStyle(fontSize: 11, color: RheoTheme.textColor.withAlpha(180), fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // LİG (right)
                    Expanded(
                      child: _ProfileHoverButton(
                        onTap: () {
                          HapticService.lightTap();
                          showDialog(
                            context: context,
                            barrierColor: RheoTheme.textColor.withAlpha(100),
                            builder: (context) => Center(
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                                  decoration: BoxDecoration(
                                    color: RheoTheme.cardBg,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: RheoTheme.textColor.withAlpha(60), width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: RheoTheme.textColor.withAlpha(20),
                                        blurRadius: 24,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.shield_outlined, color: RheoTheme.textColor, size: 36),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Çok Yakında! 🚀',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: RheoTheme.textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Lig sistemi geliyor...',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: RheoTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    RheoTheme.textColor.withAlpha(50),
                                    RheoTheme.textColor.withAlpha(20),
                                  ],
                                ),
                                border: Border.all(
                                  color: RheoTheme.textColor.withAlpha(120),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.shield_outlined,
                                  color: RheoTheme.textColor,
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('Lig',
                              style: TextStyle(fontSize: 11, color: RheoTheme.textMuted, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Text('Yakında',
                              style: TextStyle(fontSize: 14, color: RheoTheme.textColor, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // === Compact Stats Section ===
              StaggeredFadeIn(
                index: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('İSTATİSTİKLER',
                    style: TextStyle(color: RheoTheme.textMuted, fontSize: 12, letterSpacing: 3, fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(height: 10),

              StaggeredFadeIn(
                index: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: RheoTheme.brandCardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RheoTheme.brandCardBorder),
                    boxShadow: [
                      BoxShadow(color: RheoTheme.textColor.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MiniStat(icon: Icons.check_circle, value: '${progress.totalCorrect}', label: 'Doğru', color: const Color(0xFF4CAF50)),
                      _divider(),
                      _MiniStat(icon: Icons.cancel, value: '${progress.totalWrong}', label: 'Yanlış', color: RheoColors.error),
                      _divider(),
                      _MiniStat(icon: Icons.percent, value: '${progress.accuracy.toStringAsFixed(0)}%', label: 'Doğruluk', color: RheoTheme.textColor),
                      _divider(),
                      _MiniStat(icon: Icons.quiz, value: '${progress.totalQuestions}', label: 'Toplam', color: RheoTheme.textColor.withAlpha(160)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              StaggeredFadeIn(
                index: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: RheoTheme.brandCardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RheoTheme.brandCardBorder),
                    boxShadow: [
                      BoxShadow(color: RheoTheme.textColor.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MiniStat(icon: Icons.local_fire_department, value: '${progress.currentStreak}', label: 'Güncel Doğru Seri', color: const Color(0xFFFF9800)),
                      _divider(),
                      _MiniStat(icon: Icons.whatshot, value: '${progress.bestStreak}', label: 'En İyi Doğru Seri', color: const Color(0xFFFFD700)),
                      _divider(),
                      _MiniStat(icon: Icons.login, value: '${progress.currentStreak}', label: 'Güncel Giriş Serisi', color: const Color(0xFF42A5F5)),
                      _divider(),
                      _MiniStat(icon: Icons.star, value: '${progress.bestStreak}', label: 'En İyi Giriş Serisi', color: const Color(0xFFAB47BC)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // === Achievements Button ===
              StaggeredFadeIn(
                index: 3,
                child: _ProfileHoverButton(
                  onTap: () {
                    HapticService.lightTap();
                    Navigator.push(
                      context,
                      PageTransitions.slideRight(const AchievementsScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: RheoTheme.brandCardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: RheoTheme.brandCardBorder),
                      boxShadow: [
                        BoxShadow(color: RheoTheme.textColor.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: RheoTheme.textColor.withAlpha(15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.emoji_events, color: RheoTheme.textColor, size: 26),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Başarımlar',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: RheoTheme.textColor)),
                              const SizedBox(height: 2),
                              Text('$unlockedCount /$totalCount başarım kilidi açıldı',
                                style: TextStyle(fontSize: 12, color: RheoTheme.textMuted)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: RheoTheme.textColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('$unlockedCount/$totalCount',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: RheoTheme.textColor)),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios_rounded,
                            color: RheoTheme.textColor.withAlpha(120), size: 16),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 28, color: RheoTheme.textMuted.withAlpha(60));
  }
}

// === Compact Mini Stat ===
class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _MiniStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 4),
        Text(value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 1),
        Text(label,
          style: TextStyle(fontSize: 9, color: RheoTheme.textMuted)),
      ],
    );
  }
}

// === Hover/press button wrapper used for profile elements ===
class _ProfileHoverButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _ProfileHoverButton({required this.child, required this.onTap});

  @override
  State<_ProfileHoverButton> createState() => _ProfileHoverButtonState();
}

class _ProfileHoverButtonState extends State<_ProfileHoverButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: _pressed
              ? (Matrix4.identity()..scale(0.96))
              : (_hovered
                  ? (Matrix4.identity()..translate(0.0, -2.0))
                  : Matrix4.identity()),
          child: widget.child,
        ),
      ),
    );
  }
}
