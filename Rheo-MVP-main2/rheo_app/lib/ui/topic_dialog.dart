import 'package:flutter/material.dart';
import 'theme.dart';
import 'animations.dart';

/// Topic options for filtering
class TopicOption {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final bool isAI;

  const TopicOption({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    this.isAI = false,
  });
}

/// Available topics
class Topics {
  static const List<TopicOption> all = [
    TopicOption(
      id: '',
      label: 'Tümü',
      icon: Icons.grid_view_rounded,
      color: RheoColors.primary,
    ),
    TopicOption(
      id: 'variable',
      label: 'Değişkenler',
      icon: Icons.data_object_rounded,
      color: Color(0xFF4CAF50),
    ),
    TopicOption(
      id: 'loop',
      label: 'Döngüler',
      icon: Icons.loop_rounded,
      color: Color(0xFFFF9800),
    ),
    TopicOption(
      id: 'if_else',
      label: 'Koşullar',
      icon: Icons.call_split_rounded,
      color: Color(0xFF2196F3),
    ),
    TopicOption(
      id: 'function',
      label: 'Fonksiyonlar',
      icon: Icons.functions_rounded,
      color: Color(0xFF9C27B0),
    ),
    TopicOption(
      id: 'list',
      label: 'Listeler',
      icon: Icons.list_alt_rounded,
      color: Color(0xFFE91E63),
    ),
    TopicOption(
      id: 'string',
      label: 'Stringler',
      icon: Icons.text_fields_rounded,
      color: Color(0xFF00BCD4),
    ),
    TopicOption(
      id: 'array',
      label: 'Diziler',
      icon: Icons.view_array_rounded,
      color: Color(0xFFFF5722),
    ),
    TopicOption(
      id: 'oop',
      label: 'OOP',
      icon: Icons.account_tree_rounded,
      color: Color(0xFF8BC34A),
    ),
    TopicOption(
      id: 'recursion',
      label: 'Özyineleme',
      icon: Icons.replay_rounded,
      color: Color(0xFF673AB7),
    ),
    TopicOption(
      id: 'sorting',
      label: 'Sıralama',
      icon: Icons.sort_rounded,
      color: Color(0xFFFF9800),
    ),
    TopicOption(
      id: 'stack_queue',
      label: 'Yığın & Kuyruk',
      icon: Icons.layers_rounded,
      color: Color(0xFF795548),
    ),
  ];

  /// AI destekli kategoriler
  static const List<TopicOption> aiTopics = [
    TopicOption(
      id: 'ai_arrays',
      label: 'Arrays & Hashing',
      icon: Icons.rocket_launch_rounded,
      color: Color(0xFF00BCD4),
      isAI: true,
    ),
    TopicOption(
      id: 'ai_linked_lists',
      label: 'Linked Lists',
      icon: Icons.link_rounded,
      color: Color(0xFFFF5722),
      isAI: true,
    ),
    TopicOption(
      id: 'ai_trees',
      label: 'Trees & Graphs',
      icon: Icons.account_tree_rounded,
      color: Color(0xFF8BC34A),
      isAI: true,
    ),
  ];
}

/// Topic selection dialog - returns TopicOption or null
Future<TopicOption?> showTopicDialog(BuildContext context) {
  final langAccent = RheoTheme.langText();

  return showModalBottomSheet<TopicOption>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: RheoTheme.cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 16),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: RheoTheme.textMuted.withAlpha(80),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Konu Seç',
              style: TextStyle(
                color: RheoTheme.textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Çalışmak istediğin konuyu seç',
              style: TextStyle(color: RheoTheme.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 20),
            
            // Statik konular — hepsi dil renginde
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: Topics.all.map((topic) {
                return _buildTopicTile(context, topic, langAccent);
              }).toList(),
            ),
            
            const SizedBox(height: 20),
            
            // AI Ayırıcısı
            Row(
              children: [
                Expanded(child: Divider(color: RheoTheme.textMuted.withAlpha(60))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, color: const Color(0xFF00BCD4), size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'AI Destekli',
                        style: TextStyle(
                          color: const Color(0xFF00BCD4),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Divider(color: RheoTheme.textMuted.withAlpha(60))),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // AI kategorileri — hepsi dil renginde
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: Topics.aiTopics.map((topic) {
                return _buildTopicTile(context, topic, langAccent);
              }).toList(),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}

Widget _buildTopicTile(BuildContext context, TopicOption topic, Color langColor) {
  return _TopicTileButton(
    topic: topic,
    langColor: langColor,
    onTap: () {
      HapticService.lightTap();
      Navigator.pop(context, topic);
    },
  );
}

/// Stateful topic tile with hover/press animation
class _TopicTileButton extends StatefulWidget {
  final TopicOption topic;
  final Color langColor;
  final VoidCallback onTap;

  const _TopicTileButton({
    required this.topic,
    required this.langColor,
    required this.onTap,
  });

  @override
  State<_TopicTileButton> createState() => _TopicTileButtonState();
}

class _TopicTileButtonState extends State<_TopicTileButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  bool get _elevated => _isHovered || _isPressed;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: (MediaQuery.of(context).size.width - 60) / 2,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: RheoTheme.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _elevated
                  ? widget.langColor.withAlpha(160)
                  : widget.langColor.withAlpha(60),
              width: _elevated ? 2 : 1,
            ),
            boxShadow: _elevated
                ? [
                    BoxShadow(
                      color: widget.langColor.withAlpha(25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          transform: _isPressed
              ? (Matrix4.identity()..scale(0.96))
              : (_isHovered
                  ? (Matrix4.identity()..translate(0.0, -2.0))
                  : Matrix4.identity()),
          child: Row(
            children: [
              Icon(widget.topic.icon, color: widget.langColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.topic.label,
                      style: TextStyle(
                        color: RheoTheme.textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.topic.isAI) ...[
                      const SizedBox(height: 2),
                      Text(
                        'AI ✨',
                        style: TextStyle(
                          color: widget.langColor.withAlpha(150),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
