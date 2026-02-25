import 'package:flutter/material.dart';
import '../data/journey_data.dart';
import '../data/journey_progress.dart';
import '../logic/language_service.dart';
import '../logic/storage_service.dart';
import '../data/app_strings.dart';
import 'theme.dart';
import 'widgets/journey_node_widget.dart';
import 'widgets/journey_path_painter.dart';
import 'widgets/journey_bottom_nav.dart';
import 'widgets/cosmic_effects.dart';
import 'quest_screen.dart';
import 'quiz_screen.dart';
import 'animations.dart';

/// Premium 3D Anti-Gravity Learning Journey
class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});
  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> with TickerProviderStateMixin {
  late JourneyMap _journeyMap;
  late ScrollController _scrollCtrl;
  bool _isLoading = true;
  int _navIndex = 0;

  // ── Colors ──
  static const _spaceBg = Color(0xFF0A0E1A);
  static const _greenBright = Color(0xFF58CC02);
  static const _greenMid = Color(0xFF46A302);
  static const _greenDark = Color(0xFF2D6A00);
  static const _gold = Color(0xFFFFC800);
  static const _blue = Color(0xFF1CB0F6);
  static const _red = Color(0xFFFF4B4B);
  static const _purple = Color(0xFFCE82FF);

  @override
  void initState() {
    super.initState();
    _scrollCtrl = ScrollController();
    _loadJourney();
  }

  Future<void> _loadJourney() async {
    await journeyProgress.init();
    _buildCurrentJourney();
    journeyProgress.applyProgress(_journeyMap);
    setState(() => _isLoading = false);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActive());
  }

  void _buildCurrentJourney() {
    switch (languageService.selected) {
      case ProgrammingLanguage.python:
        _journeyMap = buildPythonJourney();
        break;
      case ProgrammingLanguage.java:
        _journeyMap = buildJavaJourney();
        break;
      case ProgrammingLanguage.javascript:
        _journeyMap = buildJavaScriptJourney();
        break;
    }
  }

  void _scrollToActive() {
    if (!_scrollCtrl.hasClients) return;
    final allNodes = _journeyMap.allNodes;
    int idx = allNodes.indexWhere((n) => n.status == NodeStatus.available);
    if (idx < 0) idx = allNodes.length - 1;
    final target = (idx * 130.0 - 200).clamp(0.0, _scrollCtrl.position.maxScrollExtent);
    _scrollCtrl.animateTo(target, duration: const Duration(milliseconds: 800), curve: Curves.easeOutCubic);
  }

  void _reloadJourney() {
    _buildCurrentJourney();
    journeyProgress.applyProgress(_journeyMap);
    setState(() {});
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _spaceBg,
      body: CosmicBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: _greenBright))
                    : _navIndex == 0
                        ? _buildJourneyView()
                        : _navIndex == 1
                            ? const QuestScreen()
                            : _buildComingSoonTab(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: JourneyBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  /// ═══════════════════════════════════════════
  ///  "Coming Soon" placeholder for tabs 2-4
  /// ═══════════════════════════════════════════
  Widget _buildComingSoonTab() {
    final labels = ['', '', 'Liderlik Tablosu', 'Profil', 'Ayarlar'];
    final icons = [Icons.home, Icons.inventory_2, Icons.emoji_events_rounded, Icons.person_rounded, Icons.settings_rounded];
    final colors = [_greenBright, _gold, _blue, _purple, Colors.white];
    final idx = _navIndex.clamp(2, 4);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors[idx].withOpacity(0.1),
              border: Border.all(color: colors[idx].withOpacity(0.3), width: 2),
            ),
            child: Icon(icons[idx], color: colors[idx], size: 48),
          ),
          const SizedBox(height: 20),
          Text(
            labels[idx],
            style: TextStyle(color: colors[idx], fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            S.tr('Yakında!', 'Coming Soon!'),
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 15),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  TOP STATUS BAR + LANGUAGE SWITCHER
  // ═══════════════════════════════════════════
  Widget _buildTopBar() {
    final lang = languageService.selected;
    final progress = storageService.progress;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // ── Language selector (TAPPABLE!) ──
          GestureDetector(
            onTap: () => _showLanguagePicker(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color(lang.colorValue).withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Color(lang.colorValue).withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(color: Color(lang.colorValue).withOpacity(0.1), blurRadius: 8),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(lang.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    lang.label,
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white60, size: 18),
                ],
              ),
            ),
          ),
          const Spacer(),
          _statusBadge('🔥', '${progress.currentStreak}', const Color(0xFFFF9600)),
          const SizedBox(width: 6),
          _statusBadge('💎', '${journeyProgress.totalJourneyXP}', _blue),
          const SizedBox(width: 6),
          _statusBadge('❤️', '5', _red),
        ],
      ),
    );
  }

  /// ── Language picker bottom sheet ──
  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2F38).withOpacity(0.98),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              S.tr('Programlama Dili Seç', 'Select Language'),
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            for (final lang in ProgrammingLanguage.values) ...[
              _buildLanguageOption(lang, ctx),
              if (lang != ProgrammingLanguage.values.last) const SizedBox(height: 10),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(ProgrammingLanguage lang, BuildContext ctx) {
    final isSelected = languageService.selected == lang;
    final color = Color(lang.colorValue);

    return GestureDetector(
      onTap: () async {
        await languageService.setLanguage(lang);
        _reloadJourney();
        if (ctx.mounted) Navigator.pop(ctx);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color.withOpacity(0.6) : Colors.white.withOpacity(0.08),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: color.withOpacity(0.15), blurRadius: 12),
          ] : null,
        ),
        child: Row(
          children: [
            Text(lang.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                lang.label,
                style: TextStyle(
                  color: isSelected ? color : Colors.white70,
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
            if (isSelected)
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
              ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 8)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  JOURNEY VIEW
  // ═══════════════════════════════════════════
  Widget _buildJourneyView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth.clamp(0.0, 420.0);
    final isTr = storageService.progress.locale == 'tr';

    return SingleChildScrollView(
      controller: _scrollCtrl,
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: SizedBox(
          width: contentWidth,
          child: Column(
            children: [
              const SizedBox(height: 8),
              for (int ci = 0; ci < _journeyMap.chapters.length; ci++) ...[
                FloatingWidget(
                  amplitude: 3,
                  delay: ci * 0.5,
                  child: _buildUnitHeader(_journeyMap.chapters[ci], isTr),
                ),
                const SizedBox(height: 24),
                _buildChapterPath(_journeyMap.chapters[ci], contentWidth, ci),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  UNIT HEADER
  // ═══════════════════════════════════════════
  Widget _buildUnitHeader(JourneyChapter chapter, bool isTr) {
    final color = Color(chapter.colorValue);
    final completedCount = chapter.nodes.where((n) => n.isCompleted).length;
    final totalCount = chapter.nodes.where((n) => n.type != NodeType.chest).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            Color.lerp(color, Colors.black, 0.25)!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color.lerp(color, Colors.white, 0.35)!.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Color.lerp(color, Colors.black, 0.7)!,
            offset: const Offset(0, 6),
            blurRadius: 0,
            spreadRadius: -3,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (isTr ? chapter.subtitleTr : chapter.subtitleEn).toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isTr ? chapter.titleTr : chapter.titleEn,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 16),
                const SizedBox(height: 2),
                Text(
                  '$completedCount/$totalCount',
                  style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  CHAPTER PATH — S-CURVE + NODES
  // ═══════════════════════════════════════════
  Widget _buildChapterPath(JourneyChapter chapter, double width, int chapterIdx) {
    final nodes = chapter.nodes;
    final chapterColor = Color(chapter.colorValue);
    final centerX = width / 2;
    final swingX = width * 0.26;
    const nodeSpacingY = 130.0;

    final positions = <Offset>[];
    final statuses = <NodeStatus>[];

    for (int i = 0; i < nodes.length; i++) {
      double xOff;
      switch (i % 5) {
        case 0: xOff = 0; break;
        case 1: xOff = swingX; break;
        case 2: xOff = swingX * 0.35; break;
        case 3: xOff = -swingX; break;
        case 4: xOff = -swingX * 0.35; break;
        default: xOff = 0;
      }
      positions.add(Offset(centerX + xOff, i * nodeSpacingY + 50));
      statuses.add(nodes[i].status);
    }

    final totalHeight = nodes.length * nodeSpacingY + 80;
    final activeIdx = nodes.indexWhere((n) => n.status == NodeStatus.available);

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Energy bridge paths
          CustomPaint(
            size: Size(width, totalHeight),
            painter: JourneyPathPainter(nodePositions: positions, nodeStatuses: statuses),
          ),
          // Nodes — each is tappable
          for (int i = 0; i < nodes.length; i++)
            Positioned(
              left: positions[i].dx - 45,
              top: positions[i].dy - 45,
              child: FloatingWidget(
                amplitude: nodes[i].status == NodeStatus.available ? 5 : 2,
                duration: Duration(milliseconds: 2500 + (i * 300)),
                delay: i * 0.3,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _onNodeTap(nodes[i]),
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Center(
                      child: JourneyNodeWidget(
                        node: nodes[i],
                        chapterColor: chapterColor,
                        onTap: () => _onNodeTap(nodes[i]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          // Mascot
          if (activeIdx >= 0)
            Positioned(
              left: positions[activeIdx].dx + 44,
              top: positions[activeIdx].dy - 28,
              child: FloatingWidget(
                amplitude: 8,
                duration: const Duration(milliseconds: 3000),
                child: Image.asset(
                  'assets/mascot_happy.png',
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Text('🦦', style: TextStyle(fontSize: 36)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  NODE TAP HANDLERS
  // ═══════════════════════════════════════════
  void _onNodeTap(LessonNode node) {
    if (node.status == NodeStatus.locked) {
      _showLockedSnackBar();
      return;
    }
    if (node.type == NodeType.chest) {
      _openChest(node);
      return;
    }
    _showLessonDialog(node);
  }

  void _showLockedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.tr('🔒 Önce önceki dersi tamamla!', '🔒 Complete the previous lesson first!')),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A2F38),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLessonDialog(LessonNode node) {
    final isTr = storageService.progress.locale == 'tr';
    final isBoss = node.type == NodeType.boss;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 380),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2F38).withOpacity(0.97),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(color: _greenBright.withOpacity(0.15), blurRadius: 40, spreadRadius: -5),
              const BoxShadow(color: Colors.black54, blurRadius: 30, offset: Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── 3D Icon ──
              _build3DIcon(isBoss ? '👑' : node.icon, _greenBright, _greenDark),
              const SizedBox(height: 16),
              // ── Title ──
              Text(
                isTr ? node.titleTr : node.titleEn,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // ── Description ──
              Text(
                isBoss
                    ? S.tr('${node.requiredCorrect} soruyu doğru cevapla!', 'Answer ${node.requiredCorrect} correctly!')
                    : S.tr('${node.requiredCorrect} soru doğru cevapla', 'Answer ${node.requiredCorrect} correctly'),
                style: const TextStyle(color: Color(0xFF8899AA), fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                S.tr('Minimum %70 doğru oranı gerekli', 'Minimum 70% accuracy required'),
                style: TextStyle(color: _gold.withOpacity(0.7), fontSize: 12, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              // ── Stars (if completed) ──
              if (node.isCompleted) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      i < node.stars ? Icons.star_rounded : Icons.star_border_rounded,
                      color: i < node.stars ? _gold : const Color(0xFF4A4A5A),
                      size: 28,
                    ),
                  )),
                ),
              ],
              const SizedBox(height: 24),
              // ── 3D START BUTTON ──
              _build3DButton(
                text: node.isCompleted ? S.tr('Tekrar Oyna', 'Play Again') : S.tr('BAŞLA', 'START'),
                topColor: _greenBright,
                bottomColor: _greenDark,
                textColor: Colors.white,
                onTap: () {
                  Navigator.pop(ctx);
                  _startLesson(node);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ── 3D floating icon with depth ──
  Widget _build3DIcon(String emoji, Color topColor, Color bottomColor) {
    return SizedBox(
      width: 84,
      height: 94,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Deep shadow glow
          Positioned(
            top: 12,
            child: Container(
              width: 76, height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bottomColor,
                boxShadow: [BoxShadow(color: topColor.withOpacity(0.25), blurRadius: 20)],
              ),
            ),
          ),
          // Mid
          Positioned(
            top: 6,
            child: Container(width: 76, height: 76, decoration: BoxDecoration(shape: BoxShape.circle, color: Color.lerp(topColor, bottomColor, 0.5))),
          ),
          // Top dome
          Positioned(
            top: 0,
            child: Container(
              width: 76, height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.3),
                  radius: 0.9,
                  colors: [Color.lerp(topColor, Colors.white, 0.3)!, topColor, Color.lerp(topColor, bottomColor, 0.5)!],
                ),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 36))),
            ),
          ),
          // Highlight
          Positioned(
            top: 6, left: 16,
            child: Container(
              width: 24, height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ── Reusable 3D button with press animation ──
  Widget _build3DButton({
    required String text,
    required Color topColor,
    required Color bottomColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return _Pressable3DButton(
      text: text,
      topColor: topColor,
      bottomColor: bottomColor,
      textColor: textColor,
      onTap: onTap,
    );
  }

  void _startLesson(LessonNode node) {
    Navigator.push(
      context,
      PageTransitions.slideRight(
        QuizScreen(
          language: languageService.selected,
          topic: node.topic,
          questionsCount: node.requiredCorrect + 2,
          journeyNodeId: node.id,
          onJourneyComplete: (correct, total) => _onLessonComplete(node, correct, total),
        ),
      ),
    );
  }

  void _onLessonComplete(LessonNode node, int correct, int total) async {
    final accuracy = total > 0 ? correct / total : 0.0;
    final passedMinCorrect = correct >= node.requiredCorrect;
    final passedMinAccuracy = accuracy >= 0.70;

    if (passedMinCorrect && passedMinAccuracy) {
      // Passed — calculate stars
      final stars = accuracy >= 1.0 ? 3 : accuracy >= 0.85 ? 2 : 1;
      await journeyProgress.completeNode(node.id, stars);
      await journeyProgress.addXP(stars * 10);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.tr(
              '🎉 Tebrikler! $stars yıldız kazandın! (+${stars * 10} XP)',
              '🎉 Congratulations! You earned $stars stars! (+${stars * 10} XP)',
            )),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            backgroundColor: _greenDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } else {
      // Failed — show retry message
      if (mounted) {
        final pct = (accuracy * 100).round();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.tr(
              '❌ Yetersiz! %$pct doğru oranı. En az %70 gerekli. Tekrar dene!',
              '❌ Not enough! $pct% accuracy. Minimum 70% required. Try again!',
            )),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            backgroundColor: _red.withOpacity(0.9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
    _reloadJourney();
  }

  void _openChest(LessonNode node) {
    if (node.isCompleted) return;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 380),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2F38).withOpacity(0.97),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: _gold.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(color: _gold.withOpacity(0.15), blurRadius: 40, spreadRadius: -5),
              const BoxShadow(color: Colors.black54, blurRadius: 30, offset: Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _build3DIcon('🎁', _gold, const Color(0xFFCC9E00)),
              const SizedBox(height: 16),
              Text(
                S.tr('Hazine Sandığı!', 'Treasure Chest!'),
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                S.tr('+30 XP kazandın! 🎉', 'You earned +30 XP! 🎉'),
                style: const TextStyle(color: Color(0xFF8899AA), fontSize: 14),
              ),
              const SizedBox(height: 24),
              _build3DButton(
                text: S.tr('AÇ!', 'OPEN!'),
                topColor: _gold,
                bottomColor: const Color(0xFFCC9E00),
                textColor: const Color(0xFF7A5629),
                onTap: () async {
                  await journeyProgress.collectChest(node.id);
                  await journeyProgress.completeNode(node.id, 0);
                  await journeyProgress.addXP(30);
                  _reloadJourney();
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ── Animated 3D button that presses down on tap ──
class _Pressable3DButton extends StatefulWidget {
  final String text;
  final Color topColor;
  final Color bottomColor;
  final Color textColor;
  final VoidCallback onTap;

  const _Pressable3DButton({
    required this.text,
    required this.topColor,
    required this.bottomColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<_Pressable3DButton> createState() => _Pressable3DButtonState();
}

class _Pressable3DButtonState extends State<_Pressable3DButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final depth = _isPressed ? 2.0 : 8.0;
    final topOffset = _isPressed ? 6.0 : 0.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: double.infinity,
        height: 60,
        child: Stack(
          children: [
            // Bottom 3D depth
            Positioned(
              top: depth + topOffset,
              left: 0, right: 0,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: widget.bottomColor,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            // Top face
            Positioned(
              top: topOffset,
              left: 0, right: 0,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.lerp(widget.topColor, Colors.white, 0.15)!,
                      widget.topColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                  boxShadow: _isPressed ? null : [
                    BoxShadow(color: widget.topColor.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 4)),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
                    ),
                  ),
                ),
              ),
            ),
            // Highlight
            if (!_isPressed)
              Positioned(
                top: topOffset + 4,
                left: 20, right: 20,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
