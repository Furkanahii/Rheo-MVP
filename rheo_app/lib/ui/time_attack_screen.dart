import 'package:flutter/material.dart';
import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import '../logic/game_controller.dart';
import '../logic/elo_calculator.dart';
import '../logic/sound_service.dart';
import '../logic/language_service.dart';
import '../data/app_strings.dart';
import 'theme.dart';
import 'animations.dart';
import 'widgets/mascot_widget.dart';

class TimeAttackScreen extends StatefulWidget {
  const TimeAttackScreen({super.key});

  @override
  State<TimeAttackScreen> createState() => _TimeAttackScreenState();
}

class _TimeAttackScreenState extends State<TimeAttackScreen> 
    with TickerProviderStateMixin {
  final GameController _controller = GameController();
  late ConfettiController _confettiController;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  
  // Timer state
  Timer? _timer;
  static const int _totalSeconds = 20;
  int _remainingSeconds = _totalSeconds;
  
  bool _isLoading = true;
  String? _selectedAnswer;
  bool? _isCorrect;
  bool _showAnswerOverlay = false;
  List<String> _shuffledOptions = [];
  bool _timeUp = false;

  @override
  void initState() {
    super.initState();
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
    await _controller.loadQuestions(
      maxQuestions: 10, 
      language: languageService.selected.name,
    );
    _prepareQuestion();
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _confettiController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _prepareQuestion() {
    if (_controller.currentQuestion != null) {
      _shuffledOptions = _controller.currentQuestion!.getShuffledOptions();
      _selectedAnswer = null;
      _isCorrect = null;
      _timeUp = false;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingSeconds = _totalSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
        
        // Tick sound at 5 seconds
        if (_remainingSeconds == 5) {
          HapticService.lightTap();
        }
      } else {
        _onTimeUp();
      }
    });
  }

  void _onTimeUp() {
    _timer?.cancel();
    if (_selectedAnswer != null) return;
    
    setState(() {
      _timeUp = true;
      _selectedAnswer = "";
      _isCorrect = false;
    });
    
    soundService.playWrong();
    HapticService.error();
    _shakeController.forward().then((_) => _shakeController.reset());
    
    // Record as wrong answer
    _controller.recordTimeOut();
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _nextQuestion();
    });
  }

  Future<void> _onAnswerSelected(String answer) async {
    if (_selectedAnswer != null) return;
    _timer?.cancel();

    HapticService.lightTap();
    
    final isCorrect = await _controller.checkAnswer(answer);
    
    setState(() {
      _selectedAnswer = answer;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      _confettiController.play();
      soundService.playCorrect();
      HapticService.success();
    } else {
      _shakeController.forward().then((_) => _shakeController.reset());
      soundService.playWrong();
      HapticService.error();
    }

    // Show answer overlay after short delay
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
    _controller.nextQuestion();
    if (_controller.isFinished) {
      _showResults();
    } else {
      setState(() {
        _showAnswerOverlay = false;
        _prepareQuestion();
      });
    }
  }

  void _showResults() {
    final summary = _controller.getSessionSummary();
    HapticService.achievement();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          blur: 20,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.tr('ÔÅ▒´©Å Time Attack Bitti!', 'ÔÅ▒´©Å Time Attack Complete!'), 
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              MascotResultCard(accuracy: summary['accuracy']),
              const SizedBox(height: 8),
              _buildStatRow(S.tr('Skor', 'Score'), '${summary['score']}', Colors.amber),
              _buildStatRow(S.dogru, '${summary['correct']}', RheoColors.success),
              _buildStatRow(S.yanlis, '${summary['wrong']}', RheoColors.error),
              _buildStatRow(S.basari, '%${summary['accuracy']}', RheoColors.primary),
              const Divider(color: RheoColors.glassBorder, height: 20),
              _buildStatRow('ELO', '${summary['elo']}', 
                  Color(EloCalculator.getRankColor(summary['elo']))),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        HapticService.lightTap();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(S.tr('Ana Sayfa', 'Home'), style: TextStyle(color: RheoColors.textMuted)),
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
                        );
                        _controller.reset();
                        _prepareQuestion();
                        setState(() => _isLoading = false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RheoColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(S.tr('Tekrar', 'Replay')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: RheoColors.textSecondary, fontSize: 14)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Color _getTimerColor() {
    if (_remainingSeconds > 12) return RheoColors.success;
    if (_remainingSeconds > 6) return RheoColors.warning;
    return RheoColors.error;
  }

  Color _getButtonColor(String option) {
    if (_selectedAnswer == null) return RheoTheme.optionBg;
    if (_timeUp) {
      if (option == _controller.currentQuestion?.correctAnswer) return RheoColors.success;
      return RheoTheme.optionBg;
    }
    if (option == _controller.currentQuestion?.correctAnswer) return RheoColors.success;
    if (option == _selectedAnswer && !_isCorrect!) return RheoColors.error;
    return RheoTheme.optionBg;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: RheoTheme.scaffoldBg(),
        body: const Center(child: CircularProgressIndicator(color: RheoColors.accent)),
      );
    }

    final question = _controller.currentQuestion;
    if (question == null) {
      return Scaffold(
        backgroundColor: RheoTheme.scaffoldBg(),
        body: Center(child: Text(S.tr('Soru yok', 'No questions'), style: TextStyle(color: RheoTheme.textMuted))),
      );
    }

    final timerColor = _getTimerColor();

    return Scaffold(
      backgroundColor: RheoTheme.scaffoldBg(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close_rounded, color: RheoTheme.textColor),
            onPressed: () {
              HapticService.lightTap();
              _timer?.cancel();
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              Icon(Icons.timer_rounded, color: timerColor, size: 20),
              const SizedBox(width: 6),
              Text(
                '${_remainingSeconds}s',
                style: TextStyle(
                  color: timerColor, 
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: RheoColors.accent.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_controller.currentIndex + 1}/${_controller.totalQuestions}',
                style: const TextStyle(color: RheoColors.accent, fontWeight: FontWeight.w600),
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
                colors: const [RheoColors.success, RheoColors.accent, Colors.yellow],
              ),
            ),
            
            SafeArea(
              child: Column(
                children: [
                  // Timer Progress Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: _remainingSeconds / _totalSeconds),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, value, _) {
                          return LinearProgressIndicator(
                            value: value,
                            backgroundColor: RheoColors.glassLight,
                            valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                            minHeight: 8,
                          );
                        },
                      ),
                    ),
                  ),
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Language tag
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: RheoColors.accent.withAlpha(40),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'ÔÅ│ TIME ATTACK',
                                  style: TextStyle(fontSize: 10, color: RheoColors.accent, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                languageService.selected.emoji,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                languageService.selected.label.toUpperCase(),
                                style: TextStyle(fontSize: 10, color: RheoColors.textMuted, letterSpacing: 1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          // Code block
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _timeUp 
                                        ? RheoColors.error 
                                        : (_selectedAnswer == null 
                                            ? RheoColors.glassBorder
                                            : (_isCorrect! ? RheoColors.success : RheoColors.error)),
                                    width: _selectedAnswer == null ? 1 : 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: HighlightView(
                                    question.codeSnippet,
                                    language: languageService.selected.highlightLang,
                                    theme: RheoTheme.isDark ? atomOneDarkTheme : atomOneLightTheme,
                                    padding: const EdgeInsets.all(14),
                                    textStyle: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Question text
                          Text(
                            question.localizedQuestionText,
                            style: TextStyle(
                              fontSize: 15,
                              color: RheoTheme.textColor,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          
                          // Time Up overlay
                          if (_timeUp)
                            GlassCard(
                              borderColor: RheoColors.error.withAlpha(80),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  MascotWidget(
                                    mood: MascotMood.sad,
                                    message: MascotHelper.getTimeUpMessage(),
                                    size: 45,
                                    animate: false,
                                    bubbleColor: RheoColors.error,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    S.tr('Do─şru cevap: ${_controller.currentQuestion?.correctAnswer ?? ""}', 'Correct answer: ${_controller.currentQuestion?.correctAnswer ?? ""}'),
                                    style: TextStyle(color: RheoColors.success, fontWeight: FontWeight.w600, fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          
                          // Answer options
                          if (!_timeUp)
                            Expanded(
                              child: ListView.builder(
                                itemCount: _shuffledOptions.length,
                                itemBuilder: (context, index) {
                                  final option = _shuffledOptions[index];
                                  return StaggeredFadeIn(
                                    index: index,
                                    delay: const Duration(milliseconds: 60),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: _selectedAnswer == null 
                                              ? () => _onAnswerSelected(option) 
                                              : null,
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: _getButtonColor(option),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: _getButtonColor(option) == RheoTheme.optionBg 
                                                  ? RheoTheme.optionBorder 
                                                  : _getButtonColor(option)),
                                            ),
                                            child: Text(
                                              option,
                                              style: TextStyle(fontSize: 14, color: RheoTheme.optionText),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
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
                ],
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
                          Text(
                            S.ilerlemekIcinTikla,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 32),
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
}