/* ══════════════════════════════════════════
   Rheo Journey Data — v10 Production Ready
   ══════════════════════════════════════════ */

/* ── localStorage Persistence ── */
const STORAGE_KEY = 'rheo_progress'
const STATS_KEY = 'rheo_stats'
const ONBOARDING_KEY = 'rheo_onboarding_done'

function loadSaved(key, fallback) {
    try {
        const raw = localStorage.getItem(key)
        return raw ? JSON.parse(raw) : fallback
    } catch { return fallback }
}

function saveTo(key, data) {
    try { localStorage.setItem(key, JSON.stringify(data)) } catch { }
}

export const mascotMessages = [
    "Let's code! 🚀", "You got this! 💪", "Keep going! 🔥",
    "Almost there! ⭐", "Debug time! 🐛",
]

/* ── Languages ── */
export const languages = [
    { id: 'python', name: 'Python', icon: '🐍' },
    { id: 'javascript', name: 'JavaScript', icon: '⚡' },
    { id: 'java', name: 'Java', icon: '☕' },
]

let _activeLang = 'python'
export function getActiveLanguage() { return _activeLang }
export function setActiveLanguage(id) { _activeLang = id }

/* ── Otter Tip of the Day ── */
const tips = {
    python: [
        { tip: "Use enumerate() to get index + value in a loop!", code: "for i, v in enumerate(arr):" },
        { tip: "f-strings are the fastest way to format!", code: 'f"Hello {name}"' },
        { tip: "List comprehensions are 2x faster than loops!", code: "[x*2 for x in range(10)]" },
        { tip: "Use 'in' to check membership efficiently!", code: "if key in my_dict:" },
        { tip: "Ternary expressions save lines!", code: "x = 'yes' if a > 0 else 'no'" },
    ],
    javascript: [
        { tip: "Use destructuring for cleaner code!", code: "const { name, age } = user" },
        { tip: "Template literals are powerful!", code: "`Hello ${name}`" },
        { tip: "Arrow functions are shorter!", code: "const add = (a, b) => a + b" },
        { tip: "Use optional chaining!", code: "user?.address?.city" },
        { tip: "Nullish coalescing for defaults!", code: "const val = x ?? 'default'" },
    ],
    java: [
        { tip: "Use StringBuilder for string concat!", code: "sb.append(str)" },
        { tip: "Enhanced for-loop is cleaner!", code: "for (int x : arr) {}" },
        { tip: "var keyword for type inference!", code: "var list = new ArrayList<>()" },
        { tip: "Stream API for functional style!", code: "list.stream().filter(x -> x > 0)" },
        { tip: "Use Optional to avoid null!", code: "Optional.ofNullable(val)" },
    ],
}
const dayOfYear = Math.floor((Date.now() - new Date(new Date().getFullYear(), 0, 0)) / 86400000)
export function getTipOfTheDay() {
    const t = tips[_activeLang] || tips.python
    return t[dayOfYear % t.length]
}
// tipOfTheDay removed — use getTipOfTheDay() instead for correct language support

/* ── Code snippets (per-language) ── */
const codeSnippets = {
    python: {
        terminal: { lang: 'python', code: 'x = 10\nprint(f"Value: {x}")\n# Output: Value: 10' },
        brackets: { lang: 'python', code: 'if score >= 90:\n  grade = "A"\nelse:\n  grade = "B"' },
        play: { lang: 'python', code: 'for i in range(5):\n  print(i * 2)\n# 0, 2, 4, 6, 8' },
        search: { lang: 'python', code: 'def find_bug(arr):\n  for x in arr:\n    if x < 0:\n      return x' },
        pattern: { lang: 'python', code: 'matrix = [[1,2],[3,4]]\nfor row in matrix:\n  print(sum(row))' },
        boss: { lang: 'python', code: 'def fib(n):\n  if n <= 1: return n\n  return fib(n-1)+fib(n-2)' },
        scope: { lang: 'python', code: 'x = "global"\ndef f():\n  x = "local"\n  print(x)  # local' },
    },
    javascript: {
        terminal: { lang: 'javascript', code: 'const x = 10\nconsole.log(`Value: ${x}`)\n// Output: Value: 10' },
        brackets: { lang: 'javascript', code: 'if (score >= 90) {\n  grade = "A"\n} else {\n  grade = "B"\n}' },
        play: { lang: 'javascript', code: 'for (let i = 0; i < 5; i++) {\n  console.log(i * 2)\n}\n// 0, 2, 4, 6, 8' },
        search: { lang: 'javascript', code: 'function findBug(arr) {\n  for (const x of arr) {\n    if (x < 0) return x\n  }\n}' },
        pattern: { lang: 'javascript', code: 'const matrix = [[1,2],[3,4]]\nmatrix.forEach(row =>\n  console.log(row.reduce((a,b)=>a+b)))' },
        boss: { lang: 'javascript', code: 'function fib(n) {\n  if (n <= 1) return n\n  return fib(n-1)+fib(n-2)\n}' },
        scope: { lang: 'javascript', code: 'let x = "global"\nfunction f() {\n  let x = "local"\n  console.log(x) // local\n}' },
    },
    java: {
        terminal: { lang: 'java', code: 'int x = 10;\nSystem.out.println("Value: " + x);\n// Output: Value: 10' },
        brackets: { lang: 'java', code: 'if (score >= 90) {\n  grade = "A";\n} else {\n  grade = "B";\n}' },
        play: { lang: 'java', code: 'for (int i = 0; i < 5; i++) {\n  System.out.println(i * 2);\n}\n// 0, 2, 4, 6, 8' },
        search: { lang: 'java', code: 'static int findBug(int[] arr) {\n  for (int x : arr) {\n    if (x < 0) return x;\n  }\n  return 0;\n}' },
        pattern: { lang: 'java', code: 'int[][] matrix = {{1,2},{3,4}};\nfor (int[] row : matrix) {\n  System.out.println(\n    Arrays.stream(row).sum());\n}' },
        boss: { lang: 'java', code: 'static int fib(int n) {\n  if (n <= 1) return n;\n  return fib(n-1)+fib(n-2);\n}' },
        scope: { lang: 'java', code: 'String x = "global";\nvoid f() {\n  String x = "local";\n  System.out.println(x); // local\n}' },
    },
}

/* ── Nodes ── */
export const journeyNodes = [
    // CH 1 — Basics ⭐
    { id: 1, type: 'lesson', status: 'completed', title: 'Read & Trace', stars: 3, iconKey: 'terminal', skill: 'variables', chapter: 1 },
    { id: 2, type: 'lesson', status: 'completed', title: 'Debug It!', stars: 2, iconKey: 'brackets', skill: 'conditionals', chapter: 1 },
    { id: 3, type: 'video', status: 'completed', title: 'Watch: Variables', stars: 0, iconKey: 'video', skill: 'variables', chapter: 1, video: { creator: 'Furkan & Arda', duration: '2:45', thumbnail: '🎬' } },
    { id: 4, type: 'chest', status: 'completed', title: 'Loot Crate', stars: 0, iconKey: 'chest', skill: null, chapter: 1 },
    // CH 2 — Flow Control ⭐
    { id: 5, type: 'lesson', status: 'active', title: 'Conditional Logic', stars: 0, iconKey: 'brackets', skill: 'conditionals', chapter: 2 },
    { id: 6, type: 'lesson', status: 'locked', title: 'Boolean Mastery', stars: 0, iconKey: 'pattern', skill: 'conditionals', chapter: 2 },
    { id: 7, type: 'daily', status: 'available', title: "Today's Challenge", stars: 0, iconKey: 'daily', skill: 'mixed', chapter: 2 },
    { id: 8, type: 'video', status: 'locked', title: 'Watch: Conditionals', stars: 0, iconKey: 'video', skill: 'conditionals', chapter: 2, video: { creator: 'Furkan & Arda', duration: '3:00', thumbnail: '🎥' } },
    // CH 3 — Loops ⭐⭐
    { id: 9, type: 'lesson', status: 'locked', title: 'Loop Basics', stars: 0, iconKey: 'play', skill: 'loops', chapter: 3 },
    { id: 10, type: 'lesson', status: 'locked', title: 'Nested Loops', stars: 0, iconKey: 'pattern', skill: 'loops', chapter: 3 },
    { id: 11, type: 'playground', status: 'locked', title: 'Try: Loops', stars: 0, iconKey: 'playground', skill: 'loops', chapter: 3, playground: { starterCode: 'for i in range(5):\n  print(i)', expectedOutput: '0\n1\n2\n3\n4' } },
    { id: 12, type: 'chest', status: 'locked', title: 'Loot Crate', stars: 0, iconKey: 'chest', skill: null, chapter: 3 },
    // CH 4 — Functions ⭐⭐
    { id: 13, type: 'lesson', status: 'locked', title: 'Function Design', stars: 0, iconKey: 'scope', skill: 'functions', chapter: 4 },
    { id: 14, type: 'lesson', status: 'locked', title: 'Scope & Closures', stars: 0, iconKey: 'scope', skill: 'functions', chapter: 4 },
    { id: 15, type: 'video', status: 'locked', title: 'Watch: Functions', stars: 0, iconKey: 'video', skill: 'functions', chapter: 4, video: { creator: 'Furkan & Arda', duration: '3:30', thumbnail: '🎥' } },
    { id: 16, type: 'boss', status: 'locked', title: 'Boss: Recursion', stars: 0, iconKey: 'boss', skill: 'functions', chapter: 4 },
    // CH 5 — Data Structures I ⭐⭐
    { id: 17, type: 'lesson', status: 'locked', title: 'Arrays Deep', stars: 0, iconKey: 'pattern', skill: 'data_structures', chapter: 5 },
    { id: 18, type: 'lesson', status: 'locked', title: 'Strings & Maps', stars: 0, iconKey: 'search', skill: 'data_structures', chapter: 5 },
    { id: 19, type: 'playground', status: 'locked', title: 'Try: Collections', stars: 0, iconKey: 'playground', skill: 'data_structures', chapter: 5, playground: { starterCode: 'counts = {}\nfor c in "hello":\n  counts[c] = counts.get(c, 0) + 1\nprint(counts)', expectedOutput: "{'h': 1, 'e': 1, 'l': 2, 'o': 1}" } },
    { id: 20, type: 'chest', status: 'locked', title: 'Loot Crate', stars: 0, iconKey: 'chest', skill: null, chapter: 5 },
    // CH 6 — Algorithms I ⭐⭐⭐
    { id: 21, type: 'lesson', status: 'locked', title: 'Sorting Showdown', stars: 0, iconKey: 'pattern', skill: 'algorithms', chapter: 6 },
    { id: 22, type: 'lesson', status: 'locked', title: 'Binary Search', stars: 0, iconKey: 'search', skill: 'algorithms', chapter: 6 },
    { id: 23, type: 'lesson', status: 'locked', title: 'Time Complexity', stars: 0, iconKey: 'scope', skill: 'complexity', chapter: 6 },
    { id: 24, type: 'boss', status: 'locked', title: 'Boss: Algorithms', stars: 0, iconKey: 'boss', skill: 'algorithms', chapter: 6 },
    // CH 7 — Data Structures II ⭐⭐⭐
    { id: 25, type: 'lesson', status: 'locked', title: 'Stack & Queue', stars: 0, iconKey: 'pattern', skill: 'data_structures', chapter: 7 },
    { id: 26, type: 'lesson', status: 'locked', title: 'Linked Lists', stars: 0, iconKey: 'play', skill: 'data_structures', chapter: 7 },
    { id: 27, type: 'lesson', status: 'locked', title: 'Trees Intro', stars: 0, iconKey: 'scope', skill: 'data_structures', chapter: 7 },
    { id: 28, type: 'video', status: 'locked', title: 'Watch: Structures', stars: 0, iconKey: 'video', skill: 'data_structures', chapter: 7, video: { creator: 'Furkan & Arda', duration: '4:00', thumbnail: '🎥' } },
    // CH 8 — Algorithms II ⭐⭐⭐⭐
    { id: 29, type: 'lesson', status: 'locked', title: 'Recursive Thinking', stars: 0, iconKey: 'scope', skill: 'algorithms', chapter: 8 },
    { id: 30, type: 'lesson', status: 'locked', title: 'Divide & Conquer', stars: 0, iconKey: 'pattern', skill: 'algorithms', chapter: 8 },
    { id: 31, type: 'lesson', status: 'locked', title: 'Memoization & DP', stars: 0, iconKey: 'search', skill: 'dp', chapter: 8 },
    { id: 32, type: 'boss', status: 'locked', title: 'Boss: Recursion++', stars: 0, iconKey: 'boss', skill: 'algorithms', chapter: 8 },
    // CH 9 — Advanced ⭐⭐⭐⭐
    { id: 33, type: 'lesson', status: 'locked', title: 'Graph Basics', stars: 0, iconKey: 'pattern', skill: 'graphs', chapter: 9 },
    { id: 34, type: 'lesson', status: 'locked', title: 'BFS & DFS', stars: 0, iconKey: 'search', skill: 'graphs', chapter: 9 },
    { id: 35, type: 'lesson', status: 'locked', title: 'Two Pointer', stars: 0, iconKey: 'play', skill: 'algorithms', chapter: 9 },
    { id: 36, type: 'playground', status: 'locked', title: 'Try: Graphs', stars: 0, iconKey: 'playground', skill: 'graphs', chapter: 9, playground: { starterCode: 'graph = {"A": ["B","C"], "B": ["D"], "C": [], "D": []}\nvisited = set()\ndef dfs(node):\n  if node in visited: return\n  visited.add(node)\n  print(node)\n  for n in graph[node]: dfs(n)\ndfs("A")', expectedOutput: 'A\nB\nD\nC' } },
    // CH 10 — Mastery ⭐⭐⭐⭐
    { id: 37, type: 'lesson', status: 'locked', title: 'DP Patterns', stars: 0, iconKey: 'scope', skill: 'dp', chapter: 10 },
    { id: 38, type: 'lesson', status: 'locked', title: 'Problem Strategy', stars: 0, iconKey: 'search', skill: 'algorithms', chapter: 10 },
    { id: 39, type: 'lesson', status: 'locked', title: 'Interview Sim', stars: 0, iconKey: 'terminal', skill: 'algorithms', chapter: 10 },
    { id: 40, type: 'boss', status: 'locked', title: 'Final Boss', stars: 0, iconKey: 'boss', skill: 'algorithms', chapter: 10 },
    { id: 41, type: 'chest', status: 'locked', title: 'Gold Chest', stars: 0, iconKey: 'chest', skill: null, chapter: 10 },
    { id: 42, type: 'daily', status: 'locked', title: 'Graduation 🎓', stars: 0, iconKey: 'daily', skill: 'mixed', chapter: 10 },
]

export function getCodeSnippet(k) { return codeSnippets[_activeLang]?.[k] || codeSnippets.python?.[k] || null }

/* ── Chapter colors ── */
export const chapterColors = {
    1: { accent: '#58CC02', name: 'Basics' },
    2: { accent: '#CE82FF', name: 'Flow Control' },
    3: { accent: '#1CB0F6', name: 'Loops' },
    4: { accent: '#FF9600', name: 'Functions' },
    5: { accent: '#FF4B4B', name: 'Data Struct I' },
    6: { accent: '#2DD4BF', name: 'Algorithms I' },
    7: { accent: '#F472B6', name: 'Data Struct II' },
    8: { accent: '#818CF8', name: 'Algorithms II' },
    9: { accent: '#FB923C', name: 'Advanced' },
    10: { accent: '#FCD34D', name: 'Mastery' },
}

/* ── Mood system ── */
export function getOtterMood(streak, nextNodeType) {
    const hour = new Date().getHours()
    if (nextNodeType === 'boss') return { face: 'determined', bubble: 'Boss time! ⚔️' }
    if (nextNodeType === 'chest') return { face: 'excited', bubble: 'Loot time! 🎁' }
    if (streak >= 7) return { face: 'cool', bubble: 'On fire! 🔥' }
    if (streak === 0) return { face: 'sad', bubble: 'Miss you! 💔' }
    if (hour < 10) return { face: 'sleepy', bubble: 'Good morning! ☕' }
    if (hour >= 22) return { face: 'sleepy', bubble: 'Late night coding! 🌙' }
    return { face: 'happy', bubble: "Let's code! 🚀" }
}

/* ── Skill Radar ── */
export const skillRadar = {
    variables: { label: 'Variables', score: 85 },
    conditionals: { label: 'Conditionals', score: 70 },
    loops: { label: 'Loops', score: 45 },
    functions: { label: 'Functions', score: 25 },
    data_structures: { label: 'Data Struct.', score: 10 },
    algorithms: { label: 'Algorithms', score: 0 },
    complexity: { label: 'Complexity', score: 0 },
    graphs: { label: 'Graphs', score: 0 },
    dp: { label: 'Dyn.Program', score: 0 },
}

/* ── Achievements ── */
export const achievements = [
    { id: 'first_star', icon: '⭐', title: 'First Star', desc: 'Earn your first star', unlocked: true },
    { id: 'streak_7', icon: '🔥', title: 'Week Warrior', desc: '7-day streak', unlocked: true },
    { id: 'perfect', icon: '💎', title: 'Perfect Score', desc: '100% on a quiz', unlocked: true },
    { id: 'streak_30', icon: '🏆', title: 'Monthly Master', desc: '30-day streak', unlocked: false },
    { id: 'all_stars', icon: '🌟', title: 'Completionist', desc: 'All 3 stars on a chapter', unlocked: false },
    { id: 'boss_slayer', icon: '💀', title: 'Boss Slayer', desc: 'Defeat a boss challenge', unlocked: false },
    { id: 'speed_demon', icon: '⚡', title: 'Speed Demon', desc: 'Complete Time Attack <30s', unlocked: false },
    { id: 'bug_hunter', icon: '🐛', title: 'Bug Hunter', desc: 'Find 50 bugs total', unlocked: false },
]

/* ── League Rankings ── */
export const league = {
    current: 'Gold',
    rank: 4,
    players: [
        { name: 'CodeMaster42', xp: 2850, avatar: '🧑‍💻', isUser: false },
        { name: 'PyNinja', xp: 2340, avatar: '🥷', isUser: false },
        { name: 'BugSquasher', xp: 2100, avatar: '🐛', isUser: false },
        { name: 'You', xp: 1985, avatar: '🦦', isUser: true },
        { name: 'LoopLord', xp: 1820, avatar: '🔄', isUser: false },
        { name: 'RecursiveRex', xp: 1650, avatar: '🦖', isUser: false },
        { name: 'VarViking', xp: 1420, avatar: '⚔️', isUser: false },
        { name: 'NullPointer', xp: 1200, avatar: '💥', isUser: false },
        { name: 'SyntaxError', xp: 980, avatar: '❌', isUser: false },
        { name: 'PrintHello', xp: 750, avatar: '👶', isUser: false },
    ],
    promotionLine: 3,   // top 3 promote
    relegationLine: 8,  // bottom 3 relegate
}

/* ── Profile ── */
export const profile = {
    name: 'Furkan',
    level: 14,
    xpCurrent: 1985,
    xpNext: 2500,
    totalStars: 15,
    maxStars: 30,
    daysLearning: 42,
    longestStreak: 18,
}

/* ── Quests ── */
export const quests = {
    monthly: { title: 'February Sprint', task: 'Earn 15 Commit Points', current: 0, total: 15, daysLeft: 5 },
    weekend: { task: 'Trace 3 nested loops flawlessly', current: 0, total: 3, hoursLeft: 4 },
    weeklyBuild: {
        title: 'Calculator App',
        desc: 'Build a simple calculator using Python functions',
        icon: '🏗️',
        tasks: [
            { id: 'wb1', step: 'Define add() and subtract()', done: true },
            { id: 'wb2', step: 'Add multiply() and divide()', done: true },
            { id: 'wb3', step: 'Create input loop with menu', done: false },
            { id: 'wb4', step: 'Handle edge cases (div by 0)', done: false },
        ],
        reward: { type: 'xp', amount: 500 },
        daysLeft: 3,
    },
    mysteryQuest: {
        revealed: false,
        hidden: { task: 'Write a function with exactly 3 parameters', reward: 'gem', xp: 150 },
    },
    daily: [
        { id: 1, task: 'Start a commit streak', current: 0, total: 1, reward: 'chest', color: '#FB923C' },
        { id: 2, task: 'Read 50 lines of Python', current: 32, total: 50, reward: 'disk', color: '#58CC02' },
        { id: 3, task: 'Find 3 syntax bugs', current: 1, total: 3, reward: 'chest', color: '#38BDF8' },
        { id: 4, task: 'Score 100% on a trace quiz', current: 0, total: 1, reward: 'gem', color: '#C084FC' },
    ],
}

const _savedStats = loadSaved(STATS_KEY, null)
export const stats = {
    get language() { const l = languages.find(l => l.id === _activeLang); return l || languages[0] },
    streak: _savedStats?.streak ?? 12,
    gems: _savedStats?.gems ?? 985,
    energy: _savedStats?.energy ?? 25,
    xpToday: _savedStats?.xpToday ?? 45,
    streakShield: _savedStats?.streakShield ?? true,
}

/* ── Save/Load Progress ── */
export function saveProgress() {
    const nodeData = journeyNodes.map(n => ({ id: n.id, status: n.status, stars: n.stars }))
    saveTo(STORAGE_KEY, nodeData)
    saveTo(STATS_KEY, { streak: stats.streak, gems: stats.gems, energy: stats.energy, xpToday: stats.xpToday, streakShield: stats.streakShield })
}

export function loadProgress() {
    const saved = loadSaved(STORAGE_KEY, null)
    if (!saved) return false
    saved.forEach(s => {
        const node = journeyNodes.find(n => n.id === s.id)
        if (node) { node.status = s.status; node.stars = s.stars }
    })
    return true
}

export function isOnboardingDone() { return loadSaved(ONBOARDING_KEY, false) }
export function setOnboardingDone() { saveTo(ONBOARDING_KEY, true) }

/* ── Streak Multiplier ── */
export function getStreakMultiplier() {
    return stats.streak >= 7 ? { mult: 3, label: '3x XP' } : stats.streak >= 3 ? { mult: 2, label: '2x XP' } : { mult: 1, label: null }
}

/* ── 1v1 Duel Data ── */
export const duelQuestions = [
    { text: 'What is the output of: print(len("Hello"))', options: ['4', '5', '6', 'Error'], correct: 1 },
    { text: 'What does range(3) produce?', options: ['[1,2,3]', '[0,1,2]', '[0,1,2,3]', 'Error'], correct: 1 },
    { text: 'Which keyword defines a function?', options: ['func', 'function', 'def', 'define'], correct: 2 },
    { text: 'What is 2 ** 3 in Python?', options: ['6', '8', '9', '5'], correct: 1 },
    { text: 'What type is True?', options: ['str', 'int', 'bool', 'float'], correct: 2 },
    { text: 'What does "hello".upper() return?', options: ['"Hello"', '"HELLO"', '"hello"', 'Error'], correct: 1 },
]

export const duelData = {
    opponent: { name: 'PyNinja', avatar: '🥷', elo: 1450 },
    timer: 15,
    bestOf: 5,
}

export const duelHistory = [
    { id: 1, opponent: { name: 'CodeMaster42', avatar: '🧑‍💻' }, result: 'win', score: '3-1', xp: 25, elo: 15, date: '2h ago' },
    { id: 2, opponent: { name: 'LoopLord', avatar: '🧙' }, result: 'win', score: '3-2', xp: 30, elo: 12, date: '5h ago' },
    { id: 3, opponent: { name: 'BugSquasher', avatar: '🐛' }, result: 'loss', score: '1-3', xp: 5, elo: -8, date: 'Yesterday' },
    { id: 4, opponent: { name: 'RecursiveRex', avatar: '🦖' }, result: 'win', score: '3-0', xp: 35, elo: 20, date: '2 days ago' },
    { id: 5, opponent: { name: 'SyntaxError', avatar: '❌' }, result: 'loss', score: '2-3', xp: 10, elo: -5, date: '3 days ago' },
]

export const duelStats = { wins: 18, losses: 7, winStreak: 2, bestStreak: 5, elo: 1520 }

/* ── Otter Costumes ── */
export const otterCostumes = [
    { id: 'none', name: 'Default', price: 0, owned: true, equipped: true, emoji: '🦦', slot: null },
    { id: 'tophat', name: 'Top Hat', price: 200, owned: true, equipped: false, emoji: '🎩', slot: 'hat' },
    { id: 'crown', name: 'Royal Crown', price: 500, owned: false, equipped: false, emoji: '👑', slot: 'hat' },
    { id: 'sunglasses', name: 'Cool Shades', price: 150, owned: true, equipped: false, emoji: '🕶️', slot: 'face' },
    { id: 'monocle', name: 'Monocle', price: 300, owned: false, equipped: false, emoji: '🧐', slot: 'face' },
    { id: 'cape', name: 'Hero Cape', price: 400, owned: false, equipped: false, emoji: '🦸', slot: 'body' },
    { id: 'scarf', name: 'Winter Scarf', price: 250, owned: false, equipped: false, emoji: '🧣', slot: 'body' },
    { id: 'party', name: 'Party Hat', price: 100, owned: true, equipped: false, emoji: '🥳', slot: 'hat' },
]

/* ══════════════════════════════════════════════════
   PER-NODE, PER-LANGUAGE EXERCISES
   All 12 types spread across journey nodes
   ══════════════════════════════════════════════════ */
const nodeExercises = {
    python: {
        // ═══ CH1: BASICS ⭐ ═══
        1: [
            { type: 'trace', prompt: 'What is the value of `count`?', code: [{ text: 'count = 0' }, { text: 'for i in range(5):' }, { text: '    if i % 2 == 0:' }, { text: '        count += 1' }, { text: 'print(count)', highlight: true }], options: ['2', '3', '5', '4'], correct: 1 },
            { type: 'realworld', prompt: 'Which code counts total items in a cart?', scenario: '🛒 Cart: 3 apples, 2 oranges, 1 banana.', options: [{ code: 'cart = [3, 2, 1]\ntotal = sum(cart)', label: 'Sum list' }, { code: 'cart = 3 + 2 + 1\ntotal = len(cart)', label: 'len() on int' }, { code: 'cart = "3 2 1"\ntotal = len(cart)', label: 'String length' }, { code: 'cart = {3, 2, 1}\ntotal = max(cart)', label: 'Max of set' }], correct: 0 },
            { type: 'pair', prompt: 'Match concepts', pairs: [{ id: 1, left: 'Variable', right: 'Stores a value' }, { id: 2, left: 'String', right: 'Text data' }, { id: 3, left: 'Integer', right: 'Whole number' }, { id: 4, left: 'Boolean', right: 'True or False' }] },
            { type: 'output', prompt: 'What does this print?', code: [{ text: 'x = 7' }, { text: 'y = 2' }, { text: 'print(x // y, x % y)' }], terminalOutput: '3 1', options: ['3.5 1', '3 1', '3.5 0', '3 0'], correct: 1 },
            { type: 'fillgap', prompt: 'Complete: swap two variables without a temp', codeParts: [{ text: 'a = 5\nb = 10\n', type: 'fixed' }, { text: 'a, b = b, a', type: 'gap', id: 'g1' }], bank: ['a, b = b, a', 'a = b; b = a', 'swap(a, b)', 'a == b'], correctFill: { g1: 'a, b = b, a' } },
            { type: 'scramble', prompt: 'Build code to calculate BMI', pieces: [{ id: 'a', text: 'weight = 70' }, { id: 'b', text: 'height = 1.75' }, { id: 'c', text: 'bmi = weight / height ** 2' }, { id: 'd', text: 'print(round(bmi, 1))' }], distractors: [{ id: 'e', text: 'bmi = weight * height' }], correctOrder: ['a', 'b', 'c', 'd'] },
        ],
        2: [
            { type: 'bug', prompt: 'Find the syntax error', code: [{ text: 'def greet(name):', hasError: false }, { text: '    msg = "Hello " + name', hasError: false }, { text: '    print(msg', hasError: true }, { text: '    return msg', hasError: false }], correctLine: 2 },
            { type: 'errordecode', prompt: 'Decode this error', errorText: 'Traceback (most recent call last):\n  File "main.py", line 3\n    print(message\n         ^\nSyntaxError: unexpected EOF while parsing', question: 'What caused this?', options: ['Missing closing parenthesis', 'Undefined variable', 'Wrong indentation', 'Invalid string'], correct: 0 },
            { type: 'refactor', prompt: 'Which is the cleanest?', originalCode: 'x = 10\nif x > 5:\n    r = "big"\nelse:\n    r = "small"\nprint(r)', options: [{ code: 'x = 10\nr = "big" if x > 5 else "small"\nprint(r)', label: 'Ternary expression' }, { code: 'x = 10\nresult = ""\nif x > 5: result = "big"\nif x <= 5: result = "small"', label: 'Two ifs' }, { code: 'print("big") if 10 > 5 else print("small")', label: 'Print in ternary' }], correct: 0 },
            { type: 'bug', prompt: 'Why does this crash?', code: [{ text: 'age = input("Age: ")', hasError: false }, { text: 'if age > 18:', hasError: true }, { text: '    print("Adult")', hasError: false }], correctLine: 1 },
            { type: 'output', prompt: 'What does this print?', code: [{ text: 'x = "5"' }, { text: 'y = 3' }, { text: 'print(x * y)' }], terminalOutput: '555', options: ['15', '555', '53', 'Error'], correct: 1 },
            { type: 'trace', prompt: 'What is the type of result?', code: [{ text: 'a = 10' }, { text: 'b = 3' }, { text: 'result = a / b' }, { text: 'print(type(result))', highlight: true }], options: ["<class 'int'>", "<class 'float'>", "<class 'str'>", "3.33"], correct: 1 },
        ],
        3: [
            { type: 'video', title: 'Variables & Data Types', description: 'Variables store data. Python is dynamically typed — no type declarations needed. int, float, str, bool are the basics.', duration: '2:45', thumbnail: '🎬' },
            { type: 'output', prompt: 'What does this print?', code: [{ text: 'name = "Rheo"' }, { text: 'age = 3' }, { text: 'print(type(age))' }], terminalOutput: "<class 'int'>", options: ["<class 'str'>", "<class 'int'>", "3", "Error"], correct: 1 },
            { type: 'pair', prompt: 'Match Python types', pairs: [{ id: 1, left: 'int', right: '42' }, { id: 2, left: 'float', right: '3.14' }, { id: 3, left: 'str', right: '"hello"' }, { id: 4, left: 'bool', right: 'True' }] },
        ],
        4: [
            { type: 'pair', prompt: 'Match operators', pairs: [{ id: 1, left: '==', right: 'Equals' }, { id: 2, left: '!=', right: 'Not equals' }, { id: 3, left: '**', right: 'Power' }, { id: 4, left: '//', right: 'Floor divide' }] },
            { type: 'trace', prompt: 'What is the output?', code: [{ text: 'x = 17' }, { text: 'print(x % 5, x // 5)', highlight: true }], options: ['2 3', '3 2', '2 4', '17 5'], correct: 0 },
            { type: 'fillgap', prompt: 'Complete: convert Celsius to Fahrenheit', codeParts: [{ text: 'celsius = 25\n', type: 'fixed' }, { text: 'fahrenheit = celsius * 9/5 + 32', type: 'gap', id: 'g1' }, { text: '\nprint(fahrenheit)', type: 'fixed' }], bank: ['celsius * 9/5 + 32', 'celsius + 32', 'celsius * 1.8', 'celsius / 5 * 9'], correctFill: { g1: 'celsius * 9/5 + 32' } },
        ],
        // ═══ CH2: FLOW CONTROL ⭐ ═══
        5: [
            { type: 'trace', prompt: 'What does this nested condition print?', code: [{ text: 'x = 15' }, { text: 'if x > 20:' }, { text: '    print("A")' }, { text: 'elif x > 10:' }, { text: '    if x % 2 == 0:' }, { text: '        print("B")' }, { text: '    else:' }, { text: '        print("C")', highlight: true }], options: ['A', 'B', 'C', 'None'], correct: 2 },
            { type: 'bug', prompt: 'Voting check bug — 18 year olds should vote!', code: [{ text: 'age = 18', hasError: false }, { text: 'if age > 18:', hasError: true }, { text: '    print("Can vote")', hasError: false }], correctLine: 1 },
            { type: 'output', prompt: 'Short-circuit: what prints?', code: [{ text: 'a = 0' }, { text: 'b = 5' }, { text: 'result = a and b/a' }, { text: 'print(result)' }], terminalOutput: '0', options: ['0', 'Error: ZeroDivision', '5', 'False'], correct: 0 },
            { type: 'realworld', prompt: 'Which handles login correctly?', scenario: '🔐 3 password attempts, then lock.', options: [{ code: 'attempts = 0\nwhile attempts < 3:\n    pwd = input()\n    if pwd == secret: break\n    attempts += 1', label: 'Counter + break' }, { code: 'for i in range(3):\n    pwd = input()\n    if pwd != secret: continue', label: 'Continue loop' }, { code: 'pwd = input()\nif pwd == secret: print("OK")', label: 'Single attempt' }, { code: 'while True:\n    pwd = input()\n    break', label: 'Infinite + break' }], correct: 0 },
            { type: 'scramble', prompt: 'Build a grade calculator', pieces: [{ id: 'a', text: 'score = 75' }, { id: 'b', text: 'if score >= 90: grade = "A"' }, { id: 'c', text: 'elif score >= 80: grade = "B"' }, { id: 'd', text: 'elif score >= 70: grade = "C"' }, { id: 'e', text: 'else: grade = "F"' }, { id: 'f', text: 'print(grade)' }], distractors: [{ id: 'g', text: 'if score == 90: grade = "A"' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f'] },
            { type: 'trace', prompt: 'What does this ternary chain produce?', code: [{ text: 'n = 0' }, { text: 'label = "positive" if n > 0 else "negative" if n < 0 else "zero"' }, { text: 'print(label)', highlight: true }], options: ['positive', 'negative', 'zero', 'Error'], correct: 2 },
        ],
        6: [
            { type: 'trace', prompt: 'Truthiness check — what prints?', code: [{ text: 'x = [1, 2, 3]' }, { text: 'y = []' }, { text: 'print(bool(x), bool(y))', highlight: true }], options: ['True True', 'True False', 'False True', 'False False'], correct: 1 },
            { type: 'refactor', prompt: 'Pythonic emptiness check?', originalCode: 'if len(my_list) > 0:\n    do_something()', options: [{ code: 'if my_list:\n    do_something()', label: 'Truthy check' }, { code: 'if my_list != []:\n    do_something()', label: 'Compare to empty' }, { code: 'if my_list is not None:\n    do_something()', label: 'None check' }], correct: 0 },
            { type: 'fillgap', prompt: 'Check if number is in range 1-100', codeParts: [{ text: 'def in_range(n):\n    return ', type: 'fixed' }, { text: '1 <= n <= 100', type: 'gap', id: 'g1' }], bank: ['1 <= n <= 100', 'n > 0 and n < 101', 'n in range(100)', '1 < n < 100'], correctFill: { g1: '1 <= n <= 100' } },
            { type: 'output', prompt: 'What values are truthy in Python?', code: [{ text: 'values = [0, "", [], None, 1, "hi", [0]]' }, { text: 'truthy = [v for v in values if v]' }, { text: 'print(len(truthy))' }], terminalOutput: '3', options: ['2', '3', '4', '7'], correct: 1 },
            { type: 'pair', prompt: 'Match falsy values', pairs: [{ id: 1, left: '0', right: 'Falsy integer' }, { id: 2, left: '""', right: 'Falsy string' }, { id: 3, left: '[]', right: 'Falsy list' }, { id: 4, left: 'None', right: 'Falsy null' }] },
        ],
        7: [
            { type: 'terminal', prompt: 'Create a variable and print it', expectedCommands: ['name = "Otter"', 'print(name)'], hint: 'Assign then print', terminalHistory: [{ type: 'system', text: '>>> Daily Challenge' }] },
            { type: 'trace', prompt: 'What is `result`?', code: [{ text: 'result = ""' }, { text: 'for c in "hello":' }, { text: '    result += c.upper()' }, { text: 'print(result)', highlight: true }], options: ['hello', 'HELLO', 'Hello', 'hELLO'], correct: 1 },
            { type: 'output', prompt: 'What does this f-string print?', code: [{ text: 'name = "Otter"' }, { text: 'age = 5' }, { text: 'print(f"{name} is {age*7} in human years")' }], terminalOutput: 'Otter is 35 in human years', options: ['Otter is 35 in human years', 'Otter is 5 in human years', '{name} is {age*7}', 'Error'], correct: 0 },
        ],
        8: [
            { type: 'video', title: 'Conditional Logic Deep Dive', description: 'if/elif/else chains, ternary, truthiness, short-circuit evaluation, match-case (3.10+).', duration: '3:00', thumbnail: '🎥' },
            { type: 'trace', prompt: 'Match-case: what prints?', code: [{ text: 'status = 404' }, { text: 'match status:' }, { text: '    case 200: msg = "OK"' }, { text: '    case 404: msg = "Not Found"' }, { text: '    case _: msg = "Unknown"' }, { text: 'print(msg)', highlight: true }], options: ['OK', 'Not Found', 'Unknown', 'Error'], correct: 1 },
        ],
        // ═══ CH3: LOOPS ⭐⭐ ═══
        9: [
            { type: 'scramble', prompt: 'Print numbers 1-5', pieces: [{ id: 'a', text: 'for i in range(1, 6):' }, { id: 'b', text: '    print(i)' }], distractors: [{ id: 'c', text: '    print(i + 1)' }, { id: 'd', text: 'while i < 5:' }], correctOrder: ['a', 'b'] },
            { type: 'bug', prompt: 'Off-by-one: should print 1-10', code: [{ text: 'for i in range(1, 10):', hasError: true }, { text: '    print(i)', hasError: false }], correctLine: 0 },
            { type: 'trace', prompt: 'How many iterations?', code: [{ text: 'n = 64' }, { text: 'count = 0' }, { text: 'while n > 1:' }, { text: '    n = n // 2' }, { text: '    count += 1' }, { text: 'print(count)', highlight: true }], options: ['5', '6', '7', '32'], correct: 1 },
            { type: 'fillgap', prompt: 'Complete the sum loop', codeParts: [{ text: 'total = 0\nfor num in ', type: 'fixed' }, { text: '[1,2,3,4]', type: 'gap', id: 'g1' }, { text: ':\n    total += num', type: 'fixed' }], bank: ['[1,2,3,4]', 'range(4)', '(1,2,3)', '{1:4}'], correctFill: { g1: '[1,2,3,4]' } },
            { type: 'realworld', prompt: 'Which finds the max in a list?', scenario: '📊 Find biggest number in [3, 7, 2, 9, 4]', options: [{ code: 'nums = [3,7,2,9,4]\nbest = nums[0]\nfor n in nums:\n    if n > best: best = n', label: 'Manual scan' }, { code: 'nums = [3,7,2,9,4]\nbest = nums[-1]', label: 'Last element' }, { code: 'nums = [3,7,2,9,4]\nnums.sort()', label: 'Sort only' }, { code: 'nums = [3,7,2,9,4]\nbest = sum(nums)', label: 'Sum' }], correct: 0 },
            { type: 'output', prompt: 'What prints?', code: [{ text: 'for i in range(5):' }, { text: '    if i == 3: break' }, { text: '    print(i, end=" ")' }], terminalOutput: '0 1 2 ', options: ['0 1 2 ', '0 1 2 3', '0 1 2 3 4', '3'], correct: 0 },
        ],
        10: [
            { type: 'trace', prompt: 'How many times does print() run?', code: [{ text: 'for i in range(3):' }, { text: '    for j in range(4):' }, { text: '        print(i, j)', highlight: true }], options: ['7', '12', '9', '16'], correct: 1 },
            { type: 'output', prompt: 'What pattern prints?', code: [{ text: 'for i in range(1, 4):' }, { text: '    print("*" * i)' }], terminalOutput: '*\n**\n***', options: ['***\n**\n*', '*\n**\n***', '***', '* * *'], correct: 1 },
            { type: 'realworld', prompt: 'Flatten a 2D matrix?', scenario: '📊 [[1,2],[3,4],[5,6]] → [1,2,3,4,5,6]', options: [{ code: 'flat = [x for row in m for x in row]', label: 'List comprehension' }, { code: 'flat = sum(m)', label: 'Sum matrix' }, { code: 'flat = m.flatten()', label: '.flatten()' }, { code: 'flat = list(m)', label: 'list()' }], correct: 0 },
            { type: 'scramble', prompt: 'Build a multiplication table row', pieces: [{ id: 'a', text: 'n = 5' }, { id: 'b', text: 'for i in range(1, 11):' }, { id: 'c', text: '    print(f"{n} x {i} = {n*i}")' }], distractors: [{ id: 'd', text: '    print(n + i)' }], correctOrder: ['a', 'b', 'c'] },
            { type: 'trace', prompt: 'What does enumerate give?', code: [{ text: 'fruits = ["apple", "banana", "cherry"]' }, { text: 'for i, f in enumerate(fruits):' }, { text: '    print(i, f)', highlight: true }], options: ['0 apple\n1 banana\n2 cherry', 'apple 0\nbanana 1', '1 apple\n2 banana\n3 cherry', 'Error'], correct: 0 },
        ],
        11: [
            { type: 'scramble', prompt: 'Build a prime checker', pieces: [{ id: 'a', text: 'def is_prime(n):' }, { id: 'b', text: '    if n < 2: return False' }, { id: 'c', text: '    for i in range(2, int(n**0.5)+1):' }, { id: 'd', text: '        if n % i == 0: return False' }, { id: 'e', text: '    return True' }], distractors: [{ id: 'f', text: '    for i in range(n):' }], correctOrder: ['a', 'b', 'c', 'd', 'e'] },
            { type: 'trace', prompt: 'List comprehension — what\'s the result?', code: [{ text: 'nums = [1, 2, 3, 4, 5, 6]' }, { text: 'evens = [n for n in nums if n % 2 == 0]' }, { text: 'print(evens)', highlight: true }], options: ['[2, 4, 6]', '[1, 3, 5]', '[1, 2, 3, 4, 5, 6]', '3'], correct: 0 },
            { type: 'fillgap', prompt: 'Complete: list comprehension to square numbers', codeParts: [{ text: 'squares = ', type: 'fixed' }, { text: '[x**2 for x in range(1,6)]', type: 'gap', id: 'g1' }], bank: ['[x**2 for x in range(1,6)]', 'map(x**2, range(5))', '[x*x in range(5)]', 'range(1,6)**2'], correctFill: { g1: '[x**2 for x in range(1,6)]' } },
            { type: 'realworld', prompt: 'Which filters students who passed?', scenario: '📝 scores = [45, 78, 92, 33, 88]. Passing = 60+', options: [{ code: 'passed = [s for s in scores if s >= 60]', label: 'List comp filter' }, { code: 'passed = scores.filter(60)', label: '.filter()' }, { code: 'passed = scores > 60', label: 'Direct compare' }, { code: 'passed = max(scores)', label: 'Max only' }], correct: 0 },
        ],
        12: [
            { type: 'pair', prompt: 'Match loop tools', pairs: [{ id: 1, left: 'break', right: 'Exit loop' }, { id: 2, left: 'continue', right: 'Skip iteration' }, { id: 3, left: 'enumerate()', right: 'Index + value' }, { id: 4, left: 'zip()', right: 'Parallel iterate' }] },
            { type: 'trace', prompt: 'What does zip produce?', code: [{ text: 'names = ["Ali", "Ece"]' }, { text: 'ages = [20, 22]' }, { text: 'for n, a in zip(names, ages):' }, { text: '    print(f"{n}:{a}")', highlight: true }], options: ['Ali:20\nEce:22', 'Ali Ece\n20 22', '(Ali,20)', 'Error'], correct: 0 },
            { type: 'output', prompt: 'What prints with continue?', code: [{ text: 'for i in range(5):' }, { text: '    if i == 2: continue' }, { text: '    print(i, end=" ")' }], terminalOutput: '0 1 3 4 ', options: ['0 1 3 4 ', '0 1 2 3 4', '2', '0 1'], correct: 0 },
        ],
        // ═══ CH4: FUNCTIONS ⭐⭐ ═══
        13: [
            { type: 'trace', prompt: 'Default args — what returns?', code: [{ text: 'def add(a, b=10):' }, { text: '    return a + b' }, { text: 'print(add(3))', highlight: true }], options: ['3', '10', '13', 'Error'], correct: 2 },
            { type: 'bug', prompt: 'Should return sum, not print it', code: [{ text: 'def add(a, b):', hasError: false }, { text: '    result = a + b', hasError: false }, { text: '    print(result)', hasError: true }], correctLine: 2 },
            { type: 'refactor', prompt: 'Pick the cleanest', originalCode: 'def calc(a, b, op):\n    if op == "add": return a+b\n    if op == "sub": return a-b\n    if op == "mul": return a*b', options: [{ code: 'ops = {"add": lambda a,b: a+b,\n       "sub": lambda a,b: a-b,\n       "mul": lambda a,b: a*b}\ndef calc(a,b,op): return ops[op](a,b)', label: 'Dict dispatch' }, { code: 'def calc(a,b,op): return eval(f"{a}{op}{b}")', label: 'eval()' }, { code: 'def calc(a,b,op):\n    match op:\n        case "+": return a+b', label: 'Match' }], correct: 0 },
            { type: 'output', prompt: '*args — what prints?', code: [{ text: 'def total(*nums):' }, { text: '    return sum(nums)' }, { text: 'print(total(1, 2, 3, 4))' }], terminalOutput: '10', options: ['(1,2,3,4)', '10', '4', 'Error'], correct: 1 },
            { type: 'scramble', prompt: 'Build a function with default + kwargs', pieces: [{ id: 'a', text: 'def greet(name, greeting="Hello"):' }, { id: 'b', text: '    return f"{greeting}, {name}!"' }, { id: 'c', text: 'print(greet("Furkan"))' }, { id: 'd', text: 'print(greet("Arda", greeting="Hey"))' }], distractors: [{ id: 'e', text: '    return name + greeting' }], correctOrder: ['a', 'b', 'c', 'd'] },
            { type: 'trace', prompt: 'Lambda — what returns?', code: [{ text: 'double = lambda x: x * 2' }, { text: 'nums = [1, 2, 3]' }, { text: 'result = list(map(double, nums))' }, { text: 'print(result)', highlight: true }], options: ['[2, 4, 6]', '[1, 2, 3]', '6', 'Error'], correct: 0 },
        ],
        14: [
            { type: 'trace', prompt: 'Global or local?', code: [{ text: 'x = "global"' }, { text: 'def f():' }, { text: '    x = "local"' }, { text: '    print(x)', highlight: true }, { text: 'f()' }], options: ['global', 'local', 'Error', 'None'], correct: 1 },
            { type: 'output', prompt: 'Closure counter', code: [{ text: 'def make_counter():' }, { text: '    count = 0' }, { text: '    def inc():' }, { text: '        nonlocal count' }, { text: '        count += 1' }, { text: '        return count' }, { text: '    return inc' }, { text: 'c = make_counter()' }, { text: 'print(c(), c(), c())' }], terminalOutput: '1 2 3', options: ['0 0 0', '1 1 1', '1 2 3', 'Error'], correct: 2 },
            { type: 'bug', prompt: 'Why does this fail?', code: [{ text: 'total = 0', hasError: false }, { text: 'def add(n):', hasError: false }, { text: '    total += n', hasError: true }, { text: 'add(5)', hasError: false }], correctLine: 2 },
            { type: 'errordecode', prompt: 'Decode this scope error', errorText: "UnboundLocalError: cannot access local variable 'total' where it is not associated with a value", question: 'Fix?', options: ['Add "global total" or "nonlocal total"', 'Use total = 0 inside function', 'Import total', 'Delete total'], correct: 0 },
            { type: 'realworld', prompt: 'When to use closures?', scenario: '🧠 You need a function that remembers state between calls.', options: [{ code: 'def make_multiplier(factor):\n    def multiply(x):\n        return x * factor\n    return multiply\ndouble = make_multiplier(2)', label: 'Closure — captures factor' }, { code: 'factor = 2\ndef multiply(x):\n    return x * factor', label: 'Global variable' }, { code: 'class Mult:\n    def __init__(self, f): self.f = f', label: 'Class (overkill)' }, { code: 'multiply = lambda x: x * 2', label: 'Hardcoded lambda' }], correct: 0 },
        ],
        15: [
            { type: 'video', title: 'Functions Deep Dive', description: 'Parameters, defaults, *args, **kwargs, closures, decorators, and first-class functions.', duration: '3:30', thumbnail: '🎥' },
            { type: 'pair', prompt: 'Match function concepts', pairs: [{ id: 1, left: 'def', right: 'Declare function' }, { id: 2, left: 'return', right: 'Send value back' }, { id: 3, left: '*args', right: 'Variable positional' }, { id: 4, left: '**kwargs', right: 'Variable keyword' }] },
            { type: 'trace', prompt: 'Decorator — what prints?', code: [{ text: 'def shout(func):' }, { text: '    def wrapper(name):' }, { text: '        return func(name).upper()' }, { text: '    return wrapper' }, { text: '@shout' }, { text: 'def greet(name):' }, { text: '    return f"hello {name}"' }, { text: 'print(greet("Otter"))', highlight: true }], options: ['hello Otter', 'HELLO OTTER', 'Hello Otter', 'Error'], correct: 1 },
        ],
        16: [
            { type: 'trace', prompt: 'What does fib(5) return?', code: [{ text: 'def fib(n):' }, { text: '    if n <= 1: return n' }, { text: '    return fib(n-1) + fib(n-2)' }, { text: 'print(fib(5))', highlight: true }], options: ['3', '5', '8', '13'], correct: 1 },
            { type: 'algostep', prompt: 'fib(4) call tree', array: ['fib(4)', 'fib(3)+fib(2)', '(fib(2)+fib(1))+(fib(1)+fib(0))', '(1+1)+(1+0)=3'], step: 3, description: 'fib(4) = fib(3) + fib(2). Expanding...', question: 'What is fib(3)?', options: ['1', '2', '3', '5'], correct: 1 },
            { type: 'errordecode', prompt: 'Decode recursion error', errorText: 'RecursionError: maximum recursion depth exceeded', question: 'Cause?', options: ['Missing base case', 'Wrong return type', 'Too many params', 'Import error'], correct: 0 },
            { type: 'scramble', prompt: 'Build factorial', pieces: [{ id: 'a', text: 'def factorial(n):' }, { id: 'b', text: '    if n <= 1: return 1' }, { id: 'c', text: '    return n * factorial(n-1)' }], distractors: [{ id: 'd', text: '    return n + factorial(n)' }], correctOrder: ['a', 'b', 'c'] },
            { type: 'trace', prompt: 'What does sum_digits(123) return?', code: [{ text: 'def sum_digits(n):' }, { text: '    if n < 10: return n' }, { text: '    return n % 10 + sum_digits(n // 10)' }, { text: 'print(sum_digits(123))', highlight: true }], options: ['6', '123', '3', '12'], correct: 0 },
            { type: 'realworld', prompt: 'Which is naturally recursive?', scenario: '🤔 Which breaks into same-type subproblems?', options: [{ code: '# File system: folders contain folders', label: 'Directory traversal ✓' }, { code: '# Read file line by line', label: 'File reading' }, { code: '# Print "Hello" 5 times', label: 'Simple loop' }, { code: '# Add two numbers', label: 'Addition' }], correct: 0 },
        ],
        // ═══ CH5: DATA STRUCTURES I ⭐⭐ ═══
        17: [
            { type: 'trace', prompt: 'References! What prints?', code: [{ text: 'a = [1, 2, 3]' }, { text: 'b = a' }, { text: 'b.append(4)' }, { text: 'print(len(a))', highlight: true }], options: ['3', '4', 'Error', '[1,2,3]'], correct: 1 },
            { type: 'output', prompt: 'Slicing result?', code: [{ text: 'x = [10, 20, 30, 40, 50]' }, { text: 'print(x[1:4])' }], terminalOutput: '[20, 30, 40]', options: ['[10, 20, 30]', '[20, 30, 40]', '[20, 30, 40, 50]', '[10, 20, 30, 40]'], correct: 1 },
            { type: 'realworld', prompt: 'Reverse without mutating?', scenario: '🔄 Original must stay unchanged', options: [{ code: 'original = [1,2,3]\nrev = original[::-1]', label: 'Slice copy' }, { code: 'original = [1,2,3]\noriginal.reverse()', label: '.reverse() mutates!' }, { code: 'original = [1,2,3]\nrev = reversed(original)', label: 'Iterator only' }, { code: 'original = [1,2,3]\noriginal = original[::-1]', label: 'Reassign' }], correct: 0 },
            { type: 'bug', prompt: 'Why does b change a?', code: [{ text: 'a = [1, 2, 3]', hasError: false }, { text: 'b = a', hasError: true }, { text: 'b.append(4)', hasError: false }, { text: 'print(a)  # [1,2,3,4] !', hasError: false }], correctLine: 1 },
            { type: 'refactor', prompt: 'How to properly copy a list?', originalCode: 'original = [1, 2, 3]\ncopy = original  # This is a reference!', options: [{ code: 'copy = original[:]  # or list(original)\n# or original.copy()', label: 'Shallow copy ✓' }, { code: 'copy = original', label: 'Still a reference' }, { code: 'copy = &original', label: 'Not Python syntax' }], correct: 0 },
        ],
        18: [
            { type: 'trace', prompt: 'Frequency counter?', code: [{ text: 'word = "banana"' }, { text: 'freq = {}' }, { text: 'for c in word:' }, { text: '    freq[c] = freq.get(c, 0) + 1' }, { text: 'print(freq["a"])', highlight: true }], options: ['1', '2', '3', 'Error'], correct: 2 },
            { type: 'refactor', prompt: 'Most Pythonic char counting?', originalCode: 'freq = {}\nfor c in word:\n    if c in freq: freq[c] += 1\n    else: freq[c] = 1', options: [{ code: 'from collections import Counter\nfreq = Counter(word)', label: 'Counter class ✓' }, { code: 'freq = {c: word.count(c) for c in word}', label: 'O(n²) comprehension' }, { code: 'freq = dict.fromkeys(word, 0)', label: 'fromkeys + loop' }], correct: 0 },
            { type: 'fillgap', prompt: 'Check anagram', codeParts: [{ text: 'def is_anagram(a, b):\n    return ', type: 'fixed' }, { text: 'sorted(a) == sorted(b)', type: 'gap', id: 'g1' }], bank: ['sorted(a) == sorted(b)', 'a == b', 'len(a) == len(b)', 'set(a) == set(b)'], correctFill: { g1: 'sorted(a) == sorted(b)' } },
            { type: 'output', prompt: 'Dict comprehension?', code: [{ text: 'squares = {x: x**2 for x in range(1,5)}' }, { text: 'print(squares)' }], terminalOutput: '{1: 1, 2: 4, 3: 9, 4: 16}', options: ['{1:1, 2:4, 3:9, 4:16}', '[1, 4, 9, 16]', '{1,4,9,16}', 'Error'], correct: 0 },
            { type: 'realworld', prompt: 'Which finds most common word?', scenario: '📝 words = ["the","cat","the","dog","the"]', options: [{ code: 'from collections import Counter\nmost = Counter(words).most_common(1)', label: 'Counter.most_common()' }, { code: 'most = max(words)', label: 'Alphabetical max' }, { code: 'most = words[0]', label: 'First element' }, { code: 'most = len(words)', label: 'Count total' }], correct: 0 },
            { type: 'pair', prompt: 'Match set operations', pairs: [{ id: 1, left: 'a | b', right: 'Union' }, { id: 2, left: 'a & b', right: 'Intersection' }, { id: 3, left: 'a - b', right: 'Difference' }, { id: 4, left: 'a ^ b', right: 'Symmetric diff' }] },
        ],
        19: [
            { type: 'scramble', prompt: 'Find duplicates in a list', pieces: [{ id: 'a', text: 'def find_dupes(lst):' }, { id: 'b', text: '    seen = set()' }, { id: 'c', text: '    dupes = set()' }, { id: 'd', text: '    for x in lst:' }, { id: 'e', text: '        if x in seen: dupes.add(x)' }, { id: 'f', text: '        seen.add(x)' }, { id: 'g', text: '    return list(dupes)' }], distractors: [{ id: 'h', text: '    return lst' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f', 'g'] },
            { type: 'trace', prompt: 'Set operations?', code: [{ text: 'a = {1, 2, 3, 4}' }, { text: 'b = {3, 4, 5, 6}' }, { text: 'print(a & b)', highlight: true }], options: ['{3, 4}', '{1,2,3,4,5,6}', '{1,2}', '{5,6}'], correct: 0 },
            { type: 'realworld', prompt: 'Remove duplicates preserving order?', scenario: '📋 [3, 1, 4, 1, 5, 9, 2, 6, 5] → [3,1,4,5,9,2,6]', options: [{ code: 'seen = set()\nresult = []\nfor x in lst:\n    if x not in seen:\n        seen.add(x)\n        result.append(x)', label: 'Set + list (ordered)' }, { code: 'result = list(set(lst))', label: 'set() — loses order' }, { code: 'result = sorted(set(lst))', label: 'sorted set' }, { code: 'result = lst', label: 'No change' }], correct: 0 },
            { type: 'output', prompt: 'Dictionary merge?', code: [{ text: 'a = {"x": 1, "y": 2}' }, { text: 'b = {"y": 3, "z": 4}' }, { text: 'merged = {**a, **b}' }, { text: 'print(merged["y"])' }], terminalOutput: '3', options: ['2', '3', '[2,3]', 'Error'], correct: 1 },
        ],
        20: [
            { type: 'pair', prompt: 'Best use-case for each', pairs: [{ id: 1, left: 'List', right: 'Ordered, index access' }, { id: 2, left: 'Set', right: 'Unique + fast lookup' }, { id: 3, left: 'Dict', right: 'Key-value mapping' }, { id: 4, left: 'Tuple', right: 'Immutable sequence' }] },
            { type: 'trace', prompt: 'Tuple unpacking?', code: [{ text: 'point = (3, 7)' }, { text: 'x, y = point' }, { text: 'print(x + y)', highlight: true }], options: ['(3,7)', '10', '37', 'Error'], correct: 1 },
            { type: 'realworld', prompt: 'Which data structure for a phone book?', scenario: '📱 Look up phone number by name.', options: [{ code: 'phonebook = {"Ali": "555-1234", "Ece": "555-5678"}', label: 'Dict — O(1) lookup' }, { code: 'phonebook = [("Ali","555-1234"), ("Ece","555-5678")]', label: 'List of tuples — O(n)' }, { code: 'phonebook = {"555-1234", "555-5678"}', label: 'Set — no keys' }, { code: 'phonebook = ["Ali", "555-1234"]', label: 'Flat list' }], correct: 0 },
        ],
        // ═══ CH6: ALGORITHMS I ⭐⭐⭐ ═══
        21: [
            { type: 'algostep', prompt: 'Selection sort: find min in [64,25,12,22,11]', array: [64, 25, 12, 22, 11], step: 1, description: 'Scanning for minimum...', question: 'Min goes where?', options: ['11→index 0', '12→index 0', '22→index 1', '25→index 0'], correct: 0 },
            { type: 'trace', prompt: 'After ONE bubble sort pass on [5,1,4,2,8]?', code: [{ text: '# Compare adjacent, swap if needed' }, { text: '[5,1]→swap [1,5,4,2,8]' }, { text: '[5,4]→swap [1,4,5,2,8]' }, { text: '[5,2]→swap [1,4,2,5,8]' }, { text: '[5,8]→ok   [1,4,2,5,8]', highlight: true }], options: ['Largest at end', 'Array sorted', 'Smallest at start', 'Nothing guaranteed'], correct: 0 },
            { type: 'realworld', prompt: 'Best sort for nearly-sorted data?', scenario: '📊 Array 95% sorted, 2 elements misplaced.', options: [{ code: '# Insertion sort: O(n) best case', label: 'Insertion sort' }, { code: '# Merge sort: O(n log n) always', label: 'Merge sort' }, { code: '# Quick sort: O(n²) worst case', label: 'Quick sort' }, { code: '# Selection sort: O(n²) always', label: 'Selection sort' }], correct: 0 },
            { type: 'pair', prompt: 'Match sort to worst case', pairs: [{ id: 1, left: 'Bubble', right: 'O(n²)' }, { id: 2, left: 'Merge', right: 'O(n log n)' }, { id: 3, left: 'Insertion (best)', right: 'O(n)' }, { id: 4, left: 'Python sorted()', right: 'Timsort O(n log n)' }] },
            { type: 'scramble', prompt: 'Build insertion sort', pieces: [{ id: 'a', text: 'def insertion_sort(arr):' }, { id: 'b', text: '    for i in range(1, len(arr)):' }, { id: 'c', text: '        key = arr[i]' }, { id: 'd', text: '        j = i - 1' }, { id: 'e', text: '        while j >= 0 and arr[j] > key:' }, { id: 'f', text: '            arr[j+1] = arr[j]; j -= 1' }, { id: 'g', text: '        arr[j+1] = key' }], distractors: [{ id: 'h', text: '        arr[j] = key' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f', 'g'] },
        ],
        22: [
            { type: 'algostep', prompt: 'Binary search for 7 in [1,3,5,7,9,11,13]', array: [1, 3, 5, 7, 9, 11, 13], step: 1, description: 'Lo=0 Hi=6 Mid=3 arr[3]=7=target!', question: 'Comparisons needed?', options: ['1', '2', '3', '7'], correct: 0 },
            { type: 'trace', prompt: 'Search for 6 in [1,3,5,7,9]?', code: [{ text: 'def bsearch(arr, t):' }, { text: '    lo, hi = 0, len(arr)-1' }, { text: '    while lo <= hi:' }, { text: '        mid = (lo+hi)//2' }, { text: '        if arr[mid]==t: return mid' }, { text: '        elif arr[mid]<t: lo=mid+1' }, { text: '        else: hi=mid-1' }, { text: '    return -1', highlight: true }], options: ['Returns 2', 'Returns 3', 'Returns -1', 'Infinite loop'], correct: 2 },
            { type: 'errordecode', prompt: 'Why can binary search fail?', errorText: 'mid = (lo + hi) / 2  # float in Python 3!\n# In Java/C: (lo+hi) can overflow!', question: 'Safe mid calc?', options: ['lo + (hi-lo)//2', '(lo+hi) % 2', 'hi - lo', 'lo * hi'], correct: 0 },
            { type: 'realworld', prompt: 'Binary search requires what?', scenario: '⚠️ Precondition for binary search to work.', options: [{ code: '# Array MUST be sorted', label: 'Sorted array' }, { code: '# Array must have unique elements', label: 'Unique elements' }, { code: '# Array must be small', label: 'Small array' }, { code: '# No precondition', label: 'Works on anything' }], correct: 0 },
            { type: 'fillgap', prompt: 'Complete: find first occurrence', codeParts: [{ text: 'def first_occur(arr, t):\n    lo, hi, result = 0, len(arr)-1, -1\n    while lo <= hi:\n        mid = (lo+hi)//2\n        if arr[mid] == t:\n            ', type: 'fixed' }, { text: 'result = mid; hi = mid - 1', type: 'gap', id: 'g1' }, { text: '\n        elif arr[mid] < t: lo = mid+1\n        else: hi = mid-1\n    return result', type: 'fixed' }], bank: ['result = mid; hi = mid - 1', 'return mid', 'lo = mid + 1', 'break'], correctFill: { g1: 'result = mid; hi = mid - 1' } },
        ],
        23: [
            { type: 'trace', prompt: 'Time complexity?', code: [{ text: 'for i in range(n):' }, { text: '    for j in range(n):' }, { text: '        print(i, j)' }], options: ['O(n)', 'O(n²)', 'O(n log n)', 'O(2ⁿ)'], correct: 1 },
            { type: 'realworld', prompt: 'Search 1M sorted items?', scenario: '🔍 1,000,000 sorted integers.', options: [{ code: '# Binary: O(log n) ≈ 20 steps', label: '~20 comparisons' }, { code: '# Linear: O(n) ≈ 1M steps', label: '~1M comparisons' }, { code: '# Same in practice', label: 'Same speed' }, { code: '# Hash: always O(1)', label: 'Instant' }], correct: 0 },
            { type: 'pair', prompt: 'Match complexity', pairs: [{ id: 1, left: 'Binary Search', right: 'O(log n)' }, { id: 2, left: 'Bubble Sort', right: 'O(n²)' }, { id: 3, left: 'Merge Sort', right: 'O(n log n)' }, { id: 4, left: 'Hash Lookup', right: 'O(1) avg' }] },
            { type: 'trace', prompt: 'This loop complexity?', code: [{ text: 'i = n' }, { text: 'while i > 0:' }, { text: '    print(i)' }, { text: '    i = i // 2', highlight: true }], options: ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'], correct: 1 },
            { type: 'refactor', prompt: 'Which is faster for checking membership?', originalCode: '# Check if x exists in list\nif x in my_list:  # O(n)', options: [{ code: 'my_set = set(my_list)\nif x in my_set:  # O(1)', label: 'Convert to set — O(1) lookup' }, { code: 'my_list.sort()\nbisect.bisect(my_list, x)', label: 'Sort + bisect — O(n log n)' }, { code: 'for item in my_list:\n    if item == x: break', label: 'Still O(n)' }], correct: 0 },
        ],
        24: [
            { type: 'trace', prompt: 'Two-sum brute force?', code: [{ text: 'def two_sum(nums, t):' }, { text: '    for i in range(len(nums)):' }, { text: '        for j in range(i+1, len(nums)):' }, { text: '            if nums[i]+nums[j]==t:' }, { text: '                return [i,j]' }, { text: 'print(two_sum([2,7,11,15], 9))', highlight: true }], options: ['[0, 1]', '[1, 2]', '[0, 3]', 'None'], correct: 0 },
            { type: 'refactor', prompt: 'O(n²)→O(n) two-sum?', originalCode: '# O(n²)\nfor i in range(len(nums)):\n    for j in range(i+1, len(nums)):\n        if nums[i]+nums[j]==target: return [i,j]', options: [{ code: 'seen = {}\nfor i, n in enumerate(nums):\n    comp = target - n\n    if comp in seen: return [seen[comp], i]\n    seen[n] = i', label: 'Hash map — O(n)' }, { code: 'nums.sort()\nlo, hi = 0, len(nums)-1', label: 'Sort + two pointer' }, { code: '[nums.index(target-n) for n in nums]', label: 'Still O(n²)' }], correct: 0 },
            { type: 'scramble', prompt: 'Build O(n) two-sum', pieces: [{ id: 'a', text: 'def two_sum(nums, target):' }, { id: 'b', text: '    seen = {}' }, { id: 'c', text: '    for i, n in enumerate(nums):' }, { id: 'd', text: '        comp = target - n' }, { id: 'e', text: '        if comp in seen:' }, { id: 'f', text: '            return [seen[comp], i]' }, { id: 'g', text: '        seen[n] = i' }], distractors: [{ id: 'h', text: '        seen[i] = n' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f', 'g'] },
            { type: 'output', prompt: 'Complexity of this?', code: [{ text: '# Hash map solution' }, { text: '# One pass through array: O(n)' }, { text: '# Each lookup in dict: O(1)' }, { text: '# Total:', highlight: true }], terminalOutput: 'O(n)', options: ['O(n²)', 'O(n)', 'O(n log n)', 'O(1)'], correct: 1 },
        ],
        // ═══ CH7: DATA STRUCTURES II ⭐⭐⭐ ═══
        25: [
            { type: 'trace', prompt: 'Stack: push 1,2,3 then pop twice?', code: [{ text: 'stack = []' }, { text: 'stack.append(1); stack.append(2); stack.append(3)' }, { text: 'stack.pop(); stack.pop()' }, { text: 'print(stack)', highlight: true }], options: ['[1]', '[3]', '[1,2]', '[]'], correct: 0 },
            { type: 'realworld', prompt: 'Balanced parentheses?', scenario: '🔍 "({[]})" → True, "({[)}" → False', options: [{ code: '# Stack: push open, pop on close', label: 'Stack — LIFO' }, { code: '# Queue: FIFO', label: 'Queue' }, { code: '# Counter only', label: 'Counter' }, { code: '# Set', label: 'Set' }], correct: 0 },
            { type: 'pair', prompt: 'Match concepts', pairs: [{ id: 1, left: 'Stack', right: 'LIFO' }, { id: 2, left: 'Queue', right: 'FIFO' }, { id: 3, left: 'Deque', right: 'Double-ended' }, { id: 4, left: 'Priority Queue', right: 'Min/Max first' }] },
            { type: 'scramble', prompt: 'Check balanced brackets', pieces: [{ id: 'a', text: 'def is_valid(s):' }, { id: 'b', text: '    stack = []' }, { id: 'c', text: '    pairs = {")":"(", "]":"[", "}":"{"}' }, { id: 'd', text: '    for c in s:' }, { id: 'e', text: '        if c in "([{": stack.append(c)' }, { id: 'f', text: '        elif not stack or stack.pop() != pairs[c]:' }, { id: 'g', text: '            return False' }, { id: 'h', text: '    return len(stack) == 0' }], distractors: [{ id: 'i', text: '    return True' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'] },
            { type: 'trace', prompt: 'Queue with deque?', code: [{ text: 'from collections import deque' }, { text: 'q = deque()' }, { text: 'q.append("A"); q.append("B"); q.append("C")' }, { text: 'print(q.popleft(), q.popleft())', highlight: true }], options: ['A B', 'C B', 'A C', 'B C'], correct: 0 },
        ],
        26: [
            { type: 'trace', prompt: 'head.next.val?', code: [{ text: 'class Node:' }, { text: '    def __init__(self, val): self.val=val; self.next=None' }, { text: 'a=Node(1); b=Node(2); c=Node(3)' }, { text: 'a.next=b; b.next=c' }, { text: 'print(a.next.val)', highlight: true }], options: ['1', '2', '3', 'None'], correct: 1 },
            { type: 'scramble', prompt: 'Traverse linked list', pieces: [{ id: 'a', text: 'def traverse(head):' }, { id: 'b', text: '    curr = head' }, { id: 'c', text: '    while curr:' }, { id: 'd', text: '        print(curr.val)' }, { id: 'e', text: '        curr = curr.next' }], distractors: [{ id: 'f', text: '        curr = curr.prev' }], correctOrder: ['a', 'b', 'c', 'd', 'e'] },
            { type: 'realworld', prompt: 'When use linked list over array?', scenario: '🤔 Which scenario benefits from linked list?', options: [{ code: '# Frequent insert/delete at beginning: O(1)', label: 'Fast insert at head' }, { code: '# Random access by index', label: 'Index access — array better' }, { code: '# Sorting data', label: 'Sorting — array better' }, { code: '# Binary search', label: 'Binary search — array' }], correct: 0 },
            { type: 'trace', prompt: 'Reverse a linked list — what happens?', code: [{ text: 'prev = None; curr = head' }, { text: 'while curr:' }, { text: '    nxt = curr.next' }, { text: '    curr.next = prev' }, { text: '    prev = curr' }, { text: '    curr = nxt' }, { text: '# prev is now new head', highlight: true }], options: ['List reversed in O(n)', 'List unchanged', 'Error', 'O(n²)'], correct: 0 },
        ],
        27: [
            { type: 'trace', prompt: 'In-order BST traversal?', code: [{ text: '#       4' }, { text: '#      / \\' }, { text: '#     2   6' }, { text: '#    / \\' }, { text: '#   1   3' }, { text: '# In-order: L→Root→R', highlight: true }], options: ['4 2 1 3 6', '1 2 3 4 6', '1 3 2 6 4', '4 2 6 1 3'], correct: 1 },
            { type: 'pair', prompt: 'Match traversals', pairs: [{ id: 1, left: 'In-order', right: 'L→Root→R (sorted!)' }, { id: 2, left: 'Pre-order', right: 'Root→L→R' }, { id: 3, left: 'Post-order', right: 'L→R→Root' }, { id: 4, left: 'Level-order', right: 'BFS layer by layer' }] },
            { type: 'realworld', prompt: 'Why is BST in-order special?', scenario: '🌳 Binary Search Tree in-order traversal gives...', options: [{ code: '# Sorted order! O(n) to get all sorted', label: 'Sorted output' }, { code: '# Reverse order', label: 'Reverse sorted' }, { code: '# Random order', label: 'Random' }, { code: '# Level by level', label: 'BFS order' }], correct: 0 },
            { type: 'trace', prompt: 'BST search for 3?', code: [{ text: '#     4 → 3<4, go left' }, { text: '#    / \\' }, { text: '#   2   6 → 3>2, go right' }, { text: '#  / \\' }, { text: '# 1   3 → Found! O(log n)', highlight: true }], options: ['2 comparisons', '3 comparisons', '4 comparisons', '1 comparison'], correct: 0 },
        ],
        28: [
            { type: 'video', title: 'Data Structures Visualized', description: 'Stacks, queues, linked lists, trees — when to use each, trade-offs, and real-world applications.', duration: '4:00', thumbnail: '🎥' },
            { type: 'pair', prompt: 'Match structure to operation speed', pairs: [{ id: 1, left: 'Array[i]', right: 'O(1)' }, { id: 2, left: 'LinkedList insert at head', right: 'O(1)' }, { id: 3, left: 'BST search', right: 'O(log n) avg' }, { id: 4, left: 'Array insert at start', right: 'O(n)' }] },
        ],
        // ═══ CH8: ALGORITHMS II ⭐⭐⭐⭐ ═══
        29: [
            { type: 'trace', prompt: 'Tower of Hanoi: 3 disks = ? moves', code: [{ text: 'def hanoi(n):' }, { text: '    if n == 1: return 1' }, { text: '    return 2 * hanoi(n-1) + 1' }, { text: 'print(hanoi(3))', highlight: true }], options: ['3', '5', '7', '8'], correct: 2 },
            { type: 'realworld', prompt: 'Which is naturally recursive?', scenario: '🤔 Same-type subproblems?', options: [{ code: '# Directory tree: folders in folders', label: 'File system ✓' }, { code: '# Read file line by line', label: 'Sequential' }, { code: '# Print "Hi" 5 times', label: 'Loop' }, { code: '# Add two nums', label: 'Simple op' }], correct: 0 },
            { type: 'trace', prompt: 'sum_digits(1234)?', code: [{ text: 'def sum_digits(n):' }, { text: '    if n < 10: return n' }, { text: '    return n%10 + sum_digits(n//10)' }, { text: 'print(sum_digits(1234))', highlight: true }], options: ['10', '1234', '4', '24'], correct: 0 },
            { type: 'output', prompt: 'Recursive power complexity?', code: [{ text: 'def power(b, e):' }, { text: '    if e == 0: return 1' }, { text: '    if e % 2 == 0:' }, { text: '        h = power(b, e//2)' }, { text: '        return h * h' }, { text: '    return b * power(b, e-1)' }, { text: '# Halves each time!', highlight: true }], terminalOutput: 'O(log n)', options: ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'], correct: 1 },
            { type: 'scramble', prompt: 'Build binary search recursively', pieces: [{ id: 'a', text: 'def bsearch(arr, t, lo, hi):' }, { id: 'b', text: '    if lo > hi: return -1' }, { id: 'c', text: '    mid = (lo+hi)//2' }, { id: 'd', text: '    if arr[mid] == t: return mid' }, { id: 'e', text: '    elif arr[mid] < t: return bsearch(arr,t,mid+1,hi)' }, { id: 'f', text: '    else: return bsearch(arr,t,lo,mid-1)' }], distractors: [{ id: 'g', text: '    return bsearch(arr,t,lo,hi)' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f'] },
        ],
        30: [
            { type: 'algostep', prompt: 'Merge [1,3,5] and [2,4,6]', array: [1, 3, 5, 2, 4, 6], step: 1, description: 'Compare: 1<2, take 1. Left:[3,5] Right:[2,4,6]', question: 'Next comparison?', options: ['3 vs 2', '1 vs 2', '5 vs 6', '3 vs 4'], correct: 0 },
            { type: 'trace', prompt: 'Merge sort time complexity?', code: [{ text: '# Divide in half: log₂(n) levels' }, { text: '# Merge: O(n) per level' }, { text: '# Total: O(n × log n)', highlight: true }], options: ['O(n)', 'O(n²)', 'O(n log n)', 'O(log n)'], correct: 2 },
            { type: 'scramble', prompt: 'Build merge function', pieces: [{ id: 'a', text: 'def merge(left, right):' }, { id: 'b', text: '    result = []; i = j = 0' }, { id: 'c', text: '    while i<len(left) and j<len(right):' }, { id: 'd', text: '        if left[i]<=right[j]: result.append(left[i]); i+=1' }, { id: 'e', text: '        else: result.append(right[j]); j+=1' }, { id: 'f', text: '    result += left[i:] + right[j:]' }, { id: 'g', text: '    return result' }], distractors: [{ id: 'h', text: '    return left + right' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f', 'g'] },
            { type: 'pair', prompt: 'Divide & Conquer examples', pairs: [{ id: 1, left: 'Merge Sort', right: 'Split array, sort halves' }, { id: 2, left: 'Quick Sort', right: 'Partition around pivot' }, { id: 3, left: 'Binary Search', right: 'Halve search space' }, { id: 4, left: 'Strassen', right: 'Matrix multiply' }] },
        ],
        31: [
            { type: 'trace', prompt: 'fib(5) calls WITHOUT memo?', code: [{ text: 'def fib(n):' }, { text: '    if n<=1: return n' }, { text: '    return fib(n-1)+fib(n-2)' }, { text: '# fib(5) call tree has 15 calls!', highlight: true }], options: ['5', '9', '15', '25'], correct: 2 },
            { type: 'refactor', prompt: 'O(2ⁿ) fib → O(n)?', originalCode: 'def fib(n):\n    if n<=1: return n\n    return fib(n-1)+fib(n-2)', options: [{ code: 'memo = {}\ndef fib(n):\n    if n in memo: return memo[n]\n    if n<=1: return n\n    memo[n] = fib(n-1)+fib(n-2)\n    return memo[n]', label: 'Memoization — O(n)' }, { code: 'def fib(n):\n    return n if n<=1 else fib(n-1)+fib(n-2)', label: 'Still O(2ⁿ)' }, { code: 'import math\ndef fib(n): return math.factorial(n)', label: 'Wrong formula' }], correct: 0 },
            { type: 'realworld', prompt: 'Min coins for 11 using [1,5,6]?', scenario: '💰 Coins: [1,5,6]. Make 11.', options: [{ code: '# DP: dp[11] = min(dp[10]+1, dp[6]+1, dp[5]+1)\n# = min(3, 2, 3) = 2 coins (6+5)', label: '2 coins (6+5)' }, { code: '# Greedy: 6+5 = 2 (works here)', label: '2 (greedy=DP here)' }, { code: '# 11 ones', label: '11 coins' }, { code: '# 5+5+1', label: '3 coins' }], correct: 0 },
            { type: 'fillgap', prompt: 'Complete: climbing stairs DP', codeParts: [{ text: 'def climb(n):\n    if n<=2: return n\n    dp = [0]*(n+1)\n    dp[1], dp[2] = 1, 2\n    for i in range(3, n+1):\n        ', type: 'fixed' }, { text: 'dp[i] = dp[i-1] + dp[i-2]', type: 'gap', id: 'g1' }, { text: '\n    return dp[n]', type: 'fixed' }], bank: ['dp[i] = dp[i-1] + dp[i-2]', 'dp[i] = dp[i-1] * 2', 'dp[i] = i', 'dp[i] = dp[i-1]'], correctFill: { g1: 'dp[i] = dp[i-1] + dp[i-2]' } },
            { type: 'trace', prompt: 'Climbing stairs n=5?', code: [{ text: '# dp[1]=1, dp[2]=2' }, { text: '# dp[3]=3, dp[4]=5' }, { text: '# dp[5] = dp[4]+dp[3] = ?', highlight: true }], options: ['5', '7', '8', '13'], correct: 2 },
        ],
        32: [
            { type: 'trace', prompt: 'Fast power: power(2,10)?', code: [{ text: 'def power(b, e):' }, { text: '    if e==0: return 1' }, { text: '    if e%2==0: h=power(b,e//2); return h*h' }, { text: '    return b*power(b,e-1)' }, { text: 'print(power(2, 10))', highlight: true }], options: ['20', '100', '512', '1024'], correct: 3 },
            { type: 'output', prompt: 'Its complexity?', code: [{ text: '# power(2,10)→power(2,5)→power(2,4)' }, { text: '# →power(2,2)→power(2,1)→power(2,0)', highlight: true }], terminalOutput: 'O(log n)', options: ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'], correct: 1 },
            { type: 'scramble', prompt: 'Build memoized fibonacci', pieces: [{ id: 'a', text: 'memo = {}' }, { id: 'b', text: 'def fib(n):' }, { id: 'c', text: '    if n in memo: return memo[n]' }, { id: 'd', text: '    if n <= 1: return n' }, { id: 'e', text: '    memo[n] = fib(n-1) + fib(n-2)' }, { id: 'f', text: '    return memo[n]' }], distractors: [{ id: 'g', text: '    return fib(n)' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f'] },
            { type: 'realworld', prompt: 'When does DP help?', scenario: '🧠 DP works when problem has...', options: [{ code: '# 1. Overlapping subproblems\n# 2. Optimal substructure', label: 'Both conditions ✓' }, { code: '# Only overlapping subproblems', label: 'One condition' }, { code: '# Any recursive problem', label: 'Not always' }, { code: '# Only sorting problems', label: 'Sorting only' }], correct: 0 },
        ],
        // ═══ CH9: ADVANCED ⭐⭐⭐⭐ ═══
        33: [
            { type: 'pair', prompt: 'Match graph terms', pairs: [{ id: 1, left: 'Adjacency List', right: 'Dict of neighbors' }, { id: 2, left: 'Adjacency Matrix', right: '2D array' }, { id: 3, left: 'Directed', right: 'One-way edges' }, { id: 4, left: 'Undirected', right: 'Two-way edges' }] },
            { type: 'realworld', prompt: 'Best graph application?', scenario: '🌍 Real-world graph.', options: [{ code: '# Social network: users=nodes, friends=edges', label: 'Social network' }, { code: '# To-do list', label: 'List' }, { code: '# Calculator', label: 'Calculator' }, { code: '# Timer', label: 'Counter' }], correct: 0 },
            { type: 'output', prompt: 'Adjacency list for A→B, A→C, B→C?', code: [{ text: 'graph = {' }, { text: '    "A": ["B", "C"],' }, { text: '    "B": ["C"],' }, { text: '    "C": []' }, { text: '}' }, { text: 'print(len(graph["A"]))' }], terminalOutput: '2', options: ['1', '2', '3', '0'], correct: 1 },
            { type: 'trace', prompt: 'How many edges in this undirected graph?', code: [{ text: '# A--B, A--C, B--C (triangle)' }, { text: '# Each edge stored twice in adj list' }, { text: '# Total entries in adj lists: 6' }, { text: '# Actual edges:', highlight: true }], options: ['3', '6', '2', '9'], correct: 0 },
        ],
        34: [
            { type: 'trace', prompt: 'BFS from A. Visit order?', code: [{ text: '# A→[B,C], B→[D], C→[D], D→[]' }, { text: 'def bfs(start, graph):' }, { text: '    q = deque([start]); seen = {start}' }, { text: '    while q:' }, { text: '        node = q.popleft(); print(node)' }, { text: '        for n in graph[node]:' }, { text: '            if n not in seen:' }, { text: '                seen.add(n); q.append(n)', highlight: true }], options: ['A B C D', 'A B D C', 'A C B D', 'D B C A'], correct: 0 },
            { type: 'refactor', prompt: 'Cycle detection in directed graph?', originalCode: '# Naive: just "visited" set\n# Cannot distinguish exploring vs explored', options: [{ code: '# 3-color: WHITE→GRAY→BLACK\n# Cycle = visiting GRAY node', label: 'Three-color ✓' }, { code: '# Simple visited set', label: 'Incomplete' }, { code: '# Count edges vs nodes', label: 'Wrong' }], correct: 0 },
            { type: 'realworld', prompt: 'BFS vs DFS — when use BFS?', scenario: '🗺️ Finding shortest path in unweighted graph.', options: [{ code: '# BFS: guarantees shortest path\n# Explores level by level', label: 'BFS — shortest path' }, { code: '# DFS: goes deep first', label: 'DFS — no shortest guarantee' }, { code: '# Both give same path', label: 'Same result' }, { code: '# Neither works', label: 'Neither' }], correct: 0 },
            { type: 'pair', prompt: 'BFS vs DFS', pairs: [{ id: 1, left: 'BFS', right: 'Queue (FIFO)' }, { id: 2, left: 'DFS', right: 'Stack (LIFO)' }, { id: 3, left: 'BFS use', right: 'Shortest path' }, { id: 4, left: 'DFS use', right: 'Cycle detection' }] },
        ],
        35: [
            { type: 'trace', prompt: 'Two-pointer: pair summing to 6 in [1,2,3,4,6]?', code: [{ text: 'lo, hi = 0, 4  # 1+6=7>6' }, { text: 'hi -= 1        # 1+4=5<6' }, { text: 'lo += 1        # 2+4=6 ✓', highlight: true }], options: ['indices [1,5]', 'indices [0,4]', 'indices [1,3]', 'indices [2,3]'], correct: 2 },
            { type: 'refactor', prompt: 'O(n²) duplicates → O(n)?', originalCode: 'for i in range(len(arr)):\n    for j in range(i+1, len(arr)):\n        if arr[i]==arr[j]: return True', options: [{ code: 'return len(arr) != len(set(arr))', label: 'Set — O(n)' }, { code: 'arr.sort()\nfor i in range(len(arr)-1):\n    if arr[i]==arr[i+1]: return True', label: 'Sort — O(n log n)' }, { code: 'from collections import Counter\nreturn max(Counter(arr).values())>1', label: 'Counter — O(n)' }], correct: 0 },
            { type: 'fillgap', prompt: 'Sliding window: max sum of k consecutive', codeParts: [{ text: 'def max_sum(arr, k):\n    window = sum(arr[:k])\n    best = window\n    for i in range(k, len(arr)):\n        ', type: 'fixed' }, { text: 'window += arr[i] - arr[i-k]', type: 'gap', id: 'g1' }, { text: '\n        best = max(best, window)\n    return best', type: 'fixed' }], bank: ['window += arr[i] - arr[i-k]', 'window = sum(arr[i-k:i])', 'window += arr[i]', 'window = arr[i]'], correctFill: { g1: 'window += arr[i] - arr[i-k]' } },
            { type: 'realworld', prompt: 'Sliding window complexity?', scenario: '📊 Instead of recalculating sum each time...', options: [{ code: '# Slide: add new, remove old = O(n)\n# vs recalculate: O(n*k)', label: 'O(n) — add/remove trick' }, { code: '# O(n*k) — recompute each time', label: 'O(n*k)' }, { code: '# O(n²)', label: 'O(n²)' }, { code: '# O(1)', label: 'O(1)' }], correct: 0 },
            { type: 'trace', prompt: 'Remove duplicates in-place from sorted?', code: [{ text: 'arr = [1,1,2,2,3]' }, { text: 'w = 1  # write pointer' }, { text: 'for r in range(1, len(arr)):' }, { text: '    if arr[r] != arr[r-1]:' }, { text: '        arr[w] = arr[r]; w += 1' }, { text: 'print(arr[:w])', highlight: true }], options: ['[1,2,3]', '[1,1,2]', '[2,3]', '[1,2,2,3]'], correct: 0 },
        ],
        36: [
            { type: 'scramble', prompt: 'Build BFS', pieces: [{ id: 'a', text: 'from collections import deque' }, { id: 'b', text: 'def bfs(graph, start):' }, { id: 'c', text: '    q = deque([start])' }, { id: 'd', text: '    visited = {start}' }, { id: 'e', text: '    while q:' }, { id: 'f', text: '        node = q.popleft()' }, { id: 'g', text: '        for nb in graph[node]:' }, { id: 'h', text: '            if nb not in visited:' }, { id: 'i', text: '                visited.add(nb); q.append(nb)' }], distractors: [{ id: 'j', text: '        q.append(node)' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'] },
            { type: 'trace', prompt: 'DFS from A?', code: [{ text: '# A→[B,C], B→[D], C→[], D→[]' }, { text: 'def dfs(node, graph, seen=set()):' }, { text: '    if node in seen: return' }, { text: '    seen.add(node); print(node)' }, { text: '    for n in graph[node]: dfs(n, graph, seen)', highlight: true }], options: ['A B D C', 'A B C D', 'A C B D', 'D B C A'], correct: 0 },
            { type: 'realworld', prompt: 'Graph for GPS navigation?', scenario: '🗺️ Find shortest route between cities.', options: [{ code: '# Weighted graph + Dijkstra\n# Nodes=cities, edges=roads with distance', label: 'Weighted graph ✓' }, { code: '# Simple array of cities', label: 'Array' }, { code: '# Unweighted BFS', label: 'Missing distances' }, { code: '# Binary tree', label: 'Not a tree' }], correct: 0 },
        ],
        // ═══ CH10: MASTERY ⭐⭐⭐⭐ ═══
        37: [
            { type: 'trace', prompt: 'Climbing stairs n=4?', code: [{ text: '# dp[0]=1, dp[1]=1' }, { text: '# dp[2] = dp[1]+dp[0] = 2' }, { text: '# dp[3] = dp[2]+dp[1] = 3' }, { text: '# dp[4] = dp[3]+dp[2] = ?', highlight: true }], options: ['4', '5', '6', '8'], correct: 1 },
            { type: 'realworld', prompt: 'Which is a DP problem?', scenario: '🧠 Overlapping subproblems + optimal substructure?', options: [{ code: '# Longest Common Subsequence\n# LCS("ABCDE","ACE")="ACE"', label: 'LCS — classic DP' }, { code: '# Find max in array', label: 'Simple scan' }, { code: '# Print all elements', label: 'Traverse' }, { code: '# Swap variables', label: 'Basic op' }], correct: 0 },
            { type: 'pair', prompt: 'Match DP patterns', pairs: [{ id: 1, left: 'Fibonacci', right: 'dp[i]=dp[i-1]+dp[i-2]' }, { id: 2, left: 'Knapsack', right: 'Include or exclude item' }, { id: 3, left: 'LCS', right: 'Match or skip chars' }, { id: 4, left: 'Coin Change', right: 'min(dp[amt-coin]+1)' }] },
            { type: 'fillgap', prompt: 'Complete: 0/1 Knapsack', codeParts: [{ text: 'def knapsack(W, wt, val, n):\n    dp = [[0]*(W+1) for _ in range(n+1)]\n    for i in range(1, n+1):\n        for w in range(1, W+1):\n            if wt[i-1] <= w:\n                ', type: 'fixed' }, { text: 'dp[i][w] = max(val[i-1]+dp[i-1][w-wt[i-1]], dp[i-1][w])', type: 'gap', id: 'g1' }, { text: '\n            else:\n                dp[i][w] = dp[i-1][w]\n    return dp[n][W]', type: 'fixed' }], bank: ['dp[i][w] = max(val[i-1]+dp[i-1][w-wt[i-1]], dp[i-1][w])', 'dp[i][w] = val[i-1]', 'dp[i][w] = dp[i-1][w] + 1', 'dp[i][w] = w'], correctFill: { g1: 'dp[i][w] = max(val[i-1]+dp[i-1][w-wt[i-1]], dp[i-1][w])' } },
        ],
        38: [
            { type: 'refactor', prompt: 'Primes up to n — best approach?', originalCode: '# Brute: O(n√n)\nfor i in range(2, n+1):\n    if is_prime(i): result.append(i)', options: [{ code: '# Sieve of Eratosthenes: O(n log log n)\nsieve = [True]*(n+1)\nfor i in range(2, int(n**0.5)+1):\n    if sieve[i]:\n        for j in range(i*i, n+1, i):\n            sieve[j] = False', label: 'Sieve — much faster' }, { code: '# Check all divisors', label: 'Still brute' }, { code: '# Random testing', label: 'Probabilistic' }], correct: 0 },
            { type: 'pair', prompt: 'Match pattern to problem', pairs: [{ id: 1, left: 'Sliding window', right: 'Max subarray of size k' }, { id: 2, left: 'Two pointer', right: 'Pair sum sorted' }, { id: 3, left: 'BFS', right: 'Shortest path unweighted' }, { id: 4, left: 'DP', right: 'Min coins for amount' }] },
            { type: 'realworld', prompt: 'Problem-solving strategy?', scenario: '🎯 You get a hard problem in an interview.', options: [{ code: '# 1. Brute force first\n# 2. Identify pattern\n# 3. Optimize with right DS\n# 4. Code + test edge cases', label: 'Structured approach ✓' }, { code: '# Jump to optimal solution', label: 'Risky' }, { code: '# Give up', label: 'Never!' }, { code: '# Memorize solutions', label: 'Not scalable' }], correct: 0 },
            { type: 'scramble', prompt: 'Build Sieve of Eratosthenes', pieces: [{ id: 'a', text: 'def sieve(n):' }, { id: 'b', text: '    is_prime = [True] * (n+1)' }, { id: 'c', text: '    is_prime[0] = is_prime[1] = False' }, { id: 'd', text: '    for i in range(2, int(n**0.5)+1):' }, { id: 'e', text: '        if is_prime[i]:' }, { id: 'f', text: '            for j in range(i*i, n+1, i):' }, { id: 'g', text: '                is_prime[j] = False' }, { id: 'h', text: '    return [i for i in range(n+1) if is_prime[i]]' }], distractors: [{ id: 'i', text: '            is_prime[i] = False' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'] },
        ],
        39: [
            { type: 'fillgap', prompt: 'Reverse string in-place', codeParts: [{ text: 'def reverse(s):\n    lo, hi = 0, len(s)-1\n    while lo < hi:\n        ', type: 'fixed' }, { text: 's[lo], s[hi] = s[hi], s[lo]', type: 'gap', id: 'g1' }, { text: '\n        lo += 1; hi -= 1', type: 'fixed' }], bank: ['s[lo], s[hi] = s[hi], s[lo]', 's.reverse()', 'lo, hi = hi, lo', 's[lo] = s[hi]'], correctFill: { g1: 's[lo], s[hi] = s[hi], s[lo]' } },
            { type: 'terminal', prompt: 'FizzBuzz 1-15', expectedCommands: ['for i in range(1, 16):', '    if i%15==0: print("FizzBuzz")', '    elif i%3==0: print("Fizz")', '    elif i%5==0: print("Buzz")', '    else: print(i)'], hint: 'Check 15 first!', terminalHistory: [{ type: 'system', text: '>>> Interview: FizzBuzz' }] },
            { type: 'trace', prompt: 'Valid palindrome check?', code: [{ text: 'def is_palindrome(s):' }, { text: '    s = s.lower()' }, { text: '    s = "".join(c for c in s if c.isalnum())' }, { text: '    return s == s[::-1]' }, { text: 'print(is_palindrome("A man, a plan, a canal: Panama"))', highlight: true }], options: ['True', 'False', 'Error', 'None'], correct: 0 },
            { type: 'scramble', prompt: 'Build valid anagram checker', pieces: [{ id: 'a', text: 'def is_anagram(s, t):' }, { id: 'b', text: '    if len(s) != len(t): return False' }, { id: 'c', text: '    from collections import Counter' }, { id: 'd', text: '    return Counter(s) == Counter(t)' }], distractors: [{ id: 'e', text: '    return s == t' }], correctOrder: ['a', 'b', 'c', 'd'] },
            { type: 'realworld', prompt: 'Most asked interview pattern?', scenario: '💼 Top coding interview topics.', options: [{ code: '# Arrays + Hash Maps: ~40% of problems\n# Two pointer, sliding window, sorting', label: 'Arrays + Hashing ✓' }, { code: '# Graph algorithms only', label: 'Graphs (~15%)' }, { code: '# Dynamic Programming only', label: 'DP (~20%)' }, { code: '# Linked lists only', label: 'LL (~10%)' }], correct: 0 },
        ],
        40: [
            { type: 'trace', prompt: 'Matrix search (sorted rows+cols)?', code: [{ text: 'def search(m, t):' }, { text: '    r, c = 0, len(m[0])-1' }, { text: '    while r<len(m) and c>=0:' }, { text: '        if m[r][c]==t: return True' }, { text: '        elif m[r][c]>t: c-=1' }, { text: '        else: r+=1' }, { text: '    return False' }, { text: 'print(search([[1,4,7],[2,5,8],[3,6,9]], 5))', highlight: true }], options: ['True', 'False', 'Error', '[1,1]'], correct: 0 },
            { type: 'output', prompt: 'Its complexity?', code: [{ text: '# Start top-right' }, { text: '# Each step: eliminate row or col' }, { text: '# At most m+n steps', highlight: true }], terminalOutput: 'O(m+n)', options: ['O(m×n)', 'O(m+n)', 'O(log(mn))', 'O(1)'], correct: 1 },
            { type: 'refactor', prompt: 'Max subarray — which algo?', originalCode: '# Brute: O(n²)\nfor i in range(n):\n    curr = 0\n    for j in range(i, n):\n        curr += arr[j]\n        best = max(best, curr)', options: [{ code: "# Kadane's: O(n)\ncurr = best = arr[0]\nfor x in arr[1:]:\n    curr = max(x, curr+x)\n    best = max(best, curr)", label: "Kadane's — O(n)" }, { code: '# Sort + take last k', label: 'Sorting' }, { code: '# Recursion no memo', label: 'O(2ⁿ)' }], correct: 0 },
            { type: 'trace', prompt: "Kadane's on [-2,1,-3,4,-1,2,1,-5,4]?", code: [{ text: '# curr: -2→1→-2→4→3→5→6→1→5' }, { text: '# best: -2→1→ 1→4→4→5→6→6→6' }, { text: 'print(best)', highlight: true }], options: ['4', '6', '7', '5'], correct: 1 },
            { type: 'scramble', prompt: "Build Kadane's algorithm", pieces: [{ id: 'a', text: 'def max_subarray(nums):' }, { id: 'b', text: '    curr = best = nums[0]' }, { id: 'c', text: '    for x in nums[1:]:' }, { id: 'd', text: '        curr = max(x, curr + x)' }, { id: 'e', text: '        best = max(best, curr)' }, { id: 'f', text: '    return best' }], distractors: [{ id: 'g', text: '        curr += x' }], correctOrder: ['a', 'b', 'c', 'd', 'e', 'f'] },
        ],
        41: [
            { type: 'pair', prompt: 'Advanced concepts', pairs: [{ id: 1, left: 'Amortized O(1)', right: 'Avg cost over many ops' }, { id: 2, left: 'NP-Complete', right: 'No known fast solution' }, { id: 3, left: 'Space-Time Tradeoff', right: 'Memory saves time' }, { id: 4, left: 'Greedy', right: 'Local optimal choices' }] },
            { type: 'trace', prompt: 'Greedy: activity selection?', code: [{ text: '# Activities: (start, end)' }, { text: '# [(1,4),(3,5),(0,6),(5,7),(8,9),(5,9)]' }, { text: '# Sort by end time, pick non-overlapping' }, { text: '# Pick: (1,4),(5,7),(8,9)', highlight: true }], options: ['3 activities', '2 activities', '4 activities', '6 activities'], correct: 0 },
            { type: 'realworld', prompt: 'When does greedy FAIL?', scenario: '⚠️ Greedy doesnt always give optimal.', options: [{ code: '# Coin change: coins=[1,3,4], amount=6\n# Greedy: 4+1+1=3 coins\n# Optimal: 3+3=2 coins!', label: 'Coin change with special coins' }, { code: '# Activity selection', label: 'Greedy works here' }, { code: '# Making change with [1,5,10,25]', label: 'Standard coins work' }, { code: '# Huffman coding', label: 'Greedy optimal' }], correct: 0 },
        ],
        42: [
            { type: 'realworld', prompt: 'Journey complete! Next step?', scenario: '🎓 You mastered: variables→loops→functions→DS→algorithms→DP→graphs!', options: [{ code: '# Build real projects!\n# Apply to apps, APIs, open source', label: 'Build projects! 🚀' }, { code: '# Review everything', label: 'Review' }, { code: '# Just read more', label: 'More books' }, { code: '# Stop forever', label: 'Never stop!' }], correct: 0 },
            { type: 'pair', prompt: 'Your journey recap', pairs: [{ id: 1, left: 'CH1-2', right: 'Variables & Flow' }, { id: 2, left: 'CH3-4', right: 'Loops & Functions' }, { id: 3, left: 'CH5-7', right: 'Data Structures' }, { id: 4, left: 'CH8-10', right: 'Algorithms & DP' }] },
            { type: 'trace', prompt: 'Final puzzle: what does this return?', code: [{ text: 'def mystery(n):' }, { text: '    if n == 0: return 1' }, { text: '    return n * mystery(n-1)' }, { text: 'print(mystery(5))', highlight: true }], options: ['5', '15', '120', '720'], correct: 2 },
        ],
    },
}

// JS and Java share Python's structure with syntax-appropriate fallback
export function getExercisesForNode(nodeId, lang) {
    const l = lang || _activeLang
    const exercises = nodeExercises[l]?.[nodeId] || nodeExercises.python?.[nodeId] || []
    return exercises.length > 0 ? exercises : [
        {
            type: 'trace', prompt: 'Coming soon! This lesson is being prepared.',
            code: [{ text: '# More exercises coming soon!', highlight: true }],
            options: ['OK!'], correct: 0
        },
    ]
}
