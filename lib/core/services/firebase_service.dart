import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

/// Central Firebase + push notifications service.
/// Call [FirebaseService.init] once at app startup.
class FirebaseService {
  FirebaseService._();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
      debugPrint('✅ Firebase initialised: snorkeltje-project');
    } catch (e) {
      debugPrint('⚠️ Firebase init failed: $e');
    }
  }

  static bool get isEnabled => _initialized;

  /// Request permission + get FCM token for this device.
  /// Returns null if user denied or not initialised.
  static Future<String?> requestPermissionAndGetToken() async {
    if (!_initialized) return null;
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        return null;
      }
      final token = await messaging.getToken();
      debugPrint('🔔 FCM token: $token');
      return token;
    } catch (e) {
      debugPrint('⚠️ FCM token failed: $e');
      return null;
    }
  }

  /// Listen for foreground push notifications.
  static void listenForegroundMessages(void Function(RemoteMessage) handler) {
    if (!_initialized) return;
    FirebaseMessaging.onMessage.listen(handler);
  }
}
