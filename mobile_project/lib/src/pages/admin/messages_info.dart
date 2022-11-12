import 'package:flutter/material.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/messagesDTO.dart';
import 'package:mobile_project/src/pages/menu/client_menu.dart';

class Messages extends StatefulWidget {
  // ignore: constant_identifier_names
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  late List<MessagesDTO> itemMessages = <MessagesDTO>[];

  @override
  void initState() {
    // ignore: todo
    _onLoading();
    super.initState();
  }

  static loadPreferences() async {
    var users = await ConectionMongodb.getMessages();
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
          title: const Text("Mensajes recibidos"),
          backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                itemMessages == []
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
                                    child: Text(itemMessages[i].name!,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 2
                                            ..color =
                                                const Color.fromARGB(255, 0, 0, 0),
                                        )),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Nacionalidad: " +
                                            itemMessages[i].nacionality!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Teléfono: " + itemMessages[i].phone!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Correo: " + itemMessages[i].email!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Dirección: " + itemMessages[i].address!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Descripción: " + itemMessages[i].description!,
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
                                                    'userId': '',
                                                    'name': itemMessages[i].name!,
                                                    'nacionality': itemMessages[i]
                                                        .nacionality!,
                                                    'phone':
                                                        itemMessages[i].phone!,
                                                    'email':
                                                        itemMessages[i].email!,
                                                    'address':
                                                        itemMessages[i].address!,
                                                  });
                                            },
                                            child: const Icon(
                                                Icons.account_circle,
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
                                                      'tbl_messages');
                                              await ConectionMongodb.delete(
                                                  itemMessages[i].messageId);
                                              _onLoading();
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
                        itemCount: itemMessages.length,
                      ),
              ],
            ),
          ),
        )));
  }

  void _onLoading() async {
    itemMessages = [];
    List<Map<String, dynamic>> myUsers = await loadPreferences();
    myUsers.forEach((element) {
      itemMessages.add(MessagesDTO(
          element['_id'],
          element['name'],
          element['nacionality'],
          element['phone'],
          element['email'],
          element['address'],
          element['description']));
    });
    if (mounted) setState(() {});
  }
}
