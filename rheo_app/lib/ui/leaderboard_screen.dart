import 'package:flutter/material.dart';
import 'theme.dart';
import 'animations.dart';
import 'widgets/mascot_widget.dart';

/// Leaderboard Screen - S─▒ralama Tablosu
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  // Mock leaderboard data (ger├ğek uygulamada backend'den gelir)
  static final List<LeaderboardEntry> _mockLeaderboard = [
    LeaderboardEntry(rank: 1, name: 'CodeMaster', elo: 1850, streak: 15, avatar: '­şĞè'),
    LeaderboardEntry(rank: 2, name: 'PyNinja', elo: 1720, streak: 12, avatar: '­şÉı'),
    LeaderboardEntry(rank: 3, name: 'BugHunter', elo: 1680, streak: 8, avatar: '­şÉø'),
    LeaderboardEntry(rank: 4, name: 'DevQueen', elo: 1520, streak: 6, avatar: '­şææ'),
    LeaderboardEntry(rank: 5, name: 'RheoFan', elo: 1480, streak: 5, avatar: '­şĞĞ'),
    LeaderboardEntry(rank: 6, name: 'Algoritma', elo: 1350, streak: 4, avatar: '­şğ«'),
    LeaderboardEntry(rank: 7, name: 'Compiler', elo: 1280, streak: 3, avatar: 'ÔÜÖ´©Å'),
    LeaderboardEntry(rank: 8, name: 'Debugger', elo: 1150, streak: 2, avatar: '­şöı'),
    LeaderboardEntry(rank: 9, name: 'NewCoder', elo: 1050, streak: 1, avatar: '­şî▒'),
    LeaderboardEntry(rank: 10, name: 'Starter', elo: 1000, streak: 0, avatar: '­şÄ«'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RheoTheme.brandScaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: RheoTheme.brandText),
          onPressed: () {
            HapticService.lightTap();
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            const Text('­şÅå', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text('S─▒ralama', style: TextStyle(color: RheoTheme.brandText, fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Top 3 Podium
              _buildPodium(),
              const SizedBox(height: 24),
              
              // Period selector
              _buildPeriodSelector(),
              const SizedBox(height: 16),
              
              // Rest of leaderboard
              _buildLeaderboardList(),
              
              const SizedBox(height: 16),
              
              // User's rank card
              _buildUserRankCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPodium() {
    return StaggeredFadeIn(
      index: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd place
          _buildPodiumPlace(_mockLeaderboard[1], 2, 90, Colors.grey[500]!),
          const SizedBox(width: 8),
          // 1st place
          _buildPodiumPlace(_mockLeaderboard[0], 1, 110, RheoColors.warning),
          const SizedBox(width: 8),
          // 3rd place
          _buildPodiumPlace(_mockLeaderboard[2], 3, 70, const Color(0xFFCD7F32)),
        ],
      ),
    );
  }

  Widget _buildPodiumPlace(LeaderboardEntry entry, int place, double height, Color medalColor) {
    return Column(
      children: [
        // Avatar
        Container(
          width: place == 1 ? 70 : 55,
          height: place == 1 ? 70 : 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                medalColor.withAlpha(60),
                medalColor.withAlpha(25),
              ],
            ),
            border: Border.all(color: medalColor, width: 3),
          ),
          child: Center(
            child: Text(
              entry.avatar,
              style: TextStyle(fontSize: place == 1 ? 32 : 24),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Name
        Text(
          entry.name,
          style: TextStyle(
            color: RheoTheme.brandText,
            fontWeight: FontWeight.bold,
            fontSize: place == 1 ? 14 : 12,
          ),
        ),
        // ELO
        Text(
          '${entry.elo} ELO',
          style: TextStyle(
            color: medalColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        // Podium stand
        Container(
          width: place == 1 ? 80 : 65,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                medalColor.withAlpha(40),
                medalColor.withAlpha(15),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: medalColor.withAlpha(60)),
          ),
          child: Center(
            child: Text(
              '$place',
              style: TextStyle(
                color: medalColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return StaggeredFadeIn(
      index: 1,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: RheoTheme.brandCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: RheoTheme.brandCardBorder),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            _buildPeriodTab('Bug├╝n', true),
            _buildPeriodTab('Bu Hafta', false),
            _buildPeriodTab('T├╝m Zamanlar', false),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodTab(String title, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? RheoColors.primary.withAlpha(20) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: RheoColors.primary.withAlpha(60)) : null,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? RheoColors.primary : RheoTheme.brandMuted,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardList() {
    return Column(
      children: List.generate(
        _mockLeaderboard.length - 3, // Skip top 3
        (index) {
          final entry = _mockLeaderboard[index + 3];
          return StaggeredFadeIn(
            index: index + 2,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildLeaderboardRow(entry),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeaderboardRow(LeaderboardEntry entry) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: RheoTheme.brandCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: RheoTheme.brandCardBorder),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 30,
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                color: RheoTheme.brandMuted,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: RheoTheme.brandCardBg,
            ),
            child: Center(
              child: Text(entry.avatar, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: TextStyle(
                    color: RheoTheme.brandText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (entry.streak > 0)
                  Text(
                    '­şöÑ ${entry.streak} g├╝n seri',
                    style: TextStyle(
                      color: RheoTheme.brandMuted,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          // ELO
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: RheoColors.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: RheoColors.primary.withAlpha(40)),
            ),
            child: Text(
              '${entry.elo}',
              style: TextStyle(
                color: RheoColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRankCard() {
    return StaggeredFadeIn(
      index: 10,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: RheoTheme.brandCardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: RheoTheme.brandCardBorder),
          boxShadow: [BoxShadow(color: RheoTheme.brandAccent.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            // Mascot
            Image.asset(
              getMascotAsset(MascotMood.happy),
              height: 50,
            ),
            const SizedBox(width: 12),
            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Senin S─▒ran',
                    style: TextStyle(
                      color: RheoTheme.brandMuted,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '#42 / 156 Oyuncu',
                    style: TextStyle(
                      color: RheoTheme.brandText,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            // ELO badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [RheoColors.primary, RheoColors.accent],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                '1000 ELO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Leaderboard Entry Model
class LeaderboardEntry {
  final int rank;
  final String name;
  final int elo;
  final int streak;
  final String avatar;

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.elo,
    required this.streak,
    required this.avatar,
  });
}