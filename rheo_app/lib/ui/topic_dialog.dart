import 'package:flutter/material.dart';
import 'theme.dart';
import 'animations.dart';

/// Topic options for filtering
class TopicOption {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const TopicOption({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
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
  ];
}

/// Topic selection dialog
Future<String?> showTopicDialog(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: RheoColors.bgTop,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: RheoColors.glassBorder),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: RheoColors.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Konu Seç',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Çalışmak istediğin konuyu seç',
            style: TextStyle(color: RheoColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: Topics.all.map((topic) {
              return GestureDetector(
                onTap: () {
                  HapticService.lightTap();
                  Navigator.pop(context, topic.id);
                },
                child: Container(
                  width: (MediaQuery.of(context).size.width - 60) / 2,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: topic.color.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: topic.color.withAlpha(60)),
                  ),
                  child: Row(
                    children: [
                      Icon(topic.icon, color: topic.color, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          topic.label,
                          style: TextStyle(
                            color: topic.color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}
