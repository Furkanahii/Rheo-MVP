import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../logic/game_controller.dart';
import '../logic/elo_calculator.dart';

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
    await _controller.loadQuestions(maxQuestions: 10);
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
    if (_selectedAnswer != null) return; // Already answered

    final isCorrect = await _controller.checkAnswer(answer);
    setState(() {
      _selectedAnswer = answer;
      _isCorrect = isCorrect;
    });

    // Play animation
    if (isCorrect) {
      _confettiController.play();
    } else {
      _shakeController.forward().then((_) => _shakeController.reset());
    }

    // Show explanation after a short delay
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _showExplanation = true);
    }
  }

  void _nextQuestion() {
    _controller.nextQuestion();
    if (_controller.isFinished) {
      _showResults();
    } else {
      setState(() {
        _prepareQuestion();
      });
    }
  }

  void _showResults() {
    final summary = _controller.getSessionSummary();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Quiz Bitti! 🎉', 
          style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('Skor', '${summary['score']}', Colors.amber),
            _buildStatRow('Doğru', '${summary['correct']}', Colors.green),
            _buildStatRow('Yanlış', '${summary['wrong']}', Colors.red),
            _buildStatRow('Başarı', '%${summary['accuracy']}', Colors.blue),
            const Divider(color: Colors.grey),
            _buildStatRow('ELO', '${summary['elo']}', 
                Color(EloCalculator.getRankColor(summary['elo']))),
            _buildStatRow('Rank', summary['rank'], 
                Color(EloCalculator.getRankColor(summary['elo']))),
            _buildStatRow('Seri', '🔥 ${summary['streak']}', Colors.orange),
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
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              await _controller.loadQuestions(maxQuestions: 10);
              _controller.reset();
              _prepareQuestion();
              setState(() => _isLoading = false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00D9FF),
            ),
            child: const Text('Tekrar Oyna', 
              style: TextStyle(color: Colors.black)),
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

  Color _getButtonColor(String option) {
    if (_selectedAnswer == null) {
      return const Color(0xFF3D3D3D);
    }
    if (option == _controller.currentQuestion?.correctAnswer) {
      return Colors.green;
    }
    if (option == _selectedAnswer && !_isCorrect!) {
      return Colors.red;
    }
    return const Color(0xFF3D3D3D);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00D9FF)),
        ),
      );
    }

    final question = _controller.currentQuestion;
    if (question == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Center(child: Text('Soru yok', style: TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: Text(
          'Soru ${_controller.currentIndex + 1}/${_controller.totalQuestions}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          // ELO Display
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Color(EloCalculator.getRankColor(_controller.currentElo)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${_controller.currentElo}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          // Streak Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text('${_controller.currentStreak}', 
                  style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
          
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress bar
                  LinearProgressIndicator(
                    value: _controller.progress,
                    backgroundColor: const Color(0xFF3D3D3D),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00D9FF)),
                  ),
                  const SizedBox(height: 16),
                  
                  // Difficulty badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(question.difficulty),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getDifficultyLabel(question.difficulty),
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        question.topic.toUpperCase(),
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Code snippet with shake animation
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_isCorrect == false ? _shakeAnimation.value : 0, 0),
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2D2D),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _selectedAnswer == null 
                              ? const Color(0xFF404040)
                              : (_isCorrect! ? Colors.green : Colors.red),
                          width: _selectedAnswer == null ? 1 : 2,
                        ),
                      ),
                      child: Text(
                        question.codeSnippet,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 16,
                          color: Color(0xFF00D9FF),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Question text
                  Text(
                    question.questionText,
                    style: const TextStyle(
                      fontSize: 18,
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
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ElevatedButton(
                            onPressed: _selectedAnswer == null 
                                ? () => _onAnswerSelected(option) 
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getButtonColor(option),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Explanation card (shown after answering)
                  if (_showExplanation) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2D2D),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isCorrect! ? Colors.green : Colors.orange,
                        ),
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
                                _isCorrect! ? 'Doğru!' : 'Açıklama',
                                style: TextStyle(
                                  color: _isCorrect! ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            question.explanation,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _controller.currentIndex + 1 >= _controller.totalQuestions
                            ? 'Sonuçları Gör'
                            : 'Sonraki Soru →',
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

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1: return Colors.green;
      case 2: return Colors.orange;
      case 3: return Colors.red;
      default: return Colors.grey;
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
