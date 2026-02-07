import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../logic/storage_service.dart';
import '../logic/sound_service.dart';
import '../logic/elo_calculator.dart';
import 'theme.dart';
import 'animations.dart';
import 'quiz_screen.dart';
import 'bug_hunt_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import 'feedback_dialog.dart';

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
              icon: const Icon(Icons.bar_chart, color: RheoColors.textSecondary),
              onPressed: () => _navigateTo(const StatsScreen()),
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
                const SizedBox(height: 16),
                
                // Logo with glow effect
                StaggeredFadeIn(
                  index: 0,
                  child: _buildLogo(),
                ),
                
                const SizedBox(height: 32),
                
                // Daily Streak Warning
                if (!progress.playedToday)
                  StaggeredFadeIn(
                    index: 1,
                    child: _buildStreakWarning(),
                  ),
                
                // Stats Card
                StaggeredFadeIn(
                  index: 2,
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
                
                const Spacer(),
                
                // Mode selection header
                StaggeredFadeIn(
                  index: 3,
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
                const SizedBox(height: 16),
                
                // Game mode buttons
                StaggeredFadeIn(
                  index: 4,
                  child: _buildModeCard(
                    icon: Icons.code_rounded,
                    title: 'Çıktı Tahmini',
                    subtitle: 'Kodu oku, çıktıyı tahmin et',
                    color: RheoColors.primary,
                    onTap: () => _navigateTo(const QuizScreen()),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                StaggeredFadeIn(
                  index: 5,
                  child: _buildModeCard(
                    icon: Icons.bug_report_rounded,
                    title: 'Bug Hunter',
                    subtitle: 'Hatalı satırı bul',
                    color: RheoColors.secondary,
                    onTap: () => _navigateTo(const BugHuntScreen()),
                  ),
                ),
                
                const Spacer(),
                
                // Footer stats
                StaggeredFadeIn(
                  index: 6,
                  child: Text(
                    '${progress.totalQuestions} soru çözüldü',
                    style: TextStyle(color: RheoColors.textMuted, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        // Logo with glow
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [RheoColors.primary, RheoColors.accent],
            ).createShader(bounds),
            child: const Text(
              'RHEO',
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Kod Okuma Oyunu',
          style: TextStyle(
            fontSize: 14,
            color: RheoColors.textMuted,
            letterSpacing: 4,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        borderColor: RheoColors.secondary.withAlpha(100),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            PulseAnimation(
              child: Icon(
                Icons.local_fire_department,
                color: RheoColors.secondary,
                size: 28,
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
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: RheoColors.textMuted,
            fontSize: 11,
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
        borderColor: color.withAlpha(60),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: RheoGradients.cardGlow(color),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withAlpha(80)),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: RheoColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: color.withAlpha(150),
              size: 18,
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
