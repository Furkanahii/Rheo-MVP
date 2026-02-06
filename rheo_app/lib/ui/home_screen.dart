import 'package:flutter/material.dart';
import '../logic/storage_service.dart';
import '../logic/elo_calculator.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initStorage();
  }

  Future<void> _initStorage() async {
    await storageService.init();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00D9FF)),
        ),
      );
    }

    final progress = storageService.progress;
    final rankColor = Color(EloCalculator.getRankColor(progress.elo));

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              
              // Logo / Title
              const Text(
                'RHEO',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kod Okuma Oyunu',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[400],
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Stats Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF404040)),
                ),
                child: Column(
                  children: [
                    // ELO & Rank
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: rankColor.withAlpha(51),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: rankColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.emoji_events, color: rankColor, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                '${progress.elo} ELO',
                                style: TextStyle(
                                  color: rankColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      EloCalculator.getRankTitle(progress.elo),
                      style: TextStyle(
                        color: rankColor,
                        fontSize: 16,
                      ),
                    ),
                    
                    const Divider(color: Color(0xFF404040), height: 32),
                    
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('🔥 Seri', '${progress.currentStreak}'),
                        _buildStat('🏆 En İyi', '${progress.bestStreak}'),
                        _buildStat('📊 Doğruluk', 
                          '${progress.accuracy.toStringAsFixed(0)}%'),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Start Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuizScreen()),
                    ).then((_) => setState(() {})); // Refresh stats on return
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D9FF),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'BAŞLA',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Total questions answered
              Text(
                '${progress.totalQuestions} soru çözüldü',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
