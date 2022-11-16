import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/profilesDTO.dart';
import 'package:mobile_project/src/pages/menu/client_menu.dart';

class ProfilesInfo extends StatefulWidget {
  // ignore: constant_identifier_names
  @override
  _ProfilesInfoState createState() => _ProfilesInfoState();
}

class _ProfilesInfoState extends State<ProfilesInfo> {
  late List<ProfilesDTO> itemsProfiles = <ProfilesDTO>[];

  @override
  void initState() {
    // ignore: todo
    _onLoading();
    super.initState();
  }

  static loadPreferences() async {
    var users = await ConectionMongodb.getProfiles();
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
              title: const Text("Información de perfiles"),
              backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 17, 77, 27),
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, "/ProfilesInfoForm", arguments: {
                  'userId': '',
                  'name': '',
                  'nacionality': '',
                  'phone': '',
                  'email': '',
                  'address': '',
                });
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
                                        child: Text(itemsProfiles[i].name!,
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
                                            itemsProfiles[i].nacionality!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "📞 " + itemsProfiles[i].phone!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "📩 " + itemsProfiles[i].email!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "📍 " + itemsProfiles[i].address!,
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
                                                  Navigator.pushNamed(context,
                                                      "/ProfilesInfoForm",
                                                      arguments: {
                                                        'userId':
                                                            itemsProfiles[i]
                                                                .userId,
                                                        'name': itemsProfiles[i]
                                                            .name!,
                                                        'nacionality':
                                                            itemsProfiles[i]
                                                                .nacionality!,
                                                        'phone':
                                                            itemsProfiles[i]
                                                                .phone!,
                                                        'email':
                                                            itemsProfiles[i]
                                                                .email!,
                                                        'address':
                                                            itemsProfiles[i]
                                                                .address!,
                                                      });
                                                },
                                                child: const Icon(
                                                    Icons.border_color,
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                                style: ElevatedButton.styleFrom(
                                                  primary: const Color.fromARGB(
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
                                                                  "¿Desea eliminar el perfil?",
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
                                                                            'tbl_profiles');
                                                                        await ConectionMongodb
                                                                            .delete(
                                                                          itemsProfiles[i]
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
                                                  primary: Colors.red,
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
      itemsProfiles.add(ProfilesDTO(
          element['_id'],
          element['name'],
          element['nacionality'],
          element['phone'],
          element['email'],
          element['address']));
    });
    if (mounted) setState(() {});
  }
}
