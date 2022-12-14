import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/pages/admin/forms/password_change_form.dart';
import 'package:mobile_project/src/pages/admin/forms/places_info_form.dart';
import 'package:mobile_project/src/pages/admin/forms/reservations_info_form.dart';
import 'package:mobile_project/src/pages/admin/forms/profiles_info_form.dart';
import 'package:mobile_project/src/pages/admin/forms/users_info_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_project/src/pages/menu/client_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ConectionMongodb.connect();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      builder: FlutterSmartDialog.init(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MenuScreen(0),
        '/PlacesInfoForm': (context) => const PlacesInfoForm(),
        '/ProfilesInfoForm': (context) => const ProfilesInfoForm(),
        '/ReservationsInfoForm': (context) => const ReservationsInfoForm(),
        '/UsersInfoForm': (context) => const UsersInfoForm(),
        '/PasswordChangeForm': (context) => const PasswordChangeForm(),
      },
    );
  }
}
