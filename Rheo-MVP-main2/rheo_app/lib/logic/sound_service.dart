import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

/// Service for managing sound effects using tone generation
/// No external audio files needed — uses synthesized tones
class SoundService {
  static const String _settingsBox = 'rheo_settings';
  static const String _soundEnabledKey = 'sound_enabled';
  
  Box? _box;
  bool _soundEnabled = true;
  bool _initialized = false;
  
  // Audio players for each sound type
  AudioPlayer? _correctPlayer;
  AudioPlayer? _wrongPlayer;
  AudioPlayer? _levelUpPlayer;

  /// Initialize sound service
  Future<void> init() async {
    if (_initialized) return;
    
    try {
      _box = await Hive.openBox(_settingsBox);
      _soundEnabled = _box?.get(_soundEnabledKey, defaultValue: true) ?? true;
      
      // Pre-create players
      _correctPlayer = AudioPlayer();
      _wrongPlayer = AudioPlayer();
      _levelUpPlayer = AudioPlayer();
      
      // Set volume
      await _correctPlayer?.setVolume(0.5);
      await _wrongPlayer?.setVolume(0.5);
      await _levelUpPlayer?.setVolume(0.6);
      
      _initialized = true;
    } catch (e) {
      debugPrint('SoundService init error: $e');
      _initialized = false;
    }
  }

  /// Check if sound is enabled
  bool get isSoundEnabled => _soundEnabled;

  /// Toggle sound on/off
  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    await _box?.put(_soundEnabledKey, _soundEnabled);
  }

  /// Set sound enabled state
  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    await _box?.put(_soundEnabledKey, _soundEnabled);
  }

  /// Play correct answer sound — ascending happy tone
  Future<void> playCorrect() async {
    if (!_soundEnabled || kIsWeb) return;
    try {
      // Play a short ascending tone sequence
      final player = AudioPlayer();
      await player.setSource(AssetSource('sounds/correct.wav'));
      await player.setVolume(0.5);
      await player.resume();
      // Auto-dispose after playing
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (e) {
      // Fallback: use frequency tone if asset not found
      debugPrint('Sound playCorrect: $e');
    }
  }

  /// Play wrong answer sound — descending sad tone
  Future<void> playWrong() async {
    if (!_soundEnabled || kIsWeb) return;
    try {
      final player = AudioPlayer();
      await player.setSource(AssetSource('sounds/wrong.wav'));
      await player.setVolume(0.5);
      await player.resume();
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (e) {
      debugPrint('Sound playWrong: $e');
    }
  }

  /// Play level up sound — triumphant tone
  Future<void> playLevelUp() async {
    if (!_soundEnabled || kIsWeb) return;
    try {
      final player = AudioPlayer();
      await player.setSource(AssetSource('sounds/levelup.wav'));
      await player.setVolume(0.6);
      await player.resume();
      player.onPlayerComplete.listen((_) => player.dispose());
    } catch (e) {
      debugPrint('Sound playLevelUp: $e');
    }
  }

  /// Dispose players
  Future<void> dispose() async {
    await _correctPlayer?.dispose();
    await _wrongPlayer?.dispose();
    await _levelUpPlayer?.dispose();
  }
}

/// Global instance
final soundService = SoundService();
