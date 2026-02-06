import 'package:flutter/material.dart';
import '../logic/game_controller.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final GameController _controller = GameController();
  bool _isLoading = true;
  String? _selectedAnswer;
  bool? _isCorrect;
  List<String> _shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    await _controller.loadQuestions();
    _prepareQuestion();
    setState(() => _isLoading = false);
  }

  void _prepareQuestion() {
    if (_controller.currentQuestion != null) {
      _shuffledOptions = _controller.currentQuestion!.getShuffledOptions();
      _selectedAnswer = null;
      _isCorrect = null;
    }
  }

  void _onAnswerSelected(String answer) {
    if (_selectedAnswer != null) return; // Already answered

    final isCorrect = _controller.checkAnswer(answer);
    setState(() {
      _selectedAnswer = answer;
      _isCorrect = isCorrect;
    });

    // Wait a bit then move to next question
    Future.delayed(const Duration(milliseconds: 1200), () {
      _controller.nextQuestion();
      if (_controller.isFinished) {
        _showResults();
      } else {
        setState(() {
          _prepareQuestion();
        });
      }
    });
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('Quiz Bitti! 🎉', 
          style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Skor: ${_controller.score}',
              style: const TextStyle(color: Colors.white, fontSize: 24)),
            const SizedBox(height: 8),
            Text('En İyi Seri: ${_controller.bestStreak}',
              style: TextStyle(color: Colors.grey[400])),
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
              _controller.reset();
              setState(() {
                _isLoading = false;
                _prepareQuestion();
              });
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text('${_controller.streak}', 
                  style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
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
              const SizedBox(height: 24),
              
              // Code snippet
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF404040)),
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
              const SizedBox(height: 24),
              
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
              const SizedBox(height: 24),
              
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
              
              // Score display
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Skor: ${_controller.score}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
