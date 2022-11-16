import 'package:flutter/material.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/usersDTO.dart';
import 'package:mobile_project/src/pages/menu/client_menu.dart';

class UsersInfo extends StatefulWidget {
  // ignore: constant_identifier_names
  @override
  _UsersInfoState createState() => _UsersInfoState();
}

class _UsersInfoState extends State<UsersInfo> {
  late List<UsersDTO> itemsProfiles = <UsersDTO>[];

  @override
  void initState() {
    // ignore: todo
    _onLoading();
    super.initState();
  }

  static loadPreferences() async {
    var users = await ConectionMongodb.getUsers();
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen(2)));
          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Información de usuarios"),
              backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 17, 77, 27),
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen(2)));
              },
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    itemsProfiles == []
                        ? const Center()
                        : ListView.builder(
                            physics:
                                const NeverScrollableScrollPhysics(), //Evitará a que trate de Scrolear
                            scrollDirection: Axis.vertical,
                            itemBuilder: ((c, i) => Card(
                                color: const Color.fromARGB(255, 83, 161, 146),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                margin: const EdgeInsets.all(15),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(itemsProfiles[i].username!,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 2
                                                ..color = const Color.fromARGB(
                                                    255, 0, 0, 0),
                                            )),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "📩  " + itemsProfiles[i].email!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "📞" + itemsProfiles[i].phone!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "📍 " + itemsProfiles[i].name!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(height: 5),
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, "/UsersInfoForm",
                                                      arguments: {
                                                        'userId': itemsProfiles[i]
                                                            .userId,
                                                        'name':
                                                            itemsProfiles[i].name!,
                                                        'email':
                                                            itemsProfiles[i]
                                                                .email!,
                                                        'phone': itemsProfiles[i]
                                                            .phone!,
                                                        'username': itemsProfiles[i]
                                                            .username!,
                                                        'password': itemsProfiles[i]
                                                            .password!,
                                                      });
                                                },
                                                child: const Icon(
                                                    Icons.border_color,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color.fromARGB(
                                                      255, 27, 94, 238),
                                                  shape: const CircleBorder(),
                                                )),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                            ),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  await ConectionMongodb
                                                      .changeCollection(
                                                          'tbl_user');
                                                  await ConectionMongodb.delete(
                                                      itemsProfiles[i].userId);
                                                  _onLoading();
                                                },
                                                child: const Icon(Icons.delete,
                                                    color: Colors.white),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  shape: const CircleBorder(),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ))),
                            shrinkWrap: true,
                            itemCount: itemsProfiles.length,
                          ),
                  ],
                ),
              ),
            )));
  }

  void _onLoading() async {
    itemsProfiles = [];
    List<Map<String, dynamic>> myUsers = await loadPreferences();
    myUsers.forEach((element) {
      itemsProfiles.add(UsersDTO(
          element['_id'],
          element['name'],
          element['email'],
          element['phone'],
          element['username'],
          element['password']));
    });
    if (mounted) setState(() {});
  }
}
