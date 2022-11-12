import 'package:flutter/material.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/reservationsDTO.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationsInfo extends StatefulWidget {
  // ignore: constant_identifier_names
  @override
  _ReservationsInfoState createState() => _ReservationsInfoState();
}

class _ReservationsInfoState extends State<ReservationsInfo> {
  late List<ReservationsDTO> itemsReservations = <ReservationsDTO>[];

  @override
  void initState() {
    // ignore: todo
    _onLoading();
    super.initState();
  }

  static loadPreferences() async {
    var reservations = await ConectionMongodb.getReservations();
    return reservations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Información de perfiles"),
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
                      Navigator.pushNamed(context, "/ReservationsInfoForm",
                          arguments: {
                            'reservationId': '',
                            'placeId': '',
                            'personQuantiti': 0,
                            'checkInTime': '',
                            'checkOutTime': '',
                            'phone': '',
                            'email': '',
                            'address': '',
                            'userId': ''
                          });
                    },
                    child: const Text("Añadir nueva reserva")),
                itemsReservations == []
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
                                  // itemsReservations[i].profile_img! != '' ?
                                  // CircleAvatar(
                                  //   radius: 120,
                                  //   backgroundImage: NetworkImage(
                                  //       itemsReservations[i].profile_img!),
                                  // ) : const Center(),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(itemsReservations[i].placeId!,
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
                                        "Nacionalidad: " +
                                            itemsReservations[i]
                                                .personQuantiti!
                                                .toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Hora de llegada: " +
                                            itemsReservations[i]
                                                .checkInTime!
                                                .toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Hora de salida: " +
                                            itemsReservations[i]
                                                .checkOutTime!
                                                .toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Teléfono: " +
                                            itemsReservations[i].phone!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Correo: " +
                                            itemsReservations[i].email!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Dirección: " +
                                            itemsReservations[i].address!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Nombre de usuario: " +
                                            itemsReservations[i].userId!,
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
                                                  "/ReservationsInfoForm",
                                                  arguments: {
                                                    'reservationId':
                                                        itemsReservations[i]
                                                            .reservationId,
                                                    'placeId':
                                                        itemsReservations[i]
                                                            .placeId!,
                                                    'personQuantiti':
                                                        itemsReservations[i]
                                                            .personQuantiti!,
                                                    'checkInTime':
                                                        itemsReservations[i]
                                                            .checkInTime!,
                                                    'checkOutTime':
                                                        itemsReservations[i]
                                                            .checkOutTime!,
                                                    'phone':
                                                        itemsReservations[i]
                                                            .phone!,
                                                    'email':
                                                        itemsReservations[i]
                                                            .email!,
                                                    'address':
                                                        itemsReservations[i]
                                                            .address!,
                                                    'userId':
                                                        itemsReservations[i]
                                                            .userId!,
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
                                                      'tbl_reservations');
                                              await ConectionMongodb.delete(
                                                  itemsReservations[i]
                                                      .reservationId);
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
                        itemCount: itemsReservations.length,
                      ),
              ],
            ),
          ),
        ));
  }

  void _onLoading() async {
    itemsReservations = [];
    List<Map<String, dynamic>> myReservations = await loadPreferences();
    myReservations.forEach((element) {
      itemsReservations.add(ReservationsDTO(
          element['_id'],
          element['placeId'],
          element['personQuantiti'],
          element['checkInTime'],
          element['checkOutTime'],
          element['phone'],
          element['email'],
          element['address']));
    });
    if (mounted) setState(() {});
  }
}
