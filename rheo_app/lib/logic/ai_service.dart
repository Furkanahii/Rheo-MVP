import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/question_model.dart';

/// AI Service - Groq (Llama 3) ile dinamik soru üretimi
/// Caching + Fallback mekanizması ile güvenli çalışır
class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  String? _apiKey;
  Box? _cacheBox;
  bool _isInitialized = false;
  String? lastError;

  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.3-70b-versatile';

  /// System prompt - Senior Software Engineer rolü
  static const String _systemPrompt = '''
You are a Senior Software Engineer and coding instructor. Generate a coding question based on the user's topic. All code snippets must be in Python. Generate exactly 4 options.

IMPORTANT: Randomly pick ONE of these question types (include the "type" field in your JSON):

1. type: "output" — "What is the output of this code?" Code with tricky output due to edge cases, operator precedence, mutability, or scope.
2. type: "missing_code" — Show code with one line replaced by "_____" and ask what the missing line should be. The question_text should be "Fill in the blank to make this code work correctly."
3. type: "debug" — "Why does this code produce an error?" or "Which line contains a bug?" Code with a subtle off-by-one error, wrong comparison, or logic flaw.

The options must be realistic and diverse. Include actual output values, code lines, error descriptions — NOT Big O notations.
Keep code snippets SHORT (5-12 lines max). Make questions educational and tricky.

Output strictly in JSON format with no extra text, no markdown:
{"type": "output", "question_text": "...", "code_snippet": "x = [1,2,3]\\nprint(x[-1])", "options": ["3", "1", "[1,2,3]", "IndexError"], "correct_index": 0, "explanation": "Detailed explanation."}
''';

  /// Initialize AI service
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      _cacheBox = await Hive.openBox('ai_questions_cache');

      final apiKey = dotenv.env['GROQ_API_KEY'];
      if (apiKey == null || apiKey.isEmpty || apiKey == 'your_api_key_here') {
        debugPrint('⚠️ GROQ_API_KEY not configured in .env');
        _isInitialized = true;
        return;
      }

      _apiKey = apiKey;
      _isInitialized = true;
      debugPrint('✅ AIService initialized (Groq/Llama3)');
    } catch (e) {
      debugPrint('❌ AIService init error: $e');
      _isInitialized = true;
    }
  }

  /// AI ile soru üret
  Future<Question?> generateQuestion({
    required String topic,
    int difficulty = 2,
  }) async {
    if (!_isInitialized) await init();

    final topicLabel = _getTopicLabel(topic);
    final difficultyLabel = _getDifficultyLabel(difficulty);

    // 1. Önce API'den dene
    if (_apiKey != null) {
      try {
        final question = await _generateFromAPI(topicLabel, difficultyLabel, topic);
        if (question != null) {
          await _cacheQuestion(topic, question);
          return question;
        }
      } catch (e) {
        debugPrint('⚠️ AI generation failed, trying cache: $e');
        lastError = e.toString();
      }
    }

    // 2. Cache'den dene (Fallback)
    final cachedQuestion = _getCachedQuestion(topic);
    if (cachedQuestion != null) {
      debugPrint('📦 Serving from cache');
      return cachedQuestion;
    }

    // 3. Hiçbiri yoksa null döner
    debugPrint('❌ No questions available (no API, no cache)');
    return null;
  }

  /// Groq API'den soru üret
  Future<Question?> _generateFromAPI(
    String topicLabel,
    String difficultyLabel,
    String topicId,
  ) async {
    final userMessage = 'Generate a $difficultyLabel difficulty Code Reading question about $topicLabel. '
        'Focus on subtle bugs, edge cases, or complexity traps.';

    final body = json.encode({
      'model': _model,
      'messages': [
        {'role': 'system', 'content': _systemPrompt},
        {'role': 'user', 'content': userMessage},
      ],
      'temperature': 0.5,
    });

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Groq API error ${response.statusCode}: ${response.body}');
    }

    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final content = responseData['choices']?[0]?['message']?['content'] as String?;

    if (content == null || content.isEmpty) return null;

    // JSON parse - content içinden JSON'ı çıkar
    try {
      // Bazen model markdown ile sarabilir, temizle
      String cleanContent = content.trim();
      if (cleanContent.startsWith('```json')) {
        cleanContent = cleanContent.substring(7);
      } else if (cleanContent.startsWith('```')) {
        cleanContent = cleanContent.substring(3);
      }
      if (cleanContent.endsWith('```')) {
        cleanContent = cleanContent.substring(0, cleanContent.length - 3);
      }
      cleanContent = cleanContent.trim();

      final jsonData = json.decode(cleanContent) as Map<String, dynamic>;
      return _parseAIResponse(jsonData, topicId);
    } catch (e) {
      debugPrint('❌ JSON parse error: $e\nResponse: $content');
      return null;
    }
  }

  /// AI yanıtını Question modeline dönüştür
  Question _parseAIResponse(Map<String, dynamic> json, String topicId) {
    final options = List<String>.from(json['options'] as List);
    final correctIndex = json['correct_index'] as int;
    final correctAnswer = options[correctIndex];
    final wrongOptions = List<String>.from(options)..removeAt(correctIndex);
    final questionType = (json['type'] as String?) ?? 'output';

    return Question(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      type: questionType,
      difficulty: 2,
      topic: topicId,
      codeSnippet: json['code_snippet'] as String,
      questionText: json['question_text'] as String,
      correctAnswer: correctAnswer,
      wrongOptions: wrongOptions,
      explanation: json['explanation'] as String,
      language: 'python',
    );
  }

  /// Soruyu Hive cache'e kaydet
  Future<void> _cacheQuestion(String topic, Question question) async {
    if (_cacheBox == null) return;
    try {
      final cacheKey = 'cache_$topic';
      final existing = _cacheBox!.get(cacheKey, defaultValue: <dynamic>[]) as List;
      final questionJson = {
        'id': question.id,
        'type': question.type,
        'difficulty': question.difficulty,
        'topic': question.topic,
        'code_snippet': question.codeSnippet,
        'question_text': question.questionText,
        'correct_answer': question.correctAnswer,
        'wrong_options': question.wrongOptions,
        'explanation': question.explanation,
        'language': question.language,
      };
      existing.add(questionJson);
      if (existing.length > 20) existing.removeAt(0);
      await _cacheBox!.put(cacheKey, existing);
      debugPrint('💾 Cached question for $topic (${existing.length} total)');
    } catch (e) {
      debugPrint('❌ Cache write error: $e');
    }
  }

  /// Cache'den rastgele soru getir
  Question? _getCachedQuestion(String topic) {
    if (_cacheBox == null) return null;
    try {
      final cacheKey = 'cache_$topic';
      final cached = _cacheBox!.get(cacheKey, defaultValue: <dynamic>[]) as List;
      if (cached.isEmpty) return null;
      cached.shuffle();
      final json = Map<String, dynamic>.from(cached.first as Map);
      return Question.fromJson(json);
    } catch (e) {
      debugPrint('❌ Cache read error: $e');
      return null;
    }
  }

  String _getTopicLabel(String topicId) {
    switch (topicId) {
      // Standart kategoriler
      case 'variable':
        return 'Python variables, data types (int, float, str, bool), type casting, and basic syntax';
      case 'loop':
        return 'For loops, while loops, nested loops, break/continue statements, loop edge cases';
      case 'if_else':
        return 'If/elif/else conditions, boolean logic, ternary operators, truthy/falsy values';
      case 'function':
        return 'Lambda functions, recursion, variable scope, *args/**kwargs, default arguments, closures';
      case 'list':
        return 'Lists, list comprehensions, slicing, sorting, nested lists, list methods';
      // AI kategorileri
      case 'ai_arrays':
        return 'Arrays and Hashing (Two Sum, Contains Duplicate, Group Anagrams, Hash Maps)';
      case 'ai_linked_lists':
        return 'Linked Lists (Reverse, Merge, Detect Cycle, Floyd\'s Algorithm, Dummy Nodes)';
      case 'ai_trees':
        return 'Trees and Graphs (BFS, DFS, Binary Search Trees, Graph Traversal, Tree Recursion)';
      default:
        return topicId;
    }
  }

  String _getDifficultyLabel(int difficulty) {
    switch (difficulty) {
      case 1: return 'Easy';
      case 3: return 'Hard';
      default: return 'Medium';
    }
  }

  int getCachedCount(String topic) {
    if (_cacheBox == null) return 0;
    final cached = _cacheBox!.get('cache_$topic', defaultValue: <dynamic>[]) as List;
    return cached.length;
  }

  Future<void> clearCache() async {
    await _cacheBox?.clear();
    debugPrint('🗑️ AI cache cleared');
  }

  bool get isAvailable => _apiKey != null;
}

/// Global singleton instance
final aiService = AIService();
