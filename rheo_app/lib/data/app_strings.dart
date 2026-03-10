import '../logic/storage_service.dart';

/// Central localization class for TR/EN support.
/// Usage: `S.get('key')` or `S.homeTitle`
class S {
  S._();

  static String get locale => storageService.progress.locale;
  static bool get isEn => locale == 'en';

  /// Generic getter with key
  static String get(String key) => key;

  /// Convenience: pick between TR/EN directly
  static String tr(String trText, String enText) => isEn ? enText : trText;

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // HOME SCREEN
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get modSec => tr('MOD SE├ç', 'SELECT MODE');
  static String get ciktiTahmini => tr('├ç─▒kt─▒ Tahmini', 'Output Prediction');
  static String get ciktiTahminiSub => tr('Kodu oku, ├ğ─▒kt─▒y─▒ tahmin et', 'Read the code, predict the output');
  static String get bugHunter => tr('Hata Avc─▒s─▒', 'Bug Hunter');
  static String get bugHunterSub => tr('Hatal─▒ sat─▒r─▒ bul', 'Find the buggy line');
  static String get timeAttack => tr('Zamana Kar┼ş─▒', 'Time Attack');
  static String get timeAttackSub => tr('Zamana kar┼ş─▒ yar─▒┼ş', 'Race against time');
  static String get yukselen => tr('Y├╝kselen', 'Rising');
  static String get ustat => tr('├£stat', 'Master');
  static String get lig => tr('Lig', 'League');
  static String get yakinda => tr('Yak─▒nda', 'Coming Soon');
  static String get dogruSeri => tr('Do─şru Seri', 'Correct Streak');
  static String get gunlukHedef => tr('G├╝nl├╝k Hedef', 'Daily Goal');
  static String get gunlukHedefBelirle => tr('G├╝nl├╝k hedefini belirle!', 'Set your daily goal!');
  static String soruCozuldu(int n) => tr('$n soru ├ğ├Âz├╝ld├╝', '$n questions solved');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // QUIZ SCREEN
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get buKodunCiktisi => tr('Bu kodun ├ğ─▒kt─▒s─▒ nedir?', 'What is the output of this code?');
  static String soruN(int cur, int total) => tr('Soru $cur/$total', 'Question $cur/$total');
  static String get dogruCevap => tr('Do─şru Cevap!', 'Correct Answer!');
  static String get yanlisCevap => tr('Yanl─▒┼ş Cevap!', 'Wrong Answer!');
  static String get ilerlemekIcinTikla => tr('─░lerlemek i├ğin t─▒klay─▒n─▒z.', 'Tap to continue.');
  static String get aciklama => tr('A├ğ─▒klama', 'Explanation');
  static String get dogru => tr('Do─şru', 'Correct');
  static String get yanlis => tr('Yanl─▒┼ş', 'Wrong');
  static String get basari => tr('Ba┼şar─▒', 'Accuracy');
  static String get apiKotaHatasi => tr('API kota limiti a┼ş─▒ld─▒.\nBirka├ğ dakika bekleyip tekrar dene.', 'API quota exceeded.\nWait a few minutes and try again.');
  static String get apiKeyHatasi => tr('API key ge├ğersiz.\n.env dosyas─▒n─▒ kontrol et.', 'API key is invalid.\nCheck your .env file.');
  static String get aiSoruHatasi => tr('AI sorusu ├╝retilemedi.\n─░nternet ba─şlant─▒n─▒ kontrol et.', 'Could not generate AI question.\nCheck your internet connection.');
  static String get soruYukleniyor => tr('Soru haz─▒rlan─▒yor...', 'Preparing question...');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // QUIZ RESULT DIALOG
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get sonuclar => tr('Sonu├ğlar', 'Results');
  static String get tekrarDene => tr('Tekrar Dene', 'Try Again');
  static String get anaMenu => tr('Ana Men├╝', 'Main Menu');
  static String get toplam => tr('Toplam', 'Total');
  static String get kolay => tr('Kolay', 'Easy');
  static String get orta => tr('Orta', 'Medium');
  static String get zor => tr('Zor', 'Hard');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // TOPIC DIALOG
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get konuSec => tr('Konu Se├ğ', 'Select Topic');
  static String get konuSecSub => tr('├çal─▒┼şmak istedi─şin konuyu se├ğ', 'Choose a topic to practice');
  static String get tumu => tr('T├╝m├╝', 'All');
  static String get degiskenler => tr('De─şi┼şkenler', 'Variables');
  static String get donguler => tr('D├Âng├╝ler', 'Loops');
  static String get kosullar => tr('Ko┼şullar', 'Conditions');
  static String get fonksiyonlar => tr('Fonksiyonlar', 'Functions');
  static String get listeler => tr('Listeler', 'Lists');
  static String get stringler => tr('Stringler', 'Strings');
  static String get diziler => tr('Diziler', 'Arrays');
  static String get oopLabel => tr('OOP', 'OOP');
  static String get ozyineleme => tr('├ûzyineleme', 'Recursion');
  static String get siralama => tr('S─▒ralama', 'Sorting');
  static String get yiginKuyruk => tr('Y─▒─ş─▒n & Kuyruk', 'Stack & Queue');
  static String get aiDestekli => tr('AI Destekli', 'AI Powered');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // SETTINGS SCREEN
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get ayarlar => tr('Ayarlar', 'Settings');
  static String get sesEfektleri => tr('Ses Efektleri', 'Sound Effects');
  static String get sesEfektleriSub => tr('Do─şru/yanl─▒┼ş sesleri', 'Correct/wrong sounds');
  static String get bildirimler => tr('Bildirimler', 'Notifications');
  static String get bildirimlerSub => tr('G├╝nl├╝k hat─▒rlatmalar (18:00)', 'Daily reminders (18:00)');
  static String get tema => tr('Tema', 'Theme');
  static String get temaSub => tr('Koyu arka plan ve a├ğ─▒k yaz─▒lar', 'Dark background and light text');
  static String get dil => tr('Dil', 'Language');
  static String get dilSub => tr('Aray├╝z ve i├ğerik dili', 'Interface and content language');
  static String get geriBildirim => tr('Geri Bildirim G├Ânder', 'Send Feedback');
  static String get geriBildirimSub => tr('├ûnerilerinizi payla┼ş─▒n', 'Share your suggestions');
  static String get hakkinda => tr('Hakk─▒nda', 'About');
  static String get hakkimizdaSub => tr('Ekip ve uygulama bilgileri', 'Team and app info');
  static String get kodOkumaOyunu => tr('Kod Okuma Oyunu', 'Code Reading Game');
  static String get versiyon => tr('Versiyon', 'Version');
  static String get iletisim => tr('─░leti┼şim', 'Contact');
  static String get ilerlemeySifirla => tr('─░lerlemeyi S─▒f─▒rla', 'Reset Progress');
  static String get ilerlemeySifirlaTitle => tr('─░lerlemeyi S─▒f─▒rla?', 'Reset Progress?');
  static String get ilerlemeySifirlaMesaj => tr(
    'T├╝m ELO puan─▒n, serilerin ve istatistiklerin silinecek. Bu i┼şlem geri al─▒namaz.',
    'All your ELO points, streaks, and stats will be deleted. This cannot be undone.',
  );
  static String get iptal => tr('─░ptal', 'Cancel');
  static String get sifirla => tr('S─▒f─▒rla', 'Reset');
  static String get ilerlemeSifirlandi => tr('─░lerleme s─▒f─▒rland─▒', 'Progress has been reset');
  static String get gizlilikPolitikasi => tr('Gizlilik Politikas─▒', 'Privacy Policy');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // PROFILE SCREEN
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get profil => tr('Profil', 'Profile');
  static String get ozellestir => tr('├ûzelle┼ştir', 'Customize');
  static String get istatistikler => tr('─░STAT─░ST─░KLER', 'STATISTICS');
  static String get dogruluk => tr('Do─şruluk', 'Accuracy');
  static String get guncelDogruSeri => tr('G├╝ncel Do─şru Seri', 'Current Streak');
  static String get enIyiDogruSeri => tr('En ─░yi Do─şru Seri', 'Best Streak');
  static String get guncelGirisSeri => tr('G├╝ncel Giri┼ş Serisi', 'Login Streak');
  static String get enIyiGirisSeri => tr('En ─░yi Giri┼ş Serisi', 'Best Login Streak');
  static String get basarimlar => tr('Ba┼şar─▒mlar', 'Achievements');
  static String basarimKilidi(int unlocked, int total) => tr(
    '$unlocked /$total ba┼şar─▒m kilidi a├ğ─▒ld─▒',
    '$unlocked /$total achievements unlocked',
  );
  static String get cokYakinda => tr('├çok Yak─▒nda! ­şÜÇ', 'Coming Soon! ­şÜÇ');
  static String get ligGeliyor => tr('Lig sistemi geliyor...', 'League system coming soon...');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // RANK SCREEN
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get rankUstat => tr('├£stat', 'Master');
  static String get rankUsta => tr('Usta', 'Expert');
  static String get rankUzman => tr('Uzman', 'Specialist');
  static String get rankDeneyimli => tr('Deneyimli', 'Experienced');
  static String get rankYukselen => tr('Y├╝kselen', 'Rising');
  static String get rankCaylak => tr('├çaylak', 'Rookie');
  static String get rutbeSistemi => tr('R├╝tbe Sistemi', 'Rank System');
  static String get rutbeler => tr('R├£TBELER', 'RANKS');
  static String get puanimiSifirla => tr('Puan─▒m─▒ S─▒f─▒rla', 'Reset My Score');
  static String get puan => tr('Puan', 'Score');
  static String get sen => tr('SEN', 'YOU');
  static String puanAraligi(int min, int max) => tr('$min-$max puan', '$min-$max pts');
  static String puanUstu(int min) => tr('$min+ puan', '$min+ pts');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // ONBOARDING
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get hosGeldin => tr('Ho┼ş Geldin! ­şæï', 'Welcome! ­şæï');
  static String get atla => tr('Atla', 'Skip');
  static String get basla => tr('Ba┼şla', 'Start');
  static String get onboardBody1 => tr(
    'Kod par├ğac─▒klar─▒n─▒ incele ve ├ğ─▒kt─▒y─▒ tahmin et.\nIDE a├ğmadan, sadece parmak ucunuzla.',
    'Examine code snippets and predict the output.\nNo IDE needed, just your fingertips.',
  );
  static String get onboardBody2 => tr(
    'Hatal─▒ sat─▒r─▒ bul ve t─▒kla!\nGer├ğek debugging kaslar─▒n─▒ geli┼ştir.',
    'Find the buggy line and tap it!\nBuild real debugging muscles.',
  );
  static String get yuksel => tr('Y├╝ksel', 'Level Up');
  static String get onboardBody3 => tr(
    'Her do─şruyla ELO puan─▒n─▒ art─▒r.\nRakiplerini geride b─▒rak.',
    'Increase your ELO with every correct answer.\nOutperform your rivals.',
  );

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // ABOUT SCREEN
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get hakkimizda => tr('Hakk─▒m─▒zda', 'About Us');
  static String get uygulamaHakkinda => tr('Uygulama Hakk─▒nda', 'About the App');
  static String get uygulamaAciklama => tr(
    'Rheo, kod okuma becerilerini geli┼ştirmek i├ğin tasarlanm─▒┼ş e─şlenceli bir oyun. '
    'Python, Java ve JavaScript dillerinde ├ğe┼şitli kod par├ğac─▒klar─▒n─▒ analiz ederek ├ğ─▒kt─▒lar─▒n─▒ tahmin et.',
    'Rheo is a fun game designed to improve your code reading skills. '
    'Analyze code snippets in Python, Java, and JavaScript and predict their outputs.',
  );
  static String get gelistiriciEkip => tr('GEL─░┼ŞT─░R─░C─░ EK─░P', 'DEVELOPER TEAM');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // BUG HUNT SCREEN
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get hataliSatiriBul => tr('Hatal─▒ sat─▒r─▒ bul', 'Find the buggy line');
  static String get satiraTikla => tr('Hatal─▒ sat─▒ra t─▒kla', 'Tap the buggy line');
  static String get buSatirdaHataVar => tr('Bu sat─▒rda hata var!', 'This line has a bug!');
  static String get buSatirDogru => tr('Bu sat─▒r do─şru.', 'This line is correct.');
  static String get bugHuntSonuc => tr('Bug Hunt Sonu├ğlar─▒', 'Bug Hunt Results');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // TIME ATTACK SCREEN
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get sureBitti => tr('S├╝re Bitti!', 'Time\'s Up!');
  static String get timeAttackSonuc => tr('Time Attack Sonu├ğlar─▒', 'Time Attack Results');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // LEADERBOARD
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get liderTablosu => tr('Lider Tablosu', 'Leaderboard');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // DAILY GOAL
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get gunlukHedefAyarla => tr('G├╝nl├╝k Hedef Ayarla', 'Set Daily Goal');
  static String get gunlukSoruSayisi => tr('G├╝nl├╝k soru say─▒s─▒', 'Daily question count');
  static String get gundeSoruSayisi => tr('G├╝nde ka├ğ soru ├ğ├Âzmek istiyorsun?', 'How many questions do you want to solve per day?');
  static String get kaydet => tr('Kaydet', 'Save');
  static String get tamam => tr('Tamam', 'OK');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // INITIAL RANK / LEVEL SELECT
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get seviyeSecimi => tr('Seviye Se├ğimi', 'Select Level');
  static String get onayla => tr('Onayla', 'Confirm');

  // CUSTOMIZE PROFILE SCREEN
  static String get profiliOzellestir => tr('Profili ├ûzelle┼ştir', 'Customize Profile');
  static String get kullaniciAdi => tr('KULLANICI ADI', 'USERNAME');
  static String get kullaniciAdiHint => tr('Kullan─▒c─▒ Ad─▒', 'Username');
  static String get avatarSec => tr('AVATAR SE├ç', 'CHOOSE AVATAR');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // ACHIEVEMENTS
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get yediGunSerisi => tr('7 G├╝n Serisi', '7-Day Streak');
  static String get yediGunAciklama => tr('7 g├╝n ├╝st ├╝ste oyna', 'Play for 7 consecutive days');
  static String get otuzGunSerisi => tr('30 G├╝n Serisi', '30-Day Streak');
  static String get otuzGunAciklama => tr('30 g├╝n ├╝st ├╝ste oyna', 'Play for 30 consecutive days');
  static String get doksanGunSerisi => tr('90 G├╝n Serisi', '90-Day Streak');
  static String get doksanGunAciklama => tr('90 g├╝n ├╝st ├╝ste oyna', 'Play for 90 consecutive days');
  static String get yilSerisi => tr('365 G├╝n Serisi', '365-Day Streak');
  static String get yilAciklama => tr('1 y─▒l boyunca her g├╝n oyna', 'Play every day for a whole year');
  static String get onSoru => tr('10 Soru', '10 Questions');
  static String get onSoruAciklama => tr('10 soru ├ğ├Âz', 'Solve 10 questions');
  static String get yuzSoru => tr('100 Soru', '100 Questions');
  static String get yuzSoruAciklama => tr('100 soru ├ğ├Âz', 'Solve 100 questions');
  static String get binSoru => tr('1000 Soru', '1000 Questions');
  static String get binSoruAciklama => tr('1000 soru ├ğ├Âz', 'Solve 1000 questions');
  static String get onDogru => tr('10 Do─şru', '10 Correct');
  static String get onDogruAciklama => tr('10 do─şru cevap ver', 'Get 10 correct answers');
  static String get yuzDogru => tr('100 Do─şru', '100 Correct');
  static String get yuzDogruAciklama => tr('100 do─şru cevap ver', 'Get 100 correct answers');
  static String get binDogru => tr('1000 Do─şru', '1000 Correct');
  static String get binDogruAciklama => tr('1000 do─şru cevap ver', 'Get 1000 correct answers');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // MASCOT MESSAGES
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get selamSabah => tr('G├╝nayd─▒n! ÔİÇ´©Å', 'Good morning! ÔİÇ´©Å');
  static String get selamOgle => tr('─░yi ├Â─şlenler! ­şîñ´©Å', 'Good afternoon! ­şîñ´©Å');
  static String get selamAksam => tr('─░yi ak┼şamlar! ­şîÖ', 'Good evening! ­şîÖ');
  static String get selamGece => tr('Gece ku┼şu! ­şĞë', 'Night owl! ­şĞë');

  // Correct messages
  static List<String> get correctMessages => isEn
    ? ['Perfect! ­şÄ»', 'You are on fire! ­şöÑ', 'Wow, awesome! Ô£¿', 'Amazing! ­şÆ½', 'Keep it up! ­şÜÇ',
       'Brilliant! ­şîş', 'You got it! Ô£à', 'Smooth! ­şİÄ']
    : ['M├╝kemmel! ­şÄ»', 'Ate┼ş topusun! ­şöÑ', 'Vay be, harika! Ô£¿', '─░nan─▒lmaz! ­şÆ½', 'Devam et! ­şÜÇ',
       'Parlak zeka! ­şîş', 'Bildin! Ô£à', 'P├╝r├╝zs├╝z! ­şİÄ'];

  // Wrong messages
  static List<String> get wrongMessages => isEn
    ? ['Not quite! ­şñö', 'Try again! ­şÆ¬', 'So close! ­şİà', 'Don\'t give up! ­şî▒', 'Mistakes teach! ­şôÜ',
       'Keep pushing! ­şÆ¬', 'You\'ll get it! ­şîş', 'Learning moment! ­şğá']
    : ['Olmad─▒! ­şñö', 'Tekrar dene! ­şÆ¬', 'Az kald─▒! ­şİà', 'Pes etme! ­şî▒', 'Hata ├Â─şretir! ­şôÜ',
       'Devam! ­şÆ¬', 'Yapars─▒n! ­şîş', '├û─şrenme f─▒rsat─▒! ­şğá'];

  // Streak warnings
  static List<String> get streakWarnings => isEn
    ? ['Your streak is at risk! ­şöÑ', 'Don\'t break your streak! ÔÜí', 'One more day, keep going! ­şÆ¬']
    : ['Serin riske giriyor! ­şöÑ', 'Seriyi bozma! ÔÜí', 'Bir g├╝n daha, devam! ­şÆ¬'];

  // Result comments by accuracy
  static List<String> resultComment90 = [];
  static List<String> getResultComment(int accuracy) {
    if (accuracy >= 90) return isEn
      ? ['Legendary! ­şÅå', 'Incredible! You nailed it! ­şñ»', 'You\'re a master! ­şææ']
      : ['Efsane! ­şÅå', 'M├╝kemmelsin, ├ğ─▒lg─▒n! ­şñ»', 'Ustas─▒n! Eline sa─şl─▒k! ­şææ'];
    if (accuracy >= 70) return isEn
      ? ['Great job! ­şîş', 'Impressive! Well done! ­şÆ¬', 'Super work! ­şöÑ', 'Keep it up! ­şÜÇ']
      : ['├çok iyi gidiyorsun! ­şîş', 'Etkileyici! Bravo! ­şÆ¬', 'S├╝per ├ğal─▒┼şma! ­şöÑ', 'B├Âyle devam! ­şÜÇ'];
    if (accuracy >= 40) return isEn
      ? ['Not bad! ­şæı', 'You\'re improving! ­şôê', 'Keep practicing! ­şÆ¬', 'Half way there! ­şÆ¬']
      : ['─░yi gidiyorsun! ­şæı', 'Fena de─şil, geli┼şiyorsun! ­şôê', 'Pratik yap! ­şÆ¬', 'Yar─▒s─▒n─▒ bildin, devam! ­şÆ¬'];
    return isEn
      ? ['Everyone starts somewhere! ­şî▒', 'Don\'t give up! ­şÆ¬', 'Learning takes time! ÔÅ│', 'Every master was once a beginner! ­şÄô']
      : ['Herkes ba┼ştan ba┼şlar! ­şî▒', 'D├╝┼şme kalk, devam et! ­şÆ¬', '├û─şrenmek zaman al─▒r, sabret! ÔÅ│', 'Her usta bir ├ğ─▒rakt─▒! ­şÄô'];
  }

  // Bug Hunt messages
  static List<String> get bugHuntCorrect => isEn
    ? ['Bug caught! ­şÉø', 'Sharp eyes! ­şöı', 'Bug can\'t escape you! ­şÉŞ', 'Bug master! ­şÅå']
    : ['Bug avlad─▒n! ­şÉø', 'Keskin g├Âz! ­şöı', 'Bug senden ka├ğamaz! ­şÉŞ', 'Bug bulma ustas─▒! ­şÅå'];
  static List<String> get bugHuntWrong => isEn
    ? ['This bug escaped! ­şÉø', 'Wrong line, try again! ­şöä', 'Bug is hiding, look again! ­şæÇ']
    : ['Bu bug ka├ğt─▒! ­şÉø', 'Yanl─▒┼ş sat─▒r, tekrar bak! ­şöä', 'Bug gizlenmi┼ş, tekrar bak! ­şæÇ'];

  // Time up messages
  static List<String> get timeUpMessages => isEn
    ? ['Time\'s up! ÔÅ▒´©Å', 'So close! ÔÅ░', 'Be a little faster! ­şÅâ']
    : ['S├╝re bitti! ÔÅ▒´©Å', 'Az kald─▒! ÔÅ░', 'Biraz daha h─▒zl─▒ ol! ­şÅâ'];

  // Waiting messages
  static List<String> get waitingMessages => isEn
    ? ['Preparing question... ­şñû', 'Brain working... ­şğá', 'A special question for you! Ô£¿']
    : ['Soru haz─▒rl─▒yorum... ­şñû', 'Beyin ├ğal─▒┼ş─▒yor... ­şğá', 'Senin i├ğin ├Âzel bir soru! Ô£¿'];

  // Daily goal complete
  static List<String> get dailyGoalComplete => isEn
    ? ['Daily goal done! ­şÄë', 'Today\'s mission complete! Ô£à', 'You reached your goal! ­şÅå', 'Awesome, done for today! ­şîş']
    : ['G├╝nl├╝k hedef tamam! ­şÄë', 'Bug├╝nk├╝ g├Ârev tamamland─▒! Ô£à', 'Bravo, hedefine ula┼şt─▒n! ­şÅå', 'M├╝thi┼şsin, bug├╝nl├╝k tamam! ­şîş'];

  // Rank comments
  static String getRankComment(int elo) {
    if (elo < 200) return isEn
      ? 'Keep practicing to level up! ­şôê'
      : 'Bronze\'dan ├ğ─▒kman yak─▒n! ­şÑë';
    if (elo < 400) return isEn
      ? 'Great progress! Keep going! Ô¡É'
      : 'Devam et, y├╝kseliyorsun! ­şôê';
    if (elo < 600) return isEn
      ? 'Your level is impressive! ­şÑê'
      : 'Silver seviyen harika! ­şÑê';
    if (elo < 800) return isEn
      ? 'Almost at the top! Ô¡É'
      : 'Gold\'a az kald─▒! Ô¡É';
    if (elo < 1000) return isEn
      ? 'Platinum! You\'re a legend! ­şÆÄ'
      : 'Platinum! Efsanesin! ­şÆÄ';
    return isEn
      ? 'Diamond is near! ­şÆá'
      : 'Diamond yak─▒n! ­şÆá';
  }

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // NOTIFICATIONS
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get notifKodlarPaslaniyor => tr('­şĞĞ Kodlar paslan─▒yor!', '­şĞĞ Your coding is getting rusty!');
  static String get notifPratikYapmadinBody => tr(
    'Bug├╝n hen├╝z pratik yapmad─▒n. Gel, birlikte ├ğ├Âzelim!',
    'You haven\'t practiced today. Let\'s solve some together!',
  );

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // FEEDBACK DIALOG
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get feedbackTitle => tr(
    'Bir hata m─▒ buldun? ├ûnerilerin mi var?\nBize ula┼şmaktan ├ğekinme!',
    'Found a bug? Have suggestions?\nDon\'t hesitate to reach out!',
  );

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // ERROR / EMPTY STATES
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get birSeylerTersGitti => tr('Bir ┼şeyler ters gitti', 'Something went wrong');
  static String get tekrarDeneButon => tr('Tekrar Dene', 'Try Again');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // ELO RANK NAMES (used in elo_calculator)
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String getRankName(int elo) {
    if (elo < 200) return tr('├çaylak', 'Rookie');
    if (elo < 400) return tr('Y├╝kselen', 'Rising');
    if (elo < 600) return tr('Deneyimli', 'Experienced');
    if (elo < 800) return tr('Uzman', 'Specialist');
    if (elo < 1000) return tr('Usta', 'Expert');
    return tr('├£stat', 'Master');
  }

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // PRIVACY POLICY (simplified keys)
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get privacyTitle => tr('Gizlilik Politikas─▒', 'Privacy Policy');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // STATS SCREEN
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get istatistikBaslik => tr('─░statistikler', 'Statistics');
  static String get toplamSoru => tr('Toplam Soru', 'Total Questions');
  static String get dogruOran => tr('Do─şruluk Oran─▒', 'Accuracy Rate');
  static String get enIyiSeri => tr('En ─░yi Seri', 'Best Streak');
  static String get mevcutSeri => tr('Mevcut Seri', 'Current Streak');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // MISC
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get oyuncu => tr('Oyuncu', 'Player');
  static String get devamEt => tr('Devam Et', 'Continue');
  static String get kapat => tr('Kapat', 'Close');
  static String get evet => tr('Evet', 'Yes');
  static String get hayir => tr('Hay─▒r', 'No');

  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  // AI SERVICE PROMPTS
  // ÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉÔòÉ
  static String get aiPromptLanguage => isEn ? 'English' : 'Turkish';
  static String get aiQuestionTextLabel => isEn ? 'question' : 'soru_metni';
  static String get aiExplanationLabel => isEn ? 'explanation' : 'aciklama';
}