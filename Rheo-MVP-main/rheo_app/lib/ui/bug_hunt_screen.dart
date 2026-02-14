import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import '../logic/sound_service.dart';
import '../logic/storage_service.dart';
import '../logic/elo_calculator.dart';
import 'theme.dart';
import 'animations.dart';
import 'widgets/mascot_widget.dart';

/// Bug Hunt Question Model
class BugHuntQuestion {
  final String id;
  final List<String> codeLines;
  final int bugLineIndex;
  final String explanation;
  final int difficulty;
  final String topic;

  BugHuntQuestion({
    required this.id,
    required this.codeLines,
    required this.bugLineIndex,
    required this.explanation,
    required this.difficulty,
    required this.topic,
  });
}

class BugHuntScreen extends StatefulWidget {
  const BugHuntScreen({super.key});

  @override
  State<BugHuntScreen> createState() => _BugHuntScreenState();
}

class _BugHuntScreenState extends State<BugHuntScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  
  bool _isLoading = true;
  int _currentIndex = 0;
  int? _selectedLine;
  bool? _isCorrect;
  int _score = 0;
  int _correct = 0;
  int _wrong = 0;
  
  final List<BugHuntQuestion> _questions = [
    BugHuntQuestion(
      id: 'bug_001',
      codeLines: [
        'def greet(name):',
        '    message = "Hello, " + name',
        '    return massage',
        '',
      ],
      bugLineIndex: 2,
      explanation: 'Typo hatası: "massage" yerine "message" olmalı.',
      difficulty: 1,
      topic: 'variables',
    ),
    BugHuntQuestion(
      id: 'bug_002',
      codeLines: [
        'numbers = [1, 2, 3, 4, 5]',
        'total = 0',
        'for i in range(6):',
        '    total += numbers[i]',
      ],
      bugLineIndex: 2,
      explanation: 'range(6) kullanıldığında i=5 olur ama liste 5 elemanlı. range(5) veya len(numbers) kullanılmalı.',
      difficulty: 2,
      topic: 'loops',
    ),
    BugHuntQuestion(
      id: 'bug_003',
      codeLines: [
        'def factorial(n):',
        '    if n == 0:',
        '        return 1',
        '    return n * factorial(n)',
      ],
      bugLineIndex: 3,
      explanation: 'Sonsuz döngü: factorial(n) yerine factorial(n-1) olmalı.',
      difficulty: 3,
      topic: 'recursion',
    ),
    BugHuntQuestion(
      id: 'bug_004',
      codeLines: [
        'x = 10',
        'y = 5',
        'if x = y:',
        '    print("Equal")',
      ],
      bugLineIndex: 2,
      explanation: 'Karşılaştırma için == kullanılmalı, = atama operatörüdür.',
      difficulty: 1,
      topic: 'if_else',
    ),
    BugHuntQuestion(
      id: 'bug_005',
      codeLines: [
        'text = "Hello World"',
        'words = text.split()',
        'for word in words',
        '    print(word)',
      ],
      bugLineIndex: 2,
      explanation: 'for döngüsünün sonunda ":" eksik.',
      difficulty: 1,
      topic: 'loops',
    ),
  ];

  BugHuntQuestion get currentQuestion => _questions[_currentIndex];
  bool get isFinished => _currentIndex >= _questions.length;
  double get progress => _questions.isEmpty ? 0 : _currentIndex / _questions.length;

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
    
    _questions.shuffle();
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _onLineSelected(int lineIndex) async {
    if (_selectedLine != null) return;

    HapticService.lightTap();
    final isCorrect = lineIndex == currentQuestion.bugLineIndex;
    
    setState(() {
      _selectedLine = lineIndex;
      _isCorrect = isCorrect;
    });

    final newElo = EloCalculator.calculateNewElo(
      currentElo: storageService.progress.elo,
      questionDifficulty: currentQuestion.difficulty,
      isCorrect: isCorrect,
    );

    if (isCorrect) {
      _confettiController.play();
      soundService.playCorrect();
      HapticService.success();
      _score += 15 * currentQuestion.difficulty;
      _correct++;
    } else {
      _shakeController.forward().then((_) => _shakeController.reset());
      soundService.playWrong();
      HapticService.error();
      _wrong++;
    }

    await storageService.recordAnswer(isCorrect: isCorrect, newElo: newElo);
  }

  void _nextQuestion() {
    HapticService.lightTap();
    if (_currentIndex + 1 >= _questions.length) {
      _showResults();
    } else {
      setState(() {
        _currentIndex++;
        _selectedLine = null;
        _isCorrect = null;
      });
    }
  }

  void _showResults() {
    final accuracy = _correct + _wrong > 0 
        ? ((_correct / (_correct + _wrong)) * 100).round() 
        : 0;
    
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
              const Text('Bug Hunt Bitti! 🐞', 
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              MascotResultCard(accuracy: accuracy),
              const SizedBox(height: 12),
              _buildStatRow('Skor', '$_score', Colors.amber),
              _buildStatRow('Bulunan Bug', '$_correct', RheoColors.success),
              _buildStatRow('Kaçırılan', '$_wrong', RheoColors.error),
              _buildStatRow('Başarı', '%$accuracy', RheoColors.primary),
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
                      onPressed: () {
                        HapticService.lightTap();
                        Navigator.pop(context);
                        setState(() {
                          _currentIndex = 0;
                          _selectedLine = null;
                          _isCorrect = null;
                          _score = 0;
                          _correct = 0;
                          _wrong = 0;
                          _questions.shuffle();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RheoColors.secondary,
                        foregroundColor: Colors.white,
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

  Color _getLineColor(int lineIndex) {
    if (_selectedLine == null) return Colors.transparent;
    
    if (lineIndex == currentQuestion.bugLineIndex) {
      return RheoColors.success.withAlpha(60);
    }
    if (lineIndex == _selectedLine && !_isCorrect!) {
      return RheoColors.error.withAlpha(60);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || isFinished) {
      return const GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator(color: RheoColors.secondary)),
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
            'Bug ${_currentIndex + 1}/${_questions.length}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: RheoColors.secondary.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bug_report, color: RheoColors.secondary, size: 18),
                  const SizedBox(width: 4),
                  Text('$_correct', style: const TextStyle(color: RheoColors.secondary)),
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
                colors: const [RheoColors.success, RheoColors.primary, Colors.yellow],
              ),
            ),
            
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: RheoColors.glassLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(RheoColors.secondary),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: RheoColors.secondary.withAlpha(40),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('BUG HUNT', 
                            style: TextStyle(fontSize: 11, color: RheoColors.secondary, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          currentQuestion.topic.toUpperCase(),
                          style: TextStyle(fontSize: 11, color: RheoColors.textMuted, letterSpacing: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    const Text(
                      '🐞 Hatalı satırı bul ve tıkla!',
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Animated code block
                    Expanded(
                      child: AnimatedQuestionCard(
                        questionIndex: _currentIndex,
                        child: AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_isCorrect == false ? _shakeAnimation.value : 0, 0),
                              child: child,
                            );
                          },
                          child: GlassCard(
                            borderColor: _selectedLine == null 
                                ? RheoColors.glassBorder
                                : (_isCorrect! ? RheoColors.success : RheoColors.error),
                            padding: EdgeInsets.zero,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: currentQuestion.codeLines.length,
                              itemBuilder: (context, index) {
                                final line = currentQuestion.codeLines[index];
                                return StaggeredFadeIn(
                                  index: index,
                                  delay: const Duration(milliseconds: 50),
                                  child: InkWell(
                                    onTap: _selectedLine == null 
                                        ? () => _onLineSelected(index)
                                        : null,
                                    child: Container(
                                      color: _getLineColor(index),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 28,
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                color: RheoColors.textMuted,
                                                fontSize: 13,
                                                fontFamily: 'monospace',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: HighlightView(
                                              line.isEmpty ? ' ' : line,
                                              language: 'python',
                                              theme: atomOneDarkTheme,
                                              padding: EdgeInsets.zero,
                                              textStyle: const TextStyle(
                                                fontFamily: 'monospace',
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          if (_selectedLine != null && index == currentQuestion.bugLineIndex)
                                            const Icon(Icons.bug_report, color: RheoColors.success, size: 18),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Explanation with mascot
                    if (_selectedLine != null) ...[
                      GlassCard(
                        borderColor: _isCorrect! ? RheoColors.success : RheoColors.warning,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Mascot with emotion
                            MascotWidget(
                              mood: _isCorrect! ? MascotMood.celebrating : MascotMood.encouraging,
                              message: _isCorrect! 
                                  ? MascotHelper.getBugHuntCorrect()
                                  : MascotHelper.getBugHuntWrong(),
                              size: 55,
                              animate: _isCorrect!,
                              bubbleColor: _isCorrect! ? RheoColors.success : RheoColors.warning,
                            ),
                            const SizedBox(height: 16),
                            // Show correct line if wrong
                            if (!_isCorrect!) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: RheoColors.success.withAlpha(20),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: RheoColors.success.withAlpha(50)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.bug_report, color: RheoColors.success, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Bug satır ${currentQuestion.bugLineIndex + 1} numaralı satırda',
                                        style: TextStyle(
                                          color: RheoColors.success,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            // Explanation text
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: RheoColors.glassLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.lightbulb_outline, color: RheoColors.secondary, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Bug Açıklaması',
                                        style: TextStyle(
                                          color: RheoColors.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    currentQuestion.explanation,
                                    style: TextStyle(color: RheoColors.textSecondary, fontSize: 13, height: 1.4),
                                  ),
                                ],
                              ),
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
                            backgroundColor: RheoColors.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            _currentIndex + 1 >= _questions.length ? 'Sonuçları Gör' : 'Sonraki Bug →',
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
}
