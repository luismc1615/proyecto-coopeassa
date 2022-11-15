import 'package:flutter/material.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mobile_project/src/models/placesDTO.dart';
import 'package:mobile_project/src/models/usersDTO.dart';
import 'package:mobile_project/src/notifications/push_notification_manager.dart';
import 'package:mobile_project/src/pages/menu/admin_menu.dart';
import 'package:mobile_project/src/utils/Toast.dart';

const String ReservationsInfoFormRoute = '/ReservationsInfoForm';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ReservationsInfoFormRoute:
        return MaterialPageRoute(builder: (_) => const ReservationsInfoForm());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('404 Not found')),
                ));
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

// ignore: camel_case_types
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Crear reserva",
        home: ReservationsInfoForm(),
        onGenerateRoute: Router.generateRoute,
        initialRoute: ReservationsInfoFormRoute);
  }
}

class ReservationsInfoForm extends StatefulWidget {
  const ReservationsInfoForm({Key? key}) : super(key: key);
  @override
  _ReservationsInfoFormState createState() => _ReservationsInfoFormState();
}

class _ReservationsInfoFormState extends State<ReservationsInfoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  DateTime date = DateTime.now();
  TextEditingController Sduration = TextEditingController();
  TextEditingController Eduration = TextEditingController();
  var duration = '';
  DateTime checkInTime = DateTime.now();
  DateTime checkOutTime = DateTime.now();
  String place = 'Seleccione un sitio:';
  String profile = 'A nombre de:';
  int personQuantiti = 0;

  late List<PlacesDTO> itemsPlaces = <PlacesDTO>[];
  late List<UsersDTO> itemsProfiles = <UsersDTO>[];

  @override
  void initState() {
    _onLoading();
    Sduration.text = "";
    Eduration.text = "";
    PushNotificationsManager().init();
    super.initState();
    //set the initial value of text field
  }

  static loadSities() async {
    var sities = await ConectionMongodb.getPlaces();
    return sities;
  }

  static loadProfiles() async {
    var profiles = await ConectionMongodb.getProfiles();
    return profiles;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    PushNotificationsManager().dispose();
  }

  void setDate(DateTime dateInfo) {
    date = dateInfo;
    setState(() {});
  }

  void setPlace(String placeInfo) {
    place = placeInfo;
    setState(() {});
  }

  void setprofile(String profileInfo) {
    profile = profileInfo;
    setState(() {});
  }

  void setPersonQuantiti(int personQuantitiInfo) {
    personQuantiti = personQuantitiInfo;
    setState(() {});
  }

  void setDuration(final durationInfo) {
    duration = durationInfo;
    setState(() {});
  }

  void _submit() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reserva generada'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: const Color.fromRGBO(25, 150, 125, 1),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    FocusScope.of(context)
                        .unfocus(); // Unfocus the last selected input field
                    _formKey.currentState?.reset(); // Empty the form fields
                    Sduration.text = '';
                    Eduration.text = '';
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var listPlaces = ['carro', 'moto', 'cuadra'];
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen(2)));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Generación de reserva"),
          ),
          body: ListView(padding: const EdgeInsets.all(16.0), children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Ingrese la información de la reserva",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _FormDatePicker(
                    date: date,
                    onChanged: (value) {
                      setState(() {
                        date = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: Sduration,
                      decoration: const InputDecoration(
                          labelText: "Hora de entrada",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        if (pickedTime != null) {
                          checkInTime = intl.DateFormat.jm()
                              .parse(pickedTime.format(context).toString());
                          String formattedTime =
                              intl.DateFormat('HH:mm').format(checkInTime);
                          setState(() {
                            Sduration.text = formattedTime;
                          });
                          (value) {
                            setState(() {
                              checkInTime = value;
                            });
                          };
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo vacío';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: Eduration,
                      decoration: const InputDecoration(
                          labelText: "Hora de salida",
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder()),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        if (pickedTime != null) {
                          checkOutTime = intl.DateFormat.jm()
                              .parse(pickedTime.format(context).toString());
                          String formattedTime =
                              intl.DateFormat('HH:mm').format(checkOutTime);
                          setState(() {
                            Eduration.text = formattedTime;
                          });
                          (value) {
                            setState(() {
                              checkOutTime = value;
                            });
                          };
                        }
                      },
                      onFieldSubmitted: (value) {
                        setState(() {
                          duration =
                              Difference(checkInTime, checkOutTime) as String;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo vacío';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Cantidad de personas',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                        return 'Utilice sólo números';
                      }
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        personQuantiti = int.parse(value);
                      });
                    },
                    onChanged: (value) {
                      setPersonQuantiti(int.parse(value));
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButton(
                    hint: Text(profile),
                    items: itemsProfiles
                        .map<DropdownMenuItem<String>>((UsersDTO pro) {
                      return DropdownMenuItem<String>(
                        value: pro.name,
                        child: Text(pro.name!),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        profile = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButton(
                    hint: Text(place),
                    items: itemsPlaces
                        .map<DropdownMenuItem<String>>((PlacesDTO pl) {
                      return DropdownMenuItem<String>(
                        value: pl.name,
                        child: Text(pl.name!),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        place = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (place == 'Seleccione un sitio:' ||
                            profile == 'A nombre de:') {
                          ToastType.error(
                              "Debe seleccionar un sitio y un perfil");
                        } else {
                          await ConectionMongodb.changeCollection(
                              "tbl_reservations");
                          await ConectionMongodb.insert({
                            'personQuantiti': personQuantiti,
                            'checkInTime':
                                intl.DateFormat('HH:mm').format(checkInTime),
                            'checkOutTime':
                                intl.DateFormat('HH:mm').format(checkOutTime),
                            'place': place,
                            'profile': profile,
                            'date': intl.DateFormat.yMd().format(date),
                          });
                          await PushNotificationsManager.sendNotification2(
                            "Reserva registrada",
                            "Lugar: " + place,
                          );
                          _submit();
                        }
                      }
                    },
                    child: const Text("Guardar"),
                  ),
                ],
              ),
            ),
          ]),
        ));
  }

  void _onLoading() async {
    itemsProfiles = [];
    List<Map<String, dynamic>> myProfiles = await loadProfiles();
    myProfiles.forEach((element) {
      itemsProfiles.add(UsersDTO(
        element['_id'],
        element['name'],
        element['nacionality'],
        element['phone'],
        element['email'],
        element['address'],
      ));
    });
    itemsPlaces = [];
    List<Map<String, dynamic>> myPlaces = await loadSities();
    myPlaces.forEach((element) {
      itemsPlaces.add(PlacesDTO(
        element['_id'],
        element['address'],
        element['description'],
        element['name'],
        element['profile_img'],
        element['activities'],
      ));
    });
    if (mounted) setState(() {});
  }
}

extension StringExtension on String {
  // Method used for capitalizing the input from the form
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  _FormDatePickerState createState() => _FormDatePickerState();
}

// ignore: non_constant_identifier_names
int Difference(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Date',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              intl.DateFormat.yMd().format(widget.date),
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}
