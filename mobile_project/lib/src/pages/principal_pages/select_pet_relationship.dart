import 'package:flutter/material.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/petsDTO.dart';
import 'package:mobile_project/src/pages/forms/gallery_curiosity.dart';
import 'package:mobile_project/src/pages/principal_pages/relationships_pet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectRelationshipsPet extends StatefulWidget {
  // ignore: constant_identifier_names
  @override
  _SelectRelationshipsPetState createState() => _SelectRelationshipsPetState();
}

class _SelectRelationshipsPetState extends State<SelectRelationshipsPet> {
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
          title: const Text("Relationships"),
          backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(45),
            child: Column(
              children: [
                itemsPets == []
                    ? const Align(
                        alignment: Alignment.center,
                        child: Text("No pets created",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            )),
                      )
                    : const Align(
                        alignment: Alignment.center,
                        child: Text("Select the pet",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            )),
                      ),
                ListView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(), //Evitará a que trate de Scrolear
                  scrollDirection: Axis.vertical,
                  itemBuilder: ((c, i) => Card(
                      color: const Color.fromARGB(255, 83, 161, 146),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      margin: const EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 8),
                            itemsPets[i].profile_photo! != '' ?
                            CircleAvatar(
                              radius: 100,
                              backgroundImage:
                                  NetworkImage(itemsPets[i].profile_photo!),
                            ) : const Center(),
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: Text(itemsPets[i].name!,
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white
                                  )),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ElevatedButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 3, 72, 201)),
                                    onPressed: () async {
                                      SharedPreferences _petId =
                                          await SharedPreferences.getInstance();
                                      _petId.setString('petId',
                                          itemsPets[i].petId.toString());
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RelationshipsPet(
                                                      itemsPets[i].name)));
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text('See relationships'),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.pets,
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
