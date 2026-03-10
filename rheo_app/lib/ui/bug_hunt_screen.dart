import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import '../logic/sound_service.dart';
import '../logic/storage_service.dart';
import '../logic/elo_calculator.dart';
import '../logic/language_service.dart';
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

/// ÔöÇÔöÇÔöÇ BUG HUNT QUESTIONS ÔöÇÔöÇÔöÇ 30+ questions, difficulty 1-3
final List<BugHuntQuestion> _allBugHuntQuestions = [
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // DIFFICULTY 1 ÔÇö EASY (Syntax & Basic Errors)
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  BugHuntQuestion(
    id: 'bug_001',
    codeLines: [
      'def greet(name):',
      '    message = "Hello, " + name',
      '    return massage',
      '',
    ],
    bugLineIndex: 2,
    explanation: 'Typo hatas─▒: "massage" yerine "message" olmal─▒.',
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
    explanation: 'Kar┼ş─▒la┼şt─▒rma i├ğin == kullan─▒lmal─▒, = atama operat├Âr├╝d├╝r.',
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
    explanation: 'for d├Âng├╝s├╝n├╝n sonunda ":" eksik.',
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
    explanation: 'Fonksiyon return yerine print kullan─▒yor. total None olur ve None * 2 hata verir.',
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
    explanation: 'JavaScript\'te sat─▒r sonunda ; eksik. Strict mode\'da hata verebilir.',
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
    explanation: 'Java\'da String + int birle┼ştirme ├ğal─▒┼ş─▒r ama length() metod olmal─▒, name.length() ┼şeklinde.',
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
    explanation: 'D├Âng├╝ i├ğinde listeden eleman silmek indeksleri bozar ve IndexError olu┼şabilir.',
    explanationEn: 'Removing elements from a list during iteration shifts indices and may cause IndexError.',
    difficulty: 1,
    topic: 'list',
  ),

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // DIFFICULTY 2 ÔÇö MEDIUM (Logic & Algorithm Errors)  
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  BugHuntQuestion(
    id: 'bug_008',
    codeLines: [
      'numbers = [1, 2, 3, 4, 5]',
      'total = 0',
      'for i in range(6):',
      '    total += numbers[i]',
    ],
    bugLineIndex: 2,
    explanation: 'range(6) ÔåÆ i=5 olunca IndexError. range(5) veya range(len(numbers)) olmal─▒.',
    explanationEn: 'range(6) ÔåÆ when i=5, IndexError occurs. Should be range(5) or range(len(numbers)).',
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
    explanation: 'right = len(arr) yerine len(arr) - 1 olmal─▒. Son indeks len-1\'dir, aksi halde IndexError.',
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
    explanation: 'right = len(s) yerine len(s) - 1 olmal─▒. s[len(s)] IndexError verir.',
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
    explanation: 'Swap i┼şlemi yanl─▒┼ş! Ge├ğici de─şi┼şken olmadan atama yap─▒l─▒yor. arr[j], arr[j+1] = arr[j+1], arr[j] kullan─▒lmal─▒.',
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
    explanation: 'max_val = 0 ile ba┼şlamak negatif say─▒lar i├ğin yanl─▒┼ş. max_val = numbers[0] veya float("-inf") olmal─▒.',
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
    explanation: 'i = str.length ile ba┼şlay─▒nca str[str.length] undefined olur. i = str.length - 1 olmal─▒.',
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
    explanation: 'Sadece k├╝├ğ├╝k harf sesli harfler tan─▒ml─▒. "AEIOU" da eklenmeli veya text.lower() kullan─▒lmal─▒.',
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
    explanation: 'i < n yerine i <= n olmal─▒. Aksi halde fibonacci(5) yanl─▒┼ş sonu├ğ verir (3 yerine 5 olmal─▒).',
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
    explanation: 'seen[i] = num yanl─▒┼ş! seen[num] = i olmal─▒. De─şer ÔåÆ indeks e┼şlemesi yap─▒lmal─▒.',
    explanationEn: 'seen[i] = num is wrong! Should be seen[num] = i. Need value ÔåÆ index mapping.',
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
    explanation: '"item not in lst" yanl─▒┼ş, item daima lst i├ğinde olur. "item not in result" olmal─▒.',
    explanationEn: '"item not in lst" is wrong, item is always in lst. Should be "item not in result".',
    difficulty: 2,
    topic: 'list',
  ),

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // DIFFICULTY 3 ÔÇö HARD (Advanced Algorithm Bugs)
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  BugHuntQuestion(
    id: 'bug_018',
    codeLines: [
      'def factorial(n):',
      '    if n == 0:',
      '        return 1',
      '    return n * factorial(n)',
    ],
    bugLineIndex: 3,
    explanation: 'Sonsuz ├Âzyineleme: factorial(n) yerine factorial(n-1) olmal─▒. Stack overflow olu┼şur.',
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
    explanation: 'Son sat─▒rda right[i:] yerine right[j:] olmal─▒. i left, j right i├ğin kullan─▒l─▒r.',
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
    explanation: 'right k─▒sm─▒ s─▒ralanm─▒yor! quick_sort(right) olmal─▒, sadece right de─şil.',
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
    explanation: 'Stack LIFO olmal─▒ ama pop(0) FIFO davran─▒┼ş─▒ verir (ilk eleman─▒ ├ğ─▒kar─▒r). pop() olmal─▒.',
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
    explanation: 'Floyd\'s algoritmas─▒: fast.next yerine fast.next.next olmal─▒. Fast pointer 2 ad─▒m atmal─▒.',
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
    explanation: 'Fonksiyon stack bo┼ş olup olmad─▒─ş─▒n─▒ kontrol etmiyor sonunda. "return len(stack) == 0" olmal─▒.',
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
    explanation: 'half + half toplama yapar! half * half ├ğarpma olmal─▒. 2^4 = (2^2)*(2^2) = 4*4 = 16.',
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
    explanation: 'Deep clone de─şil shallow copy yap─▒l─▒yor. clone[key] = deepClone(obj[key]) olmal─▒.',
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
    explanation: 'a = b yanl─▒┼ş s─▒rada! a = temp olmal─▒. b zaten g├╝ncellendi, eski b de─şeri (temp) a\'ya atanmal─▒.',
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
    explanation: '[[0] * cols_B] * rows_A t├╝m sat─▒rlar ayn─▒ listeyi referans eder! [[0]*cols_B for _ in range(rows_A)] olmal─▒.',
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
    explanation: 'i < n ├ğok yava┼ş! i <= Math.sqrt(n) yeterlidir. n=1000000 i├ğin ├ğok gereksiz d├Âng├╝.',
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
    explanation: 'extend(item) sadece 1 seviye a├ğar. Recursive olmas─▒ laz─▒m: extend(flatten(item)) olmal─▒.',
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
    explanation: 'Debounce\'da fn hemen ├ğa─şr─▒lmamal─▒! Sat─▒r 5 silinmeli, sadece setTimeout i├ğinde ├ğa─şr─▒lmal─▒.',
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
    explanation: 'i + k indeks ta┼şmas─▒ yapabilir! (i + k) % n olmal─▒.',
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
    explanation: 'j = i ile ba┼şl─▒yor ama i+1 ile ba┼şlamal─▒. Kendisiyle kar┼ş─▒la┼şt─▒rma gereksiz.',
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
    explanation: 'curr.next prev\'e atan─▒nca orijinal next kaybolur! ├ûnce next_node = curr.next saklamal─▒.',
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
    explanation: '─░lk kar┼ş─▒la┼şmada KeyError verir! freq.get(word, 0) + 1 veya defaultdict kullan─▒lmal─▒.',
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
    explanation: 'func(args) yanl─▒┼ş, tuple olarak ge├ğer. func(*args) olmal─▒, arg├╝manlar a├ğ─▒lmal─▒.',
    explanationEn: 'func(args) is wrong, passes as tuple. Should be func(*args) to unpack arguments.',
    difficulty: 3,
    topic: 'function',
  ),

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // BATCH 2 ÔÇö EASY (15 more)
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  BugHuntQuestion(
    id: 'bug_036',
    codeLines: [
      'name = "Alice"',
      'age = 25',
      'print("Name: " + name + ", Age: " + age)',
    ],
    bugLineIndex: 2,
    explanation: 'String + int birle┼ştirilemez. str(age) kullan─▒lmal─▒.',
    explanationEn: 'Cannot concatenate string + int. Use str(age).',
    difficulty: 1,
    topic: 'string',
  ),
  BugHuntQuestion(
    id: 'bug_037',
    codeLines: [
      'let items = [1, 2, 3];',
      'items.push(4);',
      'console.log(items.lenght);',
    ],
    bugLineIndex: 2,
    explanation: '"lenght" yaz─▒m hatas─▒, "length" olmal─▒.',
    explanationEn: 'Typo: "lenght" should be "length".',
    difficulty: 1,
    topic: 'array',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_038',
    codeLines: [
      'public class Main {',
      '    public static void main(String[] args) {',
      '        String s = "hello";',
      '        if (s == "hello") {',
      '            System.out.println("Match");',
      '        }',
      '    }',
      '}',
    ],
    bugLineIndex: 3,
    explanation: 'Java\'da String kar┼ş─▒la┼şt─▒rmas─▒ i├ğin == yerine .equals() kullan─▒lmal─▒.',
    explanationEn: 'In Java, use .equals() instead of == for String comparison.',
    difficulty: 1,
    topic: 'string',
    language: 'java',
  ),
  BugHuntQuestion(
    id: 'bug_039',
    codeLines: [
      'scores = [85, 92, 78, 95]',
      'average = sum(scores) / len(scores)',
      'print("Average: " + average)',
    ],
    bugLineIndex: 2,
    explanation: 'String + float birle┼ştirilemez. str(average) veya f-string kullan─▒lmal─▒.',
    explanationEn: 'Cannot concatenate string + float. Use str(average) or f-string.',
    difficulty: 1,
    topic: 'variable',
  ),
  BugHuntQuestion(
    id: 'bug_040',
    codeLines: [
      'colors = {"red": 1, "blue": 2}',
      'print(colors["green"])',
    ],
    bugLineIndex: 1,
    explanation: '"green" anahtar─▒ s├Âzl├╝kte yok ÔåÆ KeyError. colors.get("green", 0) kullan─▒lmal─▒.',
    explanationEn: '"green" key not in dict ÔåÆ KeyError. Use colors.get("green", 0).',
    difficulty: 1,
    topic: 'variable',
  ),
  BugHuntQuestion(
    id: 'bug_041',
    codeLines: [
      'function multiply(a, b) {',
      '    return a * b;',
      '}',
      'let result = multiply(3);',
      'console.log(result);',
    ],
    bugLineIndex: 3,
    explanation: 'multiply 2 parametre bekliyor ama 1 verilmi┼ş. b undefined olur, sonu├ğ NaN.',
    explanationEn: 'multiply expects 2 args but got 1. b becomes undefined, result is NaN.',
    difficulty: 1,
    topic: 'function',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_042',
    codeLines: [
      'numbers = [10, 20, 30]',
      'numbers[3] = 40',
    ],
    bugLineIndex: 1,
    explanation: 'index 3 yok (0,1,2 var). IndexError. append(40) kullan─▒lmal─▒.',
    explanationEn: 'Index 3 doesn\'t exist (0,1,2 do). IndexError. Use append(40).',
    difficulty: 1,
    topic: 'list',
  ),
  BugHuntQuestion(
    id: 'bug_043',
    codeLines: [
      'int[] arr = {1, 2, 3};',
      'for (int i = 0; i <= arr.length; i++) {',
      '    System.out.println(arr[i]);',
      '}',
    ],
    bugLineIndex: 1,
    explanation: 'i <= arr.length, son indeks arr.length-1. i < arr.length olmal─▒.',
    explanationEn: 'i <= arr.length causes ArrayIndexOutOfBounds. Should be i < arr.length.',
    difficulty: 1,
    topic: 'loop',
    language: 'java',
  ),
  BugHuntQuestion(
    id: 'bug_044',
    codeLines: [
      'def is_even(n):',
      '    if n % 2 = 0:',
      '        return True',
      '    return False',
    ],
    bugLineIndex: 1,
    explanation: 'Kar┼ş─▒la┼şt─▒rma = de─şil == olmal─▒. = atama operat├Âr├╝d├╝r.',
    explanationEn: 'Comparison should be == not =. = is assignment operator.',
    difficulty: 1,
    topic: 'if_else',
  ),
  BugHuntQuestion(
    id: 'bug_045',
    codeLines: [
      'const PI = 3.14;',
      'PI = 3.14159;',
      'console.log(PI);',
    ],
    bugLineIndex: 1,
    explanation: 'const de─şi┼şkene yeniden atama yap─▒lamaz. TypeError.',
    explanationEn: 'Cannot reassign a const variable. TypeError.',
    difficulty: 1,
    topic: 'variable',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_046',
    codeLines: [
      'def divide(a, b):',
      '    return a / b',
      '',
      'result = divide(10, 0)',
    ],
    bugLineIndex: 3,
    explanation: 'S─▒f─▒ra b├Âlme hatas─▒! b == 0 kontrol├╝ yap─▒lmal─▒.',
    explanationEn: 'Division by zero error! Should check b == 0.',
    difficulty: 1,
    topic: 'function',
  ),
  BugHuntQuestion(
    id: 'bug_047',
    codeLines: [
      'String s = null;',
      'int len = s.length();',
      'System.out.println(len);',
    ],
    bugLineIndex: 1,
    explanation: 'null ├╝zerinde length() ├ğa─şr─▒l─▒nca NullPointerException olu┼şur.',
    explanationEn: 'Calling length() on null causes NullPointerException.',
    difficulty: 1,
    topic: 'string',
    language: 'java',
  ),
  BugHuntQuestion(
    id: 'bug_048',
    codeLines: [
      'my_list = [1, 2, 3]',
      'my_list.append([4, 5])',
      'print(len(my_list))  # 5 bekleniyor',
    ],
    bugLineIndex: 1,
    explanation: 'append listeyi tek eleman olarak ekler ÔåÆ [1,2,3,[4,5]], len=4. extend kullan─▒lmal─▒.',
    explanationEn: 'append adds list as single element ÔåÆ [1,2,3,[4,5]], len=4. Use extend instead.',
    difficulty: 1,
    topic: 'list',
  ),
  BugHuntQuestion(
    id: 'bug_049',
    codeLines: [
      'let x = "5";',
      'let y = 3;',
      'console.log(x + y);  // 8 bekleniyor',
    ],
    bugLineIndex: 2,
    explanation: '"5" + 3 string birle┼ştirme yapar ÔåÆ "53". parseInt(x) + y kullan─▒lmal─▒.',
    explanationEn: '"5" + 3 does string concatenation ÔåÆ "53". Use parseInt(x) + y.',
    difficulty: 1,
    topic: 'variable',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_050',
    codeLines: [
      'def say_hello():',
      '    print("Hello!")',
      '',
      'result = say_hello()',
      'print(result.upper())',
    ],
    bugLineIndex: 4,
    explanation: 'say_hello() return etmiyor ÔåÆ result None. None.upper() AttributeError verir.',
    explanationEn: 'say_hello() returns nothing ÔåÆ result is None. None.upper() raises AttributeError.',
    difficulty: 1,
    topic: 'function',
  ),

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // BATCH 2 ÔÇö MEDIUM (15 more)
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  BugHuntQuestion(
    id: 'bug_051',
    codeLines: [
      'def insertion_sort(arr):',
      '    for i in range(1, len(arr)):',
      '        key = arr[i]',
      '        j = i - 1',
      '        while j >= 0 and arr[j] > key:',
      '            arr[j + 1] = arr[j]',
      '            j -= 1',
      '        arr[j] = key',
      '    return arr',
    ],
    bugLineIndex: 7,
    explanation: 'arr[j] = key yanl─▒┼ş! j d├Âng├╝ sonunda -1 olabilir. arr[j+1] = key olmal─▒.',
    explanationEn: 'arr[j] = key is wrong! j can be -1 after loop. Should be arr[j+1] = key.',
    difficulty: 2,
    topic: 'sorting',
  ),
  BugHuntQuestion(
    id: 'bug_052',
    codeLines: [
      'def reverse_words(sentence):',
      '    words = sentence.split()',
      '    reversed_words = words.reverse()',
      '    return " ".join(reversed_words)',
    ],
    bugLineIndex: 2,
    explanation: 'list.reverse() in-place ├ğal─▒┼ş─▒r ve None d├Âner. words[::-1] veya reversed() kullan─▒lmal─▒.',
    explanationEn: 'list.reverse() works in-place and returns None. Use words[::-1] or reversed().',
    difficulty: 2,
    topic: 'list',
  ),
  BugHuntQuestion(
    id: 'bug_053',
    codeLines: [
      'function findIndex(arr, target) {',
      '    for (let i = 0; i < arr.length; i++) {',
      '        if (arr[i] === target) {',
      '            return true;',
      '        }',
      '    }',
      '    return false;',
      '}',
    ],
    bugLineIndex: 3,
    explanation: 'findIndex fonksiyonu indeks d├Ânmeli ama true d├Ân├╝yor. return i olmal─▒.',
    explanationEn: 'findIndex should return index but returns true. Should be return i.',
    difficulty: 2,
    topic: 'array',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_054',
    codeLines: [
      'class Animal:',
      '    def __init__(self, name):',
      '        self.name = name',
      '',
      'class Dog(Animal):',
      '    def __init__(self, name, breed):',
      '        self.breed = breed',
      '',
      'd = Dog("Rex", "Labrador")',
      'print(d.name)',
    ],
    bugLineIndex: 6,
    explanation: 'super().__init__(name) ├ğa─şr─▒lmam─▒┼ş! self.name atanmaz ÔåÆ AttributeError.',
    explanationEn: 'super().__init__(name) not called! self.name not set ÔåÆ AttributeError.',
    difficulty: 2,
    topic: 'oop',
  ),
  BugHuntQuestion(
    id: 'bug_055',
    codeLines: [
      'def flatten_dict(d, prefix=""):',
      '    result = {}',
      '    for key, val in d.items():',
      '        new_key = prefix + "." + key if prefix else key',
      '        if isinstance(val, dict):',
      '            result.update(flatten_dict(val, new_key))',
      '        else:',
      '            result[key] = val',
      '    return result',
    ],
    bugLineIndex: 7,
    explanation: 'result[key] = val yanl─▒┼ş! result[new_key] = val olmal─▒. Prefix kaybolur.',
    explanationEn: 'result[key] = val is wrong! Should be result[new_key] = val. Prefix is lost.',
    difficulty: 2,
    topic: 'recursion',
  ),
  BugHuntQuestion(
    id: 'bug_056',
    codeLines: [
      'public static int[] twoSum(int[] nums, int target) {',
      '    Map<Integer, Integer> map = new HashMap<>();',
      '    for (int i = 0; i < nums.length; i++) {',
      '        int complement = target - nums[i];',
      '        if (map.containsKey(complement)) {',
      '            return new int[]{map.get(complement), i};',
      '        }',
      '        map.put(i, nums[i]);',
      '    }',
      '    return new int[]{};',
      '}',
    ],
    bugLineIndex: 7,
    explanation: 'map.put(i, nums[i]) yanl─▒┼ş! map.put(nums[i], i) olmal─▒. De─şer ÔåÆ indeks e┼şlemesi.',
    explanationEn: 'map.put(i, nums[i]) is wrong! Should be map.put(nums[i], i). Value ÔåÆ index mapping.',
    difficulty: 2,
    topic: 'array',
    language: 'java',
  ),
  BugHuntQuestion(
    id: 'bug_057',
    codeLines: [
      'def anagram_check(s1, s2):',
      '    return sorted(s1) == sorted(s2)',
      '',
      'print(anagram_check("Listen", "Silent"))',
    ],
    bugLineIndex: 1,
    explanation: 'B├╝y├╝k/k├╝├ğ├╝k harf fark─▒! s1.lower() ve s2.lower() kullan─▒lmal─▒.',
    explanationEn: 'Case sensitivity issue! Should use s1.lower() and s2.lower().',
    difficulty: 2,
    topic: 'string',
  ),
  BugHuntQuestion(
    id: 'bug_058',
    codeLines: [
      'function compose(...fns) {',
      '    return function(x) {',
      '        return fns.reduce((acc, fn) => fn(acc), x);',
      '    };',
      '}',
    ],
    bugLineIndex: 2,
    explanation: 'compose sa─şdan sola ├ğal─▒┼şmal─▒. reduce yerine reduceRight kullan─▒lmal─▒.',
    explanationEn: 'compose should work right-to-left. Use reduceRight instead of reduce.',
    difficulty: 2,
    topic: 'function',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_059',
    codeLines: [
      'def merge_lists(a, b):',
      '    result = []',
      '    i = j = 0',
      '    while i < len(a) and j < len(b):',
      '        if a[i] <= b[j]:',
      '            result.append(a[i])',
      '            i += 1',
      '        else:',
      '            result.append(b[j])',
      '            j += 1',
      '    return result',
    ],
    bugLineIndex: 10,
    explanation: 'Kalan elemanlar eklenmemi┼ş! result += a[i:] + b[j:] sat─▒r─▒ eksik.',
    explanationEn: 'Remaining elements not added! Missing result += a[i:] + b[j:] line.',
    difficulty: 2,
    topic: 'sorting',
  ),
  BugHuntQuestion(
    id: 'bug_060',
    codeLines: [
      'def is_prime(n):',
      '    if n < 2:',
      '        return False',
      '    for i in range(2, n):',
      '        if n % i == 0:',
      '            return False',
      '        return True',
    ],
    bugLineIndex: 6,
    explanation: 'return True d├Âng├╝ i├ğinde! ─░lk iterasyonda True d├Ân├╝yor. D─▒┼şar─▒ ta┼ş─▒nmal─▒ (indentation hatas─▒).',
    explanationEn: 'return True is inside loop! Returns True on first iteration. Should be moved outside (indentation error).',
    difficulty: 2,
    topic: 'loop',
  ),
  BugHuntQuestion(
    id: 'bug_061',
    codeLines: [
      'def unique_chars(s):',
      '    seen = set()',
      '    for char in s:',
      '        if char in seen:',
      '            return False',
      '        seen.add(char)',
      '    return True',
      '',
      'print(unique_chars("Hello"))',
      '# True bekleniyor ama False d├Âner',
    ],
    bugLineIndex: 0,
    explanation: 'Fonksiyon do─şru ama "Hello" b├╝y├╝k H ve k├╝├ğ├╝k l i├ğerir; k├╝├ğ├╝k l 2 kez var ÔåÆ False. s.lower() gerekir mi kontrol et.',
    explanationEn: 'Function is correct but "Hello" has lowercase l twice ÔåÆ False. Consider using s.lower() for case-insensitive check.',
    difficulty: 2,
    topic: 'string',
  ),
  BugHuntQuestion(
    id: 'bug_062',
    codeLines: [
      'def fibonacci_memo(n, memo={}):',
      '    if n <= 1:',
      '        return n',
      '    if n in memo:',
      '        return memo[n]',
      '    memo[n] = fibonacci_memo(n-1) + fibonacci_memo(n-2)',
      '    return memo[n]',
    ],
    bugLineIndex: 5,
    explanation: 'Recursive ├ğa─şr─▒larda memo ge├ğirilmemi┼ş! fibonacci_memo(n-1, memo) olmal─▒.',
    explanationEn: 'memo not passed in recursive calls! Should be fibonacci_memo(n-1, memo).',
    difficulty: 2,
    topic: 'recursion',
  ),
  BugHuntQuestion(
    id: 'bug_063',
    codeLines: [
      'function throttle(fn, delay) {',
      '    let lastCall = 0;',
      '    return function(...args) {',
      '        const now = Date.now();',
      '        if (now - lastCall > delay) {',
      '            fn.apply(this, args);',
      '        }',
      '        lastCall = now;',
      '    };',
      '}',
    ],
    bugLineIndex: 7,
    explanation: 'lastCall her ├ğa─şr─▒da g├╝ncelleniyor! Sadece fn ├ğal─▒┼şt─▒─ş─▒nda g├╝ncellenmeli (if blo─şu i├ğine).',
    explanationEn: 'lastCall updates on every call! Should only update when fn executes (inside if block).',
    difficulty: 2,
    topic: 'function',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_064',
    codeLines: [
      'HashMap<String, Integer> map = new HashMap<>();',
      'map.put("a", 1);',
      'map.put("b", 2);',
      'for (String key : map.keySet()) {',
      '    if (map.get(key) == 1) {',
      '        map.remove(key);',
      '    }',
      '}',
    ],
    bugLineIndex: 5,
    explanation: 'Iterasyon s─▒ras─▒nda map\'den eleman silmek ConcurrentModificationException verir. Iterator kullan─▒lmal─▒.',
    explanationEn: 'Removing from map during iteration causes ConcurrentModificationException. Use Iterator.',
    difficulty: 2,
    topic: 'list',
    language: 'java',
  ),
  BugHuntQuestion(
    id: 'bug_065',
    codeLines: [
      'def chunk_list(lst, size):',
      '    chunks = []',
      '    for i in range(0, len(lst), size):',
      '        chunks.append(lst[i:i+size-1])',
      '    return chunks',
    ],
    bugLineIndex: 3,
    explanation: 'lst[i:i+size-1] bir eksik eleman al─▒r. lst[i:i+size] olmal─▒ (slice end exclusive).',
    explanationEn: 'lst[i:i+size-1] takes one less element. Should be lst[i:i+size] (slice end is exclusive).',
    difficulty: 2,
    topic: 'list',
  ),

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // BATCH 2 ÔÇö HARD (15 more)
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  BugHuntQuestion(
    id: 'bug_066',
    codeLines: [
      'def lru_cache(capacity):',
      '    cache = {}',
      '    order = []',
      '    def get(key):',
      '        if key in cache:',
      '            order.remove(key)',
      '            order.append(key)',
      '            return cache[key]',
      '        return -1',
      '    def put(key, value):',
      '        if key in cache:',
      '            order.remove(key)',
      '        elif len(cache) >= capacity:',
      '            oldest = order.pop()',
      '            del cache[oldest]',
      '        cache[key] = value',
      '        order.append(key)',
      '    return get, put',
    ],
    bugLineIndex: 13,
    explanation: 'order.pop() son eleman─▒ ├ğ─▒kar─▒r (en yeni). order.pop(0) olmal─▒ (en eski/LRU).',
    explanationEn: 'order.pop() removes last (newest). Should be order.pop(0) to remove oldest/LRU.',
    difficulty: 3,
    topic: 'array',
  ),
  BugHuntQuestion(
    id: 'bug_067',
    codeLines: [
      'def kadane(arr):',
      '    max_sum = 0',
      '    current_sum = 0',
      '    for num in arr:',
      '        current_sum = max(num, current_sum + num)',
      '        max_sum = max(max_sum, current_sum)',
      '    return max_sum',
    ],
    bugLineIndex: 1,
    explanation: 'max_sum = 0 ile ba┼şlamak t├╝m negatif dizilerde yanl─▒┼ş sonu├ğ verir. arr[0] veya -inf olmal─▒.',
    explanationEn: 'max_sum = 0 gives wrong result for all-negative arrays. Should be arr[0] or -inf.',
    difficulty: 3,
    topic: 'array',
  ),
  BugHuntQuestion(
    id: 'bug_068',
    codeLines: [
      'def bfs(graph, start):',
      '    visited = set()',
      '    queue = [start]',
      '    result = []',
      '    while queue:',
      '        node = queue.pop()',
      '        if node not in visited:',
      '            visited.add(node)',
      '            result.append(node)',
      '            queue.extend(graph[node])',
      '    return result',
    ],
    bugLineIndex: 5,
    explanation: 'queue.pop() son eleman─▒ ├ğ─▒kar─▒r (DFS). BFS i├ğin queue.pop(0) veya deque.popleft() kullan─▒lmal─▒.',
    explanationEn: 'queue.pop() removes last element (DFS). For BFS use queue.pop(0) or deque.popleft().',
    difficulty: 3,
    topic: 'recursion',
  ),
  BugHuntQuestion(
    id: 'bug_069',
    codeLines: [
      'function curry(fn) {',
      '    return function curried(...args) {',
      '        if (args.length >= fn.length) {',
      '            return fn(...args);',
      '        }',
      '        return function(...args2) {',
      '            return curried(...args2);',
      '        };',
      '    };',
      '}',
    ],
    bugLineIndex: 6,
    explanation: '├ûnceki arg├╝manlar kaybolur! curried(...args.concat(args2)) olmal─▒.',
    explanationEn: 'Previous args are lost! Should be curried(...args.concat(args2)).',
    difficulty: 3,
    topic: 'function',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_070',
    codeLines: [
      'def longest_common_subseq(s1, s2):',
      '    m, n = len(s1), len(s2)',
      '    dp = [[0] * (n + 1) for _ in range(m + 1)]',
      '    for i in range(1, m + 1):',
      '        for j in range(1, n + 1):',
      '            if s1[i] == s2[j]:',
      '                dp[i][j] = dp[i-1][j-1] + 1',
      '            else:',
      '                dp[i][j] = max(dp[i-1][j], dp[i][j-1])',
      '    return dp[m][n]',
    ],
    bugLineIndex: 5,
    explanation: 's1[i] ve s2[j] yanl─▒┼ş! 1-indexed dp ama 0-indexed string. s1[i-1] ve s2[j-1] olmal─▒.',
    explanationEn: 's1[i] and s2[j] are wrong! dp is 1-indexed but string is 0-indexed. Use s1[i-1] and s2[j-1].',
    difficulty: 3,
    topic: 'string',
  ),
  BugHuntQuestion(
    id: 'bug_071',
    codeLines: [
      'def knapsack(W, weights, values, n):',
      '    if n == 0 or W == 0:',
      '        return 0',
      '    if weights[n-1] > W:',
      '        return knapsack(W, weights, values, n-1)',
      '    return max(',
      '        values[n-1] + knapsack(W-weights[n-1], weights, values, n),',
      '        knapsack(W, weights, values, n-1)',
      '    )',
    ],
    bugLineIndex: 6,
    explanation: 'n yerine n-1 olmal─▒! Ayn─▒ eleman tekrar kullan─▒l─▒yor (unbounded knapsack).',
    explanationEn: 'Should be n-1, not n! Same item is reused (becomes unbounded knapsack).',
    difficulty: 3,
    topic: 'recursion',
  ),
  BugHuntQuestion(
    id: 'bug_072',
    codeLines: [
      'class MinHeap:',
      '    def __init__(self):',
      '        self.heap = []',
      '',
      '    def parent(self, i):',
      '        return (i - 1) // 2',
      '',
      '    def insert(self, val):',
      '        self.heap.append(val)',
      '        i = len(self.heap) - 1',
      '        while i > 0 and self.heap[i] < self.heap[self.parent(i)]:',
      '            self.heap[i], self.heap[self.parent(i)] = self.heap[self.parent(i)], self.heap[i]',
      '            i = self.parent(i)',
      '',
      '    def extract_min(self):',
      '        if not self.heap: return None',
      '        min_val = self.heap[0]',
      '        self.heap[0] = self.heap[-1]',
      '        self.heap.pop()',
      '        self._heapify(0)',
      '        return min_val',
      '',
      '    def _heapify(self, i):',
      '        smallest = i',
      '        left = 2 * i + 1',
      '        right = 2 * i + 2',
      '        if left < len(self.heap) and self.heap[left] < self.heap[smallest]:',
      '            smallest = left',
      '        if right < len(self.heap) and self.heap[right] < self.heap[smallest]:',
      '            smallest = right',
      '        if smallest != i:',
      '            self.heap[i], self.heap[smallest] = self.heap[smallest], self.heap[i]',
    ],
    bugLineIndex: 31,
    explanation: 'Heapify recursive ├ğa─şr─▒ eksik! Swap sonras─▒ self._heapify(smallest) gerekli.',
    explanationEn: 'Missing recursive heapify call! Need self._heapify(smallest) after swap.',
    difficulty: 3,
    topic: 'sorting',
  ),
  BugHuntQuestion(
    id: 'bug_073',
    codeLines: [
      'async function fetchAll(urls) {',
      '    const results = [];',
      '    for (const url of urls) {',
      '        const res = fetch(url);',
      '        const data = await res.json();',
      '        results.push(data);',
      '    }',
      '    return results;',
      '}',
    ],
    bugLineIndex: 3,
    explanation: 'fetch(url) await edilmemi┼ş! const res = await fetch(url) olmal─▒. Promise d├Âner.',
    explanationEn: 'fetch(url) is not awaited! Should be const res = await fetch(url). Returns Promise.',
    difficulty: 3,
    topic: 'function',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_074',
    codeLines: [
      'def coin_change(coins, amount):',
      '    dp = [float("inf")] * (amount + 1)',
      '    dp[0] = 0',
      '    for coin in coins:',
      '        for i in range(coin, amount + 1):',
      '            dp[i] = min(dp[i], dp[i - coin])',
      '    return dp[amount] if dp[amount] != float("inf") else -1',
    ],
    bugLineIndex: 5,
    explanation: 'dp[i - coin] + 1 olmal─▒! Her coin kullan─▒m─▒ 1 ekstra ad─▒m. + 1 eksik.',
    explanationEn: 'Should be dp[i - coin] + 1! Each coin usage is 1 extra step. Missing + 1.',
    difficulty: 3,
    topic: 'array',
  ),
  BugHuntQuestion(
    id: 'bug_075',
    codeLines: [
      'def topological_sort(graph):',
      '    visited = set()',
      '    result = []',
      '    def dfs(node):',
      '        if node in visited:',
      '            return',
      '        visited.add(node)',
      '        for neighbor in graph.get(node, []):',
      '            dfs(neighbor)',
      '        result.insert(0, node)',
      '    for node in graph:',
      '        dfs(node)',
      '    return result',
    ],
    bugLineIndex: 9,
    explanation: 'insert(0, node) do─şru gibi ama result.append(node) + sonra reverse daha verimli. Ancak as─▒l hata: cycle detection yok! DAG de─şilse sonsuz d├Âng├╝.',
    explanationEn: 'Missing cycle detection! Without it, non-DAG graphs cause infinite loops.',
    difficulty: 3,
    topic: 'recursion',
  ),
  BugHuntQuestion(
    id: 'bug_076',
    codeLines: [
      'public class Singleton {',
      '    private static Singleton instance;',
      '    private Singleton() {}',
      '',
      '    public static Singleton getInstance() {',
      '        if (instance == null) {',
      '            instance = new Singleton();',
      '        }',
      '        return instance;',
      '    }',
      '}',
    ],
    bugLineIndex: 5,
    explanation: 'Thread-safe de─şil! ├çoklu thread\'de birden fazla instance olu┼şabilir. synchronized veya double-check locking gerekli.',
    explanationEn: 'Not thread-safe! Multiple threads can create multiple instances. Need synchronized or double-check locking.',
    difficulty: 3,
    topic: 'oop',
    language: 'java',
  ),
  BugHuntQuestion(
    id: 'bug_077',
    codeLines: [
      'def dijkstra(graph, start):',
      '    dist = {node: float("inf") for node in graph}',
      '    dist[start] = 0',
      '    visited = set()',
      '    while len(visited) < len(graph):',
      '        u = min((d, n) for n, d in dist.items() if n not in visited)[1]',
      '        visited.add(u)',
      '        for v, w in graph[u]:',
      '            if dist[u] + w < dist[v]:',
      '                dist[v] = dist[u] + w',
      '    return dist',
    ],
    bugLineIndex: 5,
    explanation: 'dist.items() t├╝m d├╝─ş├╝mleri kontrol eder ÔåÆ O(V┬▓). Ancak as─▒l bug: negatif a─ş─▒rl─▒klarda yanl─▒┼ş sonu├ğ verir, Dijkstra negatif a─ş─▒rl─▒k desteklemez.',
    explanationEn: 'Dijkstra doesn\'t support negative weights. Gives wrong results for negative edge weights.',
    difficulty: 3,
    topic: 'recursion',
  ),
  BugHuntQuestion(
    id: 'bug_078',
    codeLines: [
      'function promiseAll(promises) {',
      '    return new Promise((resolve, reject) => {',
      '        const results = [];',
      '        let count = 0;',
      '        promises.forEach((p, i) => {',
      '            p.then(val => {',
      '                results[i] = val;',
      '                count++;',
      '                if (count === promises.length) resolve(results);',
      '            });',
      '        });',
      '    });',
      '}',
    ],
    bugLineIndex: 9,
    explanation: '.catch() eksik! Herhangi bir promise reject olursa yakalanmaz ÔåÆ unhandled rejection.',
    explanationEn: 'Missing .catch()! If any promise rejects, it\'s unhandled ÔåÆ unhandled rejection.',
    difficulty: 3,
    topic: 'function',
    language: 'javascript',
  ),
  BugHuntQuestion(
    id: 'bug_079',
    codeLines: [
      'def binary_search_rotated(arr, target):',
      '    left, right = 0, len(arr) - 1',
      '    while left <= right:',
      '        mid = (left + right) // 2',
      '        if arr[mid] == target:',
      '            return mid',
      '        if arr[left] <= arr[mid]:',
      '            if arr[left] <= target < arr[mid]:',
      '                right = mid - 1',
      '            else:',
      '                left = mid + 1',
      '        else:',
      '            if arr[mid] < target < arr[right]:',
      '                left = mid + 1',
      '            else:',
      '                right = mid - 1',
    ],
    bugLineIndex: 12,
    explanation: 'target < arr[right] yerine target <= arr[right] olmal─▒. target == arr[right] durumu ka├ğ─▒r─▒l─▒yor.',
    explanationEn: 'Should be target <= arr[right], not target < arr[right]. Misses target == arr[right] case.',
    difficulty: 3,
    topic: 'array',
  ),
  BugHuntQuestion(
    id: 'bug_080',
    codeLines: [
      'class TreeNode:',
      '    def __init__(self, val=0):',
      '        self.val = val',
      '        self.left = None',
      '        self.right = None',
      '',
      'def max_depth(root):',
      '    if root is None:',
      '        return 0',
      '    left = max_depth(root.left)',
      '    right = max_depth(root.right)',
      '    return left + right',
    ],
    bugLineIndex: 11,
    explanation: 'left + right derinlik de─şil d├╝─ş├╝m say─▒s─▒ hesaplar! max(left, right) + 1 olmal─▒.',
    explanationEn: 'left + right counts nodes, not depth! Should be max(left, right) + 1.',
    difficulty: 3,
    topic: 'recursion',
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
    
    _questions = _buildRankBasedQuestions();
    setState(() => _isLoading = false);
  }

  /// Build question list based on user rank (ELO) difficulty distribution.
  /// Same ratios as Output Quiz and Time Attack modes.
  List<BugHuntQuestion> _buildRankBasedQuestions() {
    final selectedLang = languageService.selected.name;
    final pool = _allBugHuntQuestions.where(
      (q) => q.language == selectedLang
    ).toList();
    
    final easy = pool.where((q) => q.difficulty == 1).toList()..shuffle();
    final medium = pool.where((q) => q.difficulty == 2).toList()..shuffle();
    final hard = pool.where((q) => q.difficulty == 3).toList()..shuffle();
    
    final elo = storageService.progress.elo;
    final totalCount = 12;
    
    // Rank-based difficulty ratios
    double easyRatio, mediumRatio, hardRatio;
    if (elo < 200) {
      easyRatio = 0.80; mediumRatio = 0.20; hardRatio = 0.0;
    } else if (elo < 400) {
      easyRatio = 0.60; mediumRatio = 0.40; hardRatio = 0.0;
    } else if (elo < 600) {
      easyRatio = 0.40; mediumRatio = 0.50; hardRatio = 0.10;
    } else if (elo < 800) {
      easyRatio = 0.40; mediumRatio = 0.40; hardRatio = 0.20;
    } else if (elo < 1000) {
      easyRatio = 0.30; mediumRatio = 0.40; hardRatio = 0.30;
    } else {
      easyRatio = 0.30; mediumRatio = 0.30; hardRatio = 0.40;
    }
    
    final easyCount = (totalCount * easyRatio).round().clamp(0, easy.length);
    final hardCount = (totalCount * hardRatio).round().clamp(0, hard.length);
    final mediumCount = (totalCount - easyCount - hardCount).clamp(0, medium.length);
    
    var result = [
      ...easy.take(easyCount),
      ...medium.take(mediumCount),
      ...hard.take(hardCount),
    ];
    
    // Fill remaining if not enough questions
    if (result.length < 6) {
      final usedIds = result.map((q) => q.id).toSet();
      final remaining = pool.where((q) => !usedIds.contains(q.id)).toList()..shuffle();
      result.addAll(remaining.take(12 - result.length));
    }
    
    return result;
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
              Text(S.tr('Bug Hunt Bitti! ­şÉŞ', 'Bug Hunt Complete! ­şÉŞ'), 
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              MascotResultCard(accuracy: accuracy),
              const SizedBox(height: 12),
              _buildStatRow(S.tr('Skor', 'Score'), '$_score', Colors.amber),
              _buildStatRow(S.tr('Bulunan Bug', 'Bugs Found'), '$_correct', RheoColors.success),
              _buildStatRow(S.tr('Ka├ğ─▒r─▒lan', 'Missed'), '$_wrong', RheoColors.error),
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
                        // Filter by selected language on replay too
                        final newQuestions = _buildRankBasedQuestions();
                        setState(() {
                          _currentIndex = 0;
                          _selectedLine = null;
                          _isCorrect = null;
                          _score = 0;
                          _correct = 0;
                          _wrong = 0;
                          _questions = newQuestions;
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
                      S.tr('­şÉŞ Hatal─▒ sat─▒r─▒ bul ve t─▒kla!', '­şÉŞ Find the buggy line and tap it!'),
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: RheoTheme.codeBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _selectedLine == null 
                                    ? RheoTheme.codeBorder
                                    : (_isCorrect! ? RheoColors.success.withAlpha(150) : RheoColors.error.withAlpha(150)),
                                width: _selectedLine == null ? 1 : 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(40),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Terminal-style header
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: RheoTheme.codeHeaderBg,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(13),
                                      topRight: Radius.circular(13),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Fake window controls
                                      Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFf38ba8))),
                                      const SizedBox(width: 6),
                                      Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFf9e2af))),
                                      const SizedBox(width: 6),
                                      Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFa6e3a1))),
                                      const Spacer(),
                                      Text(
                                        currentQuestion.language.toUpperCase(),
                                        style: TextStyle(
                                          color: RheoTheme.codeHeaderText,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Code lines
                                Expanded(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    itemCount: currentQuestion.codeLines.length,
                                    itemBuilder: (context, index) {
                                      final line = currentQuestion.codeLines[index];
                                      final isSelected = _selectedLine == index;
                                      final isBugLine = _selectedLine != null && index == currentQuestion.bugLineIndex;
                                      
                                      return StaggeredFadeIn(
                                        index: index,
                                        delay: const Duration(milliseconds: 50),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: _selectedLine == null 
                                                ? () => _onLineSelected(index)
                                                : null,
                                            splashColor: RheoTheme.optionBg,
                                            highlightColor: RheoTheme.optionBg,
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isBugLine
                                                    ? RheoColors.success.withAlpha(30)
                                                    : (isSelected && !_isCorrect!)
                                                        ? RheoColors.error.withAlpha(30)
                                                        : Colors.transparent,
                                                borderRadius: BorderRadius.circular(6),
                                                border: (isBugLine || (isSelected && !_isCorrect!))
                                                    ? Border.all(
                                                        color: isBugLine 
                                                            ? RheoColors.success.withAlpha(80) 
                                                            : RheoColors.error.withAlpha(80),
                                                        width: 1,
                                                      )
                                                    : null,
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Line number gutter
                                                  Container(
                                                    width: 40,
                                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(color: RheoTheme.codeBorder, width: 1),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      '${index + 1}',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: isBugLine 
                                                            ? RheoColors.success
                                                            : RheoTheme.codeLineNumber,
                                                        fontSize: 12,
                                                        fontFamily: 'monospace',
                                                        fontWeight: isBugLine ? FontWeight.bold : FontWeight.normal,
                                                      ),
                                                    ),
                                                  ),
                                                  // Code content
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 8, top: 1, bottom: 1),
                                                      child: HighlightView(
                                                        line.isEmpty ? ' ' : line,
                                                        language: currentQuestion.language,
                                                        theme: RheoTheme.isDark ? atomOneDarkTheme : atomOneLightTheme,
                                                        padding: const EdgeInsets.symmetric(vertical: 3),
                                                        textStyle: const TextStyle(
                                                          fontFamily: 'monospace',
                                                          fontSize: 13,
                                                          height: 1.4,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (_selectedLine != null && index == currentQuestion.bugLineIndex)
                                                    const Padding(
                                                      padding: EdgeInsets.only(right: 8, top: 4),
                                                      child: Icon(Icons.bug_report, color: RheoColors.success, size: 16),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
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
                                          'Bug sat─▒r ${currentQuestion.bugLineIndex + 1} numaral─▒ sat─▒rda',
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
                                        S.tr('Bug A├ğ─▒klamas─▒', 'Bug Explanation'),
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
                                ? S.tr('Sonu├ğlar─▒ G├Âr', 'See Results')
                                : S.tr('Sonraki Bug ÔåÆ', 'Next Bug ÔåÆ'),
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