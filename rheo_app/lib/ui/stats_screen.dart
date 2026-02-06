import 'package:flutter/material.dart';
import '../logic/storage_service.dart';
import '../logic/elo_calculator.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = storageService.progress;
    final rankColor = Color(EloCalculator.getRankColor(progress.elo));

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text('İstatistikler', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ELO Card
            _buildMainCard(
              child: Column(
                children: [
                  Icon(Icons.emoji_events, color: rankColor, size: 64),
                  const SizedBox(height: 12),
                  Text(
                    '${progress.elo}',
                    style: TextStyle(
                      color: rankColor,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ELO PUANI',
                    style: TextStyle(color: Colors.grey[500], letterSpacing: 2),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: rankColor.withAlpha(51),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      EloCalculator.getRankTitle(progress.elo),
                      style: TextStyle(color: rankColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    value: '${progress.totalCorrect}',
                    label: 'Doğru',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.cancel,
                    iconColor: Colors.red,
                    value: '${progress.totalWrong}',
                    label: 'Yanlış',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.percent,
                    iconColor: Colors.blue,
                    value: '${progress.accuracy.toStringAsFixed(1)}%',
                    label: 'Doğruluk',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.quiz,
                    iconColor: Colors.purple,
                    value: '${progress.totalQuestions}',
                    label: 'Toplam',
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Streak Section
            _buildMainCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStreakItem(
                        icon: Icons.local_fire_department,
                        iconColor: Colors.orange,
                        value: '${progress.currentStreak}',
                        label: 'Güncel Seri',
                      ),
                      Container(
                        width: 1,
                        height: 60,
                        color: Colors.grey[700],
                      ),
                      _buildStreakItem(
                        icon: Icons.military_tech,
                        iconColor: Colors.amber,
                        value: '${progress.bestStreak}',
                        label: 'En İyi Seri',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Last Played
            if (progress.lastPlayedDate != null)
              Text(
                'Son oyun: ${_formatDate(progress.lastPlayedDate!)}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF404040)),
      ),
      child: child,
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF404040)),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
