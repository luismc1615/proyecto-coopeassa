import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/pages/admin/forms/places_info_form.dart';
import 'package:mobile_project/src/pages/admin/forms/users_info_form.dart';
import 'package:mobile_project/src/pages/forms/information_pets.dart';
import 'package:mobile_project/src/pages/forms/pet_curiosities.dart';
import 'package:mobile_project/src/pages/forms/pet_relationship.dart';
import 'package:mobile_project/src/pages/forms/pet_walk.dart';
import 'package:mobile_project/src/pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';

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
        '/': (context) => LoginScreen(),
        '/PlacesInfoForm': (context) => const PlacesInfoForm(),
        '/UsersInfoForm': (context) => const UsersInfoForm(),
        ////////////////////////////////////////////////////////
        '/informationPets': (context) => const InformationPets(),
        '/walkPets': (context) => const PetsTravel(),
        '/PetCuriosities': (context) => const PetCuriosities(),
        '/relationshipsPetForm': (context) => const RelationshipsPetForm(),
      },
    );
  }
}
