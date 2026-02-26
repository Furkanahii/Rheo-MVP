import 'package:flutter/material.dart';
import '../logic/storage_service.dart';
import 'theme.dart';
import 'animations.dart';

/// Rank seçim bilgisi
class RankOption {
  final String title;
  final int startElo;
  final String emoji;
  final Color color;

  const RankOption(this.title, this.startElo, this.emoji, this.color);
}

final _rankOptions = [
  RankOption('Üstat', 1000, '👑', const Color(0xFFE61600)),
  RankOption('Usta', 800, '⚡', const Color(0xFFAA09DB)),
  RankOption('Uzman', 600, '🎯', const Color(0xFF416FF0)),
  RankOption('Deneyimli', 400, '💡', const Color(0xFFFF00EA)),
  RankOption('Yükselen', 200, '📈', const Color(0xFFD99800)),
  RankOption('Çaylak', 0, '🌱', const Color(0xFFE6E212)),
];

class InitialRankScreen extends StatelessWidget {
  final bool isReset;
  const InitialRankScreen({super.key, this.isReset = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RheoTheme.brandScaffoldBg,
      appBar: isReset ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: RheoTheme.textColor),
          onPressed: () {
            HapticService.lightTap();
            Navigator.pop(context);
          },
        ),
      ) : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                isReset ? 'Seviyeni Seç' : 'Hoş Geldin! 🎉',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: RheoTheme.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isReset
                    ? 'Yeniden başlamak istediğin seviyeyi seç'
                    : 'Kendini hangi seviyede görüyorsun?',
                style: TextStyle(
                  fontSize: 14,
                  color: RheoTheme.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  itemCount: _rankOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final rank = _rankOptions[index];
                    return StaggeredFadeIn(
                      index: index,
                      child: _RankCard(
                        rank: rank,
                        onTap: () => _selectRank(context, rank),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _selectRank(BuildContext context, RankOption rank) {
    HapticService.lightTap();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: RheoTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '${rank.emoji} ${rank.title}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: rank.color,
          ),
        ),
        content: Text(
          '${rank.startElo} puandan başlamak istediğine emin misin?',
          style: TextStyle(color: RheoTheme.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('İptal', style: TextStyle(color: RheoTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              final p = storageService.progress;
              p.elo = rank.startElo;
              p.hasSelectedInitialRank = true;
              if (isReset) {
                p.totalCorrect = 0;
                p.totalWrong = 0;
                p.currentStreak = 0;
                p.bestStreak = 0;
                p.dailyQuestionsToday = 0;
              }
              storageService.saveProgress(p);
              Navigator.pop(ctx);
              if (isReset) {
                Navigator.pop(context); // pop rank_screen
              } else {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: rank.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Onayla'),
          ),
        ],
      ),
    );
  }
}

class _RankCard extends StatefulWidget {
  final RankOption rank;
  final VoidCallback onTap;
  const _RankCard({required this.rank, required this.onTap});

  @override
  State<_RankCard> createState() => _RankCardState();
}

class _RankCardState extends State<_RankCard> {
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
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: widget.rank.color.withAlpha(20),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _elevated
                  ? widget.rank.color.withAlpha(120)
                  : widget.rank.color.withAlpha(40),
            ),
            boxShadow: [
              BoxShadow(
                color: _elevated
                    ? widget.rank.color.withAlpha(30)
                    : widget.rank.color.withAlpha(8),
                blurRadius: _elevated ? 18 : 6,
                offset: Offset(0, _elevated ? 5 : 2),
              ),
            ],
          ),
          transform: _pressed
              ? (Matrix4.identity()..scale(0.97))
              : (_hovered
                  ? (Matrix4.identity()..translate(0.0, -2.0))
                  : Matrix4.identity()),
          child: Row(
            children: [
              Text(widget.rank.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.rank.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: widget.rank.color,
                      ),
                    ),
                    Text(
                      '${widget.rank.startElo} puandan başla',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.rank.color.withAlpha(160),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: widget.rank.color.withAlpha(100), size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
