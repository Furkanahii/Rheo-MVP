import 'package:flutter/material.dart';
import '../logic/storage_service.dart';
import '../logic/sound_service.dart';
import 'theme.dart';
import 'animations.dart';
import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _soundEnabled = soundService.isSoundEnabled;
  }

  void _showResetDialog() {
    HapticService.lightTap();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          blur: 20,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: RheoColors.error.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_rounded, color: RheoColors.error, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                'İlerlemeyi Sıfırla?',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Tüm ELO puanın, serilerin ve istatistiklerin silinecek. Bu işlem geri alınamaz.',
                textAlign: TextAlign.center,
                style: TextStyle(color: RheoColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        HapticService.lightTap();
                        Navigator.pop(context);
                      },
                      child: Text('İptal', style: TextStyle(color: RheoColors.textMuted)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        HapticService.error();
                        await storageService.resetProgress();
                        if (context.mounted) {
                          Navigator.pop(context);
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('İlerleme sıfırlandı'),
                              backgroundColor: RheoColors.error,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RheoColors.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Sıfırla'),
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
          title: const Text('Ayarlar', style: TextStyle(color: Colors.white)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preferences Section
                StaggeredFadeIn(
                  index: 0,
                  child: _buildSectionHeader('Tercihler'),
                ),
                const SizedBox(height: 12),
                StaggeredFadeIn(
                  index: 1,
                  child: GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildToggleTile(
                          icon: Icons.volume_up_rounded,
                          title: 'Ses Efektleri',
                          subtitle: 'Doğru/yanlış sesleri',
                          value: _soundEnabled,
                          onChanged: (value) async {
                            HapticService.selectionClick();
                            await soundService.setSoundEnabled(value);
                            setState(() => _soundEnabled = value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Data Section
                StaggeredFadeIn(
                  index: 2,
                  child: _buildSectionHeader('Veri'),
                ),
                const SizedBox(height: 12),
                StaggeredFadeIn(
                  index: 3,
                  child: GlassCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildActionTile(
                          icon: Icons.refresh_rounded,
                          title: 'İlerlemeyi Sıfırla',
                          subtitle: 'Tüm verileri sil',
                          color: RheoColors.error,
                          onTap: _showResetDialog,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // About Section
                StaggeredFadeIn(
                  index: 4,
                  child: _buildSectionHeader('Hakkında'),
                ),
                const SizedBox(height: 12),
                StaggeredFadeIn(
                  index: 5,
                  child: GlassCard(
                    child: Column(
                      children: [
                        _buildAboutTile(context),
                        const Divider(color: RheoColors.glassBorder, height: 1),
                        _buildInfoTile('Versiyon', '1.0.0 Beta'),
                        const Divider(color: RheoColors.glassBorder, height: 1),
                        _buildInfoTile('İletişim', 'team@rheo.app'),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Footer
                Center(
                  child: StaggeredFadeIn(
                    index: 6,
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [RheoColors.primary, RheoColors.accent],
                          ).createShader(bounds),
                          child: const Text(
                            'RHEO',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '© 2026 • Kod Okuma Oyunu',
                          style: TextStyle(color: RheoColors.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: RheoColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: RheoColors.primary.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: RheoColors.primary, size: 22),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: RheoColors.textMuted, fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: RheoColors.primary,
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: RheoColors.textMuted, fontSize: 12)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: color.withAlpha(150), size: 16),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: RheoColors.textSecondary)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () {
        HapticService.lightTap();
        Navigator.push(
          context,
          PageTransitions.slideRight(const AboutScreen()),
        );
      },
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: RheoColors.primary.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.info_outline_rounded, color: RheoColors.primary, size: 22),
      ),
      title: const Text('Hakkımızda', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      subtitle: Text('Ekip ve uygulama bilgileri', style: TextStyle(color: RheoColors.textMuted, fontSize: 12)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: RheoColors.primary.withAlpha(150), size: 16),
    );
  }
}
