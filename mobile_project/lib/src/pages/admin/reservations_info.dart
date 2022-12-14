import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/models/reservationsDTO.dart';

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
          title: const Text("Información de reservas"),
          backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 17, 77, 27),
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, "/ReservationsInfoForm", arguments: {
              'reservationId': '',
              'personQuantiti': 0,
              'checkInTime': '',
              'checkOutTime': '',
              'place': '',
              'profile': '',
              'entryDate': '',
              'departureDate': '',
            });
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                itemsReservations == []
                    ? const Center()
                    : ListView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(), //Evitará a que trate de Scrolear
                        scrollDirection: Axis.vertical,
                        itemBuilder: ((c, i) => Card(
                            color: const Color.fromARGB(255, 83, 161, 146),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            margin: const EdgeInsets.all(15),
                            child: ClipRRect(
                              child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color:  Color.fromARGB(255, 0, 0, 0), width: 3),
                                    ),
                                  ),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(itemsReservations[i].place!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Reserva a nombre de: " +
                                            itemsReservations[i].profile!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Cantidad de personas: " +
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
                                        "Fecha de entrada: " + itemsReservations[i].entryDate!,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                        "Fecha de salida: " + itemsReservations[i].departureDate!,
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
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(left: 10),
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
                                                                  "¿Desea eliminar la reserva?",
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
                                                                            'tbl_reservations');
                                                                        await ConectionMongodb
                                                                            .delete(
                                                                          itemsReservations[i]
                                                                              .reservationId,
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
                                              primary: Colors.red,
                                              shape: const CircleBorder(),
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )))),
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
          element['personQuantiti'],
          element['checkInTime'],
          element['checkOutTime'],
          element['place'],
          element['profile'],
          element['entryDate'],
          element['departureDate']));
    });
    if (mounted) setState(() {});
  }
}
