import 'package:flutter/material.dart';
import 'theme.dart';
import 'animations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Gizlilik Politikası', style: TextStyle(color: Colors.white)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StaggeredFadeIn(
                  index: 0,
                  child: GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.shield_rounded, color: RheoColors.primary, size: 24),
                            const SizedBox(width: 10),
                            const Text(
                              'Gizlilik Politikası',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Son güncelleme: 21 Şubat 2026',
                          style: TextStyle(color: RheoColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                _buildSection(1, 'Toplanan Veriler', Icons.data_usage_rounded, [
                  'Rheo uygulaması, kullanıcı deneyimini iyileştirmek için yalnızca cihazınızda saklanan yerel verileri kullanır:',
                  '• ELO puanı ve sıralama bilgileri',
                  '• Quiz istatistikleri (doğru/yanlış sayıları)',
                  '• Günlük hedef ve seri bilgileri',
                  '• Seçilen avatar ve kullanıcı adı',
                  '• Tercih edilen programlama dili',
                  '',
                  'Bu veriler YALNIZCA cihazınızda saklanır ve hiçbir sunucuya gönderilmez.',
                ]),

                const SizedBox(height: 12),
                _buildSection(2, 'AI Soru Üretimi', Icons.auto_awesome_rounded, [
                  'AI destekli soru üretimi özelliği, Google Gemini API kullanılarak çalışır.',
                  '• API\'ye yalnızca soru üretim istekleri gönderilir.',
                  '• Kişisel bilgileriniz API\'ye gönderilmez.',
                  '• Statik soru bankası (752+ soru) API olmadan çalışır.',
                ]),

                const SizedBox(height: 12),
                _buildSection(3, 'Veri Güvenliği', Icons.lock_rounded, [
                  '• Tüm kullanıcı verileri cihazınızda yerel olarak şifreli şekilde saklanır (Hive veritabanı).',
                  '• Uygulama, kullanıcı hesabı veya kayıt gerektirmez.',
                  '• Veri silme: Ayarlar > İlerlemeyi Sıfırla ile tüm verilerinizi silebilirsiniz.',
                ]),

                const SizedBox(height: 12),
                _buildSection(4, 'Üçüncü Taraf Hizmetleri', Icons.hub_rounded, [
                  '• Google Gemini API: AI soru üretimi (opsiyonel)',
                  '• Firebase Hosting: Web versiyonu barındırma',
                  '• Bu hizmetlerin gizlilik politikaları kendi web sitelerinde bulunmaktadır.',
                ]),

                const SizedBox(height: 12),
                _buildSection(5, 'Çocuk Güvenliği', Icons.child_care_rounded, [
                  'Rheo, her yaştan kullanıcı için uygundur. Uygulama:',
                  '• Kişisel bilgi toplamaz',
                  '• Reklam göstermez',
                  '• Uygulama içi satın alma içermez',
                  '• Sosyal medya entegrasyonu yoktur',
                ]),

                const SizedBox(height: 12),
                _buildSection(6, 'İletişim', Icons.email_rounded, [
                  'Gizlilik politikası hakkında sorularınız için:',
                  '📧 rheoapp@gmail.com',
                ]),

                const SizedBox(height: 24),
                Center(
                  child: Text(
                    '© 2026 Rheo Team — Boğaziçi Üniversitesi',
                    style: TextStyle(color: RheoColors.textMuted, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(int index, String title, IconData icon, List<String> content) {
    return StaggeredFadeIn(
      index: index,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: RheoColors.accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...content.map((line) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                line,
                style: TextStyle(
                  color: RheoColors.textSecondary,
                  fontSize: 12.5,
                  height: 1.5,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
