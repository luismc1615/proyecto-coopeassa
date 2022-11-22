import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/placesDTO.dart';
import 'package:mobile_project/src/pages/admin/forms/places_gallery_form.dart';
import 'package:mobile_project/src/pages/menu/client_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlacesInfo extends StatefulWidget {
  // ignore: constant_identifier_names
  @override
  _PlacesInfoState createState() => _PlacesInfoState();
}

class _PlacesInfoState extends State<PlacesInfo> {
  late List<PlacesDTO> itemsPlaces = <PlacesDTO>[];

  @override
  void initState() {
    // ignore: todo
    _onLoading();
    super.initState();
  }

  static loadPreferences() async {
    var places = await ConectionMongodb.getPlaces();
    return places;
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
              title: const Text("Información de sitios"),
              backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 17, 77, 27),
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, "/PlacesInfoForm", arguments: {
                  'placeId': '',
                  'address': '',
                  'descripction': '',
                  'name': '',
                  'profile_img': '',
                });
              },
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    itemsPlaces == []
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
                                      itemsPlaces[i].profile_img! != ''
                                          ? CircleAvatar(
                                              radius: 115,
                                              backgroundImage: NetworkImage(
                                                  itemsPlaces[i].profile_img!),
                                            )
                                          : const Center(),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(itemsPlaces[i].name!,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 2
                                                ..color = Color.fromARGB(
                                                    255, 0, 0, 0),
                                            )),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "📍 " + itemsPlaces[i].address!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "⛺ " + itemsPlaces[i].activities!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(itemsPlaces[i].description!,
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
                                                onPressed: () async {
                                                  SharedPreferences _placeId =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  _placeId.setString(
                                                      'placeId',
                                                      itemsPlaces[i]
                                                          .placeId
                                                          .toString());
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PlacesGalleryForm(
                                                                  itemsPlaces[i]
                                                                      .name)));
                                                },
                                                child: const Icon(Icons.image,
                                                    color: Colors.white),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 8, 68, 16),
                                                  shape: const CircleBorder(),
                                                )),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(context,
                                                      "/PlacesInfoForm",
                                                      arguments: {
                                                        'placeId':
                                                            itemsPlaces[i]
                                                                .placeId,
                                                        'address':
                                                            itemsPlaces[i]
                                                                .address!,
                                                        'description':
                                                            itemsPlaces[i]
                                                                .description!,
                                                        'name': itemsPlaces[i]
                                                            .name!,
                                                        'profile_img':
                                                            itemsPlaces[i]
                                                                .profile_img!,
                                                        'activities':
                                                            itemsPlaces[i]
                                                                .activities!
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
                                                                  "¿Desea eliminar el sitio?",
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
                                                                            'tbl_places');
                                                                        await ConectionMongodb
                                                                            .delete(
                                                                          itemsPlaces[i]
                                                                              .placeId,
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
                            itemCount: itemsPlaces.length,
                          ),
                  ],
                ),
              ),
            )));
  }

  void _onLoading() async {
    itemsPlaces = [];
    List<Map<String, dynamic>> myPlaces = await loadPreferences();
    myPlaces.forEach((element) {
      itemsPlaces.add(PlacesDTO(
          element['_id'],
          element['address'],
          element['description'],
          element['name'],
          element['profile_img'],
          element['activities']));
    });
    if (mounted) setState(() {});
  }
}
