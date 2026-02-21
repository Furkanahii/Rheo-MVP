import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import '../logic/sound_service.dart';
import '../logic/storage_service.dart';
import '../logic/elo_calculator.dart';
import '../data/app_strings.dart';
import 'theme.dart';
import 'animations.dart';
import 'widgets/mascot_widget.dart';

/// Bug Hunt Question Model
class BugHuntQuestion {
  final String id;
  final List<String> codeLines;
  final int bugLineIndex;
  final String explanation;
  final String explanationEn;
  final int difficulty;
  final String topic;
  final String language;

  BugHuntQuestion({
    required this.id,
    required this.codeLines,
    required this.bugLineIndex,
    required this.explanation,
    this.explanationEn = '',
    required this.difficulty,
    required this.topic,
    this.language = 'python',
  });

  String get localizedExplanation {
    if (S.isEn && explanationEn.isNotEmpty) return explanationEn;
    return explanation;
  }
}

/// ─── BUG HUNT QUESTIONS ─── 30+ questions, difficulty 1-3
final List<BugHuntQuestion> _allBugHuntQuestions = [
  // ═══════════════════════════════════════════════════
  // DIFFICULTY 1 — EASY (Syntax & Basic Errors)
  // ═══════════════════════════════════════════════════
  BugHuntQuestion(
    id: 'bug_001',
    codeLines: [
      'def greet(name):',
      '    message = "Hello, " + name',
      '    return massage',
      '',
    ],
    bugLineIndex: 2,
    explanation: 'Typo hatası: "massage" yerine "message" olmalı.',
    explanationEn: 'Typo error: "massage" should be "message".',
    difficulty: 1,
    topic: 'variables',
  ),
  BugHuntQuestion(
    id: 'bug_002',
    codeLines: [
      'x = 10',
      'y = 5',
      'if x = y:',
      '    print("Equal")',
    ],
    bugLineIndex: 2,
    explanation: 'Karşılaştırma için == kullanılmalı, = atama operatörüdür.',
    explanationEn: 'Use == for comparison, = is the assignment operator.',
    difficulty: 1,
    topic: 'if_else',
  ),
  BugHuntQuestion(
    id: 'bug_003',
    codeLines: [
      'text = "Hello World"',
      'words = text.split()',
      'for word in words',
      '    print(word)',
    ],
    bugLineIndex: 2,
    explanation: 'for döngüsünün sonunda ":" eksik.',
    explanationEn: 'Missing ":" at the end of the for loop.',
    difficulty: 1,
    topic: 'loops',
  ),
  BugHuntQuestion(
    id: 'bug_004',
    codeLines: [
      'def add(a, b):',
      '    result = a + b',
      '    print(result)',
      '',
      'total = add(3, 5)',
      'print(total * 2)',
    ],
    bugLineIndex: 2,
    explanation: 'Fonksiyon return yerine print kullanıyor. total None olur ve None * 2 hata verir.',
    explanationEn: 'Function uses print instead of return. total becomes None and None * 2 causes an error.',
    difficulty: 1,
    topic: 'function',
  ),
  BugHuntQuestion(
    id: 'bug_005',
    codeLines: [
      'let count = 0;',
      'for (let i = 0; i < 5; i++) {',
      '    count += i',
      '}',
      'console.log(count);',
    ],
    bugLineIndex: 2,
    explanation: 'JavaScript\'te satır sonunda ; eksik. Strict mode\'da hata verebilir.',
    explanationEn: 'Missing ; at end of line in JavaScript. Can cause errors in strict mode.',
    difficulty: 1,
    topic: 'loops',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_006',
    codeLines: [
      'String name = "Rheo";',
      'int length = name.length;',
      'System.out.println(name + length);',
    ],
    bugLineIndex: 2,
    explanation: 'Java\'da String + int birleştirme çalışır ama length() metod olmalı, name.length() şeklinde.',
    explanationEn: 'In Java, length is a method for Strings: should be name.length() not name.length.',
    difficulty: 1,
    topic: 'string',
    language: 'java',
  ),
  BugHuntQuestion(
    id: 'bug_007',
    codeLines: [
      'nums = [1, 2, 3, 4, 5]',
      'for i in range(len(nums)):',
      '    if nums[i] % 2 == 0:',
      '        nums.remove(nums[i])',
    ],
    bugLineIndex: 3,
    explanation: 'Döngü içinde listeden eleman silmek indeksleri bozar ve IndexError oluşabilir.',
    explanationEn: 'Removing elements from a list during iteration shifts indices and may cause IndexError.',
    difficulty: 1,
    topic: 'list',
  ),

  // ═══════════════════════════════════════════════════
  // DIFFICULTY 2 — MEDIUM (Logic & Algorithm Errors)  
  // ═══════════════════════════════════════════════════
  BugHuntQuestion(
    id: 'bug_008',
    codeLines: [
      'numbers = [1, 2, 3, 4, 5]',
      'total = 0',
      'for i in range(6):',
      '    total += numbers[i]',
    ],
    bugLineIndex: 2,
    explanation: 'range(6) → i=5 olunca IndexError. range(5) veya range(len(numbers)) olmalı.',
    explanationEn: 'range(6) → when i=5, IndexError occurs. Should be range(5) or range(len(numbers)).',
    difficulty: 2,
    topic: 'loops',
  ),
  BugHuntQuestion(
    id: 'bug_009',
    codeLines: [
      'def binary_search(arr, target):',
      '    left, right = 0, len(arr)',
      '    while left <= right:',
      '        mid = (left + right) // 2',
      '        if arr[mid] == target:',
      '            return mid',
      '        elif arr[mid] < target:',
      '            left = mid + 1',
      '        else:',
      '            right = mid - 1',
      '    return -1',
    ],
    bugLineIndex: 1,
    explanation: 'right = len(arr) yerine len(arr) - 1 olmalı. Son indeks len-1\'dir, aksi halde IndexError.',
    explanationEn: 'right should be len(arr) - 1, not len(arr). The last index is len-1, otherwise IndexError.',
    difficulty: 2,
    topic: 'array',
  ),
  BugHuntQuestion(
    id: 'bug_010',
    codeLines: [
      'def is_palindrome(s):',
      '    s = s.lower()',
      '    left = 0',
      '    right = len(s)',
      '    while left < right:',
      '        if s[left] != s[right]:',
      '            return False',
      '        left += 1',
      '        right -= 1',
      '    return True',
    ],
    bugLineIndex: 3,
    explanation: 'right = len(s) yerine len(s) - 1 olmalı. s[len(s)] IndexError verir.',
    explanationEn: 'right should be len(s) - 1, not len(s). s[len(s)] causes IndexError.',
    difficulty: 2,
    topic: 'string',
  ),
  BugHuntQuestion(
    id: 'bug_011',
    codeLines: [
      'def bubble_sort(arr):',
      '    n = len(arr)',
      '    for i in range(n):',
      '        for j in range(n - 1):',
      '            if arr[j] > arr[j + 1]:',
      '                arr[j] = arr[j + 1]',
      '                arr[j + 1] = arr[j]',
      '    return arr',
    ],
    bugLineIndex: 5,
    explanation: 'Swap işlemi yanlış! Geçici değişken olmadan atama yapılıyor. arr[j], arr[j+1] = arr[j+1], arr[j] kullanılmalı.',
    explanationEn: 'Swap is wrong! Assignment without temp variable overwrites the value. Use arr[j], arr[j+1] = arr[j+1], arr[j].',
    difficulty: 2,
    topic: 'sorting',
  ),
  BugHuntQuestion(
    id: 'bug_012',
    codeLines: [
      'def find_max(numbers):',
      '    max_val = 0',
      '    for num in numbers:',
      '        if num > max_val:',
      '            max_val = num',
      '    return max_val',
    ],
    bugLineIndex: 1,
    explanation: 'max_val = 0 ile başlamak negatif sayılar için yanlış. max_val = numbers[0] veya float("-inf") olmalı.',
    explanationEn: 'Starting max_val = 0 fails for negative numbers. Should be numbers[0] or float("-inf").',
    difficulty: 2,
    topic: 'array',
  ),
  BugHuntQuestion(
    id: 'bug_013',
    codeLines: [
      'function reverseString(str) {',
      '    let reversed = "";',
      '    for (let i = str.length; i >= 0; i--) {',
      '        reversed += str[i];',
      '    }',
      '    return reversed;',
      '}',
    ],
    bugLineIndex: 2,
    explanation: 'i = str.length ile başlayınca str[str.length] undefined olur. i = str.length - 1 olmalı.',
    explanationEn: 'Starting i = str.length makes str[str.length] undefined. Should start at str.length - 1.',
    difficulty: 2,
    topic: 'string',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_014',
    codeLines: [
      'def count_vowels(text):',
      '    vowels = "aeiou"',
      '    count = 0',
      '    for char in text:',
      '        if char in vowels:',
      '            count += 1',
      '    return count',
      '',
      'print(count_vowels("HELLO"))',
    ],
    bugLineIndex: 1,
    explanation: 'Sadece küçük harf sesli harfler tanımlı. "AEIOU" da eklenmeli veya text.lower() kullanılmalı.',
    explanationEn: 'Only lowercase vowels defined. Should add "AEIOU" or use text.lower().',
    difficulty: 2,
    topic: 'string',
  ),
  BugHuntQuestion(
    id: 'bug_015',
    codeLines: [
      'public static int fibonacci(int n) {',
      '    if (n <= 1) return n;',
      '    int a = 0, b = 1;',
      '    for (int i = 2; i < n; i++) {',
      '        int temp = a + b;',
      '        a = b;',
      '        b = temp;',
      '    }',
      '    return b;',
      '}',
    ],
    bugLineIndex: 3,
    explanation: 'i < n yerine i <= n olmalı. Aksi halde fibonacci(5) yanlış sonuç verir (3 yerine 5 olmalı).',
    explanationEn: 'Should be i <= n instead of i < n. Otherwise fibonacci(5) returns wrong result.',
    difficulty: 2,
    topic: 'loop',
    language: 'java',
  ),
  BugHuntQuestion(
    id: 'bug_016',
    codeLines: [
      'def two_sum(nums, target):',
      '    seen = {}',
      '    for i, num in enumerate(nums):',
      '        complement = target - num',
      '        if complement in seen:',
      '            return [seen[complement], i]',
      '        seen[i] = num',
      '    return []',
    ],
    bugLineIndex: 6,
    explanation: 'seen[i] = num yanlış! seen[num] = i olmalı. Değer → indeks eşlemesi yapılmalı.',
    explanationEn: 'seen[i] = num is wrong! Should be seen[num] = i. Need value → index mapping.',
    difficulty: 2,
    topic: 'array',
  ),
  BugHuntQuestion(
    id: 'bug_017',
    codeLines: [
      'def remove_duplicates(lst):',
      '    result = []',
      '    for item in lst:',
      '        if item not in lst:',
      '            result.append(item)',
      '    return result',
    ],
    bugLineIndex: 3,
    explanation: '"item not in lst" yanlış, item daima lst içinde olur. "item not in result" olmalı.',
    explanationEn: '"item not in lst" is wrong, item is always in lst. Should be "item not in result".',
    difficulty: 2,
    topic: 'list',
  ),

  // ═══════════════════════════════════════════════════
  // DIFFICULTY 3 — HARD (Advanced Algorithm Bugs)
  // ═══════════════════════════════════════════════════
  BugHuntQuestion(
    id: 'bug_018',
    codeLines: [
      'def factorial(n):',
      '    if n == 0:',
      '        return 1',
      '    return n * factorial(n)',
    ],
    bugLineIndex: 3,
    explanation: 'Sonsuz özyineleme: factorial(n) yerine factorial(n-1) olmalı. Stack overflow oluşur.',
    explanationEn: 'Infinite recursion: factorial(n) should be factorial(n-1). Causes stack overflow.',
    difficulty: 3,
    topic: 'recursion',
  ),
  BugHuntQuestion(
    id: 'bug_019',
    codeLines: [
      'def merge_sort(arr):',
      '    if len(arr) <= 1:',
      '        return arr',
      '    mid = len(arr) // 2',
      '    left = merge_sort(arr[:mid])',
      '    right = merge_sort(arr[mid:])',
      '    return merge(left, right)',
      '',
      'def merge(left, right):',
      '    result = []',
      '    i = j = 0',
      '    while i < len(left) and j < len(right):',
      '        if left[i] <= right[j]:',
      '            result.append(left[i])',
      '            i += 1',
      '        else:',
      '            result.append(right[j])',
      '            j += 1',
      '    result += left[i:]',
      '    result += right[i:]',
    ],
    bugLineIndex: 19,
    explanation: 'Son satırda right[i:] yerine right[j:] olmalı. i left, j right için kullanılır.',
    explanationEn: 'Last line: right[i:] should be right[j:]. i is for left, j is for right.',
    difficulty: 3,
    topic: 'sorting',
  ),
  BugHuntQuestion(
    id: 'bug_020',
    codeLines: [
      'def quick_sort(arr):',
      '    if len(arr) <= 1:',
      '        return arr',
      '    pivot = arr[0]',
      '    left = [x for x in arr if x < pivot]',
      '    middle = [x for x in arr if x == pivot]',
      '    right = [x for x in arr if x > pivot]',
      '    return quick_sort(left) + middle + right',
    ],
    bugLineIndex: 7,
    explanation: 'right kısmı sıralanmıyor! quick_sort(right) olmalı, sadece right değil.',
    explanationEn: 'right part is not sorted! Should be quick_sort(right), not just right.',
    difficulty: 3,
    topic: 'sorting',
  ),
  BugHuntQuestion(
    id: 'bug_021',
    codeLines: [
      'class Stack:',
      '    def __init__(self):',
      '        self.items = []',
      '',
      '    def push(self, item):',
      '        self.items.append(item)',
      '',
      '    def pop(self):',
      '        return self.items.pop(0)',
      '',
      '    def peek(self):',
      '        return self.items[-1]',
    ],
    bugLineIndex: 8,
    explanation: 'Stack LIFO olmalı ama pop(0) FIFO davranışı verir (ilk elemanı çıkarır). pop() olmalı.',
    explanationEn: 'Stack should be LIFO but pop(0) gives FIFO behavior (removes first). Should be pop().',
    difficulty: 3,
    topic: 'stack_queue',
  ),
  BugHuntQuestion(
    id: 'bug_022',
    codeLines: [
      'def has_cycle(head):',
      '    slow = head',
      '    fast = head',
      '    while fast and fast.next:',
      '        slow = slow.next',
      '        fast = fast.next',
      '        if slow == fast:',
      '            return True',
      '    return False',
    ],
    bugLineIndex: 5,
    explanation: 'Floyd\'s algoritması: fast.next yerine fast.next.next olmalı. Fast pointer 2 adım atmalı.',
    explanationEn: 'Floyd\'s algorithm: fast should move 2 steps (fast.next.next), not 1 step (fast.next).',
    difficulty: 3,
    topic: 'oop',
  ),
  BugHuntQuestion(
    id: 'bug_023',
    codeLines: [
      'def is_balanced(s):',
      '    stack = []',
      '    pairs = {"(": ")", "[": "]", "{": "}"}',
      '    for char in s:',
      '        if char in pairs:',
      '            stack.append(char)',
      '        elif char in pairs.values():',
      '            if not stack or pairs[stack.pop()] != char:',
      '                return False',
      '    return True',
    ],
    bugLineIndex: 9,
    explanation: 'Fonksiyon stack boş olup olmadığını kontrol etmiyor sonunda. "return len(stack) == 0" olmalı.',
    explanationEn: 'Function doesn\'t check if stack is empty at end. Should be "return len(stack) == 0".',
    difficulty: 3,
    topic: 'stack_queue',
  ),
  BugHuntQuestion(
    id: 'bug_024',
    codeLines: [
      'def power(base, exp):',
      '    if exp == 0:',
      '        return 1',
      '    if exp % 2 == 0:',
      '        half = power(base, exp // 2)',
      '        return half + half',
      '    else:',
      '        return base * power(base, exp - 1)',
    ],
    bugLineIndex: 5,
    explanation: 'half + half toplama yapar! half * half çarpma olmalı. 2^4 = (2^2)*(2^2) = 4*4 = 16.',
    explanationEn: 'half + half adds! Should be half * half. 2^4 = (2^2)*(2^2) = 4*4 = 16.',
    difficulty: 3,
    topic: 'recursion',
  ),
  BugHuntQuestion(
    id: 'bug_025',
    codeLines: [
      'function deepClone(obj) {',
      '    if (typeof obj !== "object") return obj;',
      '    const clone = Array.isArray(obj) ? [] : {};',
      '    for (let key in obj) {',
      '        clone[key] = obj[key];',
      '    }',
      '    return clone;',
      '}',
    ],
    bugLineIndex: 4,
    explanation: 'Deep clone değil shallow copy yapılıyor. clone[key] = deepClone(obj[key]) olmalı.',
    explanationEn: 'This is shallow copy, not deep clone. Should be clone[key] = deepClone(obj[key]).',
    difficulty: 3,
    topic: 'recursion',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_026',
    codeLines: [
      'def gcd(a, b):',
      '    while b != 0:',
      '        temp = b',
      '        b = a % b',
      '        a = b',
      '    return a',
    ],
    bugLineIndex: 4,
    explanation: 'a = b yanlış sırada! a = temp olmalı. b zaten güncellendi, eski b değeri (temp) a\'ya atanmalı.',
    explanationEn: 'a = b is in wrong order! Should be a = temp. b was already updated, old b value (temp) should be assigned to a.',
    difficulty: 3,
    topic: 'recursion',
  ),
  BugHuntQuestion(
    id: 'bug_027',
    codeLines: [
      'def matrix_multiply(A, B):',
      '    rows_A, cols_A = len(A), len(A[0])',
      '    rows_B, cols_B = len(B), len(B[0])',
      '    result = [[0] * cols_B] * rows_A',
      '    for i in range(rows_A):',
      '        for j in range(cols_B):',
      '            for k in range(cols_A):',
      '                result[i][j] += A[i][k] * B[k][j]',
      '    return result',
    ],
    bugLineIndex: 3,
    explanation: '[[0] * cols_B] * rows_A tüm satırlar aynı listeyi referans eder! [[0]*cols_B for _ in range(rows_A)] olmalı.',
    explanationEn: '[[0]*cols_B]*rows_A makes all rows reference the same list! Use [[0]*cols_B for _ in range(rows_A)].',
    difficulty: 3,
    topic: 'list',
  ),
  BugHuntQuestion(
    id: 'bug_028',
    codeLines: [
      'public static boolean isPrime(int n) {',
      '    if (n < 2) return false;',
      '    for (int i = 2; i < n; i++) {',
      '        if (n % i == 0) return false;',
      '    }',
      '    return true;',
      '}',
    ],
    bugLineIndex: 2,
    explanation: 'i < n çok yavaş! i <= Math.sqrt(n) yeterlidir. n=1000000 için çok gereksiz döngü.',
    explanationEn: 'i < n is too slow! i <= Math.sqrt(n) is sufficient. Unnecessarily iterates for large n.',
    difficulty: 3,
    topic: 'loop',
    language: 'java',
  ),
  BugHuntQuestion(
    id: 'bug_029',
    codeLines: [
      'def flatten(lst):',
      '    result = []',
      '    for item in lst:',
      '        if isinstance(item, list):',
      '            result.extend(item)',
      '        else:',
      '            result.append(item)',
      '    return result',
      '',
      '# flatten([1, [2, [3, 4]], 5])',
      '# Expected: [1, 2, 3, 4, 5]',
    ],
    bugLineIndex: 4,
    explanation: 'extend(item) sadece 1 seviye açar. Recursive olması lazım: extend(flatten(item)) olmalı.',
    explanationEn: 'extend(item) only flattens one level. Should be recursive: extend(flatten(item)).',
    difficulty: 3,
    topic: 'recursion',
  ),
  BugHuntQuestion(
    id: 'bug_030',
    codeLines: [
      'function debounce(fn, delay) {',
      '    let timer;',
      '    return function(...args) {',
      '        clearTimeout(timer);',
      '        fn.apply(this, args);',
      '        timer = setTimeout(() => {',
      '            fn.apply(this, args);',
      '        }, delay);',
      '    };',
      '}',
    ],
    bugLineIndex: 4,
    explanation: 'Debounce\'da fn hemen çağrılmamalı! Satır 5 silinmeli, sadece setTimeout içinde çağrılmalı.',
    explanationEn: 'In debounce, fn should NOT be called immediately! Line 5 should be removed, only call inside setTimeout.',
    difficulty: 3,
    topic: 'function',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_031',
    codeLines: [
      'def rotate_array(arr, k):',
      '    n = len(arr)',
      '    rotated = [0] * n',
      '    for i in range(n):',
      '        rotated[i + k] = arr[i]',
      '    return rotated',
    ],
    bugLineIndex: 4,
    explanation: 'i + k indeks taşması yapabilir! (i + k) % n olmalı.',
    explanationEn: 'i + k can cause index overflow! Should be (i + k) % n.',
    difficulty: 2,
    topic: 'array',
  ),
  BugHuntQuestion(
    id: 'bug_032',
    codeLines: [
      'def selection_sort(arr):',
      '    for i in range(len(arr)):',
      '        min_idx = i',
      '        for j in range(i, len(arr)):',
      '            if arr[j] < arr[min_idx]:',
      '                min_idx = j',
      '        arr[i], arr[min_idx] = arr[min_idx], arr[i]',
      '    return arr',
    ],
    bugLineIndex: 3,
    explanation: 'j = i ile başlıyor ama i+1 ile başlamalı. Kendisiyle karşılaştırma gereksiz.',
    explanationEn: 'j starts at i but should start at i+1. Comparing with itself is unnecessary.',
    difficulty: 2,
    topic: 'sorting',
  ),
  BugHuntQuestion(
    id: 'bug_033',
    codeLines: [
      'class Node:',
      '    def __init__(self, val):',
      '        self.val = val',
      '        self.next = None',
      '',
      'def reverse_list(head):',
      '    prev = None',
      '    curr = head',
      '    while curr:',
      '        curr.next = prev',
      '        prev = curr',
      '        curr = curr.next',
      '    return prev',
    ],
    bugLineIndex: 9,
    explanation: 'curr.next prev\'e atanınca orijinal next kaybolur! Önce next_node = curr.next saklamalı.',
    explanationEn: 'Assigning curr.next = prev loses original next! Must save next_node = curr.next first.',
    difficulty: 3,
    topic: 'oop',
  ),
  BugHuntQuestion(
    id: 'bug_034',
    codeLines: [
      'def count_words(text):',
      '    words = text.split(" ")',
      '    freq = {}',
      '    for word in words:',
      '        freq[word] = freq[word] + 1',
      '    return freq',
    ],
    bugLineIndex: 4,
    explanation: 'İlk karşılaşmada KeyError verir! freq.get(word, 0) + 1 veya defaultdict kullanılmalı.',
    explanationEn: 'KeyError on first occurrence! Use freq.get(word, 0) + 1 or defaultdict.',
    difficulty: 2,
    topic: 'variable',
  ),
  BugHuntQuestion(
    id: 'bug_035',
    codeLines: [
      'def memoize(func):',
      '    cache = {}',
      '    def wrapper(*args):',
      '        if args not in cache:',
      '            cache[args] = func(args)',
      '        return cache[args]',
      '    return wrapper',
    ],
    bugLineIndex: 4,
    explanation: 'func(args) yanlış, tuple olarak geçer. func(*args) olmalı, argümanlar açılmalı.',
    explanationEn: 'func(args) is wrong, passes as tuple. Should be func(*args) to unpack arguments.',
    difficulty: 3,
    topic: 'function',
  ),
];


class BugHuntScreen extends StatefulWidget {
  const BugHuntScreen({super.key});

  @override
  State<BugHuntScreen> createState() => _BugHuntScreenState();
}

class _BugHuntScreenState extends State<BugHuntScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  
  bool _isLoading = true;
  int _currentIndex = 0;
  int? _selectedLine;
  bool? _isCorrect;
  bool _showAnswerOverlay = false;
  int _score = 0;
  int _correct = 0;
  int _wrong = 0;
  
  late List<BugHuntQuestion> _questions;

  BugHuntQuestion get currentQuestion => _questions[_currentIndex];
  bool get isFinished => _currentIndex >= _questions.length;
  double get progress => _questions.isEmpty ? 0 : _currentIndex / _questions.length;

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
    
    // Sort by difficulty then shuffle within groups for progressive difficulty
    final easy = _allBugHuntQuestions.where((q) => q.difficulty == 1).toList()..shuffle();
    final medium = _allBugHuntQuestions.where((q) => q.difficulty == 2).toList()..shuffle();
    final hard = _allBugHuntQuestions.where((q) => q.difficulty == 3).toList()..shuffle();
    
    // Take a balanced set: 4 easy, 4 medium, 4 hard = 12 questions per game
    _questions = [
      ...easy.take(4),
      ...medium.take(4),
      ...hard.take(4),
    ];
    
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _onLineSelected(int lineIndex) async {
    if (_selectedLine != null) return;

    HapticService.lightTap();
    final isCorrect = lineIndex == currentQuestion.bugLineIndex;
    
    setState(() {
      _selectedLine = lineIndex;
      _isCorrect = isCorrect;
    });

    final newElo = EloCalculator.calculateNewElo(
      currentElo: storageService.progress.elo,
      questionDifficulty: currentQuestion.difficulty,
      isCorrect: isCorrect,
    );

    if (isCorrect) {
      _confettiController.play();
      soundService.playCorrect();
      HapticService.success();
      _score += 15 * currentQuestion.difficulty;
      _correct++;
    } else {
      _shakeController.forward().then((_) => _shakeController.reset());
      soundService.playWrong();
      HapticService.error();
      _wrong++;
    }

    await storageService.recordAnswer(isCorrect: isCorrect, newElo: newElo);
    
    // Show overlay after a short delay
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _showAnswerOverlay = true);
    }
  }

  void _dismissOverlayAndShowExplanation() {
    HapticService.lightTap();
    setState(() => _showAnswerOverlay = false);
  }

  void _nextQuestion() {
    HapticService.lightTap();
    if (_currentIndex + 1 >= _questions.length) {
      _showResults();
    } else {
      setState(() {
        _currentIndex++;
        _selectedLine = null;
        _isCorrect = null;
        _showAnswerOverlay = false;
      });
    }
  }

  void _showResults() {
    final accuracy = _correct + _wrong > 0 
        ? ((_correct / (_correct + _wrong)) * 100).round() 
        : 0;
    
    HapticService.achievement();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          blur: 20,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.tr('Bug Hunt Bitti! 🐞', 'Bug Hunt Complete! 🐞'), 
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              MascotResultCard(accuracy: accuracy),
              const SizedBox(height: 12),
              _buildStatRow(S.tr('Skor', 'Score'), '$_score', Colors.amber),
              _buildStatRow(S.tr('Bulunan Bug', 'Bugs Found'), '$_correct', RheoColors.success),
              _buildStatRow(S.tr('Kaçırılan', 'Missed'), '$_wrong', RheoColors.error),
              _buildStatRow(S.basari, '%$accuracy', RheoColors.primary),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        HapticService.lightTap();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(S.tr('Ana Sayfa', 'Home'), style: TextStyle(color: RheoColors.textMuted)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        HapticService.lightTap();
                        Navigator.pop(context);
                        final easy = _allBugHuntQuestions.where((q) => q.difficulty == 1).toList()..shuffle();
                        final medium = _allBugHuntQuestions.where((q) => q.difficulty == 2).toList()..shuffle();
                        final hard = _allBugHuntQuestions.where((q) => q.difficulty == 3).toList()..shuffle();
                        setState(() {
                          _currentIndex = 0;
                          _selectedLine = null;
                          _isCorrect = null;
                          _score = 0;
                          _correct = 0;
                          _wrong = 0;
                          _questions = [...easy.take(4), ...medium.take(4), ...hard.take(4)];
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RheoColors.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(S.tr('Tekrar Oyna', 'Play Again')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: RheoColors.textSecondary)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getLineColor(int lineIndex) {
    if (_selectedLine == null) return Colors.transparent;
    
    if (lineIndex == currentQuestion.bugLineIndex) {
      return RheoColors.success.withAlpha(60);
    }
    if (lineIndex == _selectedLine && !_isCorrect!) {
      return RheoColors.error.withAlpha(60);
    }
    return Colors.transparent;
  }

  /// Difficulty badge color & label
  Widget _difficultyBadge(int difficulty) {
    final color = difficulty == 1
        ? RheoColors.success
        : difficulty == 2
            ? RheoColors.warning
            : RheoColors.error;
    final label = difficulty == 1
        ? S.tr('Kolay', 'Easy')
        : difficulty == 2
            ? S.tr('Orta', 'Medium')
            : S.tr('Zor', 'Hard');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || isFinished) {
      return Scaffold(
        backgroundColor: RheoTheme.scaffoldBg(),
        body: const Center(child: CircularProgressIndicator(color: RheoColors.secondary)),
      );
    }

    return Scaffold(
      backgroundColor: RheoTheme.scaffoldBg(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: RheoTheme.textColor),
            onPressed: () {
              HapticService.lightTap();
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Bug ${_currentIndex + 1}/${_questions.length}',
            style: TextStyle(color: RheoTheme.textColor, fontSize: 16),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: RheoColors.secondary.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bug_report, color: RheoColors.secondary, size: 18),
                  const SizedBox(width: 4),
                  Text('$_correct', style: const TextStyle(color: RheoColors.secondary)),
                ],
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [RheoColors.success, RheoColors.primary, Colors.yellow],
              ),
            ),
            
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: RheoColors.glassLight,
                        valueColor: const AlwaysStoppedAnimation<Color>(RheoColors.secondary),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: RheoColors.secondary.withAlpha(40),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('BUG HUNT', 
                            style: TextStyle(fontSize: 11, color: RheoColors.secondary, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        _difficultyBadge(currentQuestion.difficulty),
                        const SizedBox(width: 8),
                        Text(
                          currentQuestion.language.toUpperCase(),
                          style: TextStyle(fontSize: 11, color: RheoColors.textMuted, letterSpacing: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Text(
                      S.tr('🐞 Hatalı satırı bul ve tıkla!', '🐞 Find the buggy line and tap it!'),
                      style: TextStyle(fontSize: 16, color: RheoTheme.textColor, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Animated code block
                    Expanded(
                      child: AnimatedQuestionCard(
                        questionIndex: _currentIndex,
                        child: AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_isCorrect == false ? _shakeAnimation.value : 0, 0),
                              child: child,
                            );
                          },
                          child: GlassCard(
                            borderColor: _selectedLine == null 
                                ? RheoColors.glassBorder
                                : (_isCorrect! ? RheoColors.success : RheoColors.error),
                            padding: EdgeInsets.zero,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: currentQuestion.codeLines.length,
                              itemBuilder: (context, index) {
                                final line = currentQuestion.codeLines[index];
                                return StaggeredFadeIn(
                                  index: index,
                                  delay: const Duration(milliseconds: 50),
                                  child: InkWell(
                                    onTap: _selectedLine == null 
                                        ? () => _onLineSelected(index)
                                        : null,
                                    child: Container(
                                      color: _getLineColor(index),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 28,
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                color: RheoColors.textMuted,
                                                fontSize: 13,
                                                fontFamily: 'monospace',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: HighlightView(
                                              line.isEmpty ? ' ' : line,
                                              language: currentQuestion.language,
                                              theme: atomOneDarkTheme,
                                              padding: EdgeInsets.zero,
                                              textStyle: const TextStyle(
                                                fontFamily: 'monospace',
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                          if (_selectedLine != null && index == currentQuestion.bugLineIndex)
                                            const Icon(Icons.bug_report, color: RheoColors.success, size: 18),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Explanation with mascot
                    if (_selectedLine != null) ...[
                      GlassCard(
                        borderColor: _isCorrect! ? RheoColors.success : RheoColors.warning,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Mascot with emotion
                            MascotWidget(
                              mood: _isCorrect! ? MascotMood.celebrating : MascotMood.encouraging,
                              message: _isCorrect! 
                                  ? MascotHelper.getBugHuntCorrect()
                                  : MascotHelper.getBugHuntWrong(),
                              size: 55,
                              animate: _isCorrect!,
                              bubbleColor: _isCorrect! ? RheoColors.success : RheoColors.warning,
                            ),
                            const SizedBox(height: 16),
                            // Show correct line if wrong
                            if (!_isCorrect!) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: RheoColors.success.withAlpha(20),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: RheoColors.success.withAlpha(50)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.bug_report, color: RheoColors.success, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        S.tr(
                                          'Bug satır ${currentQuestion.bugLineIndex + 1} numaralı satırda',
                                          'Bug is on line ${currentQuestion.bugLineIndex + 1}',
                                        ),
                                        style: TextStyle(
                                          color: RheoColors.success,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            // Explanation text
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: RheoColors.glassLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.lightbulb_outline, color: RheoColors.secondary, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        S.tr('Bug Açıklaması', 'Bug Explanation'),
                                        style: TextStyle(
                                          color: RheoColors.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    currentQuestion.localizedExplanation,
                                    style: TextStyle(color: RheoTheme.textMuted, fontSize: 13, height: 1.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _nextQuestion,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: RheoColors.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            _currentIndex + 1 >= _questions.length 
                                ? S.tr('Sonuçları Gör', 'See Results')
                                : S.tr('Sonraki Bug →', 'Next Bug →'),
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Answer overlay (correct / incorrect)
            if (_showAnswerOverlay && _isCorrect != null)
              GestureDetector(
                onTap: _dismissOverlayAndShowExplanation,
                child: AnimatedOpacity(
                  opacity: _showAnswerOverlay ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.black.withOpacity(0.78),
                    width: double.infinity,
                    height: double.infinity,
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 2),
                          Text(
                            _isCorrect! ? S.dogruCevap : S.yanlisCevap,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: _isCorrect! ? RheoColors.success : RheoColors.error,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: (_isCorrect! ? RheoColors.success : RheoColors.error).withOpacity(0.5),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          PulseAnimation(
                            duration: const Duration(milliseconds: 2000),
                            child: Image.asset(
                              getMascotAsset(
                                _isCorrect! ? MascotMood.celebrating : MascotMood.encouraging,
                              ),
                              height: 140,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _isCorrect!
                                ? MascotHelper.getBugHuntCorrect()
                                : MascotHelper.getBugHuntWrong(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(flex: 3),
                          Text(
                            S.ilerlemekIcinTikla,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
    );
  }
}
