import 'package:flutter/material.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/placesDTO.dart';
import 'package:mobile_project/src/pages/client/gallery_place.dart';
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
                                        "📍 " + itemsPlaces[i].address!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "⛺ " +
                                            itemsPlaces[i].activities!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "" +
                                            itemsPlaces[i].description!,
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
                                          style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 8, 68, 16)),
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
                                                        GalleryPlace(
                                                            itemsPlaces[i]
                                                                .name)));
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Text('Ver imágenes'),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.image,
                                                size: 24.0,
                                              ),
                                            ],
                                          ),
                                        ),
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
        ));
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
