import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import '../logic/game_controller.dart';
import '../logic/elo_calculator.dart';
import '../logic/sound_service.dart';
import '../logic/language_service.dart';
import '../logic/ai_service.dart';
import 'theme.dart';
import 'animations.dart';
import 'widgets/mascot_widget.dart';
import '../data/app_strings.dart';

class QuizScreen extends StatefulWidget {
  final String? topic;
  final bool isAI;
  
  const QuizScreen({super.key, this.topic, this.isAI = false});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  final GameController _controller = GameController();
  late ConfettiController _confettiController;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  
  bool _isLoading = true;
  String? _selectedAnswer;
  bool? _isCorrect;
  List<String> _shuffledOptions = [];
  bool _showAnswerOverlay = false;
  
  // AI mode state
  bool _isAIMode = false;
  bool _isGeneratingAI = false;
  String? _aiError;
  int _aiQuestionCount = 0;
  static const int _aiMaxQuestions = 10;

  @override
  void initState() {
    super.initState();
    _isAIMode = widget.isAI;
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await _controller.init();
    
    if (_isAIMode) {
      // AI mode: generate first question
      await _loadNextAIQuestion();
    } else {
      // Static mode: load from JSON
      await _controller.loadQuestions(
        maxQuestions: 10,
        language: languageService.selected.name,
        topic: widget.topic,
      );
      
      // If no questions for this topic+language, try without language filter
      if (_controller.totalQuestions == 0 && widget.topic != null) {
        debugPrint('­şô¡ No questions for "${widget.topic}" in ${languageService.selected.name}, trying all languages');
        await _controller.loadQuestions(
          maxQuestions: 10,
          topic: widget.topic,
        );
      }
      
      // If still no questions, load ALL questions (no filters)
      if (_controller.totalQuestions == 0) {
        debugPrint('­şô¡ No questions for topic, loading all');
        await _controller.loadQuestions(maxQuestions: 10);
      }
      
      _prepareQuestion();
    }
    setState(() => _isLoading = false);
  }
  
  /// AI modunda yeni soru ├╝ret
  Future<void> _loadNextAIQuestion() async {
    if (!mounted) return;
    setState(() {
      _isGeneratingAI = true;
      _aiError = null;
    });
    
    try {
      final question = await aiService.generateQuestion(
        topic: widget.topic ?? 'ai_arrays',
        difficulty: EloCalculator.getRecommendedDifficulty(_controller.currentElo),
      );
      
      if (question != null) {
        _controller.addAIQuestion(question);
        _aiQuestionCount++;
        _prepareQuestion();
        if (mounted) {
          setState(() => _isGeneratingAI = false);
        }
      } else {
        // No question available (no API + no cache)
        if (mounted) {
          final errorDetail = aiService.lastError;
          String errorMsg;
          if (errorDetail != null && errorDetail.contains('quota')) {
            errorMsg = S.apiKotaHatasi;
          } else if (errorDetail != null && errorDetail.contains('API key')) {
            errorMsg = S.apiKeyHatasi;
          } else {
            errorMsg = S.aiSoruHatasi;
          }
          setState(() {
            _isGeneratingAI = false;
            _aiError = errorMsg;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGeneratingAI = false;
          _aiError = 'Hata: ${e.toString().length > 100 ? e.toString().substring(0, 100) : e.toString()}';
        });
      }
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _prepareQuestion() {
    if (_controller.currentQuestion != null) {
      _shuffledOptions = _controller.currentQuestion!.getShuffledOptions();
      _selectedAnswer = null;
      _isCorrect = null;
      _showAnswerOverlay = false;
    }
  }

  Future<void> _onAnswerSelected(String answer) async {
    if (_selectedAnswer != null) return;

    HapticService.lightTap();
    
    final oldRank = EloCalculator.getRankTitle(_controller.currentElo);
    final isCorrect = await _controller.checkAnswer(answer);
    final newRank = EloCalculator.getRankTitle(_controller.currentElo);
    
    setState(() {
      _selectedAnswer = answer;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      _confettiController.play();
      soundService.playCorrect();
      HapticService.success();
      
      if (newRank != oldRank) {
        soundService.playLevelUp();
        HapticService.achievement();
      }
    } else {
      _shakeController.forward().then((_) => _shakeController.reset());
      soundService.playWrong();
      HapticService.error();
    }

    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _showAnswerOverlay = true);
    }
  }

  void _dismissOverlayAndNext() {
    HapticService.lightTap();
    setState(() => _showAnswerOverlay = false);
    _nextQuestion();
  }

  void _nextQuestion() {
    HapticService.lightTap();
    _controller.nextQuestion();
    
    if (_isAIMode) {
      // AI modda: max soruya ula┼şt─▒ysa sonu├ğlar─▒ g├Âster, yoksa yeni soru ├╝ret
      if (_aiQuestionCount >= _aiMaxQuestions) {
        _showResults();
      } else {
        setState(() => _isLoading = true);
        _loadNextAIQuestion().then((_) {
          if (mounted) setState(() => _isLoading = false);
        });
      }
    } else {
      // Statik mod: eski davran─▒┼ş
      if (_controller.isFinished) {
        _showResults();
      } else {
        setState(() => _prepareQuestion());
      }
    }
  }

  void _showResults() {
    final summary = _controller.getSessionSummary();
    HapticService.achievement();
    
    // Fire confetti! ­şÄë
    _confettiController.play();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Stack(
        children: [
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFF6C63FF), Color(0xFF00D2FF), Color(0xFFFF6B6B),
                Color(0xFF4ECDC4), Color(0xFFFFD93D), Color(0xFFFF8A5C),
              ],
              numberOfParticles: 25,
              maxBlastForce: 20,
              minBlastForce: 5,
              emissionFrequency: 0.05,
              gravity: 0.15,
            ),
          ),
          // Result dialog
          Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: RheoTheme.cardBg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 16)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.tr('Quiz Bitti! ­şÄë', 'Quiz Complete! ­şÄë'), 
                style: TextStyle(color: RheoTheme.textColor, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              MascotResultCard(accuracy: summary['accuracy']),
              const SizedBox(height: 12),
              _buildStatRow(S.tr('Skor', 'Score'), '${summary['score']}', Colors.amber),
              _buildStatRow(S.dogru, '${summary['correct']}', RheoColors.success),
              _buildStatRow(S.yanlis, '${summary['wrong']}', RheoColors.error),
              _buildStatRow(S.basari, '%${summary['accuracy']}', RheoColors.primary),
              Divider(color: RheoTheme.textMuted.withAlpha(60), height: 24),
              _buildStatRow('ELO', '${summary['elo']}', 
                  Color(EloCalculator.getRankColor(summary['elo']))),
              _buildStatRow('Rank', summary['rank'], 
                  Color(EloCalculator.getRankColor(summary['elo']))),
              _buildStatRow(S.tr('Seri', 'Streak'), '­şöÑ ${summary['streak']}', RheoColors.secondary),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        HapticService.lightTap();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(S.tr('Ana Sayfa', 'Home'), style: TextStyle(color: RheoTheme.textMuted)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        HapticService.lightTap();
                        Navigator.pop(context);
                        setState(() => _isLoading = true);
                        await _controller.loadQuestions(
                          maxQuestions: 10,
                          language: languageService.selected.name,
                          topic: widget.topic,
                        );
                        _controller.reset();
                        _prepareQuestion();
                        setState(() => _isLoading = false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RheoColors.primary,
                        foregroundColor: RheoTheme.textColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(S.tr('Tekrar Oyna', 'Play Again')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: RheoTheme.textMuted)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getButtonColor(String option) {
    if (_selectedAnswer == null) return RheoTheme.optionBg;
    if (option == _controller.currentQuestion?.correctAnswer) return RheoColors.success.withAlpha(30);
    if (option == _selectedAnswer && !_isCorrect!) return RheoColors.error.withAlpha(30);
    return RheoTheme.optionBg;
  }

  Color _getButtonBorder(String option) {
    if (_selectedAnswer == null) return RheoTheme.optionBorder;
    if (option == _controller.currentQuestion?.correctAnswer) return RheoColors.success;
    if (option == _selectedAnswer && !_isCorrect!) return RheoColors.error;
    return RheoTheme.optionBorder;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _isGeneratingAI) {
      return Scaffold(
        backgroundColor: RheoTheme.scaffoldBg(),
        body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PulseAnimation(
                  child: Image.asset(getMascotAsset(MascotMood.thinking), height: 80),
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(color: RheoColors.primary),
                if (_isAIMode) ...[
                  const SizedBox(height: 16),
                  Text(
                    MascotHelper.getWaitingMessage(),
                    style: TextStyle(color: RheoTheme.textMuted, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.soruN(_aiQuestionCount, _aiMaxQuestions),
                    style: TextStyle(color: RheoTheme.textMuted.withAlpha(120), fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
      );
    }

    if (_aiError != null) {
      return Scaffold(
        backgroundColor: RheoTheme.scaffoldBg(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: RheoTheme.textColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off_rounded, color: RheoColors.warning, size: 64),
                const SizedBox(height: 20),
                Text(
                  _aiError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: RheoTheme.textMuted, fontSize: 15),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _isLoading = true);
                    _loadNextAIQuestion().then((_) {
                      if (mounted) setState(() => _isLoading = false);
                    });
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(S.tekrarDeneButon),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: RheoColors.primary,
                    foregroundColor: RheoTheme.textColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = _controller.currentQuestion;
    if (question == null) {
      return Scaffold(
        backgroundColor: RheoTheme.scaffoldBg(),
        body: Center(child: Text(S.tr('Soru yok', 'No questions'), style: TextStyle(color: RheoTheme.textMuted))),
      );
    }

    return Scaffold(
      backgroundColor: RheoTheme.scaffoldBg(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: RheoTheme.textColor),
            onPressed: () {
              HapticService.lightTap();
              Navigator.pop(context);
            },
          ),
          title: Text(
            _isAIMode 
                ? '­şñû ${S.tr('Soru', 'Question')} $_aiQuestionCount/$_aiMaxQuestions'
                : S.soruN(_controller.currentIndex + 1, _controller.totalQuestions),
            style: TextStyle(color: RheoTheme.textColor, fontSize: 16),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Color(EloCalculator.getRankColor(_controller.currentElo)).withAlpha(40),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(EloCalculator.getRankColor(_controller.currentElo)).withAlpha(100)),
              ),
              child: Text(
                '${_controller.currentElo}',
                style: TextStyle(color: Color(EloCalculator.getRankColor(_controller.currentElo)), fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  Icon(Icons.local_fire_department, color: RheoColors.secondary, size: 18),
                  const SizedBox(width: 4),
                  Text('${_controller.currentStreak}', style: TextStyle(color: RheoTheme.textColor)),
                ],
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [RheoColors.success, RheoColors.primary, RheoColors.accent, RheoColors.secondary],
              ),
            ),
            
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _controller.progress,
                        backgroundColor: RheoColors.glassLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(RheoColors.primary),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Difficulty tag
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(question.difficulty).withAlpha(40),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _getDifficultyColor(question.difficulty).withAlpha(100)),
                          ),
                          child: Text(
                            _getDifficultyLabel(question.difficulty),
                            style: TextStyle(fontSize: 11, color: _getDifficultyColor(question.difficulty), fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          question.topic.toUpperCase(),
                          style: TextStyle(fontSize: 11, color: RheoTheme.textMuted, letterSpacing: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Code block with animation
                    AnimatedQuestionCard(
                      questionIndex: _controller.currentIndex,
                      child: AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(_isCorrect == false ? _shakeAnimation.value : 0, 0),
                            child: child,
                          );
                        },
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 260),
                          decoration: BoxDecoration(
                            color: RheoTheme.codeBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _selectedAnswer == null 
                                  ? RheoTheme.codeBorder
                                  : (_isCorrect! ? RheoColors.success.withAlpha(150) : RheoColors.error.withAlpha(150)),
                              width: _selectedAnswer == null ? 1 : 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(30),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Column(
                              children: [
                                // Terminal header
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: RheoTheme.codeHeaderBg,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFf38ba8))),
                                      const SizedBox(width: 6),
                                      Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFf9e2af))),
                                      const SizedBox(width: 6),
                                      Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFa6e3a1))),
                                      const Spacer(),
                                      Text(
                                        question.language.toUpperCase(),
                                        style: TextStyle(
                                          color: RheoTheme.codeHeaderText,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Code content
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: HighlightView(
                                      question.codeSnippet,
                                      language: question.language,
                                      theme: RheoTheme.isDark ? atomOneDarkTheme : atomOneLightTheme,
                                      padding: const EdgeInsets.all(14),
                                      textStyle: const TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 13,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Question text
                    Text(
                      question.localizedQuestionText,
                      style: TextStyle(
                        fontSize: 16,
                        color: RheoTheme.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Answer options
                    ...List.generate(_shuffledOptions.length, (index) {
                      final option = _shuffledOptions[index];
                      return StaggeredFadeIn(
                        index: index,
                        delay: const Duration(milliseconds: 80),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _selectedAnswer == null 
                                  ? () => _onAnswerSelected(option) 
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: _getButtonColor(option),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: _getButtonBorder(option)),
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(fontSize: 15, color: RheoTheme.textColor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),

                  ],
                ),
              ),
            ),

            // Answer overlay (correct / incorrect)
            if (_showAnswerOverlay && _isCorrect != null)
              GestureDetector(
                onTap: _dismissOverlayAndNext,
                child: AnimatedOpacity(
                  opacity: _showAnswerOverlay ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.black.withOpacity(0.78),
                    width: double.infinity,
                    height: double.infinity,
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 2),
                          // Result text
                          Text(
                            _isCorrect! ? S.dogruCevap : S.yanlisCevap,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: _isCorrect! ? RheoColors.success : RheoColors.error,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: (_isCorrect! ? RheoColors.success : RheoColors.error).withOpacity(0.5),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          // Mascot image
                          PulseAnimation(
                            duration: const Duration(milliseconds: 2000),
                            child: Image.asset(
                              getMascotAsset(
                                _isCorrect! ? MascotMood.celebrating : MascotMood.encouraging,
                              ),
                              height: 140,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Mascot message
                          Text(
                            _isCorrect!
                                ? MascotHelper.getCorrectMessage()
                                : MascotHelper.getWrongMessage(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(flex: 3),
                          // Tap to continue hint
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Text(
                              S.ilerlemekIcinTikla,
                              style: TextStyle(
                                fontSize: 13,
                                color: RheoColors.textMuted,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
    );
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1: return RheoColors.success;
      case 2: return RheoColors.warning;
      case 3: return RheoColors.error;
      default: return RheoColors.textMuted;
    }
  }

  String _getDifficultyLabel(int difficulty) {
    switch (difficulty) {
      case 1: return S.tr('KOLAY', 'EASY');
      case 2: return S.tr('ORTA', 'MEDIUM');
      case 3: return S.tr('ZOR', 'HARD');
      default: return '?';
    }
  }
}