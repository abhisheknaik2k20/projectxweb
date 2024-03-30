import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:projectxweb/main.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(message);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message!.notification != null) {
      print('Some Notification Recived');
    }
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('token :$fCMToken');
    localNotiInit();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a Message in Foreground');
      if (message.notification != null) {
        if (message.data.containsKey('custom_key')) {
          CallKitParams params = const CallKitParams(
              id: '123',
              nameCaller: 'String',
              handle: '122345',
              type: 1,
              extra: {'userID': '123456'});
          await FlutterCallkitIncoming.startCall(params);
        } else {
          showSimpleNotification(
              title: message.notification!.title!,
              body: message.notification!.body!,
              payload: 'payload');
        }
      }
    });
  }

  static Future localNotiInit() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!
        .pushNamed('/home', arguments: notificationResponse);
  }

  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
