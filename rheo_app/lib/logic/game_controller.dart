import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../data/question_model.dart';

/// Controls quiz logic: loading questions, tracking score, etc.
class GameController {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _streak = 0;
  int _bestStreak = 0;

  // Getters
  Question? get currentQuestion => 
      _currentIndex < _questions.length ? _questions[_currentIndex] : null;
  
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  int get score => _score;
  int get streak => _streak;
  int get bestStreak => _bestStreak;
  bool get isFinished => _currentIndex >= _questions.length;
  double get progress => _questions.isEmpty ? 0 : _currentIndex / _questions.length;

  /// Load questions from assets/questions.json
  Future<void> loadQuestions() async {
    final jsonString = await rootBundle.loadString('assets/questions.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    _questions = jsonList.map((json) => Question.fromJson(json)).toList();
    _questions.shuffle(); // Randomize order
    _currentIndex = 0;
    _score = 0;
    _streak = 0;
  }

  /// Check if the selected answer is correct
  bool checkAnswer(String selectedAnswer) {
    if (currentQuestion == null) return false;
    
    final isCorrect = selectedAnswer == currentQuestion!.correctAnswer;
    
    if (isCorrect) {
      _score += 10 * (currentQuestion!.difficulty);
      _streak++;
      if (_streak > _bestStreak) _bestStreak = _streak;
    } else {
      _streak = 0;
    }
    
    return isCorrect;
  }

  /// Move to next question
  void nextQuestion() {
    if (_currentIndex < _questions.length) {
      _currentIndex++;
    }
  }

  /// Reset the game
  void reset() {
    _currentIndex = 0;
    _score = 0;
    _streak = 0;
    _questions.shuffle();
  }
}
