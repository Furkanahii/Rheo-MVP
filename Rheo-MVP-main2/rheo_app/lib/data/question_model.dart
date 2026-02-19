/// Question model for parsing questions.json
class Question {
  final String id;
  final String type;
  final int difficulty;
  final String topic;
  final String codeSnippet;
  final String questionText;
  final String correctAnswer;
  final List<String> wrongOptions;
  final String explanation;
  final String language;

  Question({
    required this.id,
    required this.type,
    required this.difficulty,
    required this.topic,
    required this.codeSnippet,
    required this.questionText,
    required this.correctAnswer,
    required this.wrongOptions,
    required this.explanation,
    this.language = 'python',
  });

  /// Factory constructor to parse JSON — error-safe
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id']?.toString() ?? 'unknown',
      type: json['type']?.toString() ?? 'output',
      difficulty: (json['difficulty'] is int) ? json['difficulty'] : int.tryParse(json['difficulty']?.toString() ?? '1') ?? 1,
      topic: json['topic']?.toString() ?? '',
      codeSnippet: json['code_snippet']?.toString() ?? '',
      questionText: json['question_text']?.toString() ?? '',
      correctAnswer: json['correct_answer']?.toString() ?? '',
      wrongOptions: (json['wrong_options'] as List?)?.map((e) => e.toString()).toList() ?? [],
      explanation: json['explanation']?.toString() ?? '',
      language: json['language']?.toString() ?? 'python',
    );
  }

  /// Get all options (shuffled: correct + wrong)
  List<String> getShuffledOptions() {
    final options = [correctAnswer, ...wrongOptions];
    options.shuffle();
    return options;
  }
}
