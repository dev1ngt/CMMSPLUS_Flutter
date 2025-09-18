



import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../helpers/utils/app_shared_preference.dart';


Future<void> handleBackgroundMessage(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}


class FirebaseApi {


  Future<String> getAccessToken() async {
    return await AppSharedPrefs.getAccessToken();
  }

  final _firebaseMessaging  = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notification',
       description: 'This channel is used for importance notification',
       importance: Importance.defaultImportance);

  final _localNotification = FlutterLocalNotificationsPlugin();



  void handleMessage(RemoteMessage? message) {
    if(message == null) return;
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Payload: ${message.data}');
  }

  Future initLocalNotifcation() async {
    const iOS_ = DarwinInitializationSettings();
    const android_ = AndroidInitializationSettings('@drawable/ic_notification');
    const settings  =InitializationSettings(android: android_ ,iOS: iOS_);

    await _localNotification.initialize(
      settings,
      // onSelectNotification:(payload){
      //   final message =RemoteMessage.fromMap(jsonDecode(payload as String));
      //   handleMessage(message);
      // }
    );
     final platform = _localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
     await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      print('Got a message whilst in the foreground!');
      if (message.notification != null) {
        print('Notification Title: ${message.notification?.title}');
        print('Notification Body: ${message.notification?.body}');
      }
       final notification = message.notification;

       _localNotification.show(
           notification.hashCode,
           notification?.title,
           notification?.body,
           NotificationDetails(
             android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_notification',
             ),
           ),
         payload: jsonEncode(message.toMap()),
       );
    });
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    String token = await getAccessToken();
    if(token.isEmpty){
      final FCMToken = await _firebaseMessaging.getToken();
      await AppSharedPrefs.get().setAccessToken(FCMToken!);
      print('token:  $FCMToken');
    }
    initLocalNotifcation();
    initPushNotification();

 }




}