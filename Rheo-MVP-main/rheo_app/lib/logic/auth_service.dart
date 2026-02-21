import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Auth Service - Google Sign-In + Firebase Auth
/// Misafir modu varsayılan, login tamamen opsiyonel
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ==================== GETTERS ====================

  /// Mevcut kullanıcı (null ise misafir modu)
  User? get currentUser => _auth.currentUser;

  /// Login olmuş mu?
  bool get isLoggedIn => _auth.currentUser != null;

  /// Kullanıcı adı
  String get displayName =>
      _auth.currentUser?.displayName ?? 'Misafir';

  /// Kullanıcı e-posta
  String get email => _auth.currentUser?.email ?? '';

  /// Kullanıcı fotoğrafı
  String? get photoUrl => _auth.currentUser?.photoURL;

  /// Kullanıcı UID
  String? get uid => _auth.currentUser?.uid;

  /// Auth state değişikliklerini dinle
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ==================== AUTH METHODS ====================

  /// Google ile giriş yap
  Future<User?> signInWithGoogle() async {
    try {
      // Google Sign-In akışı başlat
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Kullanıcı iptal etti
        debugPrint('AuthService: Google Sign-In iptal edildi');
        return null;
      }

      // Google Auth token'ları al
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase credential oluştur
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase ile giriş yap
      final userCredential = await _auth.signInWithCredential(credential);
      debugPrint('✅ AuthService: Giriş başarılı - ${userCredential.user?.displayName}');

      return userCredential.user;
    } catch (e) {
      debugPrint('⚠️ AuthService: Google Sign-In hatası: $e');
      return null;
    }
  }

  /// Çıkış yap (Misafir moduna dön)
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      debugPrint('✅ AuthService: Çıkış yapıldı');
    } catch (e) {
      debugPrint('⚠️ AuthService: Çıkış hatası: $e');
    }
  }
}

/// Global instance
final authService = AuthService();
