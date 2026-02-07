import 'package:flutter/material.dart';
import 'theme.dart';
import 'animations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
            onPressed: () {
              HapticService.lightTap();
              Navigator.pop(context);
            },
          ),
          title: const Text('Hakkımızda', style: TextStyle(color: Colors.white)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // App Logo & Info
                StaggeredFadeIn(
                  index: 0,
                  child: GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Image.asset('assets/mascot.png', height: 120),
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
                          'Learning for coding',
                          style: TextStyle(
                            color: RheoColors.textMuted,
                            fontSize: 12,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
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
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Description
                StaggeredFadeIn(
                  index: 1,
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline_rounded, color: RheoColors.primary, size: 22),
                            const SizedBox(width: 10),
                            const Text(
                              'Uygulama Hakkında',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Rheo, kod okuma becerilerini geliştirmek için tasarlanmış eğlenceli bir oyun. '
                          'Python, Java ve JavaScript dillerinde çeşitli kod parçacıklarını analiz ederek çıktılarını tahmin et.',
                          style: TextStyle(color: RheoColors.textSecondary, fontSize: 13, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Team Section Header
                StaggeredFadeIn(
                  index: 2,
                  child: Row(
                    children: [
                      Text(
                        'GELİŞTİRİCİ EKİP',
                        style: TextStyle(
                          color: RheoColors.textMuted,
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
                  index: 3,
                  child: _buildTeamMember(
                    name: 'Furkan Ahi',
                    role: 'Boğaziçi Üniversitesi',
                    icon: Icons.person_rounded,
                    color: RheoColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                
                StaggeredFadeIn(
                  index: 4,
                  child: _buildTeamMember(
                    name: 'Mahmut Emre',
                    role: 'Boğaziçi Üniversitesi',
                    icon: Icons.person_rounded,
                    color: RheoColors.accent,
                  ),
                ),
                const SizedBox(height: 10),
                
                StaggeredFadeIn(
                  index: 5,
                  child: _buildTeamMember(
                    name: 'Bahadır Erdoğan',
                    role: 'Yıldız Teknik Üniversitesi',
                    icon: Icons.person_rounded,
                    color: RheoColors.secondary,
                  ),
                ),

                const SizedBox(height: 24),

                // Footer
                StaggeredFadeIn(
                  index: 6,
                  child: Column(
                    children: [
                      Text(
                        '© 2026 Rheo Team',
                        style: TextStyle(color: RheoColors.textMuted, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Made with ❤️ in Turkey',
                        style: TextStyle(color: RheoColors.textMuted, fontSize: 11),
                      ),
                    ],
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

  Widget _buildTeamMember({
    required String name,
    required String role,
    required IconData icon,
    required Color color,
  }) {
    return GlassCard(
      borderColor: color.withAlpha(50),
      padding: const EdgeInsets.all(14),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(
                    color: RheoColors.textMuted,
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
