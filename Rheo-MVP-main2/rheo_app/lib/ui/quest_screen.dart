import 'package:flutter/material.dart';
import '../data/journey_progress.dart';
import '../logic/storage_service.dart';
import '../data/app_strings.dart';

/// Premium Quest screen with cosmic theme
class QuestScreen extends StatelessWidget {
  const QuestScreen({super.key});

  static const _red = Color(0xFFFF4B4B);
  static const _green = Color(0xFF58CC02);
  static const _gold = Color(0xFFFFC800);
  static const _blue = Color(0xFF1CB0F6);
  static const _surface = Color(0xFF1A2F38);

  @override
  Widget build(BuildContext context) {
    final isTr = storageService.progress.locale == 'tr';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildMonthlyQuest(isTr),
              const SizedBox(height: 20),
              _buildWeekendChallenge(isTr),
              const SizedBox(height: 24),
              _buildDailyQuestsHeader(isTr),
              const SizedBox(height: 12),
              _buildDailyQuest(
                icon: '🔥', color: const Color(0xFFFF9600),
                title: isTr ? 'Bir seriye başla' : 'Start a streak',
                current: storageService.progress.currentStreak > 0 ? 1 : 0,
                total: 1,
                reward: '🎁',
              ),
              const SizedBox(height: 10),
              _buildDailyQuest(
                icon: '🎯', color: _blue,
                title: isTr ? '2 derste %80 veya daha fazla' : 'Score 80%+ in 2 lessons',
                current: 0,
                total: 2,
                reward: '💎',
              ),
              const SizedBox(height: 10),
              _buildDailyQuest(
                icon: '⚡', color: _gold,
                title: isTr ? '5 soru doğru cevapla' : 'Answer 5 questions correctly',
                current: storageService.progress.totalCorrect.clamp(0, 5),
                total: 5,
                reward: '🎁',
              ),
              const SizedBox(height: 10),
              _buildDailyQuest(
                icon: '📖', color: _green,
                title: isTr ? '3 ders tamamla' : 'Complete 3 lessons',
                current: 0,
                total: 3,
                reward: '💎',
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  /// ── Monthly quest ──
  Widget _buildMonthlyQuest(bool isTr) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF5252), Color(0xFFD32F2F)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
            boxShadow: [
              BoxShadow(color: _red.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 6)),
              BoxShadow(color: const Color(0xFFB71C1C), offset: const Offset(0, 5), blurRadius: 0, spreadRadius: -2),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isTr ? 'Şubat Ayı Görevi' : 'February Quest',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(isTr ? '5 GÜN' : '5 DAYS', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isTr ? '15 Görev Puanı kazan' : 'Earn 15 Quest Points',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    _buildProgressBar(0, 15, _gold),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -20,
          right: 16,
          child: Image.asset(
            'assets/mascot_happy.png',
            width: 52,
            height: 52,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Text('🦦', style: TextStyle(fontSize: 36)),
          ),
        ),
      ],
    );
  }

  /// ── Weekend challenge ──
  Widget _buildWeekendChallenge(bool isTr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              isTr ? 'HAFTA SONU GÖREVİ' : 'WEEKEND CHALLENGE',
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
            ),
            const Spacer(),
            _buildTimeBadge(isTr ? '4 SAAT' : '4 HOURS'),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2D6A2E), Color(0xFF1B4B1C)],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(color: _green.withOpacity(0.15), blurRadius: 16, offset: const Offset(0, 4)),
              const BoxShadow(color: Color(0xFF0D2E0E), offset: Offset(0, 4), blurRadius: 0, spreadRadius: -2),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0, left: 20,
                child: Container(width: 60, height: 60, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF3D8C3E).withOpacity(0.5))),
              ),
              Positioned(
                bottom: 0, right: 40,
                child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF3D8C3E).withOpacity(0.4))),
              ),
              Center(
                child: Container(
                  width: 50, height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF8A8A8A), Color(0xFF5A5A5A)]),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(2, 4))],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isTr ? '3 ders tamamla' : 'Complete 3 lessons',
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        _buildProgressBar(0, 3, _green),
      ],
    );
  }

  Widget _buildTimeBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, color: Color(0xFF6B7280), size: 12),
          const SizedBox(width: 3),
          Text(text, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildDailyQuestsHeader(bool isTr) {
    return Row(
      children: [
        Text(
          isTr ? 'GÜNLÜK GÖREVLER' : 'DAILY QUESTS',
          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1),
        ),
        const Spacer(),
        _buildTimeBadge(isTr ? '21 SAAT' : '21 HOURS'),
      ],
    );
  }

  /// ── Daily quest card ──
  Widget _buildDailyQuest({
    required String icon,
    required Color color,
    required String title,
    required int current,
    required int total,
    required String reward,
  }) {
    final isComplete = current >= total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isComplete ? _green.withOpacity(0.4) : Colors.white.withOpacity(0.06)),
        boxShadow: [
          if (isComplete) BoxShadow(color: _green.withOpacity(0.1), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          // Quest icon
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    decoration: isComplete ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 8),
                _buildProgressBar(current, total, color),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Reward
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Center(child: Text(reward, style: const TextStyle(fontSize: 24))),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int current, int total, Color color) {
    final progress = total > 0 ? current / total : 0.0;

    return Stack(
      children: [
        Container(
          height: 16,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A3A),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        FractionallySizedBox(
          widthFactor: progress.clamp(0.0, 1.0),
          child: Container(
            height: 16,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.lerp(color, Colors.white, 0.15)!, color],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: progress > 0 ? [
                BoxShadow(color: color.withOpacity(0.4), blurRadius: 6),
              ] : null,
            ),
          ),
        ),
        // Highlight
        if (progress > 0)
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              height: 6,
              margin: const EdgeInsets.only(top: 2, left: 4, right: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
        SizedBox(
          height: 16,
          child: Center(
            child: Text(
              '$current / $total',
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
