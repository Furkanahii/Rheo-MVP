import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../logic/storage_service.dart';
import '../logic/sound_service.dart';
import '../logic/language_service.dart';
import '../logic/elo_calculator.dart';
import 'theme.dart';
import 'animations.dart';
import 'widgets/mascot_widget.dart';
import 'quiz_screen.dart';
import 'bug_hunt_screen.dart';
import 'time_attack_screen.dart';
import 'settings_screen.dart';
import 'leaderboard_screen.dart';
import 'topic_dialog.dart';
import 'profile_screen.dart';
import 'initial_rank_screen.dart';
import '../data/app_strings.dart';

/// Language-specific accent colors (text) ÔÇö delegates to RheoTheme
Color _langAccent(ProgrammingLanguage lang) => RheoTheme.langText(lang);

/// Language-specific card/button background ÔÇö now always white (cards)
Color _langCardBg(ProgrammingLanguage lang) => RheoTheme.cardBg;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  String? _fixedGreeting;
  String? _fixedSubtitle;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    await storageService.init();
    await soundService.init();
    // Fix the greeting once on init ÔÇö won't change until page is re-entered
    _fixedGreeting = MascotHelper.getGreeting();
    _fixedSubtitle = MascotHelper.getRankComment(storageService.progress.elo);
    setState(() => _isLoading = false);

    // Check if first-time user needs to pick initial rank
    if (!storageService.progress.hasSelectedInitialRank && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const InitialRankScreen()),
          ).then((_) {
            if (mounted) setState(() {});
          });
        }
      });
    }
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

  void _showDailyGoalPicker() {
    final progress = storageService.progress;
    int selectedGoal = progress.hasDailyGoal ? progress.dailyGoal : 5;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: RheoTheme.cardBg,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                S.gunlukHedef,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: RheoTheme.textColor,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.gundeSoruSayisi,
                    style: TextStyle(color: RheoTheme.textMuted, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: selectedGoal > 1
                            ? () => setDialogState(
                                () => selectedGoal--)
                            : null,
                        icon: Icon(Icons.remove_circle_outline,
                            color: selectedGoal > 1
                                ? RheoTheme.textColor
                                : RheoTheme.textMuted),
                      ),
                      Container(
                        width: 60,
                        alignment: Alignment.center,
                        child: Text(
                          '$selectedGoal',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: RheoTheme.textColor,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: selectedGoal < 50
                            ? () => setDialogState(
                                () => selectedGoal++)
                            : null,
                        icon: Icon(Icons.add_circle_outline,
                            color: selectedGoal < 50
                                ? RheoTheme.textColor
                                : RheoTheme.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(S.iptal,
                      style: TextStyle(color: RheoTheme.textMuted)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final p = storageService.progress;
                    p.dailyGoal = selectedGoal;
                    storageService.saveProgress(p);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _langAccent(languageService.selected),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(S.kaydet),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: RheoTheme.scaffoldBg(),
        body: const Center(child: _LoadingShimmer()),
      );
    }

    final progress = storageService.progress;
    final selectedLang = languageService.selected;
    final accent = _langAccent(selectedLang);
    final cardBg = _langCardBg(selectedLang);
    final rankColor = Color(EloCalculator.getRankColor(progress.elo));
    final rankTitle = EloCalculator.getRankTitle(progress.elo);
    final rankEmoji = EloCalculator.getRankEmoji(progress.elo);

    return Scaffold(
      backgroundColor: RheoTheme.scaffoldBg(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Combined header: mascot (left) + RHEO (center) + actions (right)
              StaggeredFadeIn(
                index: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Otter mascot icon (far left, 100px)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/rheo_mascot_icon.png',
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // RHEO text logo (centered, 75px)
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          'assets/rheo_logo.png',
                          height: 75,
                        ),
                      ),
                    ),
                    // Action buttons (right)
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(Icons.emoji_events_outlined, color: RheoTheme.textColor),
                          onPressed: () {
                            HapticService.lightTap();
                            showDialog(
                              context: context,
                              barrierColor: RheoTheme.textColor.withAlpha(100),
                              builder: (context) => Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                                    decoration: BoxDecoration(
                                      color: RheoTheme.cardBg,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: RheoTheme.textColor.withAlpha(60), width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: RheoTheme.textColor.withAlpha(20),
                                          blurRadius: 24,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.emoji_events_outlined, color: RheoTheme.textColor, size: 36),
                                        const SizedBox(height: 12),
                                        Text(
                                          S.tr('├çok Yak─▒nda! ­şÜÇ', 'Coming Soon! ­şÜÇ'),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: RheoTheme.textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          S.tr('S─▒ralama sistemi geliyor...', 'Leaderboard coming soon...'),
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: RheoTheme.textMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          tooltip: S.tr('S─▒ralama', 'Leaderboard'),
                        ),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: RheoColors.secondary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              S.tr('Yak─▒nda', 'Soon'),
                              style: const TextStyle(fontSize: 7, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.settings, color: RheoTheme.textColor),
                      onPressed: () => _navigateTo(const SettingsScreen()),
                    ),
                    GestureDetector(
                      onTap: () => _navigateTo(const ProfileScreen()),
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AvatarData.avatarColors[storageService.progress.selectedAvatarIndex].withAlpha(180),
                              AvatarData.avatarColors[storageService.progress.selectedAvatarIndex].withAlpha(80),
                            ],
                          ),
                          border: Border.all(
                            color: AvatarData.avatarColors[storageService.progress.selectedAvatarIndex].withAlpha(200),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            AvatarData.avatars[storageService.progress.selectedAvatarIndex],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),

              // Language Selector
              StaggeredFadeIn(
                index: 1,
                child: _buildLanguageSelector(selectedLang, accent),
              ),
              
              const SizedBox(height: 14),

              // === Stats Info Section: Puan, Lig, Seri ===
              StaggeredFadeIn(
                index: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: accent.withAlpha(40)),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withAlpha(10),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Puan (Seviye)
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.emoji_events_rounded, color: rankColor, size: 24),
                            const SizedBox(height: 4),
                            Text(
                              '${progress.elo}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: rankColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              rankTitle,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: rankColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Divider
                      Container(width: 1, height: 40, color: accent.withAlpha(40)),
                      // Lig
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.shield_outlined, color: RheoTheme.textColor, size: 24),
                            const SizedBox(height: 4),
                            Text(
                              S.lig,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: RheoTheme.textColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              S.yakinda,
                              style: TextStyle(
                                fontSize: 11,
                                color: RheoTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Divider
                      Container(width: 1, height: 40, color: accent.withAlpha(40)),
                      // Seri
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.local_fire_department, color: const Color(0xFFFF9800), size: 24),
                            const SizedBox(height: 4),
                            Text(
                              '${progress.currentStreak}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFFFF9800),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              S.dogruSeri,
                              style: TextStyle(
                                fontSize: 11,
                                color: RheoTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // === Daily Goal Section ===
              StaggeredFadeIn(
                index: 3,
                child: progress.hasDailyGoal
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: accent.withAlpha(40)),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withAlpha(10),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Goal icon
                            Text('­şÄ»', style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 10),
                            // Progress bar + text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        S.gunlukHedef,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: RheoTheme.textColor,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${progress.dailyQuestionsToday}/${progress.dailyGoal}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: progress.dailyGoalCompleted
                                              ? RheoColors.success
                                              : accent,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: progress.dailyProgress,
                                      minHeight: 8,
                                      backgroundColor: accent.withAlpha(25),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        progress.dailyGoalCompleted
                                            ? RheoColors.success
                                            : accent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Edit button with hover effect
                            _PencilHoverButton(
                              onTap: _showDailyGoalPicker,
                            ),
                          ],
                        ),
                      )
                    : _DailyGoalHoverButton(
                        accent: accent,
                        cardBg: cardBg,
                        onTap: _showDailyGoalPicker,
                      ),
              ),

              const SizedBox(height: 20),
              
              // Mode selection header
              StaggeredFadeIn(
                index: 4,
                child: Text(
                  S.modSec,
                  style: TextStyle(
                    color: RheoTheme.textColor.withAlpha(120),
                    fontSize: 12,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Game mode buttons with hover/press effects
              StaggeredFadeIn(
                index: 5,
                child: _HoverButton(
                  accentColor: accent,
                  cardBg: cardBg,
                  icon: Icons.code_rounded,
                  title: S.ciktiTahmini,
                  subtitle: S.ciktiTahminiSub,
                  onTap: () async {
                    final selectedTopic = await showTopicDialog(context);
                    if (selectedTopic != null && mounted) {
                      _navigateTo(QuizScreen(
                        topic: selectedTopic.id.isEmpty ? null : selectedTopic.id,
                        isAI: selectedTopic.isAI,
                      ));
                    }
                  },
                ),
              ),
              
              const SizedBox(height: 10),
              
              StaggeredFadeIn(
                index: 6,
                child: _HoverButton(
                  accentColor: accent,
                  cardBg: cardBg,
                  icon: Icons.bug_report_rounded,
                  title: S.bugHunter,
                  subtitle: S.bugHunterSub,
                  onTap: () => _navigateTo(const BugHuntScreen()),
                ),
              ),
              
              const SizedBox(height: 10),
              
              StaggeredFadeIn(
                index: 7,
                child: _HoverButton(
                  accentColor: accent,
                  cardBg: cardBg,
                  icon: Icons.timer_rounded,
                  title: S.timeAttack,
                  subtitle: S.timeAttackSub,
                  onTap: () => _navigateTo(const TimeAttackScreen()),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Footer stats
              StaggeredFadeIn(
                index: 8,
                child: Text(
                  S.soruCozuldu(progress.totalQuestions),
                  style: TextStyle(color: RheoTheme.textColor.withAlpha(100), fontSize: 13),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(ProgrammingLanguage selected, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: RheoTheme.cardBg,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: accent.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ProgrammingLanguage.values.map((lang) {
          final isSelected = lang == selected;
          final langColor = _langAccent(lang);
          final langBg = _langCardBg(lang);
          return Expanded(
            child: GestureDetector(
              onTap: () => _onLanguageChanged(lang),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: langBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? langColor : langColor.withAlpha(40),
                    width: isSelected ? 2.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lang.label,
                      style: TextStyle(
                        color: langColor,
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
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
            color: color.withAlpha(120),
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// === Hover/Press button with elevation animation ===
class _HoverButton extends StatefulWidget {
  final Color accentColor;
  final Color cardBg;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HoverButton({
    required this.accentColor,
    required this.cardBg,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  bool get _elevated => _isHovered || _isPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          HapticService.lightTap();
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: widget.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _elevated
                  ? widget.accentColor.withAlpha(120)
                  : widget.accentColor.withAlpha(50),
            ),
            boxShadow: [
              BoxShadow(
                color: _elevated
                    ? widget.accentColor.withAlpha(35)
                    : widget.accentColor.withAlpha(8),
                blurRadius: _elevated ? 20 : 8,
                offset: Offset(0, _elevated ? 6 : 2),
                spreadRadius: _elevated ? 1 : 0,
              ),
            ],
          ),
          transform: _isPressed
              ? (Matrix4.identity()..scale(0.97))
              : (_isHovered
                  ? (Matrix4.identity()..translate(0.0, -2.0))
                  : Matrix4.identity()),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.accentColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: widget.accentColor.withAlpha(40)),
                ),
                child: Icon(widget.icon, color: widget.accentColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: RheoTheme.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: RheoTheme.textColor.withAlpha(140),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: widget.accentColor.withAlpha(100),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === Light themed mascot card ===
class _LightMascotCard extends StatelessWidget {
  final String greeting;
  final String subtitle;
  final Color accentColor;
  final Color cardBg;

  const _LightMascotCard({
    required this.greeting,
    required this.subtitle,
    required this.accentColor,
    required this.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RheoTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            getMascotAsset(MascotMood.greeting),
            width: 56,
            height: 56,
            errorBuilder: (_, __, ___) => Icon(
              Icons.emoji_emotions,
              size: 56,
              color: accentColor.withAlpha(80),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    color: RheoTheme.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: RheoTheme.textColor.withAlpha(140),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: RheoTheme.isDark ? const Color(0xFF2A2A3A) : const Color(0xFFE8EAF6),
      highlightColor: RheoTheme.isDark ? const Color(0xFF3A3A4A) : const Color(0xFFF5F5FF),
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

// === Daily Goal "set" button with hover/press outward pop effect ===
class _DailyGoalHoverButton extends StatefulWidget {
  final Color accent;
  final Color cardBg;
  final VoidCallback onTap;

  const _DailyGoalHoverButton({
    required this.accent,
    required this.cardBg,
    required this.onTap,
  });

  @override
  State<_DailyGoalHoverButton> createState() => _DailyGoalHoverButtonState();
}

class _DailyGoalHoverButtonState extends State<_DailyGoalHoverButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  bool get _elevated => _isHovered || _isPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: widget.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _elevated
                  ? widget.accent.withAlpha(120)
                  : widget.accent.withAlpha(40),
            ),
            boxShadow: [
              BoxShadow(
                color: _elevated
                    ? widget.accent.withAlpha(30)
                    : widget.accent.withAlpha(10),
                blurRadius: _elevated ? 16 : 8,
                offset: Offset(0, _elevated ? 6 : 2),
                spreadRadius: _elevated ? 1 : 0,
              ),
            ],
          ),
          transform: _isPressed
              ? (Matrix4.identity()..scale(0.97))
              : (_isHovered
                  ? (Matrix4.identity()..translate(0.0, -2.0))
                  : Matrix4.identity()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('­şÄ»', style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Text(
                S.gunlukHedefBelirle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// === Pencil icon with hover/press scale effect ===
class _PencilHoverButton extends StatefulWidget {
  final VoidCallback onTap;
  const _PencilHoverButton({required this.onTap});

  @override
  State<_PencilHoverButton> createState() => _PencilHoverButtonState();
}

class _PencilHoverButtonState extends State<_PencilHoverButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: _isPressed
              ? (Matrix4.identity()..scale(0.85))
              : (_isHovered
                  ? (Matrix4.identity()..scale(1.2))
                  : Matrix4.identity()),
          child: Icon(
            Icons.edit,
            size: 18,
            color: _isHovered ? RheoTheme.textColor : RheoTheme.textMuted,
          ),
        ),
      ),
    );
  }
}