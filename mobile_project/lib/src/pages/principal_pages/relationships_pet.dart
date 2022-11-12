import 'package:flutter/material.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/relationshipsDTO.dart';
import 'package:mobile_project/src/pages/menu/admin_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RelationshipsPet extends StatefulWidget {
  var namePet;
  RelationshipsPet(this.namePet);
  // ignore: constant_identifier_names
  @override
  _RelationshipsPetState createState() => _RelationshipsPetState();
}

class _RelationshipsPetState extends State<RelationshipsPet> {
  late List<RelationshipsDTO> itemsRelationshipsPets = <RelationshipsDTO>[];
  // ignore: prefer_typing_uninitialized_variables
  String namePet = '';

  @override
  void initState() {
    // ignore: todo
    namePet = widget.namePet;
    _onLoading();
    super.initState();
  }

  static loadPreferences() async {
    SharedPreferences _petId = await SharedPreferences.getInstance();
    var relationships =
        await ConectionMongodb.getRelationshipsPets(_petId.getString('petId'));
    return relationships;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen(3)));
          return true;
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Relationships of " + namePet),
              backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    ElevatedButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(25, 150, 125, 1),
                            minimumSize: const Size.fromHeight(40)),
                        onPressed: () {
                          Navigator.pushNamed(context, "/relationshipsPetForm",
                              arguments: {
                                'relationship_id': '',
                                'profile_photo': '',
                                'name': '',
                                'breed': '',
                                'color': '',
                                'age': '',
                                'relationship': '',
                                'namePet': namePet
                              });
                        },
                        child: const Text("Add new relationsip")),
                    itemsRelationshipsPets == []
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
                                      CircleAvatar(
                                        radius: 120,
                                        backgroundImage: NetworkImage(
                                            itemsRelationshipsPets[i]
                                                .profile_photo!),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            itemsRelationshipsPets[i].name!,
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              foreground: Paint()
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 3
                                                ..color = Color.fromARGB(
                                                    255, 0, 0, 0),
                                            )),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "Breed: " +
                                                itemsRelationshipsPets[i]
                                                    .breed!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "Color: " +
                                                itemsRelationshipsPets[i]
                                                    .color!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "Age: " +
                                                itemsRelationshipsPets[i]
                                                    .age
                                                    .toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                            "Relationship: " +
                                                itemsRelationshipsPets[i]
                                                    .relationship!,
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
                                                  Navigator.pushNamed(context,
                                                      "/relationshipsPetForm",
                                                      arguments: {
                                                        'relationship_id':
                                                            itemsRelationshipsPets[
                                                                    i]
                                                                .relationshipId,
                                                        'profile_photo':
                                                            itemsRelationshipsPets[
                                                                    i]
                                                                .profile_photo!,
                                                        'name':
                                                            itemsRelationshipsPets[
                                                                    i]
                                                                .name!,
                                                        'breed':
                                                            itemsRelationshipsPets[
                                                                    i]
                                                                .breed!,
                                                        'color':
                                                            itemsRelationshipsPets[
                                                                    i]
                                                                .color!,
                                                        'age':
                                                            itemsRelationshipsPets[
                                                                    i]
                                                                .age
                                                                .toString(),
                                                        'relationship':
                                                            itemsRelationshipsPets[
                                                                    i]
                                                                .relationship!,
                                                        'namePet': namePet
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
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                            ),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  await ConectionMongodb
                                                      .changeCollection(
                                                          'relationshipspets');
                                                  await ConectionMongodb.delete(
                                                      itemsRelationshipsPets[i]
                                                          .relationshipId);
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
                            itemCount: itemsRelationshipsPets.length,
                          ),
                  ],
                ),
              ),
            )));
  }

  void _onLoading() async {
    itemsRelationshipsPets = [];
    List<Map<String, dynamic>> myPets = await loadPreferences();
    myPets.forEach((element) {
      itemsRelationshipsPets.add(RelationshipsDTO(
          element['_id'],
          element['name'],
          element['breed'],
          element['color'],
          element['age'],
          element['relationship'],
          element['profile_photo'],
          element['pet_id']));
    });
    if (mounted) setState(() {});
  }
}
