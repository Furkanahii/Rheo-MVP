import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import '../logic/sound_service.dart';
import '../logic/storage_service.dart';
import '../logic/elo_calculator.dart';

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
  
  // Sample bug hunt questions
  final List<BugHuntQuestion> _questions = [
    BugHuntQuestion(
      id: 'bug_001',
      codeLines: [
        'def greet(name):',
        '    message = "Hello, " + name',
        '    return massage',  // Bug: typo
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
        'for i in range(6):',  // Bug: index out of range
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
        '    return n * factorial(n)',  // Bug: infinite recursion
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
        'if x = y:',  // Bug: = instead of ==
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
        'for word in words',  // Bug: missing colon
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

    final isCorrect = lineIndex == currentQuestion.bugLineIndex;
    
    setState(() {
      _selectedLine = lineIndex;
      _isCorrect = isCorrect;
    });

    // Calculate ELO change
    final newElo = EloCalculator.calculateNewElo(
      currentElo: storageService.progress.elo,
      questionDifficulty: currentQuestion.difficulty,
      isCorrect: isCorrect,
    );

    if (isCorrect) {
      _confettiController.play();
      soundService.playCorrect();
      _score += 15 * currentQuestion.difficulty;
      _correct++;
    } else {
      _shakeController.forward().then((_) => _shakeController.reset());
      soundService.playWrong();
      _wrong++;
    }

    await storageService.recordAnswer(isCorrect: isCorrect, newElo: newElo);
  }

  void _nextQuestion() {
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
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Bug Hunt Bitti! 🐞', 
          style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatRow('Skor', '$_score', Colors.amber),
            _buildStatRow('Bulunan Bug', '$_correct', Colors.green),
            _buildStatRow('Kaçırılan', '$_wrong', Colors.red),
            _buildStatRow('Başarı', '%$accuracy', Colors.blue),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Ana Sayfa'),
          ),
          ElevatedButton(
            onPressed: () {
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
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00D9FF)),
            child: const Text('Tekrar Oyna', style: TextStyle(color: Colors.black)),
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
          Text(label, style: TextStyle(color: Colors.grey[400])),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getLineColor(int lineIndex) {
    if (_selectedLine == null) return Colors.transparent;
    
    if (lineIndex == currentQuestion.bugLineIndex) {
      return Colors.green.withAlpha(80);
    }
    if (lineIndex == _selectedLine && !_isCorrect!) {
      return Colors.red.withAlpha(80);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF00D9FF))),
      );
    }

    if (isFinished) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF00D9FF))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: Text(
          'Bug ${_currentIndex + 1}/${_questions.length}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withAlpha(50),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.bug_report, color: Colors.orange, size: 18),
                const SizedBox(width: 4),
                Text('$_correct', style: const TextStyle(color: Colors.orange)),
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
              colors: const [Colors.green, Colors.blue, Colors.yellow],
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFF3D3D3D),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('BUG HUNT', 
                          style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentQuestion.topic.toUpperCase(),
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  const Text(
                    '🐞 Hatalı satırı bul ve tıkla!',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  
                  // Clickable code lines
                  Expanded(
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
                          color: const Color(0xFF282C34),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedLine == null 
                                ? const Color(0xFF404040)
                                : (_isCorrect! ? Colors.green : Colors.red),
                            width: _selectedLine == null ? 1 : 2,
                          ),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: currentQuestion.codeLines.length,
                          itemBuilder: (context, index) {
                            final line = currentQuestion.codeLines[index];
                            return InkWell(
                              onTap: _selectedLine == null 
                                  ? () => _onLineSelected(index)
                                  : null,
                              child: Container(
                                color: _getLineColor(index),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
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
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    if (_selectedLine != null && index == currentQuestion.bugLineIndex)
                                      const Icon(Icons.bug_report, color: Colors.green, size: 20),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Explanation card
                  if (_selectedLine != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2D2D),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _isCorrect! ? Colors.green : Colors.orange),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isCorrect! ? Icons.check_circle : Icons.info,
                                color: _isCorrect! ? Colors.green : Colors.orange,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _isCorrect! ? 'Bug Bulundu!' : 'Yanlış Satır',
                                style: TextStyle(
                                  color: _isCorrect! ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currentQuestion.explanation,
                            style: TextStyle(color: Colors.grey[300], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D9FF),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _currentIndex + 1 >= _questions.length ? 'Sonuçları Gör' : 'Sonraki Bug →',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
