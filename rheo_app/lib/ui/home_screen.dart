import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../logic/storage_service.dart';
import '../logic/sound_service.dart';
import '../logic/elo_calculator.dart';
import 'quiz_screen.dart';
import 'bug_hunt_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

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

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Geri Bildirim 📬', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bir hata mı buldun? Önerilerin mi var? Bize ulaş!',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: 'team@rheo.app',
                queryParameters: {
                  'subject': 'Rheo Feedback',
                  'body': 'Uygulama Versiyonu: 1.0.0\nCihaz: Flutter Web\n\n---\nMesajınız:\n',
                },
              );
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              }
            },
            icon: const Icon(Icons.email, color: Colors.black),
            label: const Text('E-posta Gönder', style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00D9FF)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00D9FF)),
        ),
      );
    }

    final progress = storageService.progress;
    final rankColor = Color(EloCalculator.getRankColor(progress.elo));

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.feedback_outlined, color: Colors.white),
            onPressed: _showFeedbackDialog,
            tooltip: 'Geri Bildirim',
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StatsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ).then((_) => setState(() {})),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Logo / Title
              const Text(
                'RHEO',
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kod Okuma Oyunu',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[400],
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Daily Streak Warning
              if (!progress.playedToday)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withAlpha(100)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.orange, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Bugün henüz oynamadın! Serini korumak için hemen başla.',
                          style: TextStyle(color: Colors.orange[200], fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Stats Card (Compact)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMiniStat(Icons.emoji_events, '${progress.elo}', 'ELO', rankColor),
                    _buildMiniStat(Icons.local_fire_department, '${progress.currentStreak}', 'Seri', Colors.orange),
                    _buildMiniStat(Icons.percent, '${progress.accuracy.toStringAsFixed(0)}%', 'Başarı', Colors.blue),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Game Modes
              const Text(
                'MOD SEÇ',
                style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 2),
              ),
              const SizedBox(height: 16),
              
              // Output Prediction Mode
              _buildModeButton(
                icon: Icons.code,
                title: 'Çıktı Tahmini',
                subtitle: 'Kodu oku, çıktıyı tahmin et',
                color: const Color(0xFF00D9FF),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizScreen()),
                  ).then((_) => setState(() {}));
                },
              ),
              
              const SizedBox(height: 12),
              
              // Bug Hunt Mode
              _buildModeButton(
                icon: Icons.bug_report,
                title: 'Bug Hunter',
                subtitle: 'Hatalı satırı bul',
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BugHuntScreen()),
                  ).then((_) => setState(() {}));
                },
              ),
              
              const Spacer(),
              
              Text(
                '${progress.totalQuestions} soru çözüldü',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
      ],
    );
  }

  Widget _buildModeButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withAlpha(80)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color.withAlpha(150), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
