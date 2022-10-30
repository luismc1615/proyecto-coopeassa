import 'package:flutter/material.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/petsDTO.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoPets extends StatefulWidget {
  // ignore: constant_identifier_names
  @override
  _InfoPetsState createState() => _InfoPetsState();
}

class _InfoPetsState extends State<InfoPets> {
  late List<PetsDTO> itemsPets = <PetsDTO>[];

  @override
  void initState() {
    // ignore: todo
    _onLoading();
    super.initState();
  }

  static loadPreferences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userPets = await ConectionMongodb.getPets(_prefs.getString('id'));
    return userPets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Information Pets"),
          backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
                        minimumSize: const Size.fromHeight(40)
                        ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/informationPets",
                          arguments: {
                            'petId': '',
                            'profile_photo': '',
                            'name': '',
                            'breed': '',
                            'color': '',
                            'age': '',
                            'weight': ''
                          });
                    },
                    child: const Text("Add new pet")),
                itemsPets == []
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
                                  itemsPets[i].profile_photo! != '' ?
                                  CircleAvatar(
                                    radius: 120,
                                    backgroundImage: NetworkImage(
                                        itemsPets[i].profile_photo!),
                                  ) : const Center(),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(itemsPets[i].name!,
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 3
                                            ..color = Color.fromARGB(255, 0, 0, 0),
                                        )),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text("Breed: " + itemsPets[i].breed!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text("Color: " + itemsPets[i].color!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Age: " + itemsPets[i].age.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Weight (Kg): " +
                                            itemsPets[i].weight.toString(),
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
                                                  context, "/informationPets",
                                                  arguments: {
                                                    'petId': itemsPets[i].petId,
                                                    'profile_photo':
                                                        itemsPets[i]
                                                            .profile_photo!,
                                                    'name': itemsPets[i].name!,
                                                    'breed':
                                                        itemsPets[i].breed!,
                                                    'color':
                                                        itemsPets[i].color!,
                                                    'age': itemsPets[i]
                                                        .age
                                                        .toString(),
                                                    'weight': itemsPets[i]
                                                        .weight
                                                        .toString(),
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
                                                  .changeCollection('pets');
                                              await ConectionMongodb.delete(
                                                  itemsPets[i].petId);
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
                        itemCount: itemsPets.length,
                      ),
              ],
            ),
          ),
        ));
  }

  void _onLoading() async {
    itemsPets = [];
    List<Map<String, dynamic>> myPets = await loadPreferences();
    myPets.forEach((element) {
      itemsPets.add(PetsDTO(
          element['_id'],
          element['name'],
          element['breed'],
          element['color'],
          element['age'],
          element['weight'],
          element['profile_photo'],
          element['user_id']));
    });
    if (mounted) setState(() {});
  }
}
