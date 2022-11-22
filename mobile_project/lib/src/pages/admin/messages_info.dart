import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
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
                                color: const Color.fromARGB(255, 243, 241, 241),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3)),
                                margin: const EdgeInsets.all(15),
                                child: ClipRRect(
                                  child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                          color:  Color.fromARGB(255, 83, 161, 146), width: 3),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(itemMessages[i].name!,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(255, 0, 0, 0)
                                            )),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            itemMessages[i].nacionality!,
                                            style: const TextStyle(
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "📞 " + itemMessages[i].phone!,
                                            style: const TextStyle(
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "📩 " + itemMessages[i].email!,
                                            style: const TextStyle(
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "📍 " + itemMessages[i].address!,
                                            style: const TextStyle(
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const Divider(
                                        height: 20,
                                        thickness: 1,
                                        indent: 5,
                                        endIndent: 5,
                                        color: Colors.black,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            itemMessages[i].description!,
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
                                                onPressed: () {
                                                  Navigator.pushNamed(context,
                                                      "/ProfilesInfoForm",
                                                      arguments: {
                                                        'userId': '',
                                                        'name': itemMessages[i]
                                                            .name!,
                                                        'nacionality':
                                                            itemMessages[i]
                                                                .nacionality!,
                                                        'phone': itemMessages[i]
                                                            .phone!,
                                                        'email': itemMessages[i]
                                                            .email!,
                                                        'address':
                                                            itemMessages[i]
                                                                .address!,
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
                                                                  "¿Desea eliminar el mensaje?",
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
                                                                            'tbl_messages');
                                                                        await ConectionMongodb
                                                                            .delete(
                                                                          itemMessages[i]
                                                                              .messageId,
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
                                )))),
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
