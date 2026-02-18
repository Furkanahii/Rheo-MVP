import 'package:flutter/material.dart';
import '../data/achievements.dart';
import '../logic/storage_service.dart';
import 'theme.dart';
import 'animations.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = storageService.progress;
    final achievementProgress = AchievementProgress(
      totalQuestions: progress.totalQuestions,
      totalCorrect: progress.totalCorrect,
      elo: progress.elo,
      bestStreak: progress.bestStreak,
      currentStreak: progress.currentStreak,
    );

    final unlocked = Achievements.getUnlocked(achievementProgress);
    final locked = Achievements.getLocked(achievementProgress);

    return Scaffold(
      backgroundColor: RheoTheme.brandScaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: RheoTheme.brandText),
          onPressed: () {
            HapticService.lightTap();
            Navigator.pop(context);
          },
        ),
        title: Text('Başarımlar', style: TextStyle(color: RheoTheme.brandText)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Header
              StaggeredFadeIn(
                index: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: RheoTheme.brandCardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RheoTheme.brandCardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: RheoTheme.brandBlue.withAlpha(10),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: RheoTheme.brandCyan.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.emoji_events_rounded,
                          color: RheoTheme.brandCyan,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${unlocked.length} / ${Achievements.all.length}',
                              style: TextStyle(
                                color: RheoTheme.brandText,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Başarım Kazanıldı',
                              style: TextStyle(
                                color: RheoTheme.brandMuted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Progress circle
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Stack(
                          children: [
                            CircularProgressIndicator(
                              value: unlocked.length / Achievements.all.length,
                              backgroundColor: RheoTheme.brandCyan.withAlpha(30),
                              valueColor: AlwaysStoppedAnimation<Color>(RheoTheme.brandCyan),
                              strokeWidth: 5,
                            ),
                            Center(
                              child: Text(
                                '${((unlocked.length / Achievements.all.length) * 100).round()}%',
                                style: TextStyle(
                                  color: RheoTheme.brandCyan,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Unlocked Section
              if (unlocked.isNotEmpty) ...[
                _buildSectionHeader('KAZANILAN', unlocked.length),
                const SizedBox(height: 12),
                ...unlocked.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: StaggeredFadeIn(
                    index: e.key + 1,
                    child: _buildAchievementCard(e.value, isUnlocked: true),
                  ),
                )),
                const SizedBox(height: 20),
              ],

              // Locked Section
              if (locked.isNotEmpty) ...[
                _buildSectionHeader('KİLİTLİ', locked.length),
                const SizedBox(height: 12),
                ...locked.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: StaggeredFadeIn(
                    index: e.key + unlocked.length + 2,
                    child: _buildAchievementCard(e.value, isUnlocked: false),
                  ),
                )),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: RheoTheme.brandMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: RheoTheme.brandCyan.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: RheoTheme.brandMuted,
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(Achievement achievement, {required bool isUnlocked}) {
    final color = Color(achievement.colorValue);
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: RheoTheme.brandCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnlocked ? color.withAlpha(80) : RheoTheme.brandCardBorder,
        ),
        boxShadow: isUnlocked ? [
          BoxShadow(
            color: color.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUnlocked ? color.withAlpha(30) : RheoTheme.brandCardBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              achievement.icon,
              color: isUnlocked ? color : RheoTheme.brandMuted,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    color: isUnlocked ? RheoTheme.textColor : RheoTheme.textMuted,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description,
                  style: TextStyle(
                    color: RheoTheme.brandMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isUnlocked)
            Icon(
              Icons.check_circle_rounded,
              color: color,
              size: 22,
            )
          else
            Icon(
              Icons.lock_rounded,
              color: RheoTheme.brandMuted,
              size: 20,
            ),
        ],
      ),
    );
  }
}
