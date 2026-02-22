import 'package:flutter/material.dart';
import 'theme.dart';
import 'animations.dart';
import 'widgets/mascot_widget.dart';
import 'privacy_policy_screen.dart';
import 'admin_analytics_screen.dart';
import '../data/app_strings.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int _tapCount = 0;
  static const String _adminPin = 'rheo2026';

  void _showPinDialog(BuildContext context) {
    final pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: RheoTheme.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.lock_rounded, color: RheoColors.primary, size: 20),
            const SizedBox(width: 8),
            Text('Admin PIN', style: TextStyle(color: RheoTheme.textColor, fontSize: 16)),
          ],
        ),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.text,
          maxLength: 8,
          obscureText: true,
          autofocus: true,
          style: TextStyle(color: RheoTheme.textColor, fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(color: RheoTheme.textMuted.withAlpha(80)),
            counterText: '',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: RheoColors.primary, width: 2),
            ),
          ),
          onSubmitted: (value) {
            Navigator.pop(ctx);
            if (value == _adminPin) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAnalyticsScreen()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.tr('Yanlış PIN', 'Wrong PIN')), backgroundColor: RheoColors.error),
              );
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(S.tr('İptal', 'Cancel'), style: TextStyle(color: RheoTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (pinController.text == _adminPin) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAnalyticsScreen()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S.tr('Yanlış PIN', 'Wrong PIN')), backgroundColor: RheoColors.error),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: RheoColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(S.tr('Giriş', 'Enter'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(S.tr('Hakkımızda', 'About Us'), style: TextStyle(color: RheoTheme.textColor)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // App Logo & Info
              StaggeredFadeIn(
                index: 0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: RheoTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RheoTheme.buttonBorder),
                  ),
                  child: Column(
                    children: [
                      Image.asset(getMascotAsset(MascotMood.happy), height: 120),
                      const SizedBox(height: 12),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [RheoColors.primary, RheoColors.accent],
                        ).createShader(bounds),
                        child: const Text(
                          'RHEO',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        S.tr('Kodla Öğren, Oynayarak Geliş', 'Learn to Code, Level Up Playing'),
                        style: TextStyle(
                          color: RheoTheme.textMuted,
                          fontSize: 12,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          _tapCount++;
                          if (_tapCount >= 5) {
                            _tapCount = 0;
                            _showPinDialog(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: RheoColors.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'v1.0.0 Beta',
                            style: TextStyle(
                              color: RheoColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Description
              StaggeredFadeIn(
                index: 1,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: RheoTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RheoTheme.buttonBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: RheoColors.primary, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            S.tr('Uygulama Hakkında', 'About the App'),
                            style: TextStyle(color: RheoTheme.textColor, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        S.tr(
                          'Rheo, kod okuma ve anlama becerilerini geliştirmek için tasarlanmış eğlenceli ve bağımlılık yapan bir oyun. '
                          'Python, Java ve JavaScript dillerinde çeşitli kod parçacıklarını analiz ederek çıktılarını tahmin et, '
                          'Bug Hunter modunda hatalı satırları bul ve ELO sisteminde yüksel!',
                          'Rheo is a fun and addictive game designed to improve your code reading skills. '
                          'Analyze code snippets in Python, Java and JavaScript to predict their outputs, '
                          'find bug lines in Bug Hunter mode and climb the ELO rankings!',
                        ),
                        style: TextStyle(color: RheoTheme.textMuted, fontSize: 13, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Features
              StaggeredFadeIn(
                index: 2,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: RheoTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RheoTheme.buttonBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star_rounded, color: RheoColors.secondary, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            S.tr('Özellikler', 'Features'),
                            style: TextStyle(color: RheoTheme.textColor, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureRow(Icons.code, S.tr('1290+ soru havuzu', '1290+ question pool'), RheoColors.primary),
                      _buildFeatureRow(Icons.bug_report, S.tr('80+ Bug Hunter sorusu', '80+ Bug Hunter questions'), RheoColors.secondary),
                      _buildFeatureRow(Icons.language, S.tr('Python, Java, JavaScript', 'Python, Java, JavaScript'), RheoColors.accent),
                      _buildFeatureRow(Icons.trending_up, S.tr('Adaptif zorluk (ELO sistemi)', 'Adaptive difficulty (ELO system)'), RheoColors.success),
                      _buildFeatureRow(Icons.translate, S.tr('Türkçe & İngilizce', 'Turkish & English'), RheoColors.warning),
                      _buildFeatureRow(Icons.smart_toy, S.tr('AI destekli soru üretimi', 'AI-powered question generation'), RheoColors.error),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Team Section Header
              StaggeredFadeIn(
                index: 3,
                child: Row(
                  children: [
                    Text(
                      S.tr('GELİŞTİRİCİ EKİP', 'DEVELOPMENT TEAM'),
                      style: TextStyle(
                        color: RheoTheme.textMuted,
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Team Members
              StaggeredFadeIn(
                index: 4,
                child: _buildTeamMember(
                  name: 'Furkan Ahi',
                  role: S.tr('Boğaziçi Üniversitesi • Kurucu', 'Boğaziçi University • Founder'),
                  icon: Icons.person_rounded,
                  color: RheoColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              
              StaggeredFadeIn(
                index: 5,
                child: _buildTeamMember(
                  name: 'Mahmut Emre',
                  role: S.tr('Boğaziçi Üniversitesi • Kurucu', 'Boğaziçi University • Founder'),
                  icon: Icons.person_rounded,
                  color: RheoColors.accent,
                ),
              ),
              const SizedBox(height: 10),
              
              StaggeredFadeIn(
                index: 6,
                child: _buildTeamMember(
                  name: 'Bahadır Erdoğan',
                  role: S.tr('Yıldız Teknik Üniversitesi • Kurucu', 'Yıldız Technical University • Founder'),
                  icon: Icons.person_rounded,
                  color: RheoColors.secondary,
                ),
              ),

              const SizedBox(height: 24),

              // Privacy Policy Button
              StaggeredFadeIn(
                index: 7,
                child: Container(
                  decoration: BoxDecoration(
                    color: RheoTheme.cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: RheoTheme.buttonBorder),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.shield_rounded, color: RheoColors.accent),
                    title: Text(S.tr('Gizlilik Politikası', 'Privacy Policy'), 
                      style: TextStyle(color: RheoTheme.textColor, fontSize: 14, fontWeight: FontWeight.w500)),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, color: RheoTheme.textMuted, size: 16),
                    onTap: () => Navigator.push(context, 
                      MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Footer
              StaggeredFadeIn(
                index: 8,
                child: Column(
                  children: [
                    Text(
                      '© 2026 Rheo Team',
                      style: TextStyle(color: RheoTheme.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Made with ❤️ in Turkey',
                      style: TextStyle(color: RheoTheme.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: RheoTheme.textColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: RheoTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: RheoTheme.textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(
                    color: RheoTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
