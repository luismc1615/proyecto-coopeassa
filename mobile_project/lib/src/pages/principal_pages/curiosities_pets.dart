import 'package:flutter/material.dart';
import 'package:mobile_project/src/models/curiosityDTO.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/connection_mongodb.dart';
import '../forms/gallery_curiosity.dart';

class CuriositiesPets extends StatefulWidget {
  @override
  _CuriositiesPetsState createState() => _CuriositiesPetsState();
}

class _CuriositiesPetsState extends State<CuriositiesPets> {
  late List<CuriosityDTO> itemsCuriosity = <CuriosityDTO>[];

  @override
  void initState() {
    // ignore: todo
    _onLoading();
    super.initState();
  }

  static loadPreferences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userPetsCuriosity =
        await ConectionMongodb.getPetsCuriosity(_prefs.getString('id'));
    return userPetsCuriosity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("curiosities of my Pets"),
          backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  ElevatedButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(25, 150, 125, 1),
                              minimumSize: const Size.fromHeight(40)),
                      onPressed: () {
                        Navigator.pushNamed(context, "/PetCuriosities");
                      },
                      child: const Text("Add new curiosity")),
                  itemsCuriosity == []
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
                                      child: Text(itemsCuriosity[i].title!,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 1.5
                                              ..color =
                                                  const Color.fromARGB(255, 0, 0, 0),
                                          )),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      child: Text(
                                          "Place: " + itemsCuriosity[i].place!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      child: Text(
                                          "Date: " + itemsCuriosity[i].date,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      child: Text(
                                          "Description: " +
                                              itemsCuriosity[i].description!,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      child: Text(
                                          "Participants: " +
                                              itemsCuriosity[i]
                                                  .participants!
                                                  .substring(
                                                      1,
                                                      itemsCuriosity[i]
                                                              .participants!
                                                              .length -
                                                          1),
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
                                        SharedPreferences _curiosityId =
                                            await SharedPreferences
                                                .getInstance();
                                        _curiosityId.setString(
                                            'curiosityId',
                                            itemsCuriosity[i]
                                                .curiosityId
                                                .toString());
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GalleryCuriosity(
                                                        itemsCuriosity[i]
                                                            .title)));
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
                                                    .changeCollection(
                                                        'curiositiespet');
                                                await ConectionMongodb.delete(
                                                    itemsCuriosity[i]
                                                        .curiosityId);
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
                          itemCount: itemsCuriosity.length,
                        ),
                ],
              ),
            )
          ],
        ));
  }

  void _onLoading() async {
    itemsCuriosity = [];
    List<Map<String, dynamic>> myCuriosity = await loadPreferences();
    myCuriosity.forEach((element) {
      itemsCuriosity.add(CuriosityDTO(
          element['_id'],
          element['title'],
          element['description'],
          element['date'],
          element['participants'],
          element['place'],
          element['user_id']));
    });
    if (mounted) setState(() {});
  }
}
