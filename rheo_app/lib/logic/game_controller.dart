import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../data/question_model.dart';
import '../data/user_progress.dart';
import 'elo_calculator.dart';
import 'storage_service.dart';

/// Controls quiz logic with rank-based difficulty distribution.
/// Questions are selected based on user's ELO rank at session start.
class GameController {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _sessionScore = 0;
  int _sessionCorrect = 0;
  int _sessionWrong = 0;

  // Difficulty pools
  List<Question> _easyPool = [];
  List<Question> _mediumPool = [];
  List<Question> _hardPool = [];

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

  /// Load questions from assets/questions.json with rank-based difficulty.
  /// Session questions are distributed based on user's current rank.
  Future<void> loadQuestions({int? maxQuestions, String? language, String? topic}) async {
    try {
      final jsonString = await rootBundle.loadString('assets/questions.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      // Parse all questions with error handling
      List<Question> allQuestions = [];
      for (final jsonItem in jsonList) {
        try {
          allQuestions.add(Question.fromJson(jsonItem));
        } catch (e) {
          continue;
        }
      }
      
      // Filter by language
      if (language != null && language.isNotEmpty) {
        allQuestions = allQuestions.where((q) => q.language == language).toList();
      }
      
      // Filter by topic
      if (topic != null && topic.isNotEmpty) {
        allQuestions = allQuestions.where((q) => q.topic == topic).toList();
      }
      
      // Split into difficulty pools
      _easyPool = allQuestions.where((q) => q.difficulty == 1).toList()..shuffle();
      _mediumPool = allQuestions.where((q) => q.difficulty == 2).toList()..shuffle();
      _hardPool = allQuestions.where((q) => q.difficulty == 3).toList()..shuffle();
      
      debugPrint('­şÄ» Pools: easy=${_easyPool.length}, medium=${_mediumPool.length}, hard=${_hardPool.length}');
      
      // Build rank-based question list
      final totalCount = maxQuestions ?? 10;
      _questions = _buildRankQuestionList(totalCount);
      
      // Log the question order
      for (int i = 0; i < _questions.length; i++) {
        final q = _questions[i];
        final label = q.difficulty == 1 ? 'KOLAY' : q.difficulty == 2 ? 'ORTA' : 'ZOR';
        debugPrint('  Q${i+1}: $label (diff=${q.difficulty}) topic=${q.topic} lang=${q.language}');
      }
      
    } catch (e) {
      _questions = [];
    }
    
    _currentIndex = 0;
    _sessionScore = 0;
    _sessionCorrect = 0;
    _sessionWrong = 0;
  }

  /// Build initial question list with rank-based difficulty distribution.
  /// ├çaylak (ELO < 200):   80% easy, 20% medium, 0% hard
  /// Y├╝kselen (200-399):   60% easy, 40% medium, 0% hard
  /// Deneyimli (400-599):  40% easy, 50% medium, 10% hard
  /// Uzman (600-799):      40% easy, 40% medium, 20% hard
  /// Usta (800-999):       30% easy, 40% medium, 30% hard
  /// ├£stat (1000+):        30% easy, 30% medium, 40% hard
  List<Question> _buildRankQuestionList(int count) {
    final rng = Random();
    final List<Question> result = [];
    final elo = storageService.progress.elo;
    
    // Rank-based difficulty ratios
    double easyRatio, mediumRatio, hardRatio;
    if (elo < 200) {
      // ├çaylak: mostly easy
      easyRatio = 0.80; mediumRatio = 0.20; hardRatio = 0.0;
    } else if (elo < 400) {
      // Y├╝kselen: easy + some medium
      easyRatio = 0.60; mediumRatio = 0.40; hardRatio = 0.0;
    } else if (elo < 600) {
      // Deneyimli: balanced with a touch of hard
      easyRatio = 0.40; mediumRatio = 0.50; hardRatio = 0.10;
    } else if (elo < 800) {
      // Uzman: balanced
      easyRatio = 0.40; mediumRatio = 0.40; hardRatio = 0.20;
    } else if (elo < 1000) {
      // Usta: harder mix
      easyRatio = 0.30; mediumRatio = 0.40; hardRatio = 0.30;
    } else {
      // ├£stat: challenging
      easyRatio = 0.30; mediumRatio = 0.30; hardRatio = 0.40;
    }
    
    final easyCount = (count * easyRatio).round().clamp(0, _easyPool.length);
    final hardCount = (count * hardRatio).round().clamp(0, _hardPool.length);
    final mediumCount = (count - easyCount - hardCount).clamp(0, _mediumPool.length);
    
    // Pick from each pool
    final easyPick = _pickRandom(_easyPool, easyCount, rng);
    final mediumPick = _pickRandom(_mediumPool, mediumCount, rng);
    final hardPick = _pickRandom(_hardPool, hardCount, rng);
    
    // Order: easy first, then medium, then hard (progressive)
    result.addAll(easyPick);
    result.addAll(mediumPick);
    result.addAll(hardPick);
    
    // If not enough questions, fill from any pool
    if (result.length < count) {
      final remaining = [..._easyPool, ..._mediumPool, ..._hardPool]
        ..removeWhere((q) => result.any((r) => r.id == q.id));
      remaining.shuffle(rng);
      result.addAll(remaining.take(count - result.length));
    }
    
    return result.take(count).toList();
  }

  /// Pick n random questions from a pool
  List<Question> _pickRandom(List<Question> pool, int n, Random rng) {
    if (pool.isEmpty || n <= 0) return [];
    final shuffled = List<Question>.from(pool)..shuffle(rng);
    return shuffled.take(n).toList();
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

  /// Add a single AI-generated question to the queue
  void addAIQuestion(Question question) {
    _questions.add(question);
    _currentIndex = _questions.length - 1;
  }

  /// Reset the game for a new session
  void reset() {
    _currentIndex = 0;
    _sessionScore = 0;
    _sessionCorrect = 0;
    _sessionWrong = 0;
    _questions = _buildRankQuestionList(_questions.length > 0 ? _questions.length : 10);
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