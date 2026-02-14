import 'package:flutter_test/flutter_test.dart';
import 'package:rheo_app/data/question_model.dart';
import 'package:rheo_app/data/user_progress.dart';

void main() {
  group('Question', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'q1',
        'type': 'output',
        'difficulty': 2,
        'topic': 'variable',
        'code_snippet': 'x = 5\nprint(x)',
        'question_text': 'Bu kodun çıktısı ne?',
        'correct_answer': '5',
        'wrong_options': ['10', '0', 'x'],
        'explanation': 'x değişkenine 5 atanır.',
        'language': 'python',
      };

      final question = Question.fromJson(json);

      expect(question.id, 'q1');
      expect(question.type, 'output');
      expect(question.difficulty, 2);
      expect(question.topic, 'variable');
      expect(question.codeSnippet, 'x = 5\nprint(x)');
      expect(question.correctAnswer, '5');
      expect(question.wrongOptions, ['10', '0', 'x']);
      expect(question.language, 'python');
    });

    test('fromJson defaults language to python', () {
      final json = {
        'id': 'q2',
        'type': 'output',
        'difficulty': 1,
        'topic': 'loop',
        'code_snippet': 'for i in range(3): print(i)',
        'question_text': 'Çıktı?',
        'correct_answer': '0 1 2',
        'wrong_options': ['1 2 3', '0 1 2 3', '1 2'],
        'explanation': 'range(3) 0,1,2 üretir.',
      };

      final question = Question.fromJson(json);
      expect(question.language, 'python');
    });

    test('getShuffledOptions contains correct answer', () {
      final question = Question(
        id: 'q1',
        type: 'output',
        difficulty: 1,
        topic: 'variable',
        codeSnippet: 'print(1)',
        questionText: '?',
        correctAnswer: '1',
        wrongOptions: ['2', '3', '4'],
        explanation: 'test',
      );

      final options = question.getShuffledOptions();
      expect(options.length, 4);
      expect(options, contains('1'));
      expect(options, contains('2'));
      expect(options, contains('3'));
      expect(options, contains('4'));
    });
  });

  group('UserProgress', () {
    test('Default values are correct', () {
      final progress = UserProgress();

      expect(progress.elo, 1000);
      expect(progress.currentStreak, 0);
      expect(progress.bestStreak, 0);
      expect(progress.totalCorrect, 0);
      expect(progress.totalWrong, 0);
      expect(progress.dailyQuestionsToday, 0);
      expect(progress.dailyGoal, 5);
    });

    test('totalQuestions is sum of correct and wrong', () {
      final progress = UserProgress(totalCorrect: 10, totalWrong: 5);
      expect(progress.totalQuestions, 15);
    });

    test('accuracy calculates correctly', () {
      final progress = UserProgress(totalCorrect: 7, totalWrong: 3);
      expect(progress.accuracy, closeTo(70.0, 0.1));
    });

    test('accuracy is 0 when no questions answered', () {
      final progress = UserProgress();
      expect(progress.accuracy, 0);
    });

    test('dailyProgress is clamped to 1.0', () {
      final progress = UserProgress(dailyQuestionsToday: 10, dailyGoal: 5);
      expect(progress.dailyProgress, 1.0);
    });

    test('dailyGoalCompleted is true when met', () {
      final progress = UserProgress(dailyQuestionsToday: 5, dailyGoal: 5);
      expect(progress.dailyGoalCompleted, true);
    });

    test('playedToday is false when never played', () {
      final progress = UserProgress();
      expect(progress.playedToday, false);
    });

    test('playedToday is true when played today', () {
      final progress = UserProgress(lastPlayedDate: DateTime.now());
      expect(progress.playedToday, true);
    });

    test('shouldResetStreak is true when missed a day', () {
      final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
      final progress = UserProgress(lastPlayedDate: twoDaysAgo, currentStreak: 5);
      expect(progress.shouldResetStreak, true);
    });

    test('shouldResetStreak is false when played yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(hours: 20));
      final progress = UserProgress(lastPlayedDate: yesterday, currentStreak: 5);
      // Could be true or false depending on exact time, but test the logic
      // When played less than a day ago, streak should not be reset
      expect(progress.shouldResetStreak, false);
    });

    test('toMap and fromMap roundtrip', () {
      final original = UserProgress(
        elo: 1500,
        currentStreak: 3,
        bestStreak: 7,
        totalCorrect: 50,
        totalWrong: 20,
        dailyQuestionsToday: 4,
        dailyGoal: 10,
        lastPlayedDate: DateTime(2026, 2, 15),
      );

      final map = original.toMap();
      final restored = UserProgress.fromMap(map);

      expect(restored.elo, 1500);
      expect(restored.currentStreak, 3);
      expect(restored.bestStreak, 7);
      expect(restored.totalCorrect, 50);
      expect(restored.totalWrong, 20);
      expect(restored.dailyQuestionsToday, 4);
      expect(restored.dailyGoal, 10);
      expect(restored.lastPlayedDate?.year, 2026);
    });
  });
}
