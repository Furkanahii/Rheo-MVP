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
          title: const Text('Gizlilik Politikas─▒', style: TextStyle(color: Colors.white)),
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
                              'Gizlilik Politikas─▒',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Son g├╝ncelleme: 21 ┼Şubat 2026',
                          style: TextStyle(color: RheoColors.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                _buildSection(1, 'Toplanan Veriler', Icons.data_usage_rounded, [
                  'Rheo uygulamas─▒, kullan─▒c─▒ deneyimini iyile┼ştirmek i├ğin yaln─▒zca cihaz─▒n─▒zda saklanan yerel verileri kullan─▒r:',
                  'ÔÇó ELO puan─▒ ve s─▒ralama bilgileri',
                  'ÔÇó Quiz istatistikleri (do─şru/yanl─▒┼ş say─▒lar─▒)',
                  'ÔÇó G├╝nl├╝k hedef ve seri bilgileri',
                  'ÔÇó Se├ğilen avatar ve kullan─▒c─▒ ad─▒',
                  'ÔÇó Tercih edilen programlama dili',
                  '',
                  'Bu veriler YALNIZCA cihaz─▒n─▒zda saklan─▒r ve hi├ğbir sunucuya g├Ânderilmez.',
                ]),

                const SizedBox(height: 12),
                _buildSection(2, 'AI Soru ├£retimi', Icons.auto_awesome_rounded, [
                  'AI destekli soru ├╝retimi ├Âzelli─şi, Google Gemini API kullan─▒larak ├ğal─▒┼ş─▒r.',
                  'ÔÇó API\'ye yaln─▒zca soru ├╝retim istekleri g├Ânderilir.',
                  'ÔÇó Ki┼şisel bilgileriniz API\'ye g├Ânderilmez.',
                  'ÔÇó Statik soru bankas─▒ (752+ soru) API olmadan ├ğal─▒┼ş─▒r.',
                ]),

                const SizedBox(height: 12),
                _buildSection(3, 'Veri G├╝venli─şi', Icons.lock_rounded, [
                  'ÔÇó T├╝m kullan─▒c─▒ verileri cihaz─▒n─▒zda yerel olarak ┼şifreli ┼şekilde saklan─▒r (Hive veritaban─▒).',
                  'ÔÇó Uygulama, kullan─▒c─▒ hesab─▒ veya kay─▒t gerektirmez.',
                  'ÔÇó Veri silme: Ayarlar > ─░lerlemeyi S─▒f─▒rla ile t├╝m verilerinizi silebilirsiniz.',
                ]),

                const SizedBox(height: 12),
                _buildSection(4, '├£├ğ├╝nc├╝ Taraf Hizmetleri', Icons.hub_rounded, [
                  'ÔÇó Google Gemini API: AI soru ├╝retimi (opsiyonel)',
                  'ÔÇó Firebase Hosting: Web versiyonu bar─▒nd─▒rma',
                  'ÔÇó Bu hizmetlerin gizlilik politikalar─▒ kendi web sitelerinde bulunmaktad─▒r.',
                ]),

                const SizedBox(height: 12),
                _buildSection(5, '├çocuk G├╝venli─şi', Icons.child_care_rounded, [
                  'Rheo, her ya┼ştan kullan─▒c─▒ i├ğin uygundur. Uygulama:',
                  'ÔÇó Ki┼şisel bilgi toplamaz',
                  'ÔÇó Reklam g├Âstermez',
                  'ÔÇó Uygulama i├ği sat─▒n alma i├ğermez',
                  'ÔÇó Sosyal medya entegrasyonu yoktur',
                ]),

                const SizedBox(height: 12),
                _buildSection(6, '─░leti┼şim', Icons.email_rounded, [
                  'Gizlilik politikas─▒ hakk─▒nda sorular─▒n─▒z i├ğin:',
                  '­şôğ rheocode.app@gmail.com',
                ]),

                const SizedBox(height: 24),
                Center(
                  child: Text(
                    '┬® 2026 Rheo Team ÔÇö Bo─şazi├ği ├£niversitesi',
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