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

  /// Factory constructor to parse JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      type: json['type'] as String,
      difficulty: json['difficulty'] as int,
      topic: json['topic'] as String,
      codeSnippet: json['code_snippet'] as String,
      questionText: json['question_text'] as String,
      correctAnswer: json['correct_answer'] as String,
      wrongOptions: List<String>.from(json['wrong_options'] as List),
      explanation: json['explanation'] as String,
      language: json['language'] as String? ?? 'python',
    );
  }

  /// Get all options (shuffled: correct + wrong)
  List<String> getShuffledOptions() {
    final options = [correctAnswer, ...wrongOptions];
    options.shuffle();
    return options;
  }
}
