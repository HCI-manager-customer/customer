import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hci_customer/constant/constant.dart';

class NotificationController extends GetxController {
  static final NotificationController _notificationController =
      NotificationController._internal();

  static NotificationController instance = Get.find();

  factory NotificationController() {
    return _notificationController;
  }

  Rx<String> pushToken = ''.obs;

  Future<String?> generatePushToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  @override
  void onInit() {
    super.onInit();
    initNotification();
  }

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationController._internal();

  Future initNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');
      notifiController.showNotification(
          10, message.data.toString(), 'message.data.toString()', 'main');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future showNotification(
    int id,
    String title,
    String body,
    String channel,
  ) async {
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel,
          channel,
          importance: Importance.max,
          priority: Priority.max,
          autoCancel: true,
        ),
      ),
    );
  }
}
