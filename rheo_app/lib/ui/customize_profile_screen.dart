import 'package:flutter/material.dart';
import '../logic/storage_service.dart';
import '../logic/sound_service.dart';
import 'theme.dart';
import 'animations.dart';
import 'profile_screen.dart';

class CustomizeProfileScreen extends StatefulWidget {
  const CustomizeProfileScreen({super.key});

  @override
  State<CustomizeProfileScreen> createState() => _CustomizeProfileScreenState();
}

class _CustomizeProfileScreenState extends State<CustomizeProfileScreen> {
  late TextEditingController _nickController;
  late int _selectedAvatar;

  // 14 animal emojis in 2 rows of 7
  static const List<String> _avatarEmojis = [
    '🐶', '🐱', '🐼', '🦊', '🐸', '🦉', '🐰',
    '🐻', '🦁', '🐺', '🐯', '🐨', '🦋', '🐬',
  ];

  static const List<Color> _avatarColors = [
    Color(0xFF8D6E63), Color(0xFFFF9800), Color(0xFF4CAF50),
    Color(0xFFFF5722), Color(0xFF8BC34A), Color(0xFF9C27B0),
    Color(0xFFE91E63), Color(0xFF795548), Color(0xFFFF6F00),
    Color(0xFF607D8B), Color(0xFFFF7043), Color(0xFF78909C),
    Color(0xFF7C4DFF), Color(0xFF0097A7),
  ];

  @override
  void initState() {
    super.initState();
    _nickController =
        TextEditingController(text: storageService.progress.nickname);
    _selectedAvatar = storageService.progress.selectedAvatarIndex;
    // Clamp to valid range
    if (_selectedAvatar >= _avatarEmojis.length) _selectedAvatar = 0;
  }

  @override
  void dispose() {
    _nickController.dispose();
    super.dispose();
  }

  void _save() {
    HapticService.lightTap();
    final p = storageService.progress;
    p.nickname = _nickController.text.trim().isEmpty
        ? 'Oyuncu'
        : _nickController.text.trim();
    p.selectedAvatarIndex = _selectedAvatar;
    storageService.saveProgress(p);
    Navigator.pop(context);
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
        title: Text('Profili Özelleştir',
            style: TextStyle(color: RheoTheme.textColor, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text('Kaydet',
                style: TextStyle(
                    color: RheoTheme.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Avatar preview (centered, large)
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _avatarColors[_selectedAvatar].withAlpha(180),
                        _avatarColors[_selectedAvatar].withAlpha(80),
                      ],
                    ),
                    border: Border.all(
                      color: _avatarColors[_selectedAvatar].withAlpha(200),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _avatarColors[_selectedAvatar].withAlpha(60),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _avatarEmojis[_selectedAvatar],
                      style: const TextStyle(fontSize: 46),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Username label + field (left-aligned)
              Text(
                'KULLANICI ADI',
                style: TextStyle(
                  color: RheoTheme.textMuted,
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 200,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: RheoTheme.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: RheoTheme.textMuted.withAlpha(80)),
                  ),
                  child: TextField(
                    controller: _nickController,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: RheoTheme.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Kullanıcı Adı',
                      hintStyle: TextStyle(color: RheoTheme.textMuted),
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    maxLength: 20,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Avatar grid header
              Text(
                'AVATAR SEÇ',
                style: TextStyle(
                  color: RheoTheme.textMuted,
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 1.15,
                ),
                itemCount: _avatarEmojis.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedAvatar;
                  final avatarColor = _avatarColors[index];
                  return GestureDetector(
                    onTap: () {
                      HapticService.selectionClick();
                      setState(() => _selectedAvatar = index);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            avatarColor.withAlpha(isSelected ? 60 : 35),
                            avatarColor.withAlpha(isSelected ? 30 : 15),
                          ],
                        ),
                        border: Border.all(
                          color: isSelected
                              ? avatarColor
                              : avatarColor.withAlpha(50),
                          width: isSelected ? 3 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: avatarColor.withAlpha(40),
                                  blurRadius: 10,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          _avatarEmojis[index],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
