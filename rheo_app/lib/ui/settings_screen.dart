import 'package:flutter/material.dart';
import '../logic/storage_service.dart';
import '../logic/sound_service.dart';
import '../logic/notification_service.dart';
import 'theme.dart';
import 'animations.dart';
import 'about_screen.dart';
import 'feedback_dialog.dart';
import '../data/app_strings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _soundEnabled = soundService.isSoundEnabled;
    _notificationsEnabled = notificationService.isEnabled;
  }

  void _showResetDialog() {
    HapticService.lightTap();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: RheoTheme.cardBg,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: RheoTheme.cardBg,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: RheoTheme.textColor.withAlpha(15), blurRadius: 12)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: RheoColors.error.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_rounded, color: RheoColors.error, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'İlerlemeyi Sıfırla?',
                style: TextStyle(color: RheoTheme.textColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                S.ilerlemeySifirlaMesaj,
                textAlign: TextAlign.center,
                style: TextStyle(color: RheoTheme.textMuted, fontSize: 14),
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
                      child: Text(S.iptal, style: TextStyle(color: RheoTheme.textMuted)),
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
                              content: Text(S.ilerlemeSifirlandi),
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
                      child: Text(S.sifirla),
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
    return Scaffold(
        backgroundColor: RheoTheme.brandScaffoldBg,
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
          title: Text('Ayarlar', style: TextStyle(color: RheoTheme.textColor)),
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
                  child: _buildSectionHeader(S.tr('Tercihler', 'Preferences')),
                ),
                const SizedBox(height: 12),
                StaggeredFadeIn(
                  index: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: RheoTheme.brandCardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: RheoTheme.brandCardBorder),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        _buildToggleTile(
                          icon: Icons.volume_up_rounded,
                          title: S.sesEfektleri,
                          subtitle: S.sesEfektleriSub,
                          value: _soundEnabled,
                          onChanged: (value) async {
                            HapticService.selectionClick();
                            await soundService.setSoundEnabled(value);
                            setState(() => _soundEnabled = value);
                          },
                        ),
                        Divider(height: 1, color: RheoTheme.brandCardBorder),
                        _buildToggleTile(
                          icon: Icons.notifications_active_outlined,
                          title: S.bildirimler,
                          subtitle: _notificationsEnabled 
                            ? '${S.tr('Hatırlatma', 'Reminder')}: ${notificationService.hour.toString().padLeft(2, '0')}:${notificationService.minute.toString().padLeft(2, '0')}'
                            : S.bildirimlerSub,
                          value: _notificationsEnabled,
                          onChanged: (value) async {
                            HapticService.selectionClick();
                            if (value) {
                              // Show time picker
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay(hour: notificationService.hour, minute: notificationService.minute),
                                helpText: S.tr('Hatırlatma Saati', 'Reminder Time'),
                              );
                              if (time != null) {
                                await notificationService.setEnabled(true);
                                await notificationService.setReminderTime(time.hour, time.minute);
                                setState(() => _notificationsEnabled = true);
                              }
                            } else {
                              await notificationService.cancelAll();
                              setState(() => _notificationsEnabled = false);
                            }
                          },
                        ),
                        Divider(height: 1, color: RheoTheme.brandCardBorder),
                        _buildToggleTile(
                          icon: Icons.dark_mode_rounded,
                          title: S.tema,
                          subtitle: S.temaSub,
                          value: storageService.progress.isDarkMode,
                          onChanged: (value) async {
                            HapticService.selectionClick();
                            storageService.progress.isDarkMode = value;
                            await storageService.saveProgress(storageService.progress);
                            setState(() {});
                          },
                        ),
                        Divider(height: 1, color: RheoTheme.brandCardBorder),
                        _buildToggleTile(
                          icon: Icons.language_rounded,
                          title: S.dil,
                          subtitle: storageService.progress.locale == 'en' ? 'English' : 'Türkçe',
                          value: storageService.progress.locale == 'en',
                          onChanged: (value) async {
                            HapticService.selectionClick();
                            storageService.progress.locale = value ? 'en' : 'tr';
                            await storageService.saveProgress(storageService.progress);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                
                // Feedback Section
                StaggeredFadeIn(
                  index: 4,
                  child: _buildSectionHeader(S.geriBildirim),
                ),
                const SizedBox(height: 12),
                StaggeredFadeIn(
                  index: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: RheoTheme.brandCardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: RheoTheme.brandCardBorder),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        _buildActionTile(
                          icon: Icons.feedback_outlined,
                          title: S.geriBildirim,
                          subtitle: S.geriBildirimSub,
                          color: RheoColors.primary,
                          onTap: () {
                            HapticService.lightTap();
                            showFeedbackDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                // About Section
                StaggeredFadeIn(
                  index: 6,
                  child: _buildSectionHeader(S.hakkinda),
                ),
                const SizedBox(height: 12),
                StaggeredFadeIn(
                  index: 7,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: RheoTheme.brandCardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: RheoTheme.brandCardBorder),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        _buildAboutTile(context),
                        Divider(color: RheoTheme.brandCardBorder, height: 1),
                        _buildInfoTile(S.versiyon, '1.0.0 Beta'),
                        Divider(color: RheoTheme.brandCardBorder, height: 1),
                        _buildInfoTile(S.iletisim, 'team@rheo.app'),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Footer
                Center(
                  child: StaggeredFadeIn(
                    index: 8,
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
                          style: TextStyle(color: RheoTheme.brandMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
          color: RheoTheme.brandMuted,
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
          color: RheoTheme.brandCyan.withAlpha(30),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: RheoTheme.brandCyan, size: 22),
      ),
      title: Text(title, style: TextStyle(color: RheoTheme.textColor, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: RheoTheme.brandMuted, fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: RheoTheme.brandCyan,
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
      subtitle: Text(subtitle, style: TextStyle(color: RheoTheme.brandMuted, fontSize: 12)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: color.withAlpha(150), size: 16),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: RheoTheme.brandMuted)),
          Text(value, style: TextStyle(color: RheoTheme.textColor, fontWeight: FontWeight.w500)),
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
      title: Text('Hakkımızda', style: TextStyle(color: RheoTheme.textColor, fontWeight: FontWeight.w500)),
      subtitle: Text('Ekip ve uygulama bilgileri', style: TextStyle(color: RheoTheme.brandMuted, fontSize: 12)),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: RheoColors.primary.withAlpha(150), size: 16),
    );
  }
}
