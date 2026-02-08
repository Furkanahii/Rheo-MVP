import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../logic/storage_service.dart';
import '../logic/sound_service.dart';
import '../logic/language_service.dart';
import '../logic/elo_calculator.dart';
import 'theme.dart';
import 'animations.dart';
import 'quiz_screen.dart';
import 'bug_hunt_screen.dart';
import 'time_attack_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import 'leaderboard_screen.dart';
import 'feedback_dialog.dart';
import 'topic_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    await storageService.init();
    await soundService.init();
    setState(() => _isLoading = false);
  }

  void _navigateTo(Widget screen) {
    HapticService.lightTap();
    Navigator.push(context, PageTransitions.slideRight(screen))
        .then((_) => setState(() {}));
  }

  void _onLanguageChanged(ProgrammingLanguage lang) async {
    HapticService.selectionClick();
    await languageService.setLanguage(lang);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: RheoColors.bgTop,
        body: Center(child: _LoadingShimmer()),
      );
    }

    final progress = storageService.progress;
    final rankColor = Color(EloCalculator.getRankColor(progress.elo));
    final selectedLang = languageService.selected;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.feedback_outlined, color: RheoColors.textSecondary),
              onPressed: () {
                HapticService.lightTap();
                showFeedbackDialog(context);
              },
              tooltip: 'Geri Bildirim',
            ),
            IconButton(
              icon: const Icon(Icons.emoji_events_outlined, color: RheoColors.textSecondary),
              onPressed: () => _navigateTo(const LeaderboardScreen()),
              tooltip: 'Sıralama',
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart, color: RheoColors.textSecondary),
              onPressed: () => _navigateTo(const StatsScreen()),
              tooltip: 'İstatistikler',
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: RheoColors.textSecondary),
              onPressed: () => _navigateTo(const SettingsScreen()),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Language Selector
                StaggeredFadeIn(
                  index: 0,
                  child: _buildLanguageSelector(selectedLang),
                ),
                
                const SizedBox(height: 16),
                
                // Logo with glow effect
                StaggeredFadeIn(
                  index: 1,
                  child: _buildLogo(),
                ),
                
                const SizedBox(height: 12),
                
                // Daily Streak Warning
                if (!progress.playedToday)
                  StaggeredFadeIn(
                    index: 2,
                    child: _buildStreakWarning(),
                  ),
                
                // Stats Card
                StaggeredFadeIn(
                  index: 3,
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          icon: Icons.emoji_events,
                          value: '${progress.elo}',
                          label: 'ELO',
                          color: rankColor,
                        ),
                        _buildStatItem(
                          icon: Icons.local_fire_department,
                          value: '${progress.currentStreak}',
                          label: 'Seri',
                          color: RheoColors.secondary,
                        ),
                        _buildStatItem(
                          icon: Icons.percent,
                          value: '${progress.accuracy.toStringAsFixed(0)}%',
                          label: 'Doğruluk',
                          color: RheoColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Daily Goal Card
                StaggeredFadeIn(
                  index: 4,
                  child: GlassCard(
                    borderColor: progress.dailyGoalCompleted 
                        ? RheoColors.success.withAlpha(100) 
                        : RheoColors.primary.withAlpha(50),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Icon(
                          progress.dailyGoalCompleted 
                              ? Icons.check_circle_rounded 
                              : Icons.flag_rounded,
                          color: progress.dailyGoalCompleted 
                              ? RheoColors.success 
                              : RheoColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                progress.dailyGoalCompleted 
                                    ? 'Günlük hedef tamamlandı! 🎉' 
                                    : 'Günlük Hedef',
                                style: TextStyle(
                                  color: progress.dailyGoalCompleted 
                                      ? RheoColors.success 
                                      : Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: progress.dailyProgress,
                                  backgroundColor: RheoColors.glassLight,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    progress.dailyGoalCompleted 
                                        ? RheoColors.success 
                                        : RheoColors.primary,
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${progress.dailyQuestionsToday}/${progress.dailyGoal}',
                          style: TextStyle(
                            color: progress.dailyGoalCompleted 
                                ? RheoColors.success 
                                : RheoColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Mode selection header
                StaggeredFadeIn(
                  index: 4,
                  child: Text(
                    'MOD SEÇ',
                    style: TextStyle(
                      color: RheoColors.textMuted,
                      fontSize: 12,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Game mode buttons
                StaggeredFadeIn(
                  index: 5,
                  child: _buildModeCard(
                    icon: Icons.code_rounded,
                    title: 'Çıktı Tahmini',
                    subtitle: 'Kodu oku, çıktıyı tahmin et',
                    color: RheoColors.primary,
                    onTap: () async {
                      final topic = await showTopicDialog(context);
                      if (topic != null && mounted) {
                        _navigateTo(QuizScreen(topic: topic.isEmpty ? null : topic));
                      }
                    },
                  ),
                ),
                
                const SizedBox(height: 10),
                
                StaggeredFadeIn(
                  index: 6,
                  child: _buildModeCard(
                    icon: Icons.bug_report_rounded,
                    title: 'Bug Hunter',
                    subtitle: 'Hatalı satırı bul',
                    color: RheoColors.secondary,
                    onTap: () => _navigateTo(const BugHuntScreen()),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                StaggeredFadeIn(
                  index: 7,
                  child: _buildModeCard(
                    icon: Icons.timer_rounded,
                    title: 'Time Attack',
                    subtitle: 'Zamana karşı yarış',
                    color: RheoColors.accent,
                    onTap: () => _navigateTo(const TimeAttackScreen()),
                  ),
                ),
                
                const Spacer(),
                
                // Footer stats
                StaggeredFadeIn(
                  index: 8,
                  child: Text(
                    '${progress.totalQuestions} soru çözüldü',
                    style: TextStyle(color: RheoColors.textMuted, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(ProgrammingLanguage selected) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      borderRadius: BorderRadius.circular(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ProgrammingLanguage.values.map((lang) {
          final isSelected = lang == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => _onLanguageChanged(lang),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Color(lang.colorValue).withAlpha(40) 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected 
                      ? Border.all(color: Color(lang.colorValue).withAlpha(100)) 
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(lang.emoji, style: const TextStyle(fontSize: 16)),
                    if (isSelected) ...[
                      const SizedBox(width: 4),
                      Text(
                        lang.label,
                        style: TextStyle(
                          color: Color(lang.colorValue),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Mascot
        Image.asset(
          'assets/mascot.png',
          height: 50,
        ),
        const SizedBox(height: 4),
        // App Name
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [RheoColors.primary, RheoColors.accent],
          ).createShader(bounds),
          child: const Text(
            'RHEO',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 6,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Learning for coding',
          style: TextStyle(
            fontSize: 12,
            color: RheoColors.textMuted,
            letterSpacing: 2,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        borderColor: RheoColors.secondary.withAlpha(100),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            PulseAnimation(
              child: Icon(
                Icons.local_fire_department,
                color: RheoColors.secondary,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Bugün henüz oynamadın! Serini koru.',
                style: TextStyle(color: RheoColors.secondary, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: RheoColors.textMuted,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticService.lightTap();
        onTap();
      },
      child: GlassCard(
        borderColor: color.withAlpha(50),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: RheoGradients.cardGlow(color),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withAlpha(70)),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: RheoColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: color.withAlpha(120),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: RheoColors.surfaceLight,
      highlightColor: RheoColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
