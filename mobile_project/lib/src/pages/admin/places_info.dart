import 'package:flutter/material.dart';
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
                      Navigator.pushNamed(context, "/PlacesInfoForm",
                          arguments: {
                            'placeId': '',
                            'address': '',
                            'descripction': '',
                            'name': '',
                            'profile_img': '',
                          });
                    },
                    child: const Text("Añadir nuevo sitio")),
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
                                          radius: 120,
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
                                            ..color =
                                                Color.fromARGB(255, 0, 0, 0),
                                        )),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Descripción: " +
                                            itemsPlaces[i].description!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Dirección: " + itemsPlaces[i].address!,
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
                                              primary: const Color.fromARGB(
                                                  255, 8, 68, 16),
                                              shape: const CircleBorder(),
                                            )),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, "/PlacesInfoForm",
                                                  arguments: {
                                                    'placeId':
                                                        itemsPlaces[i].placeId,
                                                    'address':
                                                        itemsPlaces[i].address!,
                                                    'description':
                                                        itemsPlaces[i]
                                                            .description!,
                                                    'name':
                                                        itemsPlaces[i].name!,
                                                    'profile_img':
                                                        itemsPlaces[i]
                                                            .profile_img!
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
                                                      'tbl_places');
                                              await ConectionMongodb.delete(
                                                  itemsPlaces[i].placeId);
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
      itemsPlaces.add(PlacesDTO(element['_id'], element['address'],
          element['description'], element['profile_img'], element['name']));
    });
    if (mounted) setState(() {});
  }
}
