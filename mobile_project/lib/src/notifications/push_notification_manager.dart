import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
var token;
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    //final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    //final dynamic notification = message['notification'];
  }
  // Or do other work.
}

class PushNotificationsManager {
  PushNotificationsManager._();
  factory PushNotificationsManager() => _instance;
  static final PushNotificationsManager _instance =
      PushNotificationsManager._();
  FirebaseMessaging? _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future _showNotification(String? title, String? description) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      description,
      platformChannelSpecifics,
      payload: 'This is notification detail Text...',
    );
  }

  Future onSelectNotification(String? payload) async {
    /* showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("Your Notification Detail"),
          content: Text("Payload : $payload"),
        );
      },
    ); */
  }

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging!.requestPermission();
      _firebaseMessaging!.subscribeToTopic('promos');

      // For testing purposes print the Firebase Messaging token
      String? token = await _firebaseMessaging!.getToken();
      print(token);
      SharedPreferences _prefsToken = await SharedPreferences.getInstance();
      _prefsToken.setString('token', token!);
      //await _prefsToken.saveUserToken(token);

      _initialized = true;

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;

        if (message.notification != null) {
          _showNotification(
            notification!.title,
            notification.body,
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

      //Inicializar notificaciones locales
      var initializationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = const IOSInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);
    }
  }

  void dispose() {
    _initialized = false;
    _firebaseMessaging = null;
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    //print("Handling a background message: ${message.messageId}");
  }

  void initialize() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> sendNotification(title, message) async {
    FirebaseMessaging.instance
        .getToken()
        .then((value) => {token = value, print(token)});

    String url = "https://fcm.googleapis.com/fcm/send";
    // SharedPreferences _prefsToken = await SharedPreferences.getInstance();
    // var token = _prefsToken.getString('token');

    final msg = jsonEncode({
      'to': token,
      'notification': {'title': title, 'subtitle': message}
    });

    await http
        .post(
          Uri.parse(url),
          headers: <String, String>{
            'Authorization':
                "key=AAAA8GhxavY:APA91bF1ArcSpjOIzYfXJilQXEJBs5_Sa8HAWsTtXvnAhS3FDddEElkQ8CS6-g2Ijo7coz0tDayEEvFEcOKO9-S2oCJHMqTGvqqmmGeNce1wYaPehb6cQL-Vh9hz8w4J-eX0WQORXWhH",
            'Content-Type': 'application/json'
          },
          body: msg,
        )
        .then((value) => print('Valor: ${value}'))
        .catchError((onError) {
      print('error: ${onError}');
    });
  }

  static Future<void> sendNotification2(title, message) async {
    await FirebaseMessaging.instance
        .getToken()
        .then((value) => {token = value, print(token)});

    String url = "https://fcm.googleapis.com/fcm/send";
    // SharedPreferences _prefsToken = await SharedPreferences.getInstance();
    // var token = _prefsToken.getString('token');

    final msg = jsonEncode({
      'to': token,
      'notification': {'title': title, 'body': message}
    });

    try {
      await http
          .post(
            Uri.parse(url),
            headers: <String, String>{
              'Authorization':
                  "key=AAAA8GhxavY:APA91bF1ArcSpjOIzYfXJilQXEJBs5_Sa8HAWsTtXvnAhS3FDddEElkQ8CS6-g2Ijo7coz0tDayEEvFEcOKO9-S2oCJHMqTGvqqmmGeNce1wYaPehb6cQL-Vh9hz8w4J-eX0WQORXWhH",
              'Content-Type': 'application/json'
            },
            body: msg,
          )
          .then((value) => inspect(value))
          .catchError((onError) {
        inspect(onError);
      });
      print("FCM request for device sent!");
    } catch (e) {
      print(e);
    }
  }

  // Future<Response> sendNotification(List<String> tokenIdList, String contents, String heading) async{

  //   return await post(
  //     Uri.parse('https://onesignal.com/api/v1/notifications'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, dynamic>
  //     {
  //       "app_id": kAppId,//kAppId is the App Id that one get from the OneSignal When the application is registered.

  //       "include_player_ids": tokenIdList,//tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

  //         // android_accent_color reprsent the color of the heading text in the notifiction
  //       "android_accent_color":"FF9976D2",

  //       "small_icon":"ic_stat_onesignal_default",

  //       "large_icon":"https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

  //       "headings": {"en": heading},

  //       "contents": {"en": contents},

  //     }),
  //   );
  // }

}
