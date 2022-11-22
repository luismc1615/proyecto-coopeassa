import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/src/pages/client/contact_form.dart';
import 'package:mobile_project/src/pages/client/places_info.dart';
import 'package:mobile_project/src/pages/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  static const String ROUTE = "/";
  var numPage;
  MenuScreen(this.numPage);
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _actualPage = 0;
  final List<Widget> _pages = [
    PlacesInfo(),
    const ContactForm(),
    LoginScreen(),
  ];

  final items = <Widget>[
    const Icon(
      Icons.landscape,
      color: Colors.white,
      semanticLabel: "Sitios",
    ),
    const Icon(
      Icons.contact_mail,
      color: Colors.white,
      semanticLabel: "Contáctenos",
    ),
    const Icon(
      Icons.account_circle,
      color: Colors.white,
      semanticLabel: "Inicio Administradores",
    ),
  ];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    _actualPage = widget.numPage;
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    print(_prefs.getString('id'));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          exit(0);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: (_pages[_actualPage]),
          bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.white,
            color: const Color.fromRGBO(25, 150, 125, 1),
            animationDuration: const Duration(milliseconds: 300),
            items: items,
            index: _actualPage,
            onTap: (index) {
              setState(() {
                _actualPage = index;
              });
            },
          ),
        ));
  }
}
