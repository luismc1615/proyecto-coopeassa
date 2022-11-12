import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/notifications/push_notification_manager.dart';
import 'package:mobile_project/src/pages/menu/admin_menu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String ReservationsInfoFormRoute = '/reservation_info_form';

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
  static const String ROUTE = "/ReservationsInfoForm";
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Ret Registration",
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
  String placeId = '';
  int personQuantiti = 0;
  DateTime checkInTime = DateTime.now();
  DateTime checkOutTime = DateTime.now();
  String phone = '';
  String email = '';
  String address = '';
  String userId = '';

  final ImagePicker _imagePicker = ImagePicker();
  final storage =
      FirebaseStorage.instanceFor(bucket: 'gs://homepets-c02ac.appspot.com')
          .ref();

  @override
  void initState() {
    PushNotificationsManager().init();
    super.initState();
  }

  @override
  void dispose() {
    PushNotificationsManager().dispose();
    super.dispose();
  }

  loadPreferences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('id');
  }

  void setPlaceId(String placeIdInfo) {
    placeId = placeIdInfo;
    setState(() {});
  }

  void setPersonQuantiti(int personQuantitiInfo) {
    personQuantitiInfo = personQuantiti;
    setState(() {});
  }

  void setPhone(String phoneInfo) {
    phone = phoneInfo;
    setState(() {});
  }

  void setEmail(String emailInfo) {
    email = emailInfo;
    setState(() {});
  }

  void setAddress(String addressInfo) {
    address = addressInfo;
    setState(() {});
  }

  void setUserId(String userIdInfo) {
    userId = userIdInfo;
    setState(() {});
  }

  void _submit() {
    showDialog<void>(
      context: context,
      barrierDismissible:
          true, // reservation can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('La información del usuario ha sido registrada'),
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
    final itemReservations = ModalRoute.of(context)!.settings.arguments as Map;
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen(1)));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true, title: const Text("Registro de perfil")),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Column(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Ingrese la información del perfil",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: itemReservations['placeId'] != ''
                              ? itemReservations['placeId']
                              : '',
                          decoration: const InputDecoration(
                              labelText: 'Lugar',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          onFieldSubmitted: (value) {
                            setState(() {
                              placeId = value.capitalize();
                            });
                          },
                          onChanged: (value) {
                            setPlaceId(value);
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 3) {
                              return 'El nombre debe contener al menos 3 caracteres';
                            } else if (value
                                .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                              return 'El nombre no puede contener caracteres especiales';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: itemReservations['personQuantiti'] != ''
                              ? itemReservations['personQuantiti']
                              : '',
                          decoration: const InputDecoration(
                              labelText: 'Cantidad de personas',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.parse(value) <= 1) {
                              return 'La cantidad debe ser mayor o igual a 1';
                            } else if (value
                                .contains(RegExp(r'^[a-zA-Z_\-=@,\.;]+$'))) {
                              return 'La nacionalidad no puede contener caracteres especiales';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              personQuantiti = int.parse(value.capitalize());
                            });
                          },
                          onChanged: (value) {
                            setPersonQuantiti(int.parse(value));
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: itemReservations['phone'] != ''
                              ? itemReservations['phone']
                              : '',
                          decoration: const InputDecoration(
                              labelText: 'Teléfono',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 3) {
                              return 'El teléfono debe contener al menos 3 caracteres';
                            } else if (value
                                .contains(RegExp(r'^[a-zA-Z_\-=@,\.;]+$'))) {
                              return 'El telefono ingresado no es válido';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              phone = value.capitalize();
                            });
                          },
                          onChanged: (value) {
                            setPhone(value);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: itemReservations['email'] != ''
                              ? itemReservations['email']
                              : '',
                          decoration: const InputDecoration(
                              labelText: 'Correo electrónico',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 3) {
                              return 'El correo debe contener al menos 3 caracteres';
                            } else if (!value.contains(RegExp(
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$"))) {
                              return 'El correo no es válido';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              phone = value.capitalize();
                            });
                          },
                          onChanged: (value) {
                            setEmail(value);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: itemReservations['address'] != ''
                              ? itemReservations['address']
                              : '',
                          decoration: const InputDecoration(
                              labelText: 'Dirección',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 3) {
                              return 'La dirección debe contener al menos 3 caracteres';
                            } else if (value
                                .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                              return 'La dirección no puede contener caracteres especiales';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              address = value;
                            });
                          },
                          onChanged: (value) {
                            setAddress(value);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: itemReservations['userId'] != ''
                              ? itemReservations['userId']
                              : '',
                          decoration: const InputDecoration(
                              labelText: 'Nombre de usuario',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 3) {
                              return 'El nombre de usuario debe contener al menos 3 caracteres';
                            } else if (value
                                .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                              return 'el usuario no puede contener caracteres especiales';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              userId = value;
                            });
                          },
                          onChanged: (value) {
                            setUserId(value);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(60)),
                          onPressed: () async {
                            if (itemReservations['reservationId'] == '') {
                              if (_formKey.currentState!.validate()) {
                                await ConectionMongodb.changeCollection(
                                    "tbl_reservations");
                                await ConectionMongodb.insert({
                                  'placeId': placeId,
                                  'personQuantiti': personQuantiti,
                                  'phone': phone,
                                  'email': email,
                                  'address': address,
                                  'userId': userId
                                });
                                await PushNotificationsManager
                                    .sendNotification2(
                                  "Nuevo reserva registrada",
                                  placeId,
                                );
                                _submit();
                                // setState(() {
                                //   urlPath = '';
                                // });
                              }
                            } else {
                              if (_formKey.currentState!.validate()) {
                                if (placeId == '') {
                                  placeId = itemReservations['placeId'];
                                }
                                if (personQuantiti == 0) {
                                  personQuantiti = int.parse(
                                      itemReservations['personQuantiti']);
                                }
                                if (phone == '') {
                                  phone = itemReservations['phone'];
                                }
                                if (email == '') {
                                  email = itemReservations['email'];
                                }
                                if (address == '') {
                                  address = itemReservations['address'];
                                }
                                if (userId == '') {
                                  userId = itemReservations['userId'];
                                }
                                // if (urlPath == '') {
                                //   urlPath = itemReservations['profile_img'];
                                // }
                                await ConectionMongodb.changeCollection(
                                    'tbl_reservations');
                                await ConectionMongodb.update({
                                  "_id": itemReservations['reservationId']
                                }, {
                                  '_id': itemReservations['reservationId'],
                                  'placeId': placeId,
                                  'personQuantiti': personQuantiti,
                                  'phone': phone,
                                  'email': email,
                                  'address': address,
                                  'userId': userId
                                });
                                SmartDialog.showToast(
                                    "Información editada con éxito");
                              }
                            }
                          },
                          child: Text(itemReservations['reservationId'] != ''
                              ? 'Editar'
                              : 'Guardar'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  //se comento pero se puede incorporar mas adelante

  // Future openGalery() async {
  //   UploadTask? task;
  //   if (await Permission.storage.request().isGranted) {
  //     XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
  //     if (image != null) {
  //       SmartDialog.showLoading();
  //       try {
  //         task = uploadFile('img_profile/${image.name}', File(image.path));
  //         if (task == null) return;
  //         final snapshot = await task.whenComplete(() {});
  //         // urlPath = await snapshot.ref.getDownloadURL();
  //         setState(() {});
  //       } catch (error) {
  //         print('Error-> $error');
  //       }
  //       SmartDialog.dismiss();
  //     }
  //   } else {
  //     Permission.storage.request();
  //   }
  // }

  // Future openCamera() async {
  //   UploadTask? task;
  //   if (await Permission.camera.request().isGranted) {
  //     XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
  //     if (image != null) {
  //       SmartDialog.showLoading();
  //       try {
  //         task = uploadFile('img_profile/${image.name}', File(image.path));
  //         if (task == null) return;
  //         final snapshot = await task.whenComplete(() {});
  //         // urlPath = await snapshot.ref.getDownloadURL();
  //         setState(() {});
  //       } catch (error) {
  //         print('Error-> $error');
  //       }
  //       SmartDialog.dismiss();
  //     }
  //   } else {
  //     Permission.storage.request();
  //   }
  // }

  UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}

extension StringExtension on String {
  // Method used for capitalizing the input from the form
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
