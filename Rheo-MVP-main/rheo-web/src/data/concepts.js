/* ══════════════════════════════════════════
   Rheo — Concept Decks (konu anlatımı)
   Short, swipeable card lessons that replace the old video nodes.
   One deck per chapter per language; 6 cards, ~90 seconds.

   Card kinds — see ConceptDeck.jsx for the renderer:
     hook     opening question, sets up why the topic matters
     idea     the core rule + a snippet
     code     a worked example
     compare  wrong-vs-right side by side
     pitfall  the classic trap
     recap    three takeaways, unlocks CONTINUE

   Every text field is { en, tr }; the deck picks the active locale.
   Code lines are already language-specific — the deck lives under its
   language key, so no per-line branching is needed.
   ══════════════════════════════════════════ */

/* ── PYTHON ────────────────────────────────────────────────────── */
const pythonDecks = {
    1: {
        titleEn: 'Variables & Types', titleTr: 'Değişkenler & Tipler',
        minutes: 2,
        cards: [
            {
                kind: 'hook', icon: '📦',
                title: { en: 'Where does a program keep things?', tr: 'Program bir şeyi nerede tutar?' },
                body: {
                    en: 'A variable is a name you stick on a value so you can ask for it again later.',
                    tr: 'Değişken, bir değere yapıştırdığın isimdir; sonra o isimle geri istersin.',
                },
            },
            {
                kind: 'idea', icon: '🏷️',
                title: { en: 'Name on the left, value on the right', tr: 'Solda isim, sağda değer' },
                body: {
                    en: 'You never declare a type. Python reads the value and picks the type for you.',
                    tr: 'Tip yazmazsın. Python değere bakar ve tipi kendisi seçer.',
                },
                code: ['name = "Rheo"', 'age = 3', 'print(name, age)   # Rheo 3'],
                caption: { en: '= means "put this in", not "is equal to".', tr: '= "eşittir" değil, "bunu içine koy" demektir.' },
            },
            {
                kind: 'code', icon: '🔢',
                title: { en: 'The four you will use every day', tr: 'Her gün kullanacağın dört tip' },
                code: [
                    'count = 42       # int',
                    'ratio = 3.14     # float',
                    'label = "hello"  # str',
                    'ready = True     # bool',
                ],
                caption: { en: 'type(count) reports the type of the value, not the name.', tr: 'type(count), ismin değil değerin tipini söyler.' },
            },
            {
                kind: 'compare', icon: '⚖️',
                title: { en: 'One equals sign, or two?', tr: 'Tek eşittir mi, çift mi?' },
                bad: { code: ['if age = 3:'], label: { en: 'assigns → SyntaxError', tr: 'atama yapar → SyntaxError' } },
                good: { code: ['if age == 3:'], label: { en: 'compares → True / False', tr: 'karşılaştırır → True / False' } },
                body: { en: 'One = stores. Two == asks a question.', tr: 'Tek = saklar. Çift == soru sorar.' },
            },
            {
                kind: 'pitfall', icon: '⚠️',
                title: { en: 'input() always hands back text', tr: 'input() her zaman metin döndürür' },
                code: ['age = input("Age: ")   # "25", a str', 'if age > 18:           # TypeError!', '    print("Adult")'],
                body: {
                    en: 'Even when the user types digits, you get a str. Convert first: int(input(...)).',
                    tr: 'Kullanıcı rakam yazsa bile elinde str olur. Önce çevir: int(input(...)).',
                },
            },
            {
                kind: 'recap', icon: '✅',
                title: { en: 'Three things to carry out', tr: 'Yanında götüreceğin üç şey' },
                bullets: [
                    { en: 'A variable is a name bound to a value — no type declaration.', tr: 'Değişken, bir değere bağlanmış isimdir — tip bildirimi yok.' },
                    { en: 'int, float, str, bool cover almost everything early on.', tr: 'int, float, str, bool başlangıçta neredeyse her şeyi kapsar.' },
                    { en: '= assigns, == compares, and input() gives you a str.', tr: '= atar, == karşılaştırır, input() sana str verir.' },
                ],
            },
        ],
    },
    2: {
        titleEn: 'Conditions & Flow', titleTr: 'Koşullar & Akış',
        minutes: 2,
        cards: [
            {
                kind: 'hook', icon: '🔀',
                title: { en: 'One input, two futures', tr: 'Tek girdi, iki gelecek' },
                body: {
                    en: 'A condition is the point where your program stops being a straight line and starts making a choice.',
                    tr: 'Koşul, programın düz çizgi olmaktan çıkıp seçim yapmaya başladığı yerdir.',
                },
            },
            {
                kind: 'idea', icon: '🧭',
                title: { en: 'if → elif → else', tr: 'if → elif → else' },
                body: {
                    en: 'Python checks top to bottom and runs the FIRST true branch only. The rest is skipped.',
                    tr: 'Python yukarıdan aşağı bakar ve SADECE ilk doğru dalı çalıştırır. Gerisi atlanır.',
                },
                code: ['if score >= 90:', '    grade = "A"', 'elif score >= 50:', '    grade = "B"', 'else:', '    grade = "F"'],
                caption: { en: 'else has no condition — it is the "none of the above" branch.', tr: "else'in koşulu yoktur — o \"hiçbiri\" dalıdır." },
            },
            {
                kind: 'code', icon: '🧪',
                title: { en: 'Indentation is the block', tr: 'Girinti, bloğun kendisidir' },
                code: ['x = 15', 'if x > 10:', '    print("big")     # inside the if', 'print("done")        # always runs'],
                caption: { en: 'Four spaces decide what belongs to the branch. Nothing else does.', tr: 'Dala neyin ait olduğuna dört boşluk karar verir. Başka hiçbir şey değil.' },
            },
            {
                kind: 'compare', icon: '⚖️',
                title: { en: 'Chain them, or repeat yourself?', tr: 'Zincirle mi, tekrar mı et?' },
                bad: { code: ['if x > 10: label = "big"', 'if x <= 10: label = "small"'], label: { en: 'two tests, can disagree later', tr: 'iki test, sonra çelişebilir' } },
                good: { code: ['if x > 10: label = "big"', 'else: label = "small"'], label: { en: 'one test, always consistent', tr: 'tek test, hep tutarlı' } },
                body: { en: 'elif/else guarantee exactly one branch wins.', tr: 'elif/else tam olarak bir dalın kazanmasını garanti eder.' },
            },
            {
                kind: 'pitfall', icon: '⚠️',
                title: { en: 'Empty things are False', tr: 'Boş şeyler False sayılır' },
                code: ['if items:      # [] → False', '    print("we have items")', '', '# 0, "", [], {}, None are falsy'],
                body: {
                    en: 'You rarely need == True. Ask for the value itself and let truthiness do the work.',
                    tr: 'Nadiren == True gerekir. Değerin kendisini sor, doğruluk (truthiness) işi halletsin.',
                },
            },
            {
                kind: 'recap', icon: '✅',
                title: { en: 'Three things to carry out', tr: 'Yanında götüreceğin üç şey' },
                bullets: [
                    { en: 'Only the first true branch in a chain runs.', tr: 'Zincirde yalnızca ilk doğru dal çalışır.' },
                    { en: 'Indentation defines the block — not braces, not luck.', tr: 'Bloğu girinti belirler — süslü parantez değil, şans hiç değil.' },
                    { en: '0, "", [], {} and None all behave as False.', tr: '0, "", [], {} ve None hepsi False gibi davranır.' },
                ],
            },
        ],
    },
    4: {
        titleEn: 'Functions', titleTr: 'Fonksiyonlar',
        minutes: 2,
        cards: [
            {
                kind: 'hook', icon: '🧩',
                title: { en: 'Copy-paste is a bug factory', tr: 'Kopyala-yapıştır bir hata fabrikasıdır' },
                body: {
                    en: 'The third time you write the same lines, you will fix a bug in two of them and forget the third.',
                    tr: 'Aynı satırları üçüncü kez yazdığında, ikisindeki hatayı düzeltip üçüncüsünü unutursun.',
                },
            },
            {
                kind: 'idea', icon: '🔁',
                title: { en: 'Take something in, hand something back', tr: 'Bir şey al, bir şey geri ver' },
                body: {
                    en: 'def names the block. Parameters are what it needs; return is what it produces.',
                    tr: 'def bloğa isim verir. Parametreler ihtiyacı, return ise ürettiğidir.',
                },
                code: ['def area(w, h):', '    return w * h', '', 'print(area(3, 4))   # 12'],
                caption: { en: 'The function runs only when you call it with ().', tr: 'Fonksiyon yalnızca () ile çağırdığında çalışır.' },
            },
            {
                kind: 'code', icon: '📥',
                title: { en: 'Defaults make arguments optional', tr: 'Varsayılanlar argümanı isteğe bağlı yapar' },
                code: ['def greet(name, greeting="Hi"):', '    return f"{greeting}, {name}!"', '', 'greet("Ada")            # Hi, Ada!', 'greet("Ada", "Hello")   # Hello, Ada!'],
                caption: { en: 'Parameters with defaults must come after the ones without.', tr: 'Varsayılanlı parametreler, varsayılansızlardan sonra gelmeli.' },
            },
            {
                kind: 'compare', icon: '⚖️',
                title: { en: 'return vs print', tr: 'return vs print' },
                bad: { code: ['def double(x):', '    print(x * 2)', '', 'y = double(5)   # y is None'], label: { en: 'shows it, gives you nothing', tr: 'gösterir, sana bir şey vermez' } },
                good: { code: ['def double(x):', '    return x * 2', '', 'y = double(5)   # y is 10'], label: { en: 'hands the value back', tr: 'değeri geri verir' } },
                body: { en: 'print talks to the human. return talks to the rest of your code.', tr: 'print insana konuşur. return kodunun geri kalanına konuşur.' },
            },
            {
                kind: 'pitfall', icon: '⚠️',
                title: { en: 'Never default to a mutable', tr: 'Asla değiştirilebilir bir varsayılan verme' },
                code: ['def add(item, cart=[]):   # built ONCE', '    cart.append(item)', '    return cart', '', '# fix: cart=None, then cart = cart or []'],
                body: {
                    en: 'That [] is created when the function is defined, so every caller shares one list.',
                    tr: 'O [] fonksiyon tanımlanırken bir kez oluşur; böylece tüm çağıranlar aynı listeyi paylaşır.',
                },
            },
            {
                kind: 'recap', icon: '✅',
                title: { en: 'Three things to carry out', tr: 'Yanında götüreceğin üç şey' },
                bullets: [
                    { en: 'Parameters are the inputs; return is the output.', tr: 'Parametreler girdi, return ise çıktıdır.' },
                    { en: 'A function with no return gives back None.', tr: "return'ü olmayan fonksiyon None döndürür." },
                    { en: 'Default arguments are evaluated once, at definition time.', tr: 'Varsayılan argümanlar tanım anında bir kez hesaplanır.' },
                ],
            },
        ],
    },
    7: {
        titleEn: 'Stacks, Queues & Trees', titleTr: 'Yığın, Kuyruk & Ağaçlar',
        minutes: 2,
        cards: [
            {
                kind: 'hook', icon: '🏗️',
                title: { en: 'The order you take things out is a design decision', tr: 'Çıkarma sırası bir tasarım kararıdır' },
                body: {
                    en: 'Undo, printer jobs, browser history — each picks a different "who is next?" rule.',
                    tr: 'Geri al, yazıcı işleri, tarayıcı geçmişi — her biri farklı bir "sıra kimde?" kuralı seçer.',
                },
            },
            {
                kind: 'idea', icon: '🥞',
                title: { en: 'Stack — last in, first out', tr: 'Yığın — son giren ilk çıkar' },
                body: {
                    en: 'A pile of plates. You always take the one you put down most recently. That is Ctrl+Z.',
                    tr: 'Tabak yığını. Hep en son koyduğunu alırsın. Ctrl+Z tam olarak budur.',
                },
                code: ['stack = []', 'stack.append("a")', 'stack.append("b")', 'stack.pop()      # "b"'],
                caption: { en: 'A plain list is already a stack: append + pop.', tr: 'Düz bir list zaten yığındır: append + pop.' },
            },
            {
                kind: 'code', icon: '🚶',
                title: { en: 'Queue — first in, first out', tr: 'Kuyruk — ilk giren ilk çıkar' },
                code: ['from collections import deque', '', 'q = deque(["a", "b"])', 'q.append("c")     # join the back', 'q.popleft()       # "a" leaves first'],
                caption: { en: 'A queue at a counter: nobody jumps ahead.', tr: 'Gişedeki sıra: kimse öne kaynak yapmaz.' },
            },
            {
                kind: 'compare', icon: '⚖️',
                title: { en: 'Why deque and not a list?', tr: 'Neden list değil de deque?' },
                bad: { code: ['q = ["a", "b", "c"]', 'q.pop(0)   # shifts every element'], label: { en: 'O(n) — slower as it grows', tr: 'O(n) — büyüdükçe yavaşlar' } },
                good: { code: ['q = deque(["a", "b", "c"])', 'q.popleft()   # just moves a pointer'], label: { en: 'O(1) — constant, always', tr: 'O(1) — her zaman sabit' } },
                body: { en: 'Same result, different cost. At 10 items nobody notices; at 100k everybody does.', tr: 'Aynı sonuç, farklı maliyet. 10 elemanda kimse fark etmez; 100 binde herkes eder.' },
            },
            {
                kind: 'idea', icon: '🌳',
                title: { en: 'Linked list & tree — nodes pointing at nodes', tr: 'Bağlı liste & ağaç — düğümleri işaret eden düğümler' },
                body: {
                    en: 'Stop storing items side by side. Store each item with a pointer to the next one — one pointer is a list, two is a tree.',
                    tr: 'Elemanları yan yana tutmayı bırak. Her elemanı sonrakine işaret ederek tut — bir işaretçi liste, iki işaretçi ağaç yapar.',
                },
                code: ['class Node:', '    def __init__(self, value):', '        self.value = value', '        self.left = None', '        self.right = None'],
                caption: { en: 'Drop .right and the same class becomes a linked list.', tr: '.right’ı çıkar, aynı sınıf bağlı listeye dönüşür.' },
            },
            {
                kind: 'recap', icon: '✅',
                title: { en: 'Three things to carry out', tr: 'Yanında götüreceğin üç şey' },
                bullets: [
                    { en: 'Stack = LIFO (append/pop). Queue = FIFO (append/popleft).', tr: 'Yığın = LIFO (append/pop). Kuyruk = FIFO (append/popleft).' },
                    { en: 'Removing from the front of a list is O(n) — use deque.', tr: 'Listenin başından silmek O(n)’dir — deque kullan.' },
                    { en: 'Trees and linked lists are just nodes holding pointers.', tr: 'Ağaçlar ve bağlı listeler, işaretçi tutan düğümlerden ibarettir.' },
                ],
            },
        ],
    },
}

/* ── JAVASCRIPT ────────────────────────────────────────────────── */
const jsDecks = {
    1: {
        titleEn: 'Variables & Types', titleTr: 'Değişkenler & Tipler',
        minutes: 2,
        cards: [
            {
                kind: 'hook', icon: '📦',
                title: { en: 'Where does a program keep things?', tr: 'Program bir şeyi nerede tutar?' },
                body: {
                    en: 'A variable is a name you stick on a value so you can ask for it again later.',
                    tr: 'Değişken, bir değere yapıştırdığın isimdir; sonra o isimle geri istersin.',
                },
            },
            {
                kind: 'idea', icon: '🏷️',
                title: { en: 'const by default, let when it changes', tr: 'Varsayılan const, değişecekse let' },
                body: {
                    en: 'const blocks reassignment, which makes the code easier to read. Reach for let only when you must.',
                    tr: 'const yeniden atamayı engeller, kodu okumayı kolaylaştırır. let’e ancak mecbur kalınca uzan.',
                },
                code: ['const name = "Rheo"', 'let score = 0', 'score = score + 10', 'console.log(name, score)   // Rheo 10'],
                caption: { en: 'var is the old one — block scope is why let and const replaced it.', tr: 'var eskisidir — blok kapsamı, let ve const’un onu neden değiştirdiğidir.' },
            },
            {
                kind: 'code', icon: '🔢',
                title: { en: 'The types you will meet first', tr: 'İlk karşılaşacağın tipler' },
                code: [
                    'const count = 42      // number',
                    'const label = "hi"    // string',
                    'const ready = true    // boolean',
                    'const nothing = null  // empty',
                    'let unset             // undefined',
                ],
                caption: { en: 'typeof tells you which one you actually have.', tr: 'Elinde gerçekte hangisi var, onu typeof söyler.' },
            },
            {
                kind: 'compare', icon: '⚖️',
                title: { en: '== or ===?', tr: '== mi, === mi?' },
                bad: { code: ['"5" == 5    // true'], label: { en: 'converts types first', tr: 'önce tip dönüştürür' } },
                good: { code: ['"5" === 5   // false'], label: { en: 'compares value AND type', tr: 'değeri VE tipi karşılaştırır' } },
                body: { en: 'Use === everywhere. == hides the bug instead of reporting it.', tr: 'Her yerde === kullan. == hatayı bildirmek yerine saklar.' },
            },
            {
                kind: 'pitfall', icon: '⚠️',
                title: { en: '+ means two different things', tr: '+ iki farklı anlama gelir' },
                code: ['"5" + 3    // "53"  → string glued', '"5" - 3    // 2     → number math', 'Number("5") + 3   // 8  the fix'],
                body: {
                    en: 'With a string on either side, + concatenates. Every other operator converts to number.',
                    tr: 'Bir taraf string ise + birleştirir. Diğer tüm operatörler sayıya çevirir.',
                },
            },
            {
                kind: 'recap', icon: '✅',
                title: { en: 'Three things to carry out', tr: 'Yanında götüreceğin üç şey' },
                bullets: [
                    { en: 'const first, let when the value has to change, never var.', tr: 'Önce const, değer değişecekse let, asla var.' },
                    { en: '=== compares value and type; == quietly converts.', tr: '=== değeri ve tipi karşılaştırır; == sessizce dönüştürür.' },
                    { en: '"5" + 3 is "53" — check your types before you add.', tr: '"5" + 3 sonucu "53" — toplamadan önce tipleri kontrol et.' },
                ],
            },
        ],
    },
    2: {
        titleEn: 'Conditions & Flow', titleTr: 'Koşullar & Akış',
        minutes: 2,
        cards: [
            {
                kind: 'hook', icon: '🔀',
                title: { en: 'One input, two futures', tr: 'Tek girdi, iki gelecek' },
                body: {
                    en: 'A condition is the point where your program stops being a straight line and starts making a choice.',
                    tr: 'Koşul, programın düz çizgi olmaktan çıkıp seçim yapmaya başladığı yerdir.',
                },
            },
            {
                kind: 'idea', icon: '🧭',
                title: { en: 'if → else if → else', tr: 'if → else if → else' },
                body: {
                    en: 'JavaScript checks top to bottom and runs the FIRST true branch only.',
                    tr: 'JavaScript yukarıdan aşağı bakar ve SADECE ilk doğru dalı çalıştırır.',
                },
                code: ['if (score >= 90) {', '  grade = "A"', '} else if (score >= 50) {', '  grade = "B"', '} else {', '  grade = "F"', '}'],
                caption: { en: 'The braces are the block — indentation is only for humans.', tr: 'Bloğu süslü parantezler yapar — girinti sadece insanlar içindir.' },
            },
            {
                kind: 'code', icon: '🎚️',
                title: { en: 'A one-line choice: the ternary', tr: 'Tek satırlık seçim: ternary' },
                code: ['const label = age >= 18', '  ? "adult"', '  : "minor"', '', '// an if/else that returns a value'],
                caption: { en: 'Great for one assignment. Nest two of them and readability dies.', tr: 'Tek atama için harika. İki tanesini iç içe koyarsan okunabilirlik biter.' },
            },
            {
                kind: 'compare', icon: '⚖️',
                title: { en: 'Falsy is not the same as missing', tr: 'Falsy ile "yok" aynı şey değildir' },
                bad: { code: ['const port = input || 8080', '// input = 0 → 8080. Wrong!'], label: { en: '|| rejects every falsy value', tr: '|| tüm falsy değerleri reddeder' } },
                good: { code: ['const port = input ?? 8080', '// only null/undefined → 8080'], label: { en: '?? rejects only null/undefined', tr: '?? yalnızca null/undefined’ı reddeder' } },
                body: { en: '0, "", NaN are real values. Defaults with || throw them away.', tr: '0, "", NaN gerçek değerlerdir. || ile varsayılan vermek onları çöpe atar.' },
            },
            {
                kind: 'pitfall', icon: '⚠️',
                title: { en: 'Six values are falsy. Learn them once.', tr: 'Altı değer falsy’dir. Bir kez öğren, yeter.' },
                code: ['false  0  ""  null  undefined  NaN', '', 'if (items.length) { /* not empty */ }'],
                body: {
                    en: 'Everything else — including [] and {} — is truthy. Yes, even an empty array.',
                    tr: 'Geri kalan her şey — [] ve {} dahil — truthy’dir. Evet, boş dizi bile.',
                },
            },
            {
                kind: 'recap', icon: '✅',
                title: { en: 'Three things to carry out', tr: 'Yanında götüreceğin üç şey' },
                bullets: [
                    { en: 'Only the first true branch in a chain runs.', tr: 'Zincirde yalnızca ilk doğru dal çalışır.' },
                    { en: 'The ternary is an if/else that produces a value.', tr: 'Ternary, değer üreten bir if/else’tir.' },
                    { en: 'Six falsy values; [] and {} are not among them.', tr: 'Altı falsy değer var; [] ve {} onlardan değil.' },
                ],
            },
        ],
    },
    4: {
        titleEn: 'Functions', titleTr: 'Fonksiyonlar',
        minutes: 2,
        cards: [
            {
                kind: 'hook', icon: '🧩',
                title: { en: 'Copy-paste is a bug factory', tr: 'Kopyala-yapıştır bir hata fabrikasıdır' },
                body: {
                    en: 'The third time you write the same lines, you will fix a bug in two of them and forget the third.',
                    tr: 'Aynı satırları üçüncü kez yazdığında, ikisindeki hatayı düzeltip üçüncüsünü unutursun.',
                },
            },
            {
                kind: 'idea', icon: '🔁',
                title: { en: 'Take something in, hand something back', tr: 'Bir şey al, bir şey geri ver' },
                body: {
                    en: 'Parameters are what the function needs; return is what it produces.',
                    tr: 'Parametreler fonksiyonun ihtiyacı, return ise ürettiğidir.',
                },
                code: ['function area(w, h) {', '  return w * h', '}', '', 'const arrow = (w, h) => w * h'],
                caption: { en: 'A one-expression arrow returns it automatically — no return keyword.', tr: 'Tek ifadeli ok fonksiyonu onu otomatik döndürür — return yazmazsın.' },
            },
            {
                kind: 'code', icon: '📥',
                title: { en: 'Defaults and rest', tr: 'Varsayılanlar ve rest' },
                code: ['function greet(name, hi = "Hi") {', '  return `${hi}, ${name}!`', '}', '', 'const sum = (...nums) =>', '  nums.reduce((a, b) => a + b, 0)'],
                caption: { en: '...nums collects every remaining argument into an array.', tr: '...nums kalan tüm argümanları bir diziye toplar.' },
            },
            {
                kind: 'compare', icon: '⚖️',
                title: { en: 'The arrow trap: braces swallow the result', tr: 'Ok tuzağı: süslü parantez sonucu yutar' },
                bad: { code: ['const double = x => { x * 2 }', 'double(5)   // undefined'], label: { en: 'a block with no return', tr: "return'süz bir blok" } },
                good: { code: ['const double = x => x * 2', 'double(5)   // 10'], label: { en: 'expression body returns it', tr: 'ifade gövdesi onu döndürür' } },
                body: { en: 'Add braces and you owe the function a return statement.', tr: 'Süslü parantez eklersen fonksiyona bir return borçlanırsın.' },
            },
            {
                kind: 'pitfall', icon: '⚠️',
                title: { en: 'A function remembers where it was born', tr: 'Fonksiyon doğduğu yeri hatırlar' },
                code: ['function counter() {', '  let n = 0', '  return () => ++n  // n survives', '}', 'const next = counter()', 'next()  // 1', 'next()  // 2'],
                body: {
                    en: 'That is a closure: the inner function keeps its outer variables alive after the outer call ends.',
                    tr: 'Bu bir closure: iç fonksiyon, dış çağrı bitse de dış değişkenleri canlı tutar.',
                },
            },
            {
                kind: 'recap', icon: '✅',
                title: { en: 'Three things to carry out', tr: 'Yanında götüreceğin üç şey' },
                bullets: [
                    { en: 'Parameters are the inputs; return is the output.', tr: 'Parametreler girdi, return ise çıktıdır.' },
                    { en: 'x => x * 2 returns; x => { x * 2 } does not.', tr: 'x => x * 2 döndürür; x => { x * 2 } döndürmez.' },
                    { en: 'A closure keeps outer variables alive after the call ends.', tr: 'Closure, çağrı bittikten sonra dış değişkenleri canlı tutar.' },
                ],
            },
        ],
    },
    7: {
        titleEn: 'Stacks, Queues & Trees', titleTr: 'Yığın, Kuyruk & Ağaçlar',
        minutes: 2,
        cards: [
            {
                kind: 'hook', icon: '🏗️',
                title: { en: 'The order you take things out is a design decision', tr: 'Çıkarma sırası bir tasarım kararıdır' },
                body: {
                    en: 'Undo, print jobs, browser history — each picks a different "who is next?" rule.',
                    tr: 'Geri al, yazıcı işleri, tarayıcı geçmişi — her biri farklı bir "sıra kimde?" kuralı seçer.',
                },
            },
            {
                kind: 'idea', icon: '🥞',
                title: { en: 'Stack — last in, first out', tr: 'Yığın — son giren ilk çıkar' },
                body: {
                    en: 'A pile of plates. You always take the one you put down most recently. That is Ctrl+Z.',
                    tr: 'Tabak yığını. Hep en son koyduğunu alırsın. Ctrl+Z tam olarak budur.',
                },
                code: ['const stack = []', 'stack.push("a")', 'stack.push("b")', 'stack.pop()      // "b"'],
                caption: { en: 'A plain array is already a stack: push + pop.', tr: 'Düz bir dizi zaten yığındır: push + pop.' },
            },
            {
                kind: 'code', icon: '🚶',
                title: { en: 'Queue — first in, first out', tr: 'Kuyruk — ilk giren ilk çıkar' },
                code: ['const q = ["a", "b"]', 'q.push("c")      // join the back', 'q.shift()        // "a" leaves first'],
                caption: { en: 'A queue at a counter: nobody jumps ahead.', tr: 'Gişedeki sıra: kimse öne kaynak yapmaz.' },
            },
            {
                kind: 'compare', icon: '⚖️',
                title: { en: 'shift() is not free', tr: 'shift() bedava değildir' },
                bad: { code: ['q.shift()   // re-indexes everything'], label: { en: 'O(n) — slower as it grows', tr: 'O(n) — büyüdükçe yavaşlar' } },
                good: { code: ['let head = 0', 'const item = q[head++]  // pointer'], label: { en: 'O(1) — constant, always', tr: 'O(1) — her zaman sabit' } },
                body: { en: 'Same result, different cost. At 10 items nobody notices; at 100k everybody does.', tr: 'Aynı sonuç, farklı maliyet. 10 elemanda kimse fark etmez; 100 binde herkes eder.' },
            },
            {
                kind: 'idea', icon: '🌳',
                title: { en: 'Linked list & tree — nodes pointing at nodes', tr: 'Bağlı liste & ağaç — düğümleri işaret eden düğümler' },
                body: {
                    en: 'Stop storing items side by side. Store each item with a pointer to the next — one pointer is a list, two is a tree.',
                    tr: 'Elemanları yan yana tutmayı bırak. Her elemanı sonrakine işaret ederek tut — bir işaretçi liste, iki işaretçi ağaç yapar.',
                },
                code: ['class Node {', '  constructor(value) {', '    this.value = value', '    this.left = null', '    this.right = null', '  }', '}'],
                caption: { en: 'Drop .right and the same class becomes a linked list.', tr: '.right’ı çıkar, aynı sınıf bağlı listeye dönüşür.' },
            },
            {
                kind: 'recap', icon: '✅',
                title: { en: 'Three things to carry out', tr: 'Yanında götüreceğin üç şey' },
                bullets: [
                    { en: 'Stack = LIFO (push/pop). Queue = FIFO (push/shift).', tr: 'Yığın = LIFO (push/pop). Kuyruk = FIFO (push/shift).' },
                    { en: 'shift() re-indexes the array — O(n). A head pointer is O(1).', tr: 'shift() diziyi yeniden indeksler — O(n). Baş işaretçisi O(1).' },
                    { en: 'Trees and linked lists are just nodes holding pointers.', tr: 'Ağaçlar ve bağlı listeler, işaretçi tutan düğümlerden ibarettir.' },
                ],
            },
        ],
    },
}

/* ── JAVA ──────────────────────────────────────────────────────── */
const javaDecks = {
    1: {
        titleEn: 'Variables & Types', titleTr: 'Değişkenler & Tipler',
        minutes: 2,
        cards: [
            {
                kind: 'hook', icon: '📦',
                title: { en: 'Java asks for the type up front', tr: 'Java tipi baştan sorar' },
                body: {
                    en: 'You declare what a variable holds before you use it. The compiler then catches whole classes of bugs for you.',
                    tr: 'Bir değişkenin ne tuttuğunu kullanmadan önce bildirirsin. Karşılığında derleyici bütün hata sınıflarını senin için yakalar.',
                },
            },
            {
                kind: 'idea', icon: '🏷️',
                title: { en: 'Type, name, value', tr: 'Tip, isim, değer' },
                body: {
                    en: 'The type is a promise. Break it and the code will not even compile.',
                    tr: 'Tip bir sözdür. Sözü bozarsan kod derlenmez bile.',
                },
                code: ['String name = "Rheo";', 'int age = 3;', 'System.out.println(name + " " + age);'],
                caption: { en: 'var age = 3; lets the compiler infer it — the type is still fixed.', tr: 'var age = 3; derleyicinin çıkarım yapmasını sağlar — tip yine sabittir.' },
            },
            {
                kind: 'code', icon: '🔢',
                title: { en: 'Primitives vs references', tr: 'İlkel tipler vs referanslar' },
                code: [
                    'int count = 42;       // primitive',
                    'double ratio = 3.14;  // primitive',
                    'boolean ready = true; // primitive',
                    'String label = "hi";  // reference',
                ],
                caption: { en: 'Lowercase types are primitives; capitalised ones are objects.', tr: 'Küçük harfli tipler ilkel, büyük harfliler nesnedir.' },
            },
            {
                kind: 'compare', icon: '⚖️',
                title: { en: 'Comparing Strings', tr: 'String karşılaştırma' },
                bad: { code: ['if (a == b)'], label: { en: 'compares addresses', tr: 'adresleri karşılaştırır' } },
                good: { code: ['if (a.equals(b))'], label: { en: 'compares the text', tr: 'metni karşılaştırır' } },
                body: { en: '== on objects asks "same box?". equals() asks "same contents?".', tr: 'Nesnelerde == "aynı kutu mu?" diye sorar. equals() "aynı içerik mi?" diye.' },
            },
            {
                kind: 'pitfall', icon: '⚠️',
                title: { en: 'int ÷ int throws away the remainder', tr: 'int ÷ int kalanı çöpe atar' },
                code: ['int a = 7, b = 2;', 'System.out.println(a / b);', '// 3, not 3.5', 'System.out.println((double) a / b);', '// 3.5'],
                body: {
                    en: 'Two ints divide as ints. Cast one side to double before you divide, not after.',
                    tr: 'İki int, int gibi bölünür. Bölmeden sonra değil, önce bir tarafı double’a çevir.',
                },
            },
            {
                kind: 'recap', icon: '✅',
                title: { en: 'Three things to carry out', tr: 'Yanında götüreceğin üç şey' },
                bullets: [
                    { en: 'Every variable declares its type — the compiler enforces it.', tr: 'Her değişken tipini bildirir — derleyici bunu zorunlu kılar.' },
                    { en: 'Use .equals() for Strings, == only for primitives.', tr: "String'lerde .equals(), == yalnızca ilkel tiplerde." },
                    { en: '7 / 2 is 3 until one side becomes a double.', tr: 'Bir taraf double olana kadar 7 / 2 sonucu 3’tür.' },
                ],
            },
        ],
    },
    2: {
        titleEn: 'Conditions & Flow', titleTr: 'Koşullar & Akış',
        minutes: 2,
        cards: [
            {
                kind: 'hook', icon: '🔀',
                title: { en: 'One input, two futures', tr: 'Tek girdi, iki gelecek' },
                body: {
                    en: 'A condition is the point where your program stops being a straight line and starts making a choice.',
                    tr: 'Koşul, programın düz çizgi olmaktan çıkıp seçim yapmaya başladığı yerdir.',
                },
            },
            {
                kind: 'idea', icon: '🧭',
                title: { en: 'if → else if → else', tr: 'if → else if → else' },
                body: {
                    en: 'Java checks top to bottom and runs the FIRST true branch only. The condition must be a boolean.',
                    tr: 'Java yukarıdan aşağı bakar ve SADECE ilk doğru dalı çalıştırır. Koşul boolean olmak zorundadır.',
                },
                code: ['if (score >= 90) {', '    grade = "A";', '} else if (score >= 50) {', '    grade = "B";', '} else {', '    grade = "F";', '}'],
                caption: { en: 'There is no truthiness here — if (1) does not compile.', tr: 'Burada truthiness yok — if (1) derlenmez.' },
            },
            {
                kind: 'code', icon: '🎚️',
                title: { en: 'switch when you branch on one value', tr: 'Tek değere göre dallanıyorsan switch' },
                code: ['String kind = switch (day) {', '    case SAT, SUN -> "weekend";', '    default -> "weekday";', '};'],
                caption: { en: 'The arrow form (Java 14+) returns a value and never falls through.', tr: 'Ok biçimi (Java 14+) değer döndürür ve asla alt case’e sızmaz.' },
            },
            {
                kind: 'compare', icon: '⚖️',
                title: { en: 'The classic switch leak', tr: 'Klasik switch sızıntısı' },
                bad: { code: ['case 1:', '    total += 5;   // no break', 'case 2:', '    total += 9;'], label: { en: 'falls through into case 2', tr: 'case 2’ye sızar' } },
                good: { code: ['case 1 -> total += 5;', 'case 2 -> total += 9;'], label: { en: 'one case, one action', tr: 'tek case, tek eylem' } },
                body: { en: 'A missing break silently runs the next case too.', tr: 'Eksik bir break, sessizce sonraki case’i de çalıştırır.' },
            },
            {
                kind: 'pitfall', icon: '⚠️',
                title: { en: '&& stops early — and that saves you', tr: '&& erken durur — bu seni kurtarır' },
                code: ['if (user != null && user.isActive()) {', '    // safe: the right side never runs', '    // when user is null', '}'],
                body: {
                    en: 'Short-circuit evaluation: if the left side settles the answer, the right side is never evaluated.',
                    tr: 'Kısa devre değerlendirme: sol taraf cevabı belirliyorsa sağ taraf hiç çalıştırılmaz.',
                },
            },
            {
                kind: 'recap', icon: '✅',
                title: { en: 'Three things to carry out', tr: 'Yanında götüreceğin üç şey' },
                bullets: [
                    { en: 'Conditions must be boolean — no truthy numbers.', tr: 'Koşullar boolean olmalı — truthy sayı yok.' },
                    { en: 'Arrow switch returns a value and cannot fall through.', tr: 'Ok switch değer döndürür ve alt case’e sızamaz.' },
                    { en: '&& and || short-circuit; use that to guard against null.', tr: '&& ve || kısa devre yapar; null’a karşı bunu kullan.' },
                ],
            },
        ],
    },
    4: {
        titleEn: 'Methods', titleTr: 'Metotlar',
        minutes: 2,
        cards: [
            {
                kind: 'hook', icon: '🧩',
                title: { en: 'Copy-paste is a bug factory', tr: 'Kopyala-yapıştır bir hata fabrikasıdır' },
                body: {
                    en: 'The third time you write the same lines, you will fix a bug in two of them and forget the third.',
                    tr: 'Aynı satırları üçüncü kez yazdığında, ikisindeki hatayı düzeltip üçüncüsünü unutursun.',
                },
            },
            {
                kind: 'idea', icon: '🔁',
                title: { en: 'The signature is a contract', tr: 'İmza bir sözleşmedir' },
                body: {
                    en: 'Return type, name, parameter types. Callers only need this line to use your method.',
                    tr: 'Dönüş tipi, isim, parametre tipleri. Çağıranın metodunu kullanmak için tek ihtiyacı bu satırdır.',
                },
                code: ['static int area(int w, int h) {', '    return w * h;', '}', '', 'System.out.println(area(3, 4));  // 12'],
                caption: { en: 'A non-void method must return on every path, or it will not compile.', tr: 'void olmayan metot her yolda return etmeli, yoksa derlenmez.' },
            },
            {
                kind: 'code', icon: '📥',
                title: { en: 'Overloading: same name, different inputs', tr: 'Aşırı yükleme: aynı isim, farklı girdi' },
                code: ['static int max(int a, int b)', 'static double max(double a, double b)', '', '// compiler picks by argument type'],
                caption: { en: 'Java has no default parameters — overloading fills that gap.', tr: 'Java’da varsayılan parametre yoktur — bu boşluğu aşırı yükleme doldurur.' },
            },
            {
                kind: 'compare', icon: '⚖️',
                title: { en: 'return vs println', tr: 'return vs println' },
                bad: { code: ['static void doubled(int x) {', '    System.out.println(x * 2);', '}'], label: { en: 'shows it, gives you nothing', tr: 'gösterir, sana bir şey vermez' } },
                good: { code: ['static int doubled(int x) {', '    return x * 2;', '}'], label: { en: 'hands the value back', tr: 'değeri geri verir' } },
                body: { en: 'println talks to the human. return talks to the rest of your code.', tr: 'println insana konuşur. return kodunun geri kalanına konuşur.' },
            },
            {
                kind: 'pitfall', icon: '⚠️',
                title: { en: 'Java passes copies — of the reference too', tr: 'Java kopya geçirir — referansı da kopyalar' },
                code: ['static void reset(int n) { n = 0; }', '// caller unchanged', '', 'static void clear(List<String> xs) {', '    xs.clear();  // caller sees it', '}'],
                body: {
                    en: 'Reassigning a parameter is invisible outside. Mutating the object it points to is not.',
                    tr: 'Parametreye yeniden atama dışarıdan görünmez. İşaret ettiği nesneyi değiştirmek görünür.',
                },
            },
            {
                kind: 'recap', icon: '✅',
                title: { en: 'Three things to carry out', tr: 'Yanında götüreceğin üç şey' },
                bullets: [
                    { en: 'The signature is the contract: return type, name, parameters.', tr: 'İmza sözleşmedir: dönüş tipi, isim, parametreler.' },
                    { en: 'Overloading replaces the default parameters Java lacks.', tr: 'Aşırı yükleme, Java’da olmayan varsayılan parametrenin yerini tutar.' },
                    { en: 'Reassigning a parameter is local; mutating the object is not.', tr: 'Parametreye atama yereldir; nesneyi değiştirmek değildir.' },
                ],
            },
        ],
    },
    7: {
        titleEn: 'Stacks, Queues & Trees', titleTr: 'Yığın, Kuyruk & Ağaçlar',
        minutes: 2,
        cards: [
            {
                kind: 'hook', icon: '🏗️',
                title: { en: 'The order you take things out is a design decision', tr: 'Çıkarma sırası bir tasarım kararıdır' },
                body: {
                    en: 'Undo, print jobs, browser history — each picks a different "who is next?" rule.',
                    tr: 'Geri al, yazıcı işleri, tarayıcı geçmişi — her biri farklı bir "sıra kimde?" kuralı seçer.',
                },
            },
            {
                kind: 'idea', icon: '🥞',
                title: { en: 'Stack — last in, first out', tr: 'Yığın — son giren ilk çıkar' },
                body: {
                    en: 'A pile of plates. You always take the one you put down most recently. That is Ctrl+Z.',
                    tr: 'Tabak yığını. Hep en son koyduğunu alırsın. Ctrl+Z tam olarak budur.',
                },
                code: ['Deque<String> stack =', '    new ArrayDeque<>();', 'stack.push("a");', 'stack.push("b");', 'stack.pop();   // "b"'],
                caption: { en: 'Prefer ArrayDeque over the legacy Stack class — it is faster.', tr: 'Eski Stack sınıfı yerine ArrayDeque tercih et — daha hızlıdır.' },
            },
            {
                kind: 'code', icon: '🚶',
                title: { en: 'Queue — first in, first out', tr: 'Kuyruk — ilk giren ilk çıkar' },
                code: ['Queue<String> q = new ArrayDeque<>();', 'q.offer("a");     // join the back', 'q.offer("b");', 'q.poll();         // "a" leaves first'],
                caption: { en: 'Same class, two doors: push/pop for LIFO, offer/poll for FIFO.', tr: 'Aynı sınıf, iki kapı: LIFO için push/pop, FIFO için offer/poll.' },
            },
            {
                kind: 'compare', icon: '⚖️',
                title: { en: 'Which list for removing from the front?', tr: 'Baştan silmek için hangi liste?' },
                bad: { code: ['List<String> q = new ArrayList<>();', 'q.remove(0);   // shifts every element'], label: { en: 'O(n) — slower as it grows', tr: 'O(n) — büyüdükçe yavaşlar' } },
                good: { code: ['Deque<String> q = new ArrayDeque<>();', 'q.poll();      // just moves a pointer'], label: { en: 'O(1) — constant, always', tr: 'O(1) — her zaman sabit' } },
                body: { en: 'Same result, different cost. At 10 items nobody notices; at 100k everybody does.', tr: 'Aynı sonuç, farklı maliyet. 10 elemanda kimse fark etmez; 100 binde herkes eder.' },
            },
            {
                kind: 'idea', icon: '🌳',
                title: { en: 'Linked list & tree — nodes pointing at nodes', tr: 'Bağlı liste & ağaç — düğümleri işaret eden düğümler' },
                body: {
                    en: 'Stop storing items side by side. Store each item with a reference to the next — one reference is a list, two is a tree.',
                    tr: 'Elemanları yan yana tutmayı bırak. Her elemanı sonrakine referansla tut — bir referans liste, iki referans ağaç yapar.',
                },
                code: ['class Node {', '    int value;', '    Node left, right;', '    Node(int v) { value = v; }', '}'],
                caption: { en: 'Drop right and the same class becomes a linked list.', tr: 'right’ı çıkar, aynı sınıf bağlı listeye dönüşür.' },
            },
            {
                kind: 'recap', icon: '✅',
                title: { en: 'Three things to carry out', tr: 'Yanında götüreceğin üç şey' },
                bullets: [
                    { en: 'Stack = LIFO (push/pop). Queue = FIFO (offer/poll).', tr: 'Yığın = LIFO (push/pop). Kuyruk = FIFO (offer/poll).' },
                    { en: 'ArrayDeque does both, and beats ArrayList at the front.', tr: 'ArrayDeque ikisini de yapar ve baştan silmede ArrayList’i yener.' },
                    { en: 'Trees and linked lists are just nodes holding references.', tr: 'Ağaçlar ve bağlı listeler, referans tutan düğümlerden ibarettir.' },
                ],
            },
        ],
    },
}


/* ── Chapters that had no teaching at all until now ──
   Measurement showed a beginner's success collapsing from 83% in CH1 to 0%
   by CH6, and the adaptive selector cannot rescue them: it can only choose
   from a node's own pool, and those pools bottom out well above a novice.
   The missing ingredient was instruction, not difficulty tuning.

   Each deck follows the worked-example order the novice literature is
   clearest about (Sweller): show a complete, correct example BEFORE asking
   anyone to produce one. The compare and pitfall cards then fade the
   scaffolding — right next to wrong, so the difference is the lesson —
   which sets up the Predict step the exercises already ask for (PRIMM,
   Sentance & Waite). */
Object.assign(pythonDecks, {
    "3": {
        "titleEn": "Loops",
        "titleTr": "Döngüler",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🔁",
                "title": {
                    "en": "Doing it again, without writing it again",
                    "tr": "Tekrar etmek, tekrarlı yazmadan"
                },
                "body": {
                    "en": "A loop is one block of code plus an instruction for how many times to run it.",
                    "tr": "Döngü, tek bir kod bloğu artı onu kaç kez çalıştıracağının talimatıdır."
                }
            },
            {
                "kind": "idea",
                "icon": "🎯",
                "title": {
                    "en": "for walks a sequence, while waits for a condition",
                    "tr": "for bir diziyi gezer, while bir koşulu bekler"
                },
                "body": {
                    "en": "Use for when you know what you are walking through. Use while when you are waiting for something to become true.",
                    "tr": "Neyi gezdiğini biliyorsan for, bir şeyin doğru olmasını bekliyorsan while kullan."
                },
                "code": [
                    "for ch in \"abc\":",
                    "    print(ch)      # a b c",
                    "",
                    "n = 3",
                    "while n > 0:",
                    "    n -= 1         # 3 2 1"
                ],
                "caption": {
                    "en": "A while loop that never changes its condition never ends.",
                    "tr": "Koşulunu hiç değiştirmeyen while döngüsü hiç bitmez."
                }
            },
            {
                "kind": "code",
                "icon": "🔢",
                "title": {
                    "en": "range gives numbers, not a list you can see",
                    "tr": "range sayı üretir, göreceğin bir liste değil"
                },
                "code": [
                    "range(3)      # 0 1 2  — stops BEFORE 3",
                    "range(1, 4)   # 1 2 3",
                    "range(0, 10, 2)  # 0 2 4 6 8"
                ],
                "caption": {
                    "en": "The end value is always excluded. range(3) never produces 3.",
                    "tr": "Bitiş değeri her zaman dışarıda kalır. range(3) hiç 3 üretmez."
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "The classic off-by-one",
                    "tr": "Klasik bir-eksik hatası"
                },
                "body": {
                    "en": "The list has 3 items at indexes 0, 1, 2. Walking to len(a) reaches index 3, which does not exist.",
                    "tr": "Listede 0, 1, 2 indekslerinde 3 eleman var. len(a)'ya kadar gitmek olmayan 3. indekse uzanır."
                },
                "code": [
                    "a = [10, 20, 30]",
                    "for i in range(len(a) + 1):",
                    "    print(a[i])   # IndexError on the last pass"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "for when the count is known, while when it is not.",
                        "tr": "Sayı belliyse for, değilse while."
                    },
                    {
                        "en": "range stops before its end value.",
                        "tr": "range bitiş değerinden önce durur."
                    },
                    {
                        "en": "Nested loops multiply: 3 outer x 4 inner is 12 runs.",
                        "tr": "İç içe döngüler çarpar: 3 dış x 4 iç = 12."
                    },
                    {
                        "en": "A loop that never changes its condition never ends.",
                        "tr": "Koşulunu değiştirmeyen döngü bitmez."
                    }
                ]
            }
        ]
    },
    "5": {
        "titleEn": "Collections",
        "titleTr": "Koleksiyonlar",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🗂️",
                "title": {
                    "en": "One name, many values",
                    "tr": "Tek isim, çok değer"
                },
                "body": {
                    "en": "A list keeps things in order. A dict looks things up by name. A set remembers only whether it has seen something.",
                    "tr": "Liste sırayı korur. Sözlük isimle arar. Küme sadece gördü mü görmedi mi bilir."
                }
            },
            {
                "kind": "code",
                "icon": "📋",
                "title": {
                    "en": "Lists are ordered and indexed from 0",
                    "tr": "Listeler sıralıdır ve 0'dan indekslenir"
                },
                "code": [
                    "a = [10, 20, 30]",
                    "a[0]      # 10",
                    "a[-1]     # 30  — from the end",
                    "a[1:3]    # [20, 30]  — stops before 3"
                ],
                "caption": {
                    "en": "Slicing always returns a NEW list; the original is untouched.",
                    "tr": "Dilimleme her zaman YENİ liste döndürür; orijinal değişmez."
                }
            },
            {
                "kind": "compare",
                "icon": "🔍",
                "title": {
                    "en": "Two names, one list",
                    "tr": "İki isim, tek liste"
                },
                "body": {
                    "en": "b = a does not copy. Both names point at the same object, so appending through either is visible through both.",
                    "tr": "b = a kopyalamaz. İki isim de aynı nesneyi gösterir; birinden ekleyince ikisinde de görünür."
                },
                "bad": {
                    "label": {
                        "en": "Shares the same list",
                        "tr": "Aynı listeyi paylaşır"
                    },
                    "code": [
                        "a = [1, 2]",
                        "b = a",
                        "b.append(3)",
                        "print(a)   # [1, 2, 3]"
                    ]
                },
                "good": {
                    "label": {
                        "en": "Independent copy",
                        "tr": "Bağımsız kopya"
                    },
                    "code": [
                        "a = [1, 2]",
                        "b = a[:]",
                        "b.append(3)",
                        "print(a)   # [1, 2]"
                    ]
                }
            },
            {
                "kind": "idea",
                "icon": "🔑",
                "title": {
                    "en": "Dicts trade order for speed",
                    "tr": "Sözlükler sırayı hıza takas eder"
                },
                "body": {
                    "en": "Looking up a key costs the same whether the dict has ten entries or ten million. Scanning a list does not.",
                    "tr": "Anahtar araması sözlükte on kayıt da olsa on milyon da olsa aynı sürer. Listede taramak öyle değil."
                },
                "code": [
                    "stock = {\"apple\": 3}",
                    "stock[\"apple\"]        # 3",
                    "stock.get(\"pear\", 0)  # 0, and does NOT add the key"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "Assignment shares; slicing copies.",
                        "tr": "Atama paylaşır, dilimleme kopyalar."
                    },
                    {
                        "en": "A slice stops BEFORE its end index.",
                        "tr": "Dilim bitiş indeksinden ÖNCE durur."
                    },
                    {
                        "en": "Strings cannot be changed — methods return new ones.",
                        "tr": "String değişmez — metotlar yenisini döndürür."
                    },
                    {
                        "en": "dict/set lookup is flat; list scanning grows with size.",
                        "tr": "Sözlük/küme araması sabit; liste taraması boyla büyür."
                    }
                ]
            }
        ]
    },
    "6": {
        "titleEn": "Sorting & Searching",
        "titleTr": "Sıralama & Arama",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "⚖️",
                "title": {
                    "en": "The same answer, wildly different cost",
                    "tr": "Aynı cevap, çok farklı maliyet"
                },
                "body": {
                    "en": "Every algorithm here produces the correct result. What separates them is how the work grows as the input grows.",
                    "tr": "Buradaki her algoritma doğru sonucu verir. Farkları, girdi büyüdükçe işin nasıl büyüdüğüdür."
                }
            },
            {
                "kind": "idea",
                "icon": "📈",
                "title": {
                    "en": "Big-O counts growth, not seconds",
                    "tr": "Big-O saniyeyi değil büyümeyi sayar"
                },
                "body": {
                    "en": "O(n) means doubling the input doubles the work. O(n²) means doubling it quadruples the work.",
                    "tr": "O(n): girdi iki katına çıkınca iş iki katına çıkar. O(n²): dört katına çıkar."
                },
                "code": [
                    "# 1,000,000 items",
                    "O(1)       ->  1 step",
                    "O(log n)   ->  20 steps",
                    "O(n)       ->  1,000,000",
                    "O(n log n) ->  20,000,000",
                    "O(n^2)     ->  1,000,000,000,000"
                ],
                "caption": {
                    "en": "That last row is why nobody hand-writes a quadratic sort.",
                    "tr": "Son satır, kimsenin elle kare karmaşıklıkta sıralama yazmamasının sebebi."
                }
            },
            {
                "kind": "code",
                "icon": "🔎",
                "title": {
                    "en": "Binary search halves the problem",
                    "tr": "İkili arama problemi ikiye böler"
                },
                "body": {
                    "en": "It only works on SORTED data — throwing away half the range assumes everything left of the middle is smaller.",
                    "tr": "Sadece SIRALI veride çalışır — yarıyı atmak, ortanın solundaki her şeyin küçük olduğunu varsayar."
                },
                "code": [
                    "lo, hi = 0, len(a) - 1",
                    "while lo <= hi:",
                    "    mid = (lo + hi) // 2",
                    "    if a[mid] == target: return mid",
                    "    if a[mid] < target: lo = mid + 1",
                    "    else: hi = mid - 1"
                ],
                "caption": {
                    "en": "On unsorted input it returns a confident wrong answer, with no error.",
                    "tr": "Sırasız veride hatasızca, kendinden emin bir yanlış cevap döndürür."
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "Each branch must SHRINK the range",
                    "tr": "Her dal aralığı KÜÇÜLTMELİ"
                },
                "body": {
                    "en": "When hi is lo+1, mid rounds down to lo — so lo = mid changes nothing and the loop spins forever. It must be mid + 1.",
                    "tr": "hi, lo+1 olduğunda mid aşağı yuvarlanıp lo olur — lo = mid hiçbir şeyi değiştirmez, döngü sonsuza döner. mid + 1 olmalı."
                },
                "code": [
                    "if a[mid] < target:",
                    "    lo = mid       # ← hangs",
                    "    lo = mid + 1   # ← correct"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "Sorted input is information — use it or you wasted it.",
                        "tr": "Sıralı girdi bilgidir — kullanmazsan israf."
                    },
                    {
                        "en": "Python's sort is O(n log n) and stable: ties keep their order.",
                        "tr": "Python'un sort'u O(n log n) ve kararlı: eşitler sırasını korur."
                    },
                    {
                        "en": "Nested loops over the same list are O(n²).",
                        "tr": "Aynı liste üzerinde iç içe döngü O(n²)'dir."
                    },
                    {
                        "en": "A builtin doing the scanning does not make it free.",
                        "tr": "Taramayı hazır fonksiyon yapıyor olması onu bedava yapmaz."
                    }
                ]
            }
        ]
    },
    "8": {
        "titleEn": "Recursion & Memoisation",
        "titleTr": "Özyineleme & Bellekleme",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🪆",
                "title": {
                    "en": "A function that calls itself",
                    "tr": "Kendini çağıran fonksiyon"
                },
                "body": {
                    "en": "Recursion solves a problem by solving a SMALLER version of the same problem, then combining.",
                    "tr": "Özyineleme, aynı problemin DAHA KÜÇÜK bir versiyonunu çözüp birleştirerek çalışır."
                }
            },
            {
                "kind": "code",
                "icon": "🧱",
                "title": {
                    "en": "Two parts, always",
                    "tr": "Her zaman iki parça"
                },
                "body": {
                    "en": "A base case that returns without recursing, and a recursive step that moves TOWARD it.",
                    "tr": "Özyinelemeden dönen bir taban durum, ve ona DOĞRU ilerleyen bir adım."
                },
                "code": [
                    "def total(items):",
                    "    if not items: return 0      # base case",
                    "    return items[0] + total(items[1:])  # step"
                ],
                "caption": {
                    "en": "Miss either one and it runs until Python stops it.",
                    "tr": "İkisinden biri eksikse Python durdurana kadar çalışır."
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "Unreachable is as bad as missing",
                    "tr": "Ulaşılamaz olmak, olmamak kadar kötü"
                },
                "body": {
                    "en": "The base case here is correct and never fires: from an odd n the sequence steps straight over 0.",
                    "tr": "Buradaki taban durum doğru ve hiç çalışmıyor: tek bir n'den başlayınca dizi 0'ın üstünden atlıyor."
                },
                "code": [
                    "def down(n):",
                    "    if n == 0: return    # never true from n = 5",
                    "    down(n - 2)          # 5, 3, 1, -1, -3 ..."
                ]
            },
            {
                "kind": "compare",
                "icon": "⚡",
                "title": {
                    "en": "The same code, two costs",
                    "tr": "Aynı kod, iki maliyet"
                },
                "body": {
                    "en": "Caching does not change the algorithm. It changes how many times the algorithm runs.",
                    "tr": "Bellekleme algoritmayı değiştirmez. Algoritmanın kaç kez çalıştığını değiştirir."
                },
                "bad": {
                    "label": {
                        "en": "2,692,537 calls for n=30",
                        "tr": "n=30 için 2.692.537 çağrı"
                    },
                    "code": [
                        "def fib(n):",
                        "    if n < 2: return n",
                        "    return fib(n-1) + fib(n-2)"
                    ]
                },
                "good": {
                    "label": {
                        "en": "31 calls for n=30",
                        "tr": "n=30 için 31 çağrı"
                    },
                    "code": [
                        "@lru_cache(maxsize=None)",
                        "def fib(n):",
                        "    if n < 2: return n",
                        "    return fib(n-1) + fib(n-2)"
                    ]
                }
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "Base case + a step that reaches it.",
                        "tr": "Taban durum + ona ulaşan bir adım."
                    },
                    {
                        "en": "Work placed AFTER the call runs on the way back up.",
                        "tr": "Çağrıdan SONRA yazılan iş, dönüşte çalışır."
                    },
                    {
                        "en": "A cache is two halves: check before, store after.",
                        "tr": "Önbellek iki yarımdır: önce kontrol, sonra kaydet."
                    },
                    {
                        "en": "Every pending call holds a stack frame.",
                        "tr": "Bekleyen her çağrı bir yığın çerçevesi tutar."
                    }
                ]
            }
        ]
    },
    "9": {
        "titleEn": "Graphs",
        "titleTr": "Graflar",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🕸️",
                "title": {
                    "en": "Things, and what connects them",
                    "tr": "Şeyler ve onları bağlayanlar"
                },
                "body": {
                    "en": "A graph is vertices (things) plus edges (connections). Roads, friendships, dependencies — all the same shape.",
                    "tr": "Graf = düğümler (şeyler) + kenarlar (bağlantılar). Yollar, arkadaşlıklar, bağımlılıklar — hepsi aynı şekil."
                }
            },
            {
                "kind": "code",
                "icon": "🗺️",
                "title": {
                    "en": "An adjacency list is just a dict",
                    "tr": "Komşuluk listesi aslında bir sözlük"
                },
                "code": [
                    "g = {",
                    "    \"A\": [\"B\", \"C\"],",
                    "    \"B\": [\"A\"],",
                    "    \"C\": [\"A\"],",
                    "}"
                ],
                "caption": {
                    "en": "An undirected edge appears TWICE — once from each end.",
                    "tr": "Yönsüz bir kenar İKİ kez görünür — her uçtan bir kez."
                }
            },
            {
                "kind": "compare",
                "icon": "🚶",
                "title": {
                    "en": "One structure decides the whole traversal",
                    "tr": "Tek veri yapısı tüm gezinmeyi belirler"
                },
                "body": {
                    "en": "Take from the front and you sweep level by level. Take from the back and you dive down one branch.",
                    "tr": "Baştan alırsan seviye seviye tararsın. Sondan alırsan tek dala dalarsın."
                },
                "bad": {
                    "label": {
                        "en": "Stack -> depth-first",
                        "tr": "Yığın -> derinlik öncelikli"
                    },
                    "code": [
                        "q.pop()      # A B D C",
                        "# dives to a leaf first"
                    ]
                },
                "good": {
                    "label": {
                        "en": "Queue -> breadth-first",
                        "tr": "Kuyruk -> genişlik öncelikli"
                    },
                    "code": [
                        "q.popleft()  # A B C D",
                        "# finishes each ring first"
                    ]
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "A graph can lead you back",
                    "tr": "Graf seni geri getirebilir"
                },
                "body": {
                    "en": "A tree has no way back to where you came from. A graph does — without a visited set the walk never ends.",
                    "tr": "Ağaçta geldiğin yere dönüş yoktur. Grafta vardır — ziyaret kümesi olmadan gezinme hiç bitmez."
                },
                "code": [
                    "seen = set()",
                    "if node in seen: return",
                    "seen.add(node)"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "BFS finds the SHORTEST path when edges are unweighted.",
                        "tr": "Kenarlar ağırlıksızsa EN KISA yolu BFS bulur."
                    },
                    {
                        "en": "DFS is for cycles and ordering, not distance.",
                        "tr": "DFS döngü ve sıralama içindir, mesafe için değil."
                    },
                    {
                        "en": "Always mark visited, and mark on ENQUEUE.",
                        "tr": "Ziyaret edileni işaretle — KUYRUĞA ATARKEN."
                    },
                    {
                        "en": "Undirected means the edge is recorded from both sides.",
                        "tr": "Yönsüz demek kenarın iki taraftan da yazılması demek."
                    }
                ]
            }
        ]
    },
    "10": {
        "titleEn": "Dynamic Programming",
        "titleTr": "Dinamik Programlama",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🧩",
                "title": {
                    "en": "When the same question keeps coming back",
                    "tr": "Aynı soru tekrar tekrar geldiğinde"
                },
                "body": {
                    "en": "DP is recursion plus a notebook: solve each smaller question once, write the answer down, never solve it again.",
                    "tr": "DP = özyineleme + defter: her küçük soruyu bir kez çöz, cevabı yaz, bir daha çözme."
                }
            },
            {
                "kind": "idea",
                "icon": "✌️",
                "title": {
                    "en": "Two conditions, both required",
                    "tr": "İki koşul, ikisi de şart"
                },
                "body": {
                    "en": "Overlapping subproblems: the same smaller question is asked on many paths. Optimal substructure: the best answer is built from best smaller answers.",
                    "tr": "Örtüşen alt problemler: aynı küçük soru birçok yolda sorulur. Optimal alt yapı: en iyi cevap, en iyi küçük cevaplardan kurulur."
                },
                "caption": {
                    "en": "Merge sort has substructure but no OVERLAP — a cache would never hit.",
                    "tr": "Merge sort'ta alt yapı var ama ÖRTÜŞME yok — önbellek hiç tutmaz."
                }
            },
            {
                "kind": "compare",
                "icon": "🔄",
                "title": {
                    "en": "Two directions, same answer",
                    "tr": "İki yön, aynı cevap"
                },
                "body": {
                    "en": "Top-down remembers as it goes. Bottom-up builds from the known end. Bottom-up has no stack to overflow.",
                    "tr": "Yukarıdan aşağı giderken hatırlar. Aşağıdan yukarı bilinenden kurar. İkincisinde taşacak yığın yok."
                },
                "bad": {
                    "label": {
                        "en": "Top-down (memoisation)",
                        "tr": "Yukarıdan aşağı (bellekleme)"
                    },
                    "code": [
                        "@lru_cache(None)",
                        "def fib(n):",
                        "    if n < 2: return n",
                        "    return fib(n-1) + fib(n-2)"
                    ]
                },
                "good": {
                    "label": {
                        "en": "Bottom-up (tabulation)",
                        "tr": "Aşağıdan yukarı (tablolama)"
                    },
                    "code": [
                        "dp = [0, 1]",
                        "for i in range(2, n+1):",
                        "    dp.append(dp[i-1] + dp[i-2])"
                    ]
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "The cache key must include EVERYTHING",
                    "tr": "Önbellek anahtarı HER ŞEYİ içermeli"
                },
                "body": {
                    "en": "Key on i alone when the answer also depends on remaining, and you serve the wrong stored value — wrong answers, not slow ones.",
                    "tr": "Cevap remaining'e de bağlıyken sadece i ile anahtarlarsan yanlış kaydı verirsin — yavaş değil, YANLIŞ sonuç."
                },
                "code": [
                    "memo[(i, remaining)] = r   # right",
                    "memo[i] = r                # silently wrong"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "Spot the repeated subquestion first.",
                        "tr": "Önce tekrar eden alt soruyu bul."
                    },
                    {
                        "en": "Only the last few table rows are usually needed.",
                        "tr": "Genelde tablonun son birkaç satırı yeter."
                    },
                    {
                        "en": "A too-narrow key gives wrong answers, not slow ones.",
                        "tr": "Dar anahtar yavaşlık değil yanlışlık üretir."
                    },
                    {
                        "en": "Kadane: at each step, extend the run or restart.",
                        "tr": "Kadane: her adımda ya diziyi uzat ya baştan başla."
                    }
                ]
            }
        ]
    }
})


Object.assign(jsDecks, {
    "3": {
        "titleEn": "Loops",
        "titleTr": "Döngüler",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🔁",
                "title": {
                    "en": "Doing it again, without writing it again",
                    "tr": "Tekrar etmek, tekrarlı yazmadan"
                },
                "body": {
                    "en": "A loop is one block of code plus an instruction for how many times to run it.",
                    "tr": "Döngü, tek bir kod bloğu artı onu kaç kez çalıştıracağının talimatıdır."
                }
            },
            {
                "kind": "compare",
                "icon": "⚠️",
                "title": {
                    "en": "for...of and for...in are NOT the same",
                    "tr": "for...of ile for...in AYNI DEĞİL"
                },
                "body": {
                    "en": "for...of hands you the values. for...in hands you the KEYS — and on an array those keys are strings, so \"0\" + 1 is \"01\".",
                    "tr": "for...of değerleri verir. for...in ANAHTARLARI verir — dizide bu anahtarlar string, yani \"0\" + 1 = \"01\"."
                },
                "bad": {
                    "label": {
                        "en": "for...in on an array",
                        "tr": "dizide for...in"
                    },
                    "code": [
                        "for (const i in [10,20]) {",
                        "  console.log(i);   // \"0\" \"1\" (strings!)",
                        "}"
                    ]
                },
                "good": {
                    "label": {
                        "en": "for...of on an array",
                        "tr": "dizide for...of"
                    },
                    "code": [
                        "for (const v of [10,20]) {",
                        "  console.log(v);   // 10 20",
                        "}"
                    ]
                }
            },
            {
                "kind": "code",
                "icon": "🔢",
                "title": {
                    "en": "The counting loop, spelled out",
                    "tr": "Sayan döngü, açık açık"
                },
                "code": [
                    "for (let i = 0; i < a.length; i++) {",
                    "  // i < length, never <=",
                    "}",
                    "",
                    "// let, not var: var leaks one shared i",
                    "// to every closure made in the loop"
                ],
                "caption": {
                    "en": "i < a.length, never <=. The last valid index is length - 1.",
                    "tr": "i < a.length, asla <= değil. Son geçerli indeks length - 1."
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "The classic off-by-one",
                    "tr": "Klasik bir-eksik hatası"
                },
                "body": {
                    "en": "The array has 3 items at indexes 0, 1, 2. Reaching index 3 gives undefined — no error, just a silent wrong value.",
                    "tr": "Dizide 0, 1, 2 indekslerinde 3 eleman var. 3. indekse uzanmak undefined verir — hata yok, sessiz yanlış değer."
                },
                "code": [
                    "const a = [10, 20, 30];",
                    "for (let i = 0; i <= a.length; i++)",
                    "  console.log(a[i]);  // 10 20 30 undefined"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "for...of for values, for...in for keys.",
                        "tr": "Değer için for...of, anahtar için for...in."
                    },
                    {
                        "en": "let per iteration; var is shared by all of them.",
                        "tr": "let her turda yeni; var hepsinde ortak."
                    },
                    {
                        "en": "Nested loops multiply: 3 outer x 4 inner is 12.",
                        "tr": "İç içe döngüler çarpar: 3 dış x 4 iç = 12."
                    },
                    {
                        "en": "Reading past the end gives undefined, not an error.",
                        "tr": "Sonu aşmak hata değil, undefined verir."
                    }
                ]
            }
        ]
    },
    "5": {
        "titleEn": "Collections",
        "titleTr": "Koleksiyonlar",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🗂️",
                "title": {
                    "en": "One name, many values",
                    "tr": "Tek isim, çok değer"
                },
                "body": {
                    "en": "An array keeps order. A Map looks things up by key. A Set remembers only whether it has seen something.",
                    "tr": "Dizi sırayı korur. Map anahtarla arar. Set sadece gördü mü görmedi mi bilir."
                }
            },
            {
                "kind": "compare",
                "icon": "🔗",
                "title": {
                    "en": "const does NOT freeze the contents",
                    "tr": "const İÇERİĞİ dondurmaz"
                },
                "body": {
                    "en": "const stops the NAME being pointed somewhere else. The object it points at is still fully editable.",
                    "tr": "const, İSMİN başka yeri göstermesini engeller. Gösterdiği nesne hâlâ tamamen değiştirilebilir."
                },
                "bad": {
                    "label": {
                        "en": "Shares the same array",
                        "tr": "Aynı diziyi paylaşır"
                    },
                    "code": [
                        "const a = [1, 2];",
                        "const b = a;",
                        "b.push(3);",
                        "console.log(a);  // [1, 2, 3]"
                    ]
                },
                "good": {
                    "label": {
                        "en": "Independent copy",
                        "tr": "Bağımsız kopya"
                    },
                    "code": [
                        "const a = [1, 2];",
                        "const b = [...a];",
                        "b.push(3);",
                        "console.log(a);  // [1, 2]"
                    ]
                }
            },
            {
                "kind": "code",
                "icon": "✂️",
                "title": {
                    "en": "Which methods return, which mutate",
                    "tr": "Hangisi döndürür, hangisi değiştirir"
                },
                "code": [
                    "// return a NEW array",
                    "map  filter  slice  concat",
                    "",
                    "// change the array IN PLACE",
                    "push  splice  sort  reverse"
                ],
                "caption": {
                    "en": "slice returns, splice mutates. One letter apart, opposite behaviour.",
                    "tr": "slice döndürür, splice değiştirir. Tek harf fark, zıt davranış."
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "Reading a missing key",
                    "tr": "Olmayan anahtarı okumak"
                },
                "body": {
                    "en": "A Map returns undefined for a key it does not have — not null, not an error — and it does NOT create the key.",
                    "tr": "Map olmayan anahtar için undefined döndürür — null değil, hata değil — ve anahtarı OLUŞTURMAZ."
                },
                "code": [
                    "m.get(\"pear\")   // undefined",
                    "m.has(\"pear\")   // still false",
                    "m.get(k) ?? 0   // ?? not ||, so a real 0 survives"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "Assignment shares; spread copies (shallowly).",
                        "tr": "Atama paylaşır; spread (yüzeysel) kopyalar."
                    },
                    {
                        "en": "slice stops BEFORE its end index.",
                        "tr": "slice bitiş indeksinden ÖNCE durur."
                    },
                    {
                        "en": "Strings are immutable — methods return new ones.",
                        "tr": "String değişmez — metotlar yenisini döndürür."
                    },
                    {
                        "en": "Set/Map lookup is flat; includes() scans.",
                        "tr": "Set/Map araması sabit; includes() tarar."
                    }
                ]
            }
        ]
    },
    "6": {
        "titleEn": "Sorting & Searching",
        "titleTr": "Sıralama & Arama",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "⚖️",
                "title": {
                    "en": "The same answer, wildly different cost",
                    "tr": "Aynı cevap, çok farklı maliyet"
                },
                "body": {
                    "en": "Every algorithm here is correct. What separates them is how the work grows as the input grows.",
                    "tr": "Buradaki her algoritma doğru. Farkları, girdi büyüdükçe işin nasıl büyüdüğü."
                }
            },
            {
                "kind": "pitfall",
                "icon": "🚨",
                "title": {
                    "en": "sort() compares as TEXT",
                    "tr": "sort() METİN olarak karşılaştırır"
                },
                "body": {
                    "en": "Default sort turns every element into a string, so \"100\" lands before \"9\" the same way \"ab\" lands before \"b\". It never throws — it just quietly mis-sorts.",
                    "tr": "Varsayılan sort her elemanı stringe çevirir; \"100\", \"9\"dan önce gelir — tıpkı \"ab\"nin \"b\"den önce gelmesi gibi. Hata atmaz, sessizce yanlış sıralar."
                },
                "code": [
                    "[10, 9, 100, 1].sort()",
                    "// [1, 10, 100, 9]   ← wrong",
                    "",
                    "[10, 9, 100, 1].sort((a, b) => a - b)",
                    "// [1, 9, 10, 100]   ← right"
                ]
            },
            {
                "kind": "idea",
                "icon": "📈",
                "title": {
                    "en": "Big-O counts growth, not seconds",
                    "tr": "Big-O saniyeyi değil büyümeyi sayar"
                },
                "code": [
                    "// 1,000,000 items",
                    "O(1)       ->  1 step",
                    "O(log n)   ->  20 steps",
                    "O(n)       ->  1,000,000",
                    "O(n log n) ->  20,000,000",
                    "O(n^2)     ->  1,000,000,000,000"
                ],
                "caption": {
                    "en": "That last row is why nobody hand-writes a quadratic sort.",
                    "tr": "Son satır, kimsenin elle kare karmaşıklıkta sıralama yazmamasının sebebi."
                }
            },
            {
                "kind": "code",
                "icon": "🔎",
                "title": {
                    "en": "Binary search halves the problem",
                    "tr": "İkili arama problemi ikiye böler"
                },
                "body": {
                    "en": "It only works on SORTED data, and every branch must SHRINK the range — lo = mid does not, and the loop spins forever.",
                    "tr": "Sadece SIRALI veride çalışır ve her dal aralığı KÜÇÜLTMELİ — lo = mid küçültmez, döngü sonsuza döner."
                },
                "code": [
                    "let lo = 0, hi = a.length - 1;",
                    "while (lo <= hi) {",
                    "  const mid = Math.floor((lo + hi) / 2);",
                    "  if (a[mid] === t) return mid;",
                    "  if (a[mid] < t) lo = mid + 1;   // + 1 !",
                    "  else hi = mid - 1;",
                    "}"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "sort() needs a comparator for numbers. Always.",
                        "tr": "Sayılar için sort()'a karşılaştırıcı şart. Her zaman."
                    },
                    {
                        "en": "sort mutates and returns the SAME array.",
                        "tr": "sort değiştirir ve AYNI diziyi döndürür."
                    },
                    {
                        "en": "Sorted input is information — use it or you wasted it.",
                        "tr": "Sıralı girdi bilgidir — kullanmazsan israf."
                    },
                    {
                        "en": "A builtin doing the scanning does not make it free.",
                        "tr": "Taramayı hazır fonksiyon yapıyor olması onu bedava yapmaz."
                    }
                ]
            }
        ]
    },
    "8": {
        "titleEn": "Recursion & Memoisation",
        "titleTr": "Özyineleme & Bellekleme",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🪆",
                "title": {
                    "en": "A function that calls itself",
                    "tr": "Kendini çağıran fonksiyon"
                },
                "body": {
                    "en": "Recursion solves a problem by solving a SMALLER version of the same problem, then combining.",
                    "tr": "Özyineleme, aynı problemin DAHA KÜÇÜK versiyonunu çözüp birleştirerek çalışır."
                }
            },
            {
                "kind": "code",
                "icon": "🧱",
                "title": {
                    "en": "Two parts, always",
                    "tr": "Her zaman iki parça"
                },
                "body": {
                    "en": "A base case that returns without recursing, and a step that moves TOWARD it.",
                    "tr": "Özyinelemeden dönen bir taban durum ve ona DOĞRU ilerleyen bir adım."
                },
                "code": [
                    "function total(a) {",
                    "  if (a.length === 0) return 0;      // base",
                    "  return a[0] + total(a.slice(1));   // step",
                    "}"
                ],
                "caption": {
                    "en": "Miss either and you get RangeError: Maximum call stack size exceeded.",
                    "tr": "Biri eksikse RangeError: Maximum call stack size exceeded alırsın."
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "Unreachable is as bad as missing",
                    "tr": "Ulaşılamaz olmak, olmamak kadar kötü"
                },
                "body": {
                    "en": "This base case is correct and never fires: from an odd n the sequence steps straight over 0.",
                    "tr": "Bu taban durum doğru ve hiç çalışmıyor: tek bir n'den başlayınca dizi 0'ın üstünden atlıyor."
                },
                "code": [
                    "function down(n) {",
                    "  if (n === 0) return;   // never true from 5",
                    "  down(n - 2);           // 5, 3, 1, -1, -3 ...",
                    "}"
                ]
            },
            {
                "kind": "compare",
                "icon": "⚡",
                "title": {
                    "en": "The same code, two costs",
                    "tr": "Aynı kod, iki maliyet"
                },
                "body": {
                    "en": "Caching does not change the algorithm. It changes how many times the algorithm runs.",
                    "tr": "Bellekleme algoritmayı değiştirmez. Kaç kez çalıştığını değiştirir."
                },
                "bad": {
                    "label": {
                        "en": "2,692,537 calls for n=30",
                        "tr": "n=30 için 2.692.537 çağrı"
                    },
                    "code": [
                        "function fib(n) {",
                        "  if (n < 2) return n;",
                        "  return fib(n-1) + fib(n-2);",
                        "}"
                    ]
                },
                "good": {
                    "label": {
                        "en": "29 values computed",
                        "tr": "29 değer hesaplanır"
                    },
                    "code": [
                        "const memo = new Map();",
                        "function fib(n) {",
                        "  if (n < 2) return n;",
                        "  if (memo.has(n)) return memo.get(n);",
                        "  const r = fib(n-1) + fib(n-2);",
                        "  memo.set(n, r); return r;",
                        "}"
                    ]
                }
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "Base case + a step that reaches it.",
                        "tr": "Taban durum + ona ulaşan bir adım."
                    },
                    {
                        "en": "Work placed AFTER the call runs on the way back up.",
                        "tr": "Çağrıdan SONRA yazılan iş dönüşte çalışır."
                    },
                    {
                        "en": "A cache is two halves: check before, store after.",
                        "tr": "Önbellek iki yarımdır: önce kontrol, sonra kaydet."
                    },
                    {
                        "en": "JS has no reliable tail-call removal — deep means a loop.",
                        "tr": "JS'te güvenilir kuyruk çağrısı optimizasyonu yok — derinse döngü kullan."
                    }
                ]
            }
        ]
    },
    "9": {
        "titleEn": "Graphs",
        "titleTr": "Graflar",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🕸️",
                "title": {
                    "en": "Things, and what connects them",
                    "tr": "Şeyler ve onları bağlayanlar"
                },
                "body": {
                    "en": "A graph is vertices (things) plus edges (connections). Roads, follows, dependencies — all the same shape.",
                    "tr": "Graf = düğümler (şeyler) + kenarlar (bağlantılar). Yollar, takipler, bağımlılıklar — hepsi aynı şekil."
                }
            },
            {
                "kind": "code",
                "icon": "🗺️",
                "title": {
                    "en": "An adjacency list is just an object",
                    "tr": "Komşuluk listesi aslında bir nesne"
                },
                "code": [
                    "const g = {",
                    "  A: [\"B\", \"C\"],",
                    "  B: [\"A\"],",
                    "  C: [\"A\"],",
                    "};"
                ],
                "caption": {
                    "en": "An undirected edge appears TWICE — once from each end.",
                    "tr": "Yönsüz bir kenar İKİ kez görünür — her uçtan bir kez."
                }
            },
            {
                "kind": "compare",
                "icon": "🚶",
                "title": {
                    "en": "One structure decides the whole traversal",
                    "tr": "Tek veri yapısı tüm gezinmeyi belirler"
                },
                "body": {
                    "en": "Take from the front and you sweep level by level. Take from the back and you dive down one branch.",
                    "tr": "Baştan alırsan seviye seviye tararsın. Sondan alırsan tek dala dalarsın."
                },
                "bad": {
                    "label": {
                        "en": "pop() -> depth-first",
                        "tr": "pop() -> derinlik öncelikli"
                    },
                    "code": [
                        "const n = q.pop();   // A B D C",
                        "// dives to a leaf first"
                    ]
                },
                "good": {
                    "label": {
                        "en": "shift() -> breadth-first",
                        "tr": "shift() -> genişlik öncelikli"
                    },
                    "code": [
                        "const n = q.shift(); // A B C D",
                        "// finishes each ring first"
                    ]
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "A graph can lead you back",
                    "tr": "Graf seni geri getirebilir"
                },
                "body": {
                    "en": "A tree has no way back to where you came from. A graph does — without a visited Set the walk never ends.",
                    "tr": "Ağaçta geldiğin yere dönüş yoktur. Grafta vardır — ziyaret Set'i olmadan gezinme hiç bitmez."
                },
                "code": [
                    "const seen = new Set();",
                    "if (seen.has(node)) return;",
                    "seen.add(node);"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "BFS finds the SHORTEST path when edges are unweighted.",
                        "tr": "Kenarlar ağırlıksızsa EN KISA yolu BFS bulur."
                    },
                    {
                        "en": "DFS is for cycles and ordering, not distance.",
                        "tr": "DFS döngü ve sıralama içindir, mesafe için değil."
                    },
                    {
                        "en": "Always mark visited, and mark on ENQUEUE.",
                        "tr": "Ziyaret edileni işaretle — KUYRUĞA ATARKEN."
                    },
                    {
                        "en": "shift() on a big queue is O(n) — keep a head index.",
                        "tr": "Büyük kuyrukta shift() O(n) — baş indeksi tut."
                    }
                ]
            }
        ]
    },
    "10": {
        "titleEn": "Dynamic Programming",
        "titleTr": "Dinamik Programlama",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🧩",
                "title": {
                    "en": "When the same question keeps coming back",
                    "tr": "Aynı soru tekrar tekrar geldiğinde"
                },
                "body": {
                    "en": "DP is recursion plus a notebook: solve each smaller question once, write the answer down, never solve it again.",
                    "tr": "DP = özyineleme + defter: her küçük soruyu bir kez çöz, cevabı yaz, bir daha çözme."
                }
            },
            {
                "kind": "idea",
                "icon": "✌️",
                "title": {
                    "en": "Two conditions, both required",
                    "tr": "İki koşul, ikisi de şart"
                },
                "body": {
                    "en": "Overlapping subproblems: the same smaller question is asked on many paths. Optimal substructure: the best answer is built from best smaller answers.",
                    "tr": "Örtüşen alt problemler: aynı küçük soru birçok yolda sorulur. Optimal alt yapı: en iyi cevap en iyi küçük cevaplardan kurulur."
                },
                "caption": {
                    "en": "Merge sort has substructure but no OVERLAP — a cache would never hit.",
                    "tr": "Merge sort'ta alt yapı var ama ÖRTÜŞME yok — önbellek hiç tutmaz."
                }
            },
            {
                "kind": "compare",
                "icon": "🔄",
                "title": {
                    "en": "Two directions, same answer",
                    "tr": "İki yön, aynı cevap"
                },
                "body": {
                    "en": "Top-down remembers as it goes. Bottom-up builds from the known end, with no stack to overflow.",
                    "tr": "Yukarıdan aşağı giderken hatırlar. Aşağıdan yukarı bilinenden kurar, taşacak yığın yok."
                },
                "bad": {
                    "label": {
                        "en": "Top-down (memoisation)",
                        "tr": "Yukarıdan aşağı (bellekleme)"
                    },
                    "code": [
                        "const memo = new Map();",
                        "function fib(n) {",
                        "  if (n < 2) return n;",
                        "  if (memo.has(n)) return memo.get(n);",
                        "  ...",
                        "}"
                    ]
                },
                "good": {
                    "label": {
                        "en": "Bottom-up (tabulation)",
                        "tr": "Aşağıdan yukarı (tablolama)"
                    },
                    "code": [
                        "const dp = [0, 1];",
                        "for (let i = 2; i <= n; i++)",
                        "  dp.push(dp[i-1] + dp[i-2]);"
                    ]
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "The cache key must include EVERYTHING",
                    "tr": "Önbellek anahtarı HER ŞEYİ içermeli"
                },
                "body": {
                    "en": "Key on i alone when the answer also depends on remaining, and you serve the wrong stored value — wrong answers, not slow ones.",
                    "tr": "Cevap remaining'e de bağlıyken sadece i ile anahtarlarsan yanlış kaydı verirsin — yavaş değil, YANLIŞ sonuç."
                },
                "code": [
                    "memo.set(`${i},${remaining}`, r);  // right",
                    "memo.set(i, r);                    // silently wrong"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "Spot the repeated subquestion first.",
                        "tr": "Önce tekrar eden alt soruyu bul."
                    },
                    {
                        "en": "Only the last few table rows are usually needed.",
                        "tr": "Genelde tablonun son birkaç satırı yeter."
                    },
                    {
                        "en": "A too-narrow key gives wrong answers, not slow ones.",
                        "tr": "Dar anahtar yavaşlık değil yanlışlık üretir."
                    },
                    {
                        "en": "Kadane: at each step, extend the run or restart.",
                        "tr": "Kadane: her adımda ya diziyi uzat ya baştan başla."
                    }
                ]
            }
        ]
    }
})

Object.assign(javaDecks, {
    "3": {
        "titleEn": "Loops",
        "titleTr": "Döngüler",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🔁",
                "title": {
                    "en": "Doing it again, without writing it again",
                    "tr": "Tekrar etmek, tekrarlı yazmadan"
                },
                "body": {
                    "en": "A loop is one block of code plus an instruction for how many times to run it.",
                    "tr": "Döngü, tek bir kod bloğu artı onu kaç kez çalıştıracağının talimatıdır."
                }
            },
            {
                "kind": "compare",
                "icon": "🎯",
                "title": {
                    "en": "Enhanced for gives the VALUE",
                    "tr": "Geliştirilmiş for DEĞERİ verir"
                },
                "body": {
                    "en": "The enhanced for reads as \"for each int n in nums\". Use the counting form only when you actually need the index.",
                    "tr": "Geliştirilmiş for \"nums içindeki her int n için\" diye okunur. Sayan formu sadece indekse gerçekten ihtiyacın varsa kullan."
                },
                "bad": {
                    "label": {
                        "en": "You wanted values, got indexes",
                        "tr": "Değer istedin, indeks aldın"
                    },
                    "code": [
                        "for (int i = 0; i < a.length; i++)",
                        "    System.out.println(i);   // 0 1 2"
                    ]
                },
                "good": {
                    "label": {
                        "en": "Enhanced for",
                        "tr": "Geliştirilmiş for"
                    },
                    "code": [
                        "for (int n : a)",
                        "    System.out.println(n);   // 10 20 30"
                    ]
                }
            },
            {
                "kind": "code",
                "icon": "🔢",
                "title": {
                    "en": "length is a field on arrays, a method on String",
                    "tr": "length dizide alan, String'de metot"
                },
                "code": [
                    "int[] a = {10, 20, 30};",
                    "a.length        // field — no parentheses",
                    "",
                    "String s = \"abc\";",
                    "s.length()      // method — parentheses",
                    "",
                    "List<Integer> l = List.of(1, 2);",
                    "l.size()        // and collections use size()"
                ],
                "caption": {
                    "en": "Three containers, three different spellings. It catches everyone once.",
                    "tr": "Üç kap, üç farklı yazım. Herkesi bir kez yakalar."
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "The classic off-by-one",
                    "tr": "Klasik bir-eksik hatası"
                },
                "body": {
                    "en": "The array has 3 items at indexes 0, 1, 2. Reaching index 3 throws ArrayIndexOutOfBoundsException — Java stops you, unlike JavaScript.",
                    "tr": "Dizide 0, 1, 2 indekslerinde 3 eleman var. 3. indekse uzanmak ArrayIndexOutOfBoundsException fırlatır — JavaScript'in aksine Java seni durdurur."
                },
                "code": [
                    "for (int i = 0; i <= a.length; i++)",
                    "    System.out.println(a[i]);",
                    "// ArrayIndexOutOfBoundsException: 3"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "Enhanced for for values, counting form for indexes.",
                        "tr": "Değer için geliştirilmiş for, indeks için sayan form."
                    },
                    {
                        "en": "i < length, never <=.",
                        "tr": "i < length, asla <= değil."
                    },
                    {
                        "en": "Nested loops multiply: 3 outer x 4 inner is 12.",
                        "tr": "İç içe döngüler çarpar: 3 dış x 4 iç = 12."
                    },
                    {
                        "en": "A variable declared inside the loop dies at its brace.",
                        "tr": "Döngü içinde tanımlanan değişken parantezde ölür."
                    }
                ]
            }
        ]
    },
    "5": {
        "titleEn": "Collections",
        "titleTr": "Koleksiyonlar",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🗂️",
                "title": {
                    "en": "One name, many values",
                    "tr": "Tek isim, çok değer"
                },
                "body": {
                    "en": "An array has a fixed size. An ArrayList grows. A HashMap looks things up by key. A HashSet remembers only whether it has seen something.",
                    "tr": "Dizinin boyu sabittir. ArrayList büyür. HashMap anahtarla arar. HashSet sadece gördü mü görmedi mi bilir."
                }
            },
            {
                "kind": "pitfall",
                "icon": "🚨",
                "title": {
                    "en": "== on objects asks the WRONG question",
                    "tr": "Nesnelerde == YANLIŞ soruyu sorar"
                },
                "body": {
                    "en": "== compares references — are these the same object? equals() compares contents. With literals the string pool can make == accidentally true, which is why this bug seems to come and go.",
                    "tr": "== referansları karşılaştırır — aynı nesne mi? equals() içeriği karşılaştırır. Literal'lerde string havuzu == 'i tesadüfen doğru yapabilir; bu yüzden hata gelip gider gibi görünür."
                },
                "code": [
                    "String a = new String(\"hi\");",
                    "String b = new String(\"hi\");",
                    "a == b        // false  ← two objects",
                    "a.equals(b)   // true   ← same text"
                ]
            },
            {
                "kind": "code",
                "icon": "🧰",
                "title": {
                    "en": "New arrays are pre-filled with defaults",
                    "tr": "Yeni diziler varsayılanla dolu gelir"
                },
                "code": [
                    "new int[3]      // {0, 0, 0}",
                    "new double[3]   // {0.0, 0.0, 0.0}",
                    "new boolean[3]  // {false, false, false}",
                    "new String[3]   // {null, null, null}  ← !"
                ],
                "caption": {
                    "en": "An int[] is safe to read immediately. A String[] hands you nulls.",
                    "tr": "int[] hemen okunabilir. String[] sana null verir."
                }
            },
            {
                "kind": "compare",
                "icon": "🔗",
                "title": {
                    "en": "Assignment shares the same array",
                    "tr": "Atama aynı diziyi paylaşır"
                },
                "body": {
                    "en": "Assigning copies the REFERENCE, not the elements. Both names then point at one array.",
                    "tr": "Atama elemanları değil REFERANSI kopyalar. İki isim de tek diziyi gösterir."
                },
                "bad": {
                    "label": {
                        "en": "Shared",
                        "tr": "Paylaşımlı"
                    },
                    "code": [
                        "int[] a = {1, 2};",
                        "int[] b = a;",
                        "b[0] = 9;",
                        "// a[0] is now 9"
                    ]
                },
                "good": {
                    "label": {
                        "en": "Independent copy",
                        "tr": "Bağımsız kopya"
                    },
                    "code": [
                        "int[] a = {1, 2};",
                        "int[] b = a.clone();",
                        "b[0] = 9;",
                        "// a[0] is still 1"
                    ]
                }
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "equals() for contents, == for identity or primitives.",
                        "tr": "İçerik için equals(), kimlik/ilkel için ==."
                    },
                    {
                        "en": "Arrays are fixed size; ArrayList grows.",
                        "tr": "Dizi sabit boyutlu; ArrayList büyür."
                    },
                    {
                        "en": "String is immutable — methods return new ones.",
                        "tr": "String değişmez — metotlar yenisini döndürür."
                    },
                    {
                        "en": "HashMap.get returns null for a missing key.",
                        "tr": "HashMap.get olmayan anahtar için null döndürür."
                    }
                ]
            }
        ]
    },
    "6": {
        "titleEn": "Sorting & Searching",
        "titleTr": "Sıralama & Arama",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "⚖️",
                "title": {
                    "en": "The same answer, wildly different cost",
                    "tr": "Aynı cevap, çok farklı maliyet"
                },
                "body": {
                    "en": "Every algorithm here is correct. What separates them is how the work grows as the input grows.",
                    "tr": "Buradaki her algoritma doğru. Farkları, girdi büyüdükçe işin nasıl büyüdüğü."
                }
            },
            {
                "kind": "idea",
                "icon": "📈",
                "title": {
                    "en": "Big-O counts growth, not seconds",
                    "tr": "Big-O saniyeyi değil büyümeyi sayar"
                },
                "code": [
                    "// 1,000,000 items",
                    "O(1)       ->  1 step",
                    "O(log n)   ->  20 steps",
                    "O(n)       ->  1,000,000",
                    "O(n log n) ->  20,000,000",
                    "O(n^2)     ->  1,000,000,000,000"
                ],
                "caption": {
                    "en": "That last row is why nobody hand-writes a quadratic sort.",
                    "tr": "Son satır, kimsenin elle kare karmaşıklıkta sıralama yazmamasının sebebi."
                }
            },
            {
                "kind": "code",
                "icon": "🔀",
                "title": {
                    "en": "Java sorts primitives and objects differently",
                    "tr": "Java ilkelleri ve nesneleri farklı sıralar"
                },
                "code": [
                    "Arrays.sort(intArray);      // dual-pivot quicksort",
                    "                            // in place, NOT stable",
                    "",
                    "Collections.sort(list);     // merge sort",
                    "                            // STABLE: ties keep order"
                ],
                "caption": {
                    "en": "Arrays.sort returns void — there is no int[] s = Arrays.sort(a).",
                    "tr": "Arrays.sort void döndürür — int[] s = Arrays.sort(a) diye bir şey yok."
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "Each branch must SHRINK the range",
                    "tr": "Her dal aralığı KÜÇÜLTMELİ"
                },
                "body": {
                    "en": "When hi is lo+1, integer division makes mid equal lo — so lo = mid changes nothing and the loop spins forever. Also prefer lo + (hi-lo)/2: lo+hi can overflow int.",
                    "tr": "hi, lo+1 olduğunda tam sayı bölmesi mid'i lo yapar — lo = mid hiçbir şeyi değiştirmez, döngü sonsuza döner. Ayrıca lo + (hi-lo)/2 tercih et: lo+hi int'i taşırabilir."
                },
                "code": [
                    "int mid = lo + (hi - lo) / 2;",
                    "if (a[mid] < t) lo = mid + 1;   // + 1 !",
                    "else            hi = mid - 1;"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "Binary search needs SORTED input — no exception if not.",
                        "tr": "İkili arama SIRALI girdi ister — değilse hata da vermez."
                    },
                    {
                        "en": "Collections.sort is stable; Arrays.sort on primitives is not.",
                        "tr": "Collections.sort kararlı; ilkellerde Arrays.sort değil."
                    },
                    {
                        "en": "Nested loops over the same array are O(n^2).",
                        "tr": "Aynı dizide iç içe döngü O(n^2)'dir."
                    },
                    {
                        "en": "A library method doing the scanning does not make it free.",
                        "tr": "Taramayı kütüphane yapıyor olması onu bedava yapmaz."
                    }
                ]
            }
        ]
    },
    "8": {
        "titleEn": "Recursion & Memoisation",
        "titleTr": "Özyineleme & Bellekleme",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🪆",
                "title": {
                    "en": "A method that calls itself",
                    "tr": "Kendini çağıran metot"
                },
                "body": {
                    "en": "Recursion solves a problem by solving a SMALLER version of the same problem, then combining.",
                    "tr": "Özyineleme, aynı problemin DAHA KÜÇÜK versiyonunu çözüp birleştirerek çalışır."
                }
            },
            {
                "kind": "code",
                "icon": "🧱",
                "title": {
                    "en": "Two parts, always",
                    "tr": "Her zaman iki parça"
                },
                "body": {
                    "en": "A base case that returns without recursing, and a step that moves TOWARD it.",
                    "tr": "Özyinelemeden dönen bir taban durum ve ona DOĞRU ilerleyen bir adım."
                },
                "code": [
                    "static int total(int[] a, int i) {",
                    "    if (i == a.length) return 0;       // base",
                    "    return a[i] + total(a, i + 1);     // step",
                    "}"
                ],
                "caption": {
                    "en": "Miss either and the JVM throws StackOverflowError.",
                    "tr": "Biri eksikse JVM StackOverflowError fırlatır."
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "Stack, not heap",
                    "tr": "Yığın (stack), öbek (heap) değil"
                },
                "body": {
                    "en": "StackOverflowError is NOT out of memory. The stack and the heap are different memory, so raising -Xmx changes nothing. Fix the base case.",
                    "tr": "StackOverflowError bellek yetmemesi DEĞİLDİR. Yığın ve öbek farklı bellektir, -Xmx artırmak hiçbir şeyi değiştirmez. Taban durumu düzelt."
                },
                "code": [
                    "static void down(int n) {",
                    "    if (n == 0) return;   // never true from 5",
                    "    down(n - 2);          // 5, 3, 1, -1 ...",
                    "}"
                ]
            },
            {
                "kind": "compare",
                "icon": "⚡",
                "title": {
                    "en": "The same code, two costs",
                    "tr": "Aynı kod, iki maliyet"
                },
                "body": {
                    "en": "Caching does not change the algorithm. It changes how many times the algorithm runs.",
                    "tr": "Bellekleme algoritmayı değiştirmez. Kaç kez çalıştığını değiştirir."
                },
                "bad": {
                    "label": {
                        "en": "2,692,537 calls for n=30",
                        "tr": "n=30 için 2.692.537 çağrı"
                    },
                    "code": [
                        "static long fib(int n) {",
                        "    if (n < 2) return n;",
                        "    return fib(n-1) + fib(n-2);",
                        "}"
                    ]
                },
                "good": {
                    "label": {
                        "en": "29 values computed",
                        "tr": "29 değer hesaplanır"
                    },
                    "code": [
                        "static Map<Integer,Long> memo = new HashMap<>();",
                        "static long fib(int n) {",
                        "    if (n < 2) return n;",
                        "    if (memo.containsKey(n)) return memo.get(n);",
                        "    long r = fib(n-1) + fib(n-2);",
                        "    memo.put(n, r); return r;",
                        "}"
                    ]
                }
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "Base case + a step that reaches it.",
                        "tr": "Taban durum + ona ulaşan bir adım."
                    },
                    {
                        "en": "Work placed AFTER the call runs on the way back up.",
                        "tr": "Çağrıdan SONRA yazılan iş dönüşte çalışır."
                    },
                    {
                        "en": "A cache is two halves: check before, store after.",
                        "tr": "Önbellek iki yarımdır: önce kontrol, sonra kaydet."
                    },
                    {
                        "en": "Java has NO tail-call removal — deep means a loop.",
                        "tr": "Java'da kuyruk çağrısı optimizasyonu YOK — derinse döngü."
                    }
                ]
            }
        ]
    },
    "9": {
        "titleEn": "Graphs",
        "titleTr": "Graflar",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🕸️",
                "title": {
                    "en": "Things, and what connects them",
                    "tr": "Şeyler ve onları bağlayanlar"
                },
                "body": {
                    "en": "A graph is vertices (things) plus edges (connections). Roads, follows, dependencies — all the same shape.",
                    "tr": "Graf = düğümler (şeyler) + kenarlar (bağlantılar). Yollar, takipler, bağımlılıklar — hepsi aynı şekil."
                }
            },
            {
                "kind": "code",
                "icon": "🗺️",
                "title": {
                    "en": "An adjacency list is just a Map",
                    "tr": "Komşuluk listesi aslında bir Map"
                },
                "code": [
                    "Map<String,List<String>> g = new HashMap<>();",
                    "g.put(\"A\", List.of(\"B\", \"C\"));",
                    "g.put(\"B\", List.of(\"A\"));",
                    "g.put(\"C\", List.of(\"A\"));"
                ],
                "caption": {
                    "en": "An undirected edge appears TWICE — once from each end.",
                    "tr": "Yönsüz bir kenar İKİ kez görünür — her uçtan bir kez."
                }
            },
            {
                "kind": "compare",
                "icon": "🚶",
                "title": {
                    "en": "One structure decides the whole traversal",
                    "tr": "Tek veri yapısı tüm gezinmeyi belirler"
                },
                "body": {
                    "en": "Take from the front and you sweep level by level. Take from the back and you dive down one branch.",
                    "tr": "Baştan alırsan seviye seviye tararsın. Sondan alırsan tek dala dalarsın."
                },
                "bad": {
                    "label": {
                        "en": "pollLast() -> depth-first",
                        "tr": "pollLast() -> derinlik öncelikli"
                    },
                    "code": [
                        "String n = q.pollLast();  // A B D C",
                        "// dives to a leaf first"
                    ]
                },
                "good": {
                    "label": {
                        "en": "pollFirst() -> breadth-first",
                        "tr": "pollFirst() -> genişlik öncelikli"
                    },
                    "code": [
                        "String n = q.pollFirst(); // A B C D",
                        "// finishes each ring first"
                    ]
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "A graph can lead you back",
                    "tr": "Graf seni geri getirebilir"
                },
                "body": {
                    "en": "A tree has no way back to where you came from. A graph does — without a visited Set the walk never ends.",
                    "tr": "Ağaçta geldiğin yere dönüş yoktur. Grafta vardır — ziyaret Set'i olmadan gezinme hiç bitmez."
                },
                "code": [
                    "Set<String> seen = new HashSet<>();",
                    "if (!seen.add(node)) return;",
                    "// add returns false if it was already there"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "BFS finds the SHORTEST path when edges are unweighted.",
                        "tr": "Kenarlar ağırlıksızsa EN KISA yolu BFS bulur."
                    },
                    {
                        "en": "DFS is for cycles and ordering, not distance.",
                        "tr": "DFS döngü ve sıralama içindir, mesafe için değil."
                    },
                    {
                        "en": "Always mark visited, and mark on ENQUEUE.",
                        "tr": "Ziyaret edileni işaretle — KUYRUĞA ATARKEN."
                    },
                    {
                        "en": "Set.add returning false is the check and the mark in one.",
                        "tr": "Set.add'in false dönmesi hem kontrol hem işaretlemedir."
                    }
                ]
            }
        ]
    },
    "10": {
        "titleEn": "Dynamic Programming",
        "titleTr": "Dinamik Programlama",
        "minutes": 2,
        "cards": [
            {
                "kind": "hook",
                "icon": "🧩",
                "title": {
                    "en": "When the same question keeps coming back",
                    "tr": "Aynı soru tekrar tekrar geldiğinde"
                },
                "body": {
                    "en": "DP is recursion plus a notebook: solve each smaller question once, write the answer down, never solve it again.",
                    "tr": "DP = özyineleme + defter: her küçük soruyu bir kez çöz, cevabı yaz, bir daha çözme."
                }
            },
            {
                "kind": "idea",
                "icon": "✌️",
                "title": {
                    "en": "Two conditions, both required",
                    "tr": "İki koşul, ikisi de şart"
                },
                "body": {
                    "en": "Overlapping subproblems: the same smaller question is asked on many paths. Optimal substructure: the best answer is built from best smaller answers.",
                    "tr": "Örtüşen alt problemler: aynı küçük soru birçok yolda sorulur. Optimal alt yapı: en iyi cevap en iyi küçük cevaplardan kurulur."
                },
                "caption": {
                    "en": "Merge sort has substructure but no OVERLAP — a cache would never hit.",
                    "tr": "Merge sort'ta alt yapı var ama ÖRTÜŞME yok — önbellek hiç tutmaz."
                }
            },
            {
                "kind": "compare",
                "icon": "🔄",
                "title": {
                    "en": "Two directions, same answer",
                    "tr": "İki yön, aynı cevap"
                },
                "body": {
                    "en": "Top-down remembers as it goes. Bottom-up builds from the known end, with no stack to overflow — which matters more in Java, where there is no tail-call removal.",
                    "tr": "Yukarıdan aşağı giderken hatırlar. Aşağıdan yukarı bilinenden kurar, taşacak yığın yok — Java'da bu daha önemli, çünkü kuyruk çağrısı optimizasyonu yok."
                },
                "bad": {
                    "label": {
                        "en": "Top-down (memoisation)",
                        "tr": "Yukarıdan aşağı (bellekleme)"
                    },
                    "code": [
                        "if (memo.containsKey(n))",
                        "    return memo.get(n);",
                        "long r = fib(n-1) + fib(n-2);",
                        "memo.put(n, r);"
                    ]
                },
                "good": {
                    "label": {
                        "en": "Bottom-up (tabulation)",
                        "tr": "Aşağıdan yukarı (tablolama)"
                    },
                    "code": [
                        "long[] dp = new long[n+1];",
                        "dp[1] = 1;",
                        "for (int i = 2; i <= n; i++)",
                        "    dp[i] = dp[i-1] + dp[i-2];"
                    ]
                }
            },
            {
                "kind": "pitfall",
                "icon": "⚠️",
                "title": {
                    "en": "The cache key must include EVERYTHING",
                    "tr": "Önbellek anahtarı HER ŞEYİ içermeli"
                },
                "body": {
                    "en": "Key on i alone when the answer also depends on remaining, and you serve the wrong stored value — wrong answers, not slow ones.",
                    "tr": "Cevap remaining'e de bağlıyken sadece i ile anahtarlarsan yanlış kaydı verirsin — yavaş değil, YANLIŞ sonuç."
                },
                "code": [
                    "memo.put(i + \",\" + remaining, r);  // right",
                    "memo.put(i, r);                    // silently wrong"
                ]
            },
            {
                "kind": "recap",
                "icon": "🧠",
                "title": {
                    "en": "What to carry into the questions",
                    "tr": "Sorulara taşıyacakların"
                },
                "bullets": [
                    {
                        "en": "Spot the repeated subquestion first.",
                        "tr": "Önce tekrar eden alt soruyu bul."
                    },
                    {
                        "en": "Only the last few table rows are usually needed.",
                        "tr": "Genelde tablonun son birkaç satırı yeter."
                    },
                    {
                        "en": "A too-narrow key gives wrong answers, not slow ones.",
                        "tr": "Dar anahtar yavaşlık değil yanlışlık üretir."
                    },
                    {
                        "en": "Kadane: at each step, extend the run or restart.",
                        "tr": "Kadane: her adımda ya diziyi uzat ya baştan başla."
                    }
                ]
            }
        ]
    }
})

const decksByLanguage = { python: pythonDecks, javascript: jsDecks, java: javaDecks }

/* Returns the deck for a chapter in the given language, or null when that
   chapter has no concept lesson yet. Falls back to Python only if the
   language has no deck table at all — never to a different chapter. */
export function getConceptDeck(chapter, lang) {
    const table = decksByLanguage[lang] || decksByLanguage.python
    return table[chapter] || null
}

export function hasConceptDeck(chapter, lang) {
    return getConceptDeck(chapter, lang) != null
}

/* Card text is stored as { en, tr }; this resolves one against the locale. */
export function pickLocale(field, locale) {
    if (field == null) return ''
    if (typeof field === 'string') return field
    return (locale === 'tr' ? field.tr : field.en) || field.en || ''
}
