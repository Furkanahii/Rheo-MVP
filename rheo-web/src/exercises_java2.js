/* ══════════════════════════════════════════════════
   JAVA EXERCISES — CH6-CH10 (nodes 21-42)
   ══════════════════════════════════════════════════ */
export const javaExercisesCh6to10 = {
    21: [
        { type: 'algostep', prompt: 'Selection sort: find min in [64,25,12,22,11]', array: [64, 25, 12, 22, 11], step: 1, description: 'Scanning for minimum...', question: 'Min goes where?', options: ['11→index 0', '12→index 0', '22→index 1', '25→index 0'], correct: 0 },
        { type: 'pair', prompt: 'Match sort to worst case', pairs: [{ id: 1, left: 'Bubble', right: 'O(n²)' }, { id: 2, left: 'Merge', right: 'O(n log n)' }, { id: 3, left: 'Insertion (best)', right: 'O(n)' }, { id: 4, left: 'Arrays.sort()', right: 'Dual-pivot Quicksort' }] },
        { type: 'scramble', prompt: 'Build insertion sort', pieces: [{ id: 'a', text: 'static void insertionSort(int[] arr) {' }, { id: 'b', text: '    for (int i = 1; i < arr.length; i++) {' }, { id: 'c', text: '        int key = arr[i];' }, { id: 'd', text: '        int j = i - 1;' }, { id: 'e', text: '        while (j >= 0 && arr[j] > key) {' }, { id: 'f', text: '            arr[j+1] = arr[j]; j--;' }, { id: 'g', text: '        }' }, { id: 'h', text: '        arr[j+1] = key;' }, { id: 'i', text: '    }' }, { id: 'j', text: '}' }], distractors: [{ id: 'k', text: '        arr[j] = key;' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'] },
    ],
    22: [
        { type: 'algostep', prompt: 'Binary search for 7 in [1,3,5,7,9,11,13]', array: [1, 3, 5, 7, 9, 11, 13], step: 1, description: 'lo=0 hi=6 mid=3 arr[3]=7=target!', question: 'Comparisons needed?', options: ['1', '2', '3', '7'], correct: 0 },
        { type: 'trace', prompt: 'Search for 6 in {1,3,5,7,9}?', code: [{ text: 'static int bsearch(int[] arr, int t) {' }, { text: '    int lo = 0, hi = arr.length - 1;' }, { text: '    while (lo <= hi) {' }, { text: '        int mid = lo + (hi-lo)/2;' }, { text: '        if (arr[mid] == t) return mid;' }, { text: '        else if (arr[mid] < t) lo = mid+1;' }, { text: '        else hi = mid-1;' }, { text: '    }' }, { text: '    return -1;', highlight: true }, { text: '}' }], options: ['Returns 2', 'Returns 3', 'Returns -1', 'Infinite loop'], correct: 2 },
        { type: 'errordecode', prompt: 'Java overflow in binary search?', errorText: 'int mid = (lo + hi) / 2;\n// If lo + hi > Integer.MAX_VALUE → OVERFLOW!', question: 'Safe mid calc?', options: ['lo + (hi - lo) / 2', '(lo + hi) % 2', 'hi - lo', 'lo * hi'], correct: 0 },
        { type: 'realworld', prompt: 'Binary search requires what?', scenario: '⚠️ Precondition for binary search to work.', options: [{ code: '// Array MUST be sorted', label: 'Sorted array' }, { code: '// Array must have unique elements', label: 'Unique' }, { code: '// Array must be small', label: 'Small' }, { code: '// No precondition', label: 'Anything' }], correct: 0 },
    ],
    23: [
        { type: 'trace', prompt: 'Time complexity?', code: [{ text: 'for (int i = 0; i < n; i++) {' }, { text: '    for (int j = 0; j < n; j++) {' }, { text: '        System.out.println(i + " " + j);' }, { text: '    }' }, { text: '}' }], options: ['O(n)', 'O(n²)', 'O(n log n)', 'O(2ⁿ)'], correct: 1 },
        { type: 'pair', prompt: 'Match complexity', pairs: [{ id: 1, left: 'Binary Search', right: 'O(log n)' }, { id: 2, left: 'Bubble Sort', right: 'O(n²)' }, { id: 3, left: 'Merge Sort', right: 'O(n log n)' }, { id: 4, left: 'HashMap get', right: 'O(1) avg' }] },
        { type: 'refactor', prompt: 'Faster membership check?', originalCode: '// O(n) linear search\nfor (int x : arr) {\n    if (x == target) return true;\n}', options: [{ code: 'Set<Integer> set = new HashSet<>(List.of(...));\nreturn set.contains(target); // O(1)', label: 'HashSet — O(1)' }, { code: 'Arrays.sort(arr);\nArrays.binarySearch(arr, target);', label: 'Sort + bsearch' }, { code: 'for (int x : arr) if (x==target) break;', label: 'Still O(n)' }], correct: 0 },
    ],
    24: [
        { type: 'trace', prompt: 'Two-sum brute force?', code: [{ text: 'static int[] twoSum(int[] nums, int t) {' }, { text: '    for (int i=0; i<nums.length; i++)' }, { text: '        for (int j=i+1; j<nums.length; j++)' }, { text: '            if (nums[i]+nums[j]==t)' }, { text: '                return new int[]{i, j};' }, { text: '    return null;' }, { text: '}' }, { text: '// twoSum({2,7,11,15}, 9)', highlight: true }], options: ['[0, 1]', '[1, 2]', '[0, 3]', 'null'], correct: 0 },
        { type: 'refactor', prompt: 'O(n²)→O(n) two-sum?', originalCode: '// O(n²) brute force\nfor (int i=0; i<nums.length; i++)\n    for (int j=i+1; j<nums.length; j++)', options: [{ code: 'Map<Integer,Integer> seen = new HashMap<>();\nfor (int i=0; i<nums.length; i++) {\n    int comp = target - nums[i];\n    if (seen.containsKey(comp))\n        return new int[]{seen.get(comp), i};\n    seen.put(nums[i], i);\n}', label: 'HashMap — O(n)' }, { code: 'Arrays.sort(nums);\n// two pointer', label: 'Sort + pointer' }, { code: '// Still brute force', label: 'Still O(n²)' }], correct: 0 },
    ],
    25: [
        { type: 'trace', prompt: 'Stack: push 1,2,3 then pop twice?', code: [{ text: 'Deque<Integer> stack = new ArrayDeque<>();' }, { text: 'stack.push(1); stack.push(2); stack.push(3);' }, { text: 'stack.pop(); stack.pop();' }, { text: 'System.out.println(stack);', highlight: true }], options: ['[1]', '[3]', '[1,2]', '[]'], correct: 0 },
        { type: 'pair', prompt: 'Match Java collections', pairs: [{ id: 1, left: 'ArrayDeque (stack)', right: 'LIFO' }, { id: 2, left: 'LinkedList (queue)', right: 'FIFO' }, { id: 3, left: 'ArrayDeque (deque)', right: 'Double-ended' }, { id: 4, left: 'PriorityQueue', right: 'Min first (heap)' }] },
    ],
    26: [
        { type: 'trace', prompt: 'head.next.val?', code: [{ text: 'class Node {' }, { text: '    int val; Node next;' }, { text: '    Node(int v) { val=v; next=null; }' }, { text: '}' }, { text: 'Node a=new Node(1), b=new Node(2), c=new Node(3);' }, { text: 'a.next=b; b.next=c;' }, { text: 'System.out.println(a.next.val);', highlight: true }], options: ['1', '2', '3', 'null'], correct: 1 },
        { type: 'scramble', prompt: 'Traverse linked list', pieces: [{ id: 'a', text: 'static void traverse(Node head) {' }, { id: 'b', text: '    Node curr = head;' }, { id: 'c', text: '    while (curr != null) {' }, { id: 'd', text: '        System.out.println(curr.val);' }, { id: 'e', text: '        curr = curr.next;' }, { id: 'f', text: '    }' }, { id: 'g', text: '}' }], distractors: [{ id: 'h', text: '        curr = curr.prev;' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f', 'g'] },
    ],
    27: [
        { type: 'trace', prompt: 'In-order BST traversal?', code: [{ text: '//       4' }, { text: '//      / \\' }, { text: '//     2   6' }, { text: '//    / \\' }, { text: '//   1   3' }, { text: '// In-order: L→Root→R', highlight: true }], options: ['4 2 1 3 6', '1 2 3 4 6', '1 3 2 6 4', '4 2 6 1 3'], correct: 1 },
        { type: 'pair', prompt: 'Match traversals', pairs: [{ id: 1, left: 'In-order', right: 'L→Root→R (sorted!)' }, { id: 2, left: 'Pre-order', right: 'Root→L→R' }, { id: 3, left: 'Post-order', right: 'L→R→Root' }, { id: 4, left: 'Level-order', right: 'BFS layer by layer' }] },
    ],
    28: [
        { type: 'video', title: 'Data Structures Visualized', description: 'Stacks, queues, linked lists, trees — when to use each, trade-offs, and real-world applications in Java.', duration: '4:00', thumbnail: '🎥' },
        { type: 'pair', prompt: 'Match structure to operation', pairs: [{ id: 1, left: 'ArrayList.get(i)', right: 'O(1)' }, { id: 2, left: 'LinkedList.addFirst()', right: 'O(1)' }, { id: 3, left: 'TreeMap search', right: 'O(log n)' }, { id: 4, left: 'ArrayList.add(0, e)', right: 'O(n)' }] },
    ],
    29: [
        { type: 'trace', prompt: 'Tower of Hanoi: 3 disks = ? moves', code: [{ text: 'static int hanoi(int n) {' }, { text: '    if (n == 1) return 1;' }, { text: '    return 2 * hanoi(n-1) + 1;' }, { text: '}' }, { text: 'System.out.println(hanoi(3));', highlight: true }], options: ['3', '5', '7', '8'], correct: 2 },
        { type: 'trace', prompt: 'sumDigits(1234)?', code: [{ text: 'static int sumDigits(int n) {' }, { text: '    if (n < 10) return n;' }, { text: '    return n%10 + sumDigits(n/10);' }, { text: '}' }, { text: 'System.out.println(sumDigits(1234));', highlight: true }], options: ['10', '1234', '4', '24'], correct: 0 },
    ],
    30: [
        { type: 'algostep', prompt: 'Merge [1,3,5] and [2,4,6]', array: [1, 3, 5, 2, 4, 6], step: 1, description: 'Compare: 1<2, take 1.', question: 'Next comparison?', options: ['3 vs 2', '1 vs 2', '5 vs 6', '3 vs 4'], correct: 0 },
        { type: 'trace', prompt: 'Merge sort time complexity?', code: [{ text: '// Divide in half: log₂(n) levels' }, { text: '// Merge: O(n) per level' }, { text: '// Total: O(n × log n)', highlight: true }], options: ['O(n)', 'O(n²)', 'O(n log n)', 'O(log n)'], correct: 2 },
        { type: 'pair', prompt: 'Divide & Conquer examples', pairs: [{ id: 1, left: 'Merge Sort', right: 'Split, sort halves' }, { id: 2, left: 'Quick Sort', right: 'Partition pivot' }, { id: 3, left: 'Binary Search', right: 'Halve space' }, { id: 4, left: 'Strassen', right: 'Matrix multiply' }] },
    ],
    31: [
        { type: 'refactor', prompt: 'O(2ⁿ) fib → O(n)?', originalCode: 'static int fib(int n) {\n    if (n<=1) return n;\n    return fib(n-1)+fib(n-2);\n}', options: [{ code: 'static Map<Integer,Integer> memo = new HashMap<>();\nstatic int fib(int n) {\n    if (memo.containsKey(n)) return memo.get(n);\n    if (n<=1) return n;\n    memo.put(n, fib(n-1)+fib(n-2));\n    return memo.get(n);\n}', label: 'Memoization — O(n)' }, { code: 'static int fib(int n) {\n    return n<=1 ? n : fib(n-1)+fib(n-2);\n}', label: 'Still O(2ⁿ)' }, { code: 'Math.factorial(n)', label: 'Wrong' }], correct: 0 },
        { type: 'fillgap', prompt: 'Complete: climbing stairs DP', codeParts: [{ text: 'static int climb(int n) {\n    if (n <= 2) return n;\n    int[] dp = new int[n+1];\n    dp[1] = 1; dp[2] = 2;\n    for (int i = 3; i <= n; i++) {\n        ', type: 'fixed' }, { text: 'dp[i] = dp[i-1] + dp[i-2];', type: 'gap', id: 'g1' }, { text: '\n    }\n    return dp[n];\n}', type: 'fixed' }], bank: ['dp[i] = dp[i-1] + dp[i-2];', 'dp[i] = dp[i-1] * 2;', 'dp[i] = i;', 'dp[i] = dp[i-1];'], correctFill: { g1: 'dp[i] = dp[i-1] + dp[i-2];' } },
    ],
    32: [
        { type: 'trace', prompt: 'Fast power: power(2,10)?', code: [{ text: 'static long power(int b, int e) {' }, { text: '    if (e==0) return 1;' }, { text: '    if (e%2==0) { long h=power(b,e/2); return h*h; }' }, { text: '    return b*power(b,e-1);' }, { text: '}' }, { text: 'System.out.println(power(2, 10));', highlight: true }], options: ['20', '100', '512', '1024'], correct: 3 },
        { type: 'realworld', prompt: 'When does DP help?', scenario: '🧠 DP works when problem has...', options: [{ code: '// 1. Overlapping subproblems\n// 2. Optimal substructure', label: 'Both conditions ✓' }, { code: '// Only overlapping', label: 'One' }, { code: '// Any recursion', label: 'Not always' }, { code: '// Only sorting', label: 'No' }], correct: 0 },
    ],
    33: [
        { type: 'pair', prompt: 'Match graph terms', pairs: [{ id: 1, left: 'Adjacency List', right: 'Map<V, List<V>>' }, { id: 2, left: 'Adjacency Matrix', right: 'int[][]' }, { id: 3, left: 'Directed', right: 'One-way edges' }, { id: 4, left: 'Undirected', right: 'Two-way edges' }] },
        { type: 'output', prompt: 'Adjacency list size?', code: [{ text: 'Map<String,List<String>> graph = new HashMap<>();' }, { text: 'graph.put("A", List.of("B", "C"));' }, { text: 'graph.put("B", List.of("C"));' }, { text: 'graph.put("C", List.of());' }, { text: 'System.out.println(graph.get("A").size());' }], terminalOutput: '2', options: ['1', '2', '3', '0'], correct: 1 },
    ],
    34: [
        { type: 'trace', prompt: 'BFS from A. Visit order?', code: [{ text: '// A→[B,C], B→[D], C→[D], D→[]' }, { text: 'Queue<String> q = new LinkedList<>();' }, { text: 'q.add(start); Set<String> seen = new HashSet<>();' }, { text: 'seen.add(start);' }, { text: 'while (!q.isEmpty()) {' }, { text: '    String node = q.poll();' }, { text: '    for (String n : graph.get(node))' }, { text: '        if (seen.add(n)) q.add(n);', highlight: true }, { text: '}' }], options: ['A B C D', 'A B D C', 'A C B D', 'D B C A'], correct: 0 },
        { type: 'pair', prompt: 'BFS vs DFS', pairs: [{ id: 1, left: 'BFS', right: 'Queue (FIFO)' }, { id: 2, left: 'DFS', right: 'Stack (LIFO)' }, { id: 3, left: 'BFS use', right: 'Shortest path' }, { id: 4, left: 'DFS use', right: 'Cycle detection' }] },
    ],
    35: [
        { type: 'trace', prompt: 'Two-pointer: pair summing to 6 in [1,2,3,4,6]?', code: [{ text: 'int lo = 0, hi = 4; // 1+6=7>6' }, { text: 'hi--;              // 1+4=5<6' }, { text: 'lo++;              // 2+4=6 ✓', highlight: true }], options: ['indices [1,5]', 'indices [0,4]', 'indices [1,3]', 'indices [2,3]'], correct: 2 },
        { type: 'fillgap', prompt: 'Sliding window: max sum of k consecutive', codeParts: [{ text: 'static int maxSum(int[] arr, int k) {\n    int window = 0;\n    for (int i=0; i<k; i++) window += arr[i];\n    int best = window;\n    for (int i = k; i < arr.length; i++) {\n        ', type: 'fixed' }, { text: 'window += arr[i] - arr[i-k];', type: 'gap', id: 'g1' }, { text: '\n        best = Math.max(best, window);\n    }\n    return best;\n}', type: 'fixed' }], bank: ['window += arr[i] - arr[i-k];', 'window = Arrays.stream(arr,i-k,i).sum();', 'window += arr[i];', 'window = arr[i];'], correctFill: { g1: 'window += arr[i] - arr[i-k];' } },
    ],
    36: [
        { type: 'scramble', prompt: 'Build BFS in Java', pieces: [{ id: 'a', text: 'static void bfs(Map<String,List<String>> graph, String start) {' }, { id: 'b', text: '    Queue<String> q = new LinkedList<>();' }, { id: 'c', text: '    Set<String> visited = new HashSet<>();' }, { id: 'd', text: '    q.add(start); visited.add(start);' }, { id: 'e', text: '    while (!q.isEmpty()) {' }, { id: 'f', text: '        String node = q.poll();' }, { id: 'g', text: '        for (String nb : graph.get(node)) {' }, { id: 'h', text: '            if (visited.add(nb)) q.add(nb);' }, { id: 'i', text: '        }' }, { id: 'j', text: '    }' }, { id: 'k', text: '}' }], distractors: [{ id: 'l', text: '        q.add(node);' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k'] },
    ],
    37: [
        { type: 'trace', prompt: 'Climbing stairs n=4?', code: [{ text: '// dp[0]=1, dp[1]=1' }, { text: '// dp[2] = 2, dp[3] = 3' }, { text: '// dp[4] = dp[3]+dp[2] = ?', highlight: true }], options: ['4', '5', '6', '8'], correct: 1 },
        { type: 'pair', prompt: 'Match DP patterns', pairs: [{ id: 1, left: 'Fibonacci', right: 'dp[i]=dp[i-1]+dp[i-2]' }, { id: 2, left: 'Knapsack', right: 'Include or exclude' }, { id: 3, left: 'LCS', right: 'Match or skip' }, { id: 4, left: 'Coin Change', right: 'min(dp[amt-coin]+1)' }] },
    ],
    38: [
        { type: 'pair', prompt: 'Match pattern to problem', pairs: [{ id: 1, left: 'Sliding window', right: 'Max subarray k' }, { id: 2, left: 'Two pointer', right: 'Pair sum sorted' }, { id: 3, left: 'BFS', right: 'Shortest unweighted' }, { id: 4, left: 'DP', right: 'Min coins' }] },
    ],
    39: [
        { type: 'trace', prompt: 'Valid palindrome?', code: [{ text: 'static boolean isPalin(String s) {' }, { text: '    s = s.toLowerCase().replaceAll("[^a-z0-9]","");' }, { text: '    return s.equals(new StringBuilder(s).reverse().toString());' }, { text: '}' }, { text: 'System.out.println(isPalin("A man, a plan, a canal: Panama"));', highlight: true }], options: ['true', 'false', 'Error', 'null'], correct: 0 },
        { type: 'scramble', prompt: 'Build valid anagram checker', pieces: [{ id: 'a', text: 'static boolean isAnagram(String s, String t) {' }, { id: 'b', text: '    if (s.length() != t.length()) return false;' }, { id: 'c', text: '    char[] a = s.toCharArray(), b = t.toCharArray();' }, { id: 'd', text: '    Arrays.sort(a); Arrays.sort(b);' }, { id: 'e', text: '    return Arrays.equals(a, b);' }, { id: 'f', text: '}' }], distractors: [{ id: 'g', text: '    return s.equals(t);' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f'] },
    ],
    40: [
        { type: 'trace', prompt: 'Matrix search?', code: [{ text: 'static boolean search(int[][] m, int t) {' }, { text: '    int r=0, c=m[0].length-1;' }, { text: '    while (r<m.length && c>=0) {' }, { text: '        if (m[r][c]==t) return true;' }, { text: '        else if (m[r][c]>t) c--;' }, { text: '        else r++;' }, { text: '    }' }, { text: '    return false;' }, { text: '}', highlight: true }], options: ['true', 'false', 'Error', '[1,1]'], correct: 0 },
        { type: 'refactor', prompt: 'Max subarray?', originalCode: '// Brute: O(n²)', options: [{ code: "// Kadane's: O(n)\nint curr = arr[0], best = arr[0];\nfor (int i=1;i<arr.length;i++) {\n    curr = Math.max(arr[i], curr+arr[i]);\n    best = Math.max(best, curr);\n}", label: "Kadane's — O(n)" }, { code: '// Sort', label: 'Wrong' }, { code: '// O(2ⁿ)', label: 'Slow' }], correct: 0 },
    ],
    41: [
        { type: 'pair', prompt: 'Advanced concepts', pairs: [{ id: 1, left: 'Amortized O(1)', right: 'ArrayList.add() avg' }, { id: 2, left: 'NP-Complete', right: 'No known fast solution' }, { id: 3, left: 'Space-Time', right: 'Memory saves time' }, { id: 4, left: 'Greedy', right: 'Local optimal' }] },
    ],
    42: [
        { type: 'realworld', prompt: 'Journey complete! Next step?', scenario: '🎓 You mastered: variables→loops→methods→DS→algorithms→DP→graphs!', options: [{ code: '// Build real projects!\n// Apply to apps, APIs, open source', label: 'Build projects! 🚀' }, { code: '// Review', label: 'Review' }, { code: '// Read more', label: 'Books' }, { code: '// Stop', label: 'Never!' }], correct: 0 },
        { type: 'pair', prompt: 'Your journey recap', pairs: [{ id: 1, left: 'CH1-2', right: 'Variables & Flow' }, { id: 2, left: 'CH3-4', right: 'Loops & Methods' }, { id: 3, left: 'CH5-7', right: 'Data Structures' }, { id: 4, left: 'CH8-10', right: 'Algorithms & DP' }] },
        { type: 'trace', prompt: 'Final puzzle: what returns?', code: [{ text: 'static int mystery(int n) {' }, { text: '    if (n == 0) return 1;' }, { text: '    return n * mystery(n - 1);' }, { text: '}' }, { text: 'System.out.println(mystery(5));', highlight: true }], options: ['5', '15', '120', '720'], correct: 2 },
    ],
}
