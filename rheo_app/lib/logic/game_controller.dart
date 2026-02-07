import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../data/question_model.dart';
import '../data/user_progress.dart';
import 'elo_calculator.dart';
import 'storage_service.dart';

/// Controls quiz logic: loading questions, tracking score, ELO, etc.
class GameController {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _sessionScore = 0;
  int _sessionCorrect = 0;
  int _sessionWrong = 0;

  // Getters
  Question? get currentQuestion => 
      _currentIndex < _questions.length ? _questions[_currentIndex] : null;
  
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  int get sessionScore => _sessionScore;
  int get sessionCorrect => _sessionCorrect;
  int get sessionWrong => _sessionWrong;
  bool get isFinished => _currentIndex >= _questions.length;
  double get progress => _questions.isEmpty ? 0 : _currentIndex / _questions.length;

  // User progress from storage
  UserProgress get userProgress => storageService.progress;
  int get currentElo => userProgress.elo;
  int get currentStreak => userProgress.currentStreak;
  int get bestStreak => userProgress.bestStreak;
  String get rankTitle => EloCalculator.getRankTitle(currentElo);

  /// Initialize storage
  Future<void> init() async {
    await storageService.init();
  }

  /// Load questions from assets/questions.json
  /// [language] filter: 'python', 'java', 'javascript', or null for all
  /// [topic] filter: 'variable', 'loop', 'if_else', etc or null for all
  Future<void> loadQuestions({int? maxQuestions, String? language, String? topic}) async {
    final jsonString = await rootBundle.loadString('assets/questions.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _questions = jsonList.map((json) => Question.fromJson(json)).toList();
    
    // Filter by language if specified
    if (language != null && language.isNotEmpty) {
      _questions = _questions.where((q) => q.language == language).toList();
    }
    
    // Filter by topic if specified
    if (topic != null && topic.isNotEmpty) {
      _questions = _questions.where((q) => q.topic == topic).toList();
    }
    
    // Filter by difficulty based on ELO
    _filterByEloDifficulty();
    
    // Sort by difficulty based on user ELO
    _sortQuestionsByElo();
    
    // Limit questions if specified
    if (maxQuestions != null && _questions.length > maxQuestions) {
      _questions = _questions.take(maxQuestions).toList();
    }
    
    _currentIndex = 0;
    _sessionScore = 0;
    _sessionCorrect = 0;
    _sessionWrong = 0;
  }

  /// Filter questions: include hard ones only for ELO >= 1200
  void _filterByEloDifficulty() {
    final elo = currentElo;
    
    if (elo < 1200) {
      // Exclude difficulty 3 (hard) questions
      _questions = _questions.where((q) => q.difficulty <= 2).toList();
    } else if (elo >= 1500) {
      // For high ELO, prioritize hard questions
      final hardQuestions = _questions.where((q) => q.difficulty == 3).toList();
      final otherQuestions = _questions.where((q) => q.difficulty < 3).toList();
      
      // Mix: 60% hard, 40% other
      hardQuestions.shuffle();
      otherQuestions.shuffle();
      
      final hardCount = (10 * 0.6).round();
      final otherCount = 10 - hardCount;
      
      _questions = [
        ...hardQuestions.take(hardCount),
        ...otherQuestions.take(otherCount),
      ];
    }
  }

  /// Sort questions based on user ELO (adaptive difficulty)
  void _sortQuestionsByElo() {
    final recommendedDifficulty = EloCalculator.getRecommendedDifficulty(currentElo);
    
    // Shuffle first
    _questions.shuffle();
    
    // Then sort putting recommended difficulty first
    _questions.sort((a, b) {
      final aDiff = (a.difficulty - recommendedDifficulty).abs();
      final bDiff = (b.difficulty - recommendedDifficulty).abs();
      return aDiff.compareTo(bDiff);
    });
  }

  /// Check if the selected answer is correct and update ELO
  Future<bool> checkAnswer(String selectedAnswer) async {
    if (currentQuestion == null) return false;
    
    final isCorrect = selectedAnswer == currentQuestion!.correctAnswer;
    final difficulty = currentQuestion!.difficulty;
    
    // Calculate new ELO
    final newElo = EloCalculator.calculateNewElo(
      currentElo: currentElo,
      questionDifficulty: difficulty,
      isCorrect: isCorrect,
    );
    
    // Update score
    if (isCorrect) {
      _sessionScore += 10 * difficulty;
      _sessionCorrect++;
    } else {
      _sessionWrong++;
    }
    
    // Save to storage
    await storageService.recordAnswer(
      isCorrect: isCorrect,
      newElo: newElo,
    );
    
    return isCorrect;
  }

  /// Record timeout as wrong answer (for Time Attack mode)
  Future<void> recordTimeOut() async {
    if (currentQuestion == null) return;
    
    final difficulty = currentQuestion!.difficulty;
    final newElo = EloCalculator.calculateNewElo(
      currentElo: currentElo,
      questionDifficulty: difficulty,
      isCorrect: false,
    );
    
    _sessionWrong++;
    
    await storageService.recordAnswer(
      isCorrect: false,
      newElo: newElo,
    );
  }

  /// Move to next question
  void nextQuestion() {
    if (_currentIndex < _questions.length) {
      _currentIndex++;
    }
  }

  /// Reset the game for a new session
  void reset() {
    _currentIndex = 0;
    _sessionScore = 0;
    _sessionCorrect = 0;
    _sessionWrong = 0;
    _sortQuestionsByElo();
  }

  /// Get session summary
  Map<String, dynamic> getSessionSummary() {
    return {
      'score': _sessionScore,
      'correct': _sessionCorrect,
      'wrong': _sessionWrong,
      'accuracy': _sessionCorrect + _sessionWrong > 0
          ? (_sessionCorrect / (_sessionCorrect + _sessionWrong) * 100).round()
          : 0,
      'elo': currentElo,
      'rank': rankTitle,
      'streak': currentStreak,
      'bestStreak': bestStreak,
    };
  }
}
