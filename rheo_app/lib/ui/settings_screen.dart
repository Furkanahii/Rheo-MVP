import 'package:flutter/material.dart';
import '../logic/sound_service.dart';
import '../logic/storage_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text('Ayarlar', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sound Settings
          _buildSection(
            title: 'SES',
            children: [
              _buildToggleTile(
                icon: Icons.volume_up,
                title: 'Ses Efektleri',
                subtitle: 'Doğru/yanlış cevap sesleri',
                value: _soundEnabled,
                onChanged: (value) async {
                  await soundService.setSoundEnabled(value);
                  setState(() => _soundEnabled = value);
                },
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Data Settings
          _buildSection(
            title: 'VERİ',
            children: [
              _buildActionTile(
                icon: Icons.refresh,
                iconColor: Colors.orange,
                title: 'İlerlemeyi Sıfırla',
                subtitle: 'Tüm istatistikler silinecek',
                onTap: () => _showResetDialog(context),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // About Section
          _buildSection(
            title: 'HAKKINDA',
            children: [
              _buildInfoTile(
                icon: Icons.info_outline,
                title: 'Versiyon',
                value: '1.0.0',
              ),
              _buildInfoTile(
                icon: Icons.code,
                title: 'Geliştirici',
                value: 'Rheo Team',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
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
      leading: Icon(icon, color: const Color(0xFF00D9FF)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: const Color(0xFF00D9FF),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Text(value, style: TextStyle(color: Colors.grey[400])),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text('İlerlemeyi Sıfırla?', style: TextStyle(color: Colors.white)),
        content: Text(
          'Tüm ELO puanın, streak\'in ve istatistiklerin silinecek. Bu işlem geri alınamaz.',
          style: TextStyle(color: Colors.grey[400]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await storageService.resetProgress();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('İlerleme sıfırlandı')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sıfırla', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
