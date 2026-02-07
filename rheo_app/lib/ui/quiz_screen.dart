import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import '../logic/game_controller.dart';
import '../logic/elo_calculator.dart';
import '../logic/sound_service.dart';
import '../logic/language_service.dart';
import 'theme.dart';
import 'animations.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

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
  bool _showExplanation = false;

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
    _confettiController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _prepareQuestion() {
    if (_controller.currentQuestion != null) {
      _shuffledOptions = _controller.currentQuestion!.getShuffledOptions();
      _selectedAnswer = null;
      _isCorrect = null;
      _showExplanation = false;
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
      setState(() => _showExplanation = true);
    }
  }

  void _nextQuestion() {
    HapticService.lightTap();
    _controller.nextQuestion();
    if (_controller.isFinished) {
      _showResults();
    } else {
      setState(() => _prepareQuestion());
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
              const Text('Quiz Bitti! 🎉', 
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildStatRow('Skor', '${summary['score']}', Colors.amber),
              _buildStatRow('Doğru', '${summary['correct']}', RheoColors.success),
              _buildStatRow('Yanlış', '${summary['wrong']}', RheoColors.error),
              _buildStatRow('Başarı', '%${summary['accuracy']}', RheoColors.primary),
              const Divider(color: RheoColors.glassBorder, height: 24),
              _buildStatRow('ELO', '${summary['elo']}', 
                  Color(EloCalculator.getRankColor(summary['elo']))),
              _buildStatRow('Rank', summary['rank'], 
                  Color(EloCalculator.getRankColor(summary['elo']))),
              _buildStatRow('Seri', '🔥 ${summary['streak']}', RheoColors.secondary),
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
                      child: Text('Ana Sayfa', style: TextStyle(color: RheoColors.textMuted)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        HapticService.lightTap();
                        Navigator.pop(context);
                        setState(() => _isLoading = true);
                        await _controller.loadQuestions(maxQuestions: 10);
                        _controller.reset();
                        _prepareQuestion();
                        setState(() => _isLoading = false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RheoColors.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Tekrar Oyna'),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: RheoColors.textSecondary)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getButtonColor(String option) {
    if (_selectedAnswer == null) return RheoColors.glassLight;
    if (option == _controller.currentQuestion?.correctAnswer) return RheoColors.success;
    if (option == _selectedAnswer && !_isCorrect!) return RheoColors.error;
    return RheoColors.glassLight;
  }

  Color _getButtonBorder(String option) {
    if (_selectedAnswer == null) return RheoColors.glassBorder;
    if (option == _controller.currentQuestion?.correctAnswer) return RheoColors.success;
    if (option == _selectedAnswer && !_isCorrect!) return RheoColors.error;
    return RheoColors.glassBorder;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator(color: RheoColors.primary)),
        ),
      );
    }

    final question = _controller.currentQuestion;
    if (question == null) {
      return GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: Text('Soru yok', style: TextStyle(color: RheoColors.textMuted))),
        ),
      );
    }

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () {
              HapticService.lightTap();
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Soru ${_controller.currentIndex + 1}/${_controller.totalQuestions}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
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
                  Text('${_controller.currentStreak}', style: const TextStyle(color: Colors.white)),
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
              child: Padding(
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
                          style: TextStyle(fontSize: 11, color: RheoColors.textMuted, letterSpacing: 1),
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedAnswer == null 
                                  ? RheoColors.glassBorder
                                  : (_isCorrect! ? RheoColors.success : RheoColors.error),
                              width: _selectedAnswer == null ? 1 : 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: HighlightView(
                              question.codeSnippet,
                              language: 'python',
                              theme: atomOneDarkTheme,
                              padding: const EdgeInsets.all(16),
                              textStyle: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Question text
                    Text(
                      question.questionText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Answer options
                    Expanded(
                      child: ListView.builder(
                        itemCount: _shuffledOptions.length,
                        itemBuilder: (context, index) {
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
                                      style: const TextStyle(fontSize: 15, color: Colors.white),
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
                    
                    // Explanation card
                    if (_showExplanation) ...[
                      GlassCard(
                        borderColor: _isCorrect! ? RheoColors.success : RheoColors.warning,
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _isCorrect! ? Icons.check_circle : Icons.info,
                                  color: _isCorrect! ? RheoColors.success : RheoColors.warning,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isCorrect! ? 'Doğru!' : 'Açıklama',
                                  style: TextStyle(
                                    color: _isCorrect! ? RheoColors.success : RheoColors.warning,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              question.explanation,
                              style: TextStyle(color: RheoColors.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RheoColors.primary,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            _controller.currentIndex + 1 >= _controller.totalQuestions
                                ? 'Sonuçları Gör'
                                : 'Sonraki Soru →',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
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
      case 1: return 'KOLAY';
      case 2: return 'ORTA';
      case 3: return 'ZOR';
      default: return '?';
    }
  }
}
