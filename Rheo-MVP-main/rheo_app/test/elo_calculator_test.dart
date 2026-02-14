import 'package:flutter_test/flutter_test.dart';
import 'package:rheo_app/logic/elo_calculator.dart';

void main() {
  group('EloCalculator', () {
    group('getKFactor', () {
      test('Easy difficulty returns K=16', () {
        expect(EloCalculator.getKFactor(1), 16);
      });

      test('Medium difficulty returns K=24', () {
        expect(EloCalculator.getKFactor(2), 24);
      });

      test('Hard difficulty returns K=32', () {
        expect(EloCalculator.getKFactor(3), 32);
      });

      test('Default difficulty returns K=24', () {
        expect(EloCalculator.getKFactor(0), 24);
        expect(EloCalculator.getKFactor(5), 24);
      });
    });

    group('getQuestionElo', () {
      test('Easy question ELO is 800', () {
        expect(EloCalculator.getQuestionElo(1), 800);
      });

      test('Medium question ELO is 1000', () {
        expect(EloCalculator.getQuestionElo(2), 1000);
      });

      test('Hard question ELO is 1200', () {
        expect(EloCalculator.getQuestionElo(3), 1200);
      });
    });

    group('expectedScore', () {
      test('Equal ELO gives 0.5 expected score', () {
        final score = EloCalculator.expectedScore(1000, 1000);
        expect(score, closeTo(0.5, 0.01));
      });

      test('Higher user ELO gives higher expected score', () {
        final score = EloCalculator.expectedScore(1200, 1000);
        expect(score, greaterThan(0.5));
      });

      test('Lower user ELO gives lower expected score', () {
        final score = EloCalculator.expectedScore(800, 1000);
        expect(score, lessThan(0.5));
      });
    });

    group('calculateNewElo', () {
      test('Correct answer increases ELO', () {
        final newElo = EloCalculator.calculateNewElo(
          currentElo: 1000,
          questionDifficulty: 2,
          isCorrect: true,
        );
        expect(newElo, greaterThan(1000));
      });

      test('Wrong answer decreases ELO', () {
        final newElo = EloCalculator.calculateNewElo(
          currentElo: 1000,
          questionDifficulty: 2,
          isCorrect: false,
        );
        expect(newElo, lessThan(1000));
      });

      test('ELO never goes below 100', () {
        final newElo = EloCalculator.calculateNewElo(
          currentElo: 100,
          questionDifficulty: 3,
          isCorrect: false,
        );
        expect(newElo, greaterThanOrEqualTo(100));
      });

      test('Hard correct answer gives bigger ELO gain', () {
        final easyGain = EloCalculator.calculateNewElo(
          currentElo: 1000,
          questionDifficulty: 1,
          isCorrect: true,
        ) - 1000;

        final hardGain = EloCalculator.calculateNewElo(
          currentElo: 1000,
          questionDifficulty: 3,
          isCorrect: true,
        ) - 1000;

        expect(hardGain, greaterThan(easyGain));
      });
    });

    group('getRecommendedDifficulty', () {
      test('Low ELO recommends easy', () {
        expect(EloCalculator.getRecommendedDifficulty(800), 1);
      });

      test('Medium ELO recommends medium', () {
        expect(EloCalculator.getRecommendedDifficulty(1000), 2);
      });

      test('High ELO recommends hard', () {
        expect(EloCalculator.getRecommendedDifficulty(1200), 3);
      });
    });

    group('getRankTitle', () {
      test('Starting rank for low ELO', () {
        expect(EloCalculator.getRankTitle(500), 'Başlangıç');
      });

      test('Grandmaster rank for high ELO', () {
        expect(EloCalculator.getRankTitle(1800), 'Grandmaster');
      });

      test('Efsane rank for very high ELO', () {
        expect(EloCalculator.getRankTitle(2000), 'Efsane');
      });
    });

    group('getRankColor', () {
      test('Returns grey for low ELO', () {
        expect(EloCalculator.getRankColor(700), 0xFF9E9E9E);
      });

      test('Returns gold for very high ELO', () {
        expect(EloCalculator.getRankColor(1800), 0xFFFFD700);
      });
    });
  });
}
