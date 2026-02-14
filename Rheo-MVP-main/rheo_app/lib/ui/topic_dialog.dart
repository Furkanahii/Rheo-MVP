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
  return showModalBottomSheet<TopicOption>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: RheoColors.bgTop,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: RheoColors.glassBorder),
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
            
            // Statik konular
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: Topics.all.map((topic) {
                return _buildTopicTile(context, topic);
              }).toList(),
            ),
            
            const SizedBox(height: 20),
            
            // AI Ayırıcısı
            Row(
              children: [
                Expanded(child: Divider(color: RheoColors.glassBorder)),
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
                Expanded(child: Divider(color: RheoColors.glassBorder)),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // AI kategorileri
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: Topics.aiTopics.map((topic) {
                return _buildTopicTile(context, topic);
              }).toList(),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    ),
  );
}

Widget _buildTopicTile(BuildContext context, TopicOption topic) {
  return GestureDetector(
    onTap: () {
      HapticService.lightTap();
      Navigator.pop(context, topic);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.label,
                  style: TextStyle(
                    color: topic.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (topic.isAI) ...[
                  const SizedBox(height: 2),
                  Text(
                    'AI ✨',
                    style: TextStyle(
                      color: topic.color.withAlpha(150),
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
  );
}

