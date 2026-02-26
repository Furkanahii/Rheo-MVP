import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../logic/storage_service.dart';
import '../logic/elo_calculator.dart';
import 'theme.dart';
import '../data/app_strings.dart';

/// Admin Analytics Dashboard ÔÇö accessible via triple-tap on version in About page
/// Shows local device stats + Firebase Console link for full analytics
class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = storageService.progress;
    final rank = EloCalculator.getRankTitle(p.elo);
    final rankColor = Color(EloCalculator.getRankColor(p.elo));
    
    // Calculate stats
    final totalAnswered = p.totalCorrect + p.totalWrong;
    final accuracy = totalAnswered > 0 
        ? ((p.totalCorrect / totalAnswered) * 100).toStringAsFixed(1) 
        : '0.0';
    final avgEloChange = totalAnswered > 0
        ? ((p.elo - 1000) / totalAnswered).toStringAsFixed(2)
        : '0';

    return Scaffold(
      backgroundColor: RheoTheme.scaffoldBg(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: RheoTheme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.analytics_rounded, color: RheoColors.primary, size: 20),
            const SizedBox(width: 8),
            Text('Admin Panel', style: TextStyle(color: RheoTheme.textColor, fontSize: 16)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: RheoColors.error.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: RheoColors.error.withAlpha(60)),
            ),
            child: const Text('ADMIN', style: TextStyle(color: RheoColors.error, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Overview Card
              _buildCard(
                title: S.tr('Kullan─▒c─▒ ├ûzeti', 'User Overview'),
                icon: Icons.person_rounded,
                color: RheoColors.primary,
                children: [
                  _buildStatRow(S.tr('ELO Puan─▒', 'ELO Score'), '${p.elo}', rankColor),
                  _buildStatRow(S.tr('Seviye', 'Rank'), rank, rankColor),
                  _buildStatRow(S.tr('G├╝nl├╝k Hedef', 'Daily Goal'), '${p.dailyGoal}', RheoTheme.textColor),
                  _buildStatRow(S.tr('Se├ğili Avatar', 'Selected Avatar'), '${p.selectedAvatarIndex}', RheoTheme.textColor),
                  _buildStatRow(S.tr('Dil', 'Locale'), p.locale.toUpperCase(), RheoTheme.textColor),
                  _buildStatRow(S.tr('Tema', 'Theme'), p.isDarkMode ? 'Dark' : 'Light', RheoTheme.textColor),
                ],
              ),

              const SizedBox(height: 16),

              // Performance Card
              _buildCard(
                title: S.tr('Performans', 'Performance'),
                icon: Icons.trending_up_rounded,
                color: RheoColors.success,
                children: [
                  _buildStatRow(S.tr('Toplam Cevap', 'Total Answers'), '$totalAnswered', RheoTheme.textColor),
                  _buildStatRow(S.tr('Do─şru', 'Correct'), '${p.totalCorrect}', RheoColors.success),
                  _buildStatRow(S.tr('Yanl─▒┼ş', 'Wrong'), '${p.totalWrong}', RheoColors.error),
                  _buildStatRow(S.tr('Do─şruluk', 'Accuracy'), '$accuracy%', 
                    double.parse(accuracy) >= 70 ? RheoColors.success : RheoColors.warning),
                  _buildStatRow(S.tr('Ort. ELO De─şi┼şim/Soru', 'Avg ELO Change/Q'), avgEloChange, RheoTheme.textColor),
                ],
              ),

              const SizedBox(height: 16),

              // Streak & Progress Card
              _buildCard(
                title: S.tr('Seril & ─░lerleme', 'Streak & Progress'),
                icon: Icons.local_fire_department,
                color: RheoColors.secondary,
                children: [
                  _buildStatRow(S.tr('G├╝nl├╝k Seri', 'Daily Streak'), '${p.currentStreak}', RheoColors.secondary),
                  _buildStatRow(S.tr('Bug├╝nk├╝ Soru', 'Today\'s Questions'), '${p.dailyQuestionsToday}', RheoTheme.textColor),
                  _buildStatRow(S.tr('Son Oyun', 'Last Played'), p.lastPlayedDate?.toString().split(' ').first ?? '-', RheoTheme.textColor),
                ],
              ),

              const SizedBox(height: 16),

              // Firebase Console Link
              _buildCard(
                title: S.tr('Firebase Analytics', 'Firebase Analytics'),
                icon: Icons.cloud_rounded,
                color: RheoColors.accent,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      S.tr(
                        'Detayl─▒ kullan─▒c─▒ analiti─şi, oturum verileri ve etkinlik izleme i├ğin Firebase Console\'u kullan─▒n.',
                        'Use Firebase Console for detailed user analytics, session data and event tracking.',
                      ),
                      style: TextStyle(color: RheoTheme.textMuted, fontSize: 12, height: 1.4),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(const ClipboardData(
                        text: 'https://console.firebase.google.com/project/rheo-mvp-2026/analytics',
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.tr('Firebase Console linki kopyaland─▒!', 'Firebase Console link copied!')),
                          backgroundColor: RheoColors.success,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: RheoColors.accent.withAlpha(15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: RheoColors.accent.withAlpha(40)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.open_in_new, color: RheoColors.accent, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'console.firebase.google.com/.../analytics',
                              style: TextStyle(color: RheoColors.accent, fontSize: 12, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(Icons.copy, color: RheoColors.accent.withAlpha(150), size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Quick Actions
              _buildCard(
                title: S.tr('H─▒zl─▒ ─░┼şlemler', 'Quick Actions'),
                icon: Icons.settings_rounded,
                color: RheoColors.warning,
                children: [
                  _buildActionButton(
                    context,
                    icon: Icons.refresh_rounded,
                    label: S.tr('─░lerlemeyi S─▒f─▒rla', 'Reset Progress'),
                    color: RheoColors.error,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: RheoTheme.cardBg,
                          title: Text(S.tr('Emin misin?', 'Are you sure?'), style: TextStyle(color: RheoTheme.textColor)),
                          content: Text(S.tr('T├╝m ilerleme s─▒f─▒rlanacak!', 'All progress will be reset!'), 
                            style: TextStyle(color: RheoTheme.textMuted)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(S.tr('─░ptal', 'Cancel')),
                            ),
                            TextButton(
                              onPressed: () async {
                                await storageService.resetProgress();
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Reset', style: TextStyle(color: RheoColors.error)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Center(
                child: Text(
                  S.tr('Bu panel sadece kurucular i├ğindir', 'This panel is for founders only'),
                  style: TextStyle(color: RheoTheme.textMuted.withAlpha(100), fontSize: 11),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RheoTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: RheoTheme.buttonBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(title, style: TextStyle(color: RheoTheme.textColor, fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: RheoTheme.textMuted, fontSize: 13)),
          Text(value, style: TextStyle(color: valueColor, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withAlpha(10),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}