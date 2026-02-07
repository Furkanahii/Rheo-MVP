import 'package:flutter/material.dart';
import '../logic/storage_service.dart';
import '../logic/elo_calculator.dart';
import 'theme.dart';
import 'animations.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = storageService.progress;
    final rankColor = Color(EloCalculator.getRankColor(progress.elo));
    final rankTitle = EloCalculator.getRankTitle(progress.elo);
    
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () {
              HapticService.lightTap();
              Navigator.pop(context);
            },
          ),
          title: const Text('İstatistikler', style: TextStyle(color: Colors.white)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // ELO Card (Main)
                StaggeredFadeIn(
                  index: 0,
                  child: GlassCard(
                    borderColor: rankColor.withAlpha(80),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: rankColor.withAlpha(30),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.emoji_events, color: rankColor, size: 40),
                        ),
                        const SizedBox(height: 12),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [rankColor, rankColor.withAlpha(180)],
                          ).createShader(bounds),
                          child: Text(
                            '${progress.elo}',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          rankTitle,
                          style: TextStyle(
                            fontSize: 18,
                            color: rankColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Performance Stats
                StaggeredFadeIn(
                  index: 1,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.check_circle,
                          value: '${progress.totalCorrect}',
                          label: 'Doğru',
                          color: RheoColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.cancel,
                          value: '${progress.totalWrong}',
                          label: 'Yanlış',
                          color: RheoColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Accuracy & Total
                StaggeredFadeIn(
                  index: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.percent,
                          value: '${progress.accuracy.toStringAsFixed(1)}%',
                          label: 'Doğruluk',
                          color: RheoColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          icon: Icons.quiz,
                          value: '${progress.totalQuestions}',
                          label: 'Toplam',
                          color: RheoColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Streak Stats
                StaggeredFadeIn(
                  index: 3,
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.local_fire_department, color: RheoColors.secondary, size: 22),
                            const SizedBox(width: 8),
                            const Text(
                              'Seri İstatistikleri',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const Divider(color: RheoColors.glassBorder, height: 24),
                        _buildInfoRow('Güncel Seri', '${progress.currentStreak} gün', RheoColors.secondary),
                        const SizedBox(height: 8),
                        _buildInfoRow('En İyi Seri', '${progress.bestStreak} gün', RheoColors.gold),
                        const SizedBox(height: 8),
                        _buildInfoRow('Son Oynama', _formatDate(progress.lastPlayedDate ?? DateTime.now()), RheoColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Rank Progress
                StaggeredFadeIn(
                  index: 4,
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rütbe İlerlemesi',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),
                        _buildRankProgress(progress.elo),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return GlassCard(
      borderColor: color.withAlpha(50),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: RheoColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: RheoColors.textSecondary)),
        Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildRankProgress(int elo) {
    final ranks = [
      ('Bronz', 0, RheoColors.bronze),
      ('Gümüş', 1000, RheoColors.silver),
      ('Altın', 1500, RheoColors.gold),
      ('Platin', 2000, RheoColors.platinum),
      ('Elmas', 2500, RheoColors.diamond),
    ];
    
    return Column(
      children: ranks.map((rank) {
        final isAchieved = elo >= rank.$2;
        final isNext = !isAchieved && (ranks.indexOf(rank) == 0 || elo >= ranks[ranks.indexOf(rank) - 1].$2);
        final progress = isAchieved ? 1.0 : (isNext ? ((elo - ranks[ranks.indexOf(rank) - 1].$2) / (rank.$2 - ranks[ranks.indexOf(rank) - 1].$2)).clamp(0.0, 1.0) : 0.0);
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: Text(
                  rank.$1,
                  style: TextStyle(
                    color: isAchieved ? rank.$3 : RheoColors.textMuted,
                    fontWeight: isAchieved ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: RheoColors.glassLight,
                    valueColor: AlwaysStoppedAnimation<Color>(rank.$3),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 40,
                child: Text(
                  '${rank.$2}',
                  style: TextStyle(color: RheoColors.textMuted, fontSize: 11),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) return 'Bugün';
    if (diff.inDays == 1) return 'Dün';
    if (diff.inDays < 7) return '${diff.inDays} gün önce';
    return '${date.day}/${date.month}/${date.year}';
  }
}
