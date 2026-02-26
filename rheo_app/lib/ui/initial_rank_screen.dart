import 'package:flutter/material.dart';
import '../logic/storage_service.dart';
import '../data/app_strings.dart';
import 'theme.dart';
import 'animations.dart';

/// Rank se├ğim bilgisi
class RankOption {
  final String title;
  final int startElo;
  final String emoji;
  final Color color;

  RankOption(this.title, this.startElo, this.emoji, this.color);
}

List<RankOption> get _rankOptions => [
  RankOption(S.rankUstat, 1000, '­şææ', const Color(0xFFD32F2F)),
  RankOption(S.rankUsta, 800, 'ÔÜí', const Color(0xFF7B1FA2)),
  RankOption(S.rankUzman, 600, '­şÄ»', const Color(0xFF1976D2)),
  RankOption(S.rankDeneyimli, 400, '­şÆí', const Color(0xFFD81B60)),
  RankOption(S.rankYukselen, 200, '­şôê', const Color(0xFF388E3C)),
  RankOption(S.rankCaylak, 0, '­şî▒', const Color(0xFF795548)),
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
                isReset ? S.seviyeSecimi : S.tr('Ho┼ş Geldin! ­şÄë', 'Welcome! ­şÄë'),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: RheoTheme.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isReset
                    ? S.tr('Yeniden ba┼şlamak istedi─şin seviyeyi se├ğ', 'Choose the level you want to restart from')
                    : S.tr('Kendini hangi seviyede g├Âr├╝yorsun?', 'What level do you see yourself at?'),
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
          S.tr('${rank.startElo} puandan ba┼şlamak istedi─şine emin misin?', 'Are you sure you want to start from ${rank.startElo} points?'),
          style: TextStyle(color: RheoTheme.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.iptal, style: TextStyle(color: RheoTheme.textMuted)),
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
            child: Text(S.onayla),
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
                      S.tr('${widget.rank.startElo} puandan ba┼şla', 'Start from ${widget.rank.startElo} pts'),
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