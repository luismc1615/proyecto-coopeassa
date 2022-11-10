import 'package:flutter/material.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/usersDTO.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersInfo extends StatefulWidget {
  // ignore: constant_identifier_names
  @override
  _UsersInfoState createState() => _UsersInfoState();
}

class _UsersInfoState extends State<UsersInfo> {
  late List<UsersDTO> itemsUsers = <UsersDTO>[];

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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Información de sitios"),
          backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
                        minimumSize: const Size.fromHeight(40)),
                    onPressed: () {
                      Navigator.pushNamed(context, "/UsersInfoForm",
                          arguments: {
                            'userId': '',
                            'name': '',
                            'nacionality': '',
                            'phone': '',
                            'email': '',
                            'address': '',
                          });
                    },
                    child: const Text("Añadir nuevo usuario")),
                itemsUsers == []
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
                                  // itemsUsers[i].profile_img! != '' ?
                                  // CircleAvatar(
                                  //   radius: 120,
                                  //   backgroundImage: NetworkImage(
                                  //       itemsUsers[i].profile_img!),
                                  // ) : const Center(),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(itemsUsers[i].name!,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 2
                                            ..color =
                                                Color.fromARGB(255, 0, 0, 0),
                                        )),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Nacionalidad: " +
                                            itemsUsers[i].nacionality!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Teléfono: " + itemsUsers[i].phone!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Correo: " + itemsUsers[i].email!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Dirección: " + itemsUsers[i].address!,
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
                                                    'userId':
                                                        itemsUsers[i].userId,
                                                    'name': itemsUsers[i].name!,
                                                    'nacionality': itemsUsers[i]
                                                        .nacionality!,
                                                    'phone':
                                                        itemsUsers[i].phone!,
                                                    'email':
                                                        itemsUsers[i].email!,
                                                    'address':
                                                        itemsUsers[i].address!,
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
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              await ConectionMongodb
                                                  .changeCollection(
                                                      'tbl_users');
                                              await ConectionMongodb.delete(
                                                  itemsUsers[i].userId);
                                              _onLoading();
                                            },
                                            child: const Icon(Icons.cancel,
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
                        itemCount: itemsUsers.length,
                      ),
              ],
            ),
          ),
        ));
  }

  void _onLoading() async {
    itemsUsers = [];
    List<Map<String, dynamic>> myUsers = await loadPreferences();
    myUsers.forEach((element) {
      itemsUsers.add(UsersDTO(
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
