import 'package:flutter/material.dart';
import '../logic/storage_service.dart';
import '../logic/elo_calculator.dart';
import 'theme.dart';
import 'animations.dart';
import 'initial_rank_screen.dart';

class RankScreen extends StatelessWidget {
  const RankScreen({super.key});

  static const _ranks = [
    _RankInfo('Üstat', 1000, '👑', Color(0xFFE61600)),
    _RankInfo('Usta', 800, '⚡', Color(0xFFAA09DB)),
    _RankInfo('Uzman', 600, '🎯', Color(0xFF416FF0)),
    _RankInfo('Deneyimli', 400, '💡', Color(0xFFFF00EA)),
    _RankInfo('Yükselen', 200, '📈', Color(0xFFD99800)),
    _RankInfo('Çaylak', 0, '🌱', Color(0xFFE6E212)),
  ];

  @override
  Widget build(BuildContext context) {
    final progress = storageService.progress;
    final currentRank = EloCalculator.getRankTitle(progress.elo);
    final rankColor = Color(EloCalculator.getRankColor(progress.elo));

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
        title: Text('Rütbe Sistemi',
            style: TextStyle(color: RheoTheme.brandText, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Row(
          children: [
            // Left: Rank table
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RÜTBELER',
                      style: TextStyle(
                        color: RheoTheme.brandMuted,
                        fontSize: 11,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        itemCount: _ranks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final rank = _ranks[index];
                          final isCurrent = rank.title == currentRank;
                          return StaggeredFadeIn(
                            index: index,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              decoration: BoxDecoration(
                                color: rank.color.withAlpha(isCurrent ? 30 : 15),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isCurrent
                                      ? rank.color
                                      : rank.color.withAlpha(50),
                                  width: isCurrent ? 3 : 1,
                                ),
                                boxShadow: isCurrent
                                    ? [
                                        BoxShadow(
                                          color: rank.color.withAlpha(30),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Text(rank.emoji,
                                      style: const TextStyle(fontSize: 22)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          rank.title,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: rank.color,
                                          ),
                                        ),
                                        Text(
                                          rank.title == 'Üstat'
                                              ? '${rank.minElo}+ puan'
                                              : '${rank.minElo}-${rank.minElo + 200} puan',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: rank.color.withAlpha(150),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isCurrent)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: rank.color.withAlpha(30),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        'SEN',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: rank.color,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Right: User info + Reset
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 0, bottom: 16),
                child: Column(
                  children: [
                    // User current rank card
                    StaggeredFadeIn(
                      index: 0,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: rankColor.withAlpha(15),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: rankColor.withAlpha(60)),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.emoji_events_rounded,
                                color: rankColor, size: 36),
                            const SizedBox(height: 4),
                            // Current rank emoji in colored circle
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: rankColor.withAlpha(25),
                                border: Border.all(color: rankColor.withAlpha(80), width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  _ranks.firstWhere((r) => r.title == currentRank, orElse: () => _ranks.last).emoji,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${progress.elo}',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: rankColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Puan',
                              style: TextStyle(
                                fontSize: 11,
                                color: RheoTheme.brandMuted,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: rankColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                currentRank,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: rankColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Reset button
                    StaggeredFadeIn(
                      index: 2,
                      child: SizedBox(
                        width: double.infinity,
                        child: _HoverResetButton(
                          onTap: () {
                            HapticService.lightTap();
                            Navigator.push(
                              context,
                              PageTransitions.slideRight(
                                const InitialRankScreen(isReset: true),
                              ),
                            ).then((_) {
                              // Refresh when coming back
                              (context as Element).markNeedsBuild();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankInfo {
  final String title;
  final int minElo;
  final String emoji;
  final Color color;
  const _RankInfo(this.title, this.minElo, this.emoji, this.color);
}

class _HoverResetButton extends StatefulWidget {
  final VoidCallback onTap;
  const _HoverResetButton({required this.onTap});

  @override
  State<_HoverResetButton> createState() => _HoverResetButtonState();
}

class _HoverResetButtonState extends State<_HoverResetButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool get _elevated => _hovered || _pressed;

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
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: _elevated
                ? RheoColors.error.withAlpha(20)
                : RheoColors.error.withAlpha(10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _elevated
                  ? RheoColors.error.withAlpha(100)
                  : RheoColors.error.withAlpha(40),
            ),
            boxShadow: _elevated
                ? [
                    BoxShadow(
                      color: RheoColors.error.withAlpha(20),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          transform: _pressed
              ? (Matrix4.identity()..scale(0.97))
              : Matrix4.identity(),
          child: Center(
            child: Text(
              'Puanımı Sıfırla',
              style: TextStyle(
                color: RheoColors.error,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
