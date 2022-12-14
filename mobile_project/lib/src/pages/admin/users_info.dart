import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/usersDTO.dart';
import 'package:mobile_project/src/pages/menu/client_menu.dart';

class UsersInfo extends StatefulWidget {
  // ignore: constant_identifier_names
  @override
  _UsersInfoState createState() => _UsersInfoState();
}

class _UsersInfoState extends State<UsersInfo> {
  late List<UsersDTO> itemUsers = <UsersDTO>[];

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
                Navigator.pushNamed(context, "/UsersInfoForm", arguments: {
                  'userId': '',
                  'name': '',
                  'email': '',
                  'phone': '',
                  'username': '',
                  'password': '',
                });
              },
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    itemUsers == []
                        ? const Center()
                        : ListView.builder(
                            physics:
                                const NeverScrollableScrollPhysics(), //Evitará a que trate de Scrolear
                            scrollDirection: Axis.vertical,
                            itemBuilder: ((c, i) => Card(
                                color: const Color.fromARGB(255, 236, 236, 236),
                                shape: BeveledRectangleBorder(
                                  side: const BorderSide(
                                      color: Color.fromARGB(255, 56, 56, 56),
                                    ),
                                    borderRadius: BorderRadius.circular(30)),
                                margin: const EdgeInsets.all(15),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(itemUsers[i].username!,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "📩  " + itemUsers[i].email!,
                                            style: const TextStyle(
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text("📞" + itemUsers[i].phone!,
                                            style: const TextStyle(
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text("📍 " + itemUsers[i].name!,
                                            style: const TextStyle(
                                                color: Color.fromARGB(255, 0, 0, 0),
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
                                                onPressed: () async {
                                                  Navigator.pushNamed(
                                                      context, "/PasswordChangeForm",
                                                      arguments: {
                                                        'userId':
                                                            itemUsers[i].userId,
                                                        'name':
                                                            itemUsers[i].name!,
                                                        'email':
                                                            itemUsers[i].email!,
                                                        'phone':
                                                            itemUsers[i].phone!,
                                                        'username': itemUsers[i]
                                                            .username!,
                                                        'password': itemUsers[i]
                                                            .password!,
                                                      });
                                                },
                                                child: const Icon(Icons.lock,
                                                    color: Colors.white),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 8, 68, 16),
                                                  shape: const CircleBorder(),
                                                )),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, "/UsersInfoForm",
                                                      arguments: {
                                                        'userId':
                                                            itemUsers[i].userId,
                                                        'name':
                                                            itemUsers[i].name!,
                                                        'email':
                                                            itemUsers[i].email!,
                                                        'phone':
                                                            itemUsers[i].phone!,
                                                        'username': itemUsers[i]
                                                            .username!,
                                                        'password': itemUsers[i]
                                                            .password!,
                                                      });
                                                },
                                                child: const Icon(
                                                    Icons.border_color,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 27, 94, 238),
                                                  shape: const CircleBorder(),
                                                )),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                            ),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  SmartDialog.show(
                                                      builder: (context) {
                                                    return Container(
                                                      height: 120,
                                                      width: 300,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(20),
                                                              child: const Text(
                                                                  "¿Desea eliminar el usuario?",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  ElevatedButton(
                                                                      style: TextButton.styleFrom(
                                                                          backgroundColor: const Color.fromRGBO(
                                                                              25,
                                                                              150,
                                                                              125,
                                                                              1)),
                                                                      onPressed:
                                                                          () async {
                                                                        await ConectionMongodb.changeCollection(
                                                                            'user');
                                                                        await ConectionMongodb
                                                                            .delete(
                                                                          itemUsers[i]
                                                                              .userId,
                                                                        );
                                                                        _onLoading();
                                                                        SmartDialog
                                                                            .dismiss();
                                                                      },
                                                                      child: const Text(
                                                                          "Sí")),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  ElevatedButton(
                                                                      style: TextButton.styleFrom(
                                                                          backgroundColor: const Color.fromARGB(
                                                                              255,
                                                                              252,
                                                                              1,
                                                                              1)),
                                                                      onPressed:
                                                                          () {
                                                                        SmartDialog
                                                                            .dismiss();
                                                                      },
                                                                      child: const Text(
                                                                          "No")),
                                                                ],
                                                              ),
                                                            ),
                                                          ]),
                                                    );
                                                  });
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
                            itemCount: itemUsers.length,
                          ),
                  ],
                ),
              ),
            )));
  }

  void _onLoading() async {
    itemUsers = [];
    List<Map<String, dynamic>> myUsers = await loadPreferences();
    myUsers.forEach((element) {
      itemUsers.add(UsersDTO(element['_id'], element['name'], element['email'],
          element['phone'], element['username'], element['password']));
    });
    if (mounted) setState(() {});
  }
}
