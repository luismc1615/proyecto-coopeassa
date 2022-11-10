import 'package:flutter/material.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/placesDTO.dart';
import 'package:mobile_project/src/pages/admin/forms/places_gallery_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlacesGallery extends StatefulWidget {
  @override
  _PlacesGalleryState createState() => _PlacesGalleryState();
}

class _PlacesGalleryState extends State<PlacesGallery> {
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
          title: const Text("Galerías"),
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
                                  itemsPlaces[i].profile_img! != '' ?
                                  CircleAvatar(
                                    radius: 120,
                                    backgroundImage: NetworkImage(
                                        itemsPlaces[i].profile_img!),
                                  ) : const Center(),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(itemsPlaces[i].name!,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 2
                                            ..color = Color.fromARGB(255, 0, 0, 0),
                                        )),
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
                                        backgroundColor: const Color.fromARGB(
                                            255, 3, 72, 201)),
                                    onPressed: () async {
                                      SharedPreferences _placeId =
                                          await SharedPreferences.getInstance();
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
                                                      itemsPlaces[i].name)));
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
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
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
          element['profile_img'],
          element['name']));
    });
    if (mounted) setState(() {});
  }
}
