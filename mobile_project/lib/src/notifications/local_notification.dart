import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppLocalNotificacions {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // ignore: prefer_typing_uninitialized_variables
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;
  var iOSPlatformChannelSpecifics;
  var platformChannelSpecifics;

  void initialize() {
    initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    initializationSettingsIOS = const IOSInitializationSettings();
    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
  }

  Future<dynamic> onSelectNotification(String? payload) async {
    /* showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("Your Notification Detail"),
          content: Text("Payload : $payload"),
        );
      },
    ); */
    //print(payload);
  }

  void notify(String title, String description) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      description,
      platformChannelSpecifics,
      payload: 'This is notification detail Text...',
    );
  }
}
