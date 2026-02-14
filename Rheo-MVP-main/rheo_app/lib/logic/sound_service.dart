import 'package:hive_flutter/hive_flutter.dart';

/// Service for managing sound effects
/// Note: Sound files need to be added to assets/sounds/ folder
class SoundService {
  static const String _settingsBox = 'rheo_settings';
  static const String _soundEnabledKey = 'sound_enabled';
  
  Box? _box;
  bool _soundEnabled = true;
  bool _initialized = false;

  /// Initialize sound service
  Future<void> init() async {
    if (_initialized) return;
    
    try {
      _box = await Hive.openBox(_settingsBox);
      _soundEnabled = _box?.get(_soundEnabledKey, defaultValue: true) ?? true;
      _initialized = true;
    } catch (e) {
      // Silently fail if Hive is not ready
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

  /// Play correct answer sound
  /// TODO: Add actual sound when APK is built
  Future<void> playCorrect() async {
    if (!_soundEnabled) return;
    // Sound will be implemented when building for mobile
    // For web, this is a no-op
  }

  /// Play wrong answer sound
  Future<void> playWrong() async {
    if (!_soundEnabled) return;
    // Sound will be implemented when building for mobile
  }

  /// Play level up sound
  Future<void> playLevelUp() async {
    if (!_soundEnabled) return;
    // Sound will be implemented when building for mobile
  }
}

/// Global instance
final soundService = SoundService();
