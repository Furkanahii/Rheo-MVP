import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';
import 'animations.dart';

/// Show feedback dialog
void showFeedbackDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const FeedbackDialog(),
  );
}

class FeedbackDialog extends StatelessWidget {
  const FeedbackDialog({super.key});

  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'team@rheo.app',
      queryParameters: {
        'subject': 'Rheo Feedback',
        'body': 'Uygulama: Rheo v1.0.0\n\n---\nMesajınız:\n',
      },
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        blur: 20,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.feedback_outlined,
              color: RheoColors.primary,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Geri Bildirim',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Bir hata mı buldun? Önerilerin mi var?\nBize ulaşmaktan çekinme!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RheoColors.textSecondary,
                fontSize: 14,
              ),
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
                    child: Text(
                      'İptal',
                      style: TextStyle(color: RheoColors.textMuted),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticService.lightTap();
                      Navigator.pop(context);
                      _sendEmail();
                    },
                    icon: const Icon(Icons.email, size: 18),
                    label: const Text('E-posta'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: RheoColors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
