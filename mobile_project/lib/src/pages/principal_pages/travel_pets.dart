import 'package:flutter/material.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/petsWalkDTO.dart';
import 'package:mobile_project/src/pages/forms/gallery_travel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TravelPets extends StatefulWidget {
  @override
  _TravelPetsState createState() => _TravelPetsState();
}

class _TravelPetsState extends State<TravelPets> {
  late List<PetsWalkDTO> itemsPetsWalk = <PetsWalkDTO>[];

  @override
  void initState() {
    // ignore: todo
    _onLoading();
    super.initState();
  }

  static loadPreferences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userPets = await ConectionMongodb.getPetsWalk(_prefs.getString('id'));
    return userPets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Travel with my pets"),
          backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
                        minimumSize: const Size.fromHeight(40)),
                    onPressed: () {
                      Navigator.pushNamed(context, "/walkPets");
                    },
                    child: const Text("Add new travel")),
                itemsPetsWalk == []
                    ? const Center()
                    : ListView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(), //Evitará a que trate de Scrolear
                        scrollDirection: Axis.vertical,
                        itemBuilder: ((c, i) => Card(
                            color: const Color.fromARGB(255, 86, 155, 141),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            margin: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(itemsPetsWalk[i].place!,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1.5
                                            ..color = const Color.fromARGB(
                                                255, 0, 0, 0),
                                        )),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(
                                        "Participants: " +
                                            itemsPetsWalk[i]
                                                .participants!
                                                .substring(
                                                    1,
                                                    itemsPetsWalk[i]
                                                            .participants!
                                                            .length -
                                                        1),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    child: Text(
                                        "Date: " + itemsPetsWalk[i].date,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    child: Text(
                                        "Start time: " +
                                            itemsPetsWalk[i].start_time!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    child: Text(
                                        "End time: " +
                                            itemsPetsWalk[i].end_time!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    child: Text(
                                        "Weather: " + itemsPetsWalk[i].weather!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(height: 5),
                                  ElevatedButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 3, 72, 201)),
                                    onPressed: () async {
                                      SharedPreferences _travelId =
                                          await SharedPreferences.getInstance();
                                      _travelId.setString(
                                          'travelId',
                                          itemsPetsWalk[i]
                                              .petWalkId
                                              .toString());
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GalleryTravel(
                                                      itemsPetsWalk[i].place)));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text('See photos'),
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
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                            onPressed: () async {
                                              await ConectionMongodb
                                                  .changeCollection('petwalk');
                                              await ConectionMongodb.delete(
                                                  itemsPetsWalk[i].petWalkId);
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
                        itemCount: itemsPetsWalk.length,
                      ),
              ],
            ),
          ),
        ));
  }

  void _onLoading() async {
    itemsPetsWalk = [];
    List<Map<String, dynamic>> myPetsWalk = await loadPreferences();
    myPetsWalk.forEach((element) {
      itemsPetsWalk.add(PetsWalkDTO(
          element['_id'],
          element['date'],
          element['place'],
          element['start_time'],
          element['end_time'],
          element['weather'],
          element['participants'],
          element['user_id']));
    });
    if (mounted) setState(() {});
  }
}
