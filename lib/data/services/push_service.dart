import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'api.dart';

// Global navigator key — wired into MaterialApp (main.dart) so notification
// taps can navigate without a BuildContext.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// Must be a top-level function (runs in its own isolate when the app is
// backgrounded/terminated). FCM shows the system-tray notification itself for
// notification-type messages, so nothing to do here.
@pragma('vm:entry-point')
Future<void> gkmFirebaseBackgroundHandler(RemoteMessage message) async {}

// ─── Push Service ────────────────────────────────────────────────────────────
// FCM + local notifications. init() is fully guarded: if Firebase isn't
// configured yet (no google-services.json), the app runs normally without push.
class PushService {
  static final PushService instance = PushService._();
  PushService._();

  final _local = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _channel = AndroidNotificationChannel(
    'gkm_customer',
    'Booking Updates',
    description: 'Booking status and service updates',
    importance: Importance.max,
  );

  Future<void> init() async {
    try {
      await Firebase.initializeApp();

      FirebaseMessaging.onBackgroundMessage(gkmFirebaseBackgroundHandler);

      // Permissions (iOS dialog + Android 13 POST_NOTIFICATIONS).
      await FirebaseMessaging.instance.requestPermission();
      try {
        if (Platform.isAndroid) await Permission.notification.request();
      } catch (_) {}

      // Local notifications (used to display foreground pushes).
      await _local.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: (resp) {
          if (resp.payload == null || resp.payload!.isEmpty) return;
          try { _handleTap(asMap(jsonDecode(resp.payload!))); } catch (_) {}
        },
      );
      await _local
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);

      // Foreground pushes → show a local notification.
      FirebaseMessaging.onMessage.listen(_showForeground);

      // Token refresh → sync to backend (only useful when logged in).
      FirebaseMessaging.instance.onTokenRefresh.listen((t) async {
        try {
          final authed = await Api().token();
          if (authed != null && authed.isNotEmpty) await Api().updateFcmToken(t);
        } catch (_) {}
      });

      // Taps: app in background → opened via notification.
      FirebaseMessaging.onMessageOpenedApp.listen((m) => _handleTap(m.data));

      // Taps: app terminated → launched via notification. Delay so the splash
      // (_Root) has settled and MaterialApp's navigator is mounted.
      final initial = await FirebaseMessaging.instance.getInitialMessage();
      if (initial != null) {
        Future.delayed(const Duration(milliseconds: 1800), () => _handleTap(initial.data));
      }

      _ready = true;
    } catch (e) {
      // Firebase not configured (missing google-services.json) or unsupported
      // platform — degrade gracefully, app works without push.
      print('>>> [Push] init skipped: $e');
    }
  }

  // Current FCM token, or null when Firebase isn't configured / not permitted.
  Future<String?> getToken() async {
    if (!_ready) return null;
    try { return await FirebaseMessaging.instance.getToken(); } catch (_) { return null; }
  }

  // Called on launch when a session already exists — keep backend token fresh.
  Future<void> syncTokenIfLoggedIn() async {
    try {
      final authed = await Api().token();
      if (authed == null || authed.isEmpty) return;
      final t = await getToken();
      if (t != null && t.isNotEmpty) await Api().updateFcmToken(t);
    } catch (_) {}
  }

  void _showForeground(RemoteMessage m) {
    try {
      final title = m.notification?.title ?? asStr(m.data['title'], 'Ghar Ka Mali');
      final body  = m.notification?.body  ?? asStr(m.data['body']);
      _local.show(
        m.hashCode,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: jsonEncode(m.data),
      );
    } catch (_) {}
  }

  // Route by payload type. Booking numbers (GKM-…) aren't numeric ids, so
  // booking events open the bookings list; complaints open the complaints list.
  Future<void> _handleTap(Map<String, dynamic> data) async {
    try {
      final authed = await Api().token();
      if (authed == null || authed.isEmpty) return; // not logged in
      final nav = rootNavigatorKey.currentState;
      if (nav == null) return;
      switch (asStr(data['type'])) {
        case 'booking_assigned':
        case 'en_route':
        case 'arrived':
        case 'completed':
          nav.pushNamed('/bookings');
          break;
        case 'complaint_resolved':
          nav.pushNamed('/complaints');
          break;
        default:
          nav.pushNamed('/notifications');
      }
    } catch (_) {}
  }
}
