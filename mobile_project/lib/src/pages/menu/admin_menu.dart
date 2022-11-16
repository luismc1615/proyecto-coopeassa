import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/src/pages/admin/places_info.dart';
import 'package:mobile_project/src/pages/admin/profiles_info.dart';
import 'package:mobile_project/src/pages/admin/reservations_info.dart';
import 'package:mobile_project/src/pages/admin/messages_info.dart';
import 'package:mobile_project/src/pages/admin/users_info.dart';
import 'package:mobile_project/src/pages/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  static const String ROUTE = "/menu";
  var numPage;
  MenuScreen(this.numPage);
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _actualPage = 0;
  final List<Widget> _pages = [
    //InfoPets(),
    PlacesInfo(),
    ProfilesInfo(),
    ReservationsInfo(),
    Messages(),
    UsersInfo()
  ];

  final items = <Widget>[
    const Icon(
      Icons.landscape,
      color: Colors.white,
      semanticLabel: "Sitios",
    ),
    const Icon(
      Icons.account_circle,
      color: Colors.white,
      semanticLabel: "Perfiles",
    ),
    const Icon(
      Icons.assignment_rounded,
      color: Colors.white,
      semanticLabel: "Perfiles",
    ),
    const Icon(
      Icons.chat,
      color: Colors.white,
      semanticLabel: "Perfiles",
    ),
    const Icon(
      Icons.admin_panel_settings,
      color: Colors.white,
      semanticLabel: "About Us",
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
          return true;
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
