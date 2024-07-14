// import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import '../utils/app_text.dart';
import '../utils/helper_functions.dart';

// FirebaseMessaging messaging = FirebaseMessaging.instance;

//From Flutter Local Notification
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print('notification action tapped with input: ${notificationResponse.input}');
  }
}

FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description,
  importance: Importance.max,
);

class NotificationService {
  AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );
  DarwinInitializationSettings? iosSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestSoundPermission: true,
    requestBadgePermission: true,
    defaultPresentBadge: true,
    requestCriticalPermission: true,
  );

  static Future<void> requestNotiPermission() async {
    if (Platform.isIOS) {
      await notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation = notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
      if (Platform.isAndroid) {
        await notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
      }

      if (Platform.isIOS) {
        await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );
      }
      // if (kDebugMode) {
      //   log("Notification is granted: $granted");
      // }
    }
  }

  static Future<void> initializeNotification() async {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestSoundPermission: true,
        requestBadgePermission: true,
        defaultPresentBadge: true,
        defaultPresentSound: true,
        requestCriticalPermission: true,
      ),
    );
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          // log("Notification Payload: $payload");
          // log('initialize method handle Method called');
          List<String> strParts = payload.toString().split("//");
          await handelRouting(category: strParts[0], navigationSlug: strParts[1]);
        }
        //Here go to new route with notification.
      },
    );
    // if (kDebugMode) {
    //   log("Notifications : $initialized");
    // }
  }

  static Future<void> handelRouting({required String category, required String navigationSlug}) async {
    if (category == AllText.videoScreen) {
      // await Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(
      //     builder: (_) => VideoDetailsScreen(
      //           videoSlug: navigationSlug,
      //         )));
      category = '';
      navigationSlug = '';
    } else {
      // await Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(
      //     builder: (_) => NewsDetailsScreen(
      //           newsUrl: navigationSlug,
      //         )));
      category = '';
      navigationSlug = '';
    }
  }

  static void createAndDisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
      await notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: "${message.data['category']}//${message.data['post_url']}",
      );
    } on Exception catch (e) {
      debugPrint('$e');
    }
  }

  static void notificationHandel() {
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        // log("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          // if (kDebugMode) {
          //   log("Notification data: $message");
          //   log("Notification data: ${message.data}");
          // }
          // log('1st Method called');
          handelRouting(category: message.data['category'].toString(), navigationSlug: message.data['post_url'].toString());
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        // if (kDebugMode) {
        //   log("FirebaseMessaging.onMessage.listen");
        // }
        if (message.notification != null) {
          // if (kDebugMode) {
          //   log('Notification Data :${message.data}');
          // }

          // log('Actual Slug $navigationSlug');
          // log('Category $category');
          // log( 'Notification Body: ${message.notification!.body}');
          NotificationService.createAndDisplaynotification(message);

          // Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(builder: (_)=>NewsDetailsScreen(newsUrl:message.data['post_url'] ,)));
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        // if (kDebugMode) {
        //   log("FirebaseMessaging.onMessageOpenedApp.listen");
        //   log("$message");
        // }
        if (message.notification != null) {
          handelRouting(category: message.data['category'].toString(), navigationSlug: message.data['post_url'].toString());
        }
      },
    );
  }
}
