import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/notifications/push_notification_manager.dart';
import 'package:mobile_project/src/pages/menu/admin_menu.dart';
import 'package:mobile_project/src/utils/Toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String PlacesInfoFormRoute = '/place_info_form';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PlacesInfoFormRoute:
        return MaterialPageRoute(builder: (_) => const PlacesInfoForm());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('404 Not found')),
                ));
    }
  }
}

class MyApp extends StatefulWidget {
  static const String ROUTE = "/PlacesInfoForm";
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Ret Registration",
        home: PlacesInfoForm(),
        onGenerateRoute: Router.generateRoute,
        initialRoute: PlacesInfoFormRoute);
  }
}

class PlacesInfoForm extends StatefulWidget {
  const PlacesInfoForm({Key? key}) : super(key: key);
  @override
  _PlacesInfoFormState createState() => _PlacesInfoFormState();
}

class _PlacesInfoFormState extends State<PlacesInfoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String address = '';
  String description = '';
  String name = '';
  String urlPath = '';

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

  void setAddress(String addressInfo) {
    address = addressInfo;
    setState(() {});
  }

  void setDescription(String descriptionInfo) {
    description = descriptionInfo;
    setState(() {});
  }

  void setName(String nameInfo) {
    name = nameInfo;
    setState(() {});
  }

  void setUrlPath(String urlPathInfo) {
    urlPath = urlPathInfo;
    setState(() {});
  }

  void _submit() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('La información del sitio ha sido registrada'),
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
    final itemPlaces = ModalRoute.of(context)!.settings.arguments as Map;
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen(0)));
          return true;
        },
        child: Scaffold(
          appBar:
              AppBar(centerTitle: true, title: const Text("Registro de sitio")),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Column(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Ingrese la información del sitio",
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
                        urlPath == '' && itemPlaces['profile_img'] != ''
                            ? CircleAvatar(
                                radius: 120,
                                backgroundImage:
                                    NetworkImage(itemPlaces['profile_img']),
                              )
                            : (urlPath == ''
                                ? const Center()
                                : CircleAvatar(
                                    radius: 120,
                                    backgroundImage: NetworkImage(urlPath),
                                  )),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            style: TextButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(25, 150, 125, 1)),
                            onPressed: () {
                              SmartDialog.show(builder: (context) {
                                return Container(
                                  height: 107,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Column(children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          ElevatedButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        25, 150, 125, 1)),
                                            onPressed: () {
                                              openGalery();
                                              SmartDialog.dismiss();
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text('Seleccionar imagen'),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Icon(
                                                  Icons.image,
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        25, 150, 125, 1)),
                                            onPressed: () {
                                              openCamera();
                                              SmartDialog.dismiss();
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                Text('Tomar foto'),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.camera,
                                                  size: 24.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                );
                              });
                            },
                            child: Text(itemPlaces['profile_img'] != ''
                                ? 'Editar imagen de perfil'
                                : 'Añadir imagen de perfil')),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: itemPlaces['name'] != ''
                              ? itemPlaces['name']
                              : '',
                          decoration: const InputDecoration(
                              labelText: 'Nombre',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.name,
                          onFieldSubmitted: (value) {
                            setState(() {
                              name = value.capitalize();
                            });
                          },
                          onChanged: (value) {
                            setName(value);
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 3) {
                              return 'Name must contain at least 3 characters';
                            } else if (value
                                .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                              return 'El nombre debe contener al menos 3 caracteres';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: itemPlaces['description'] != ''
                              ? itemPlaces['description']
                              : '',
                          decoration: const InputDecoration(
                              labelText: 'Descripción',
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
                              return 'El descripción debe contener al menos 3 caracteres';
                            } else if (value
                                .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                              return 'La descripción no puede contener caracteres especiales';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              description = value.capitalize();
                            });
                          },
                          onChanged: (value) {
                            setDescription(value);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: itemPlaces['address'] != ''
                              ? itemPlaces['address']
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
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 3) {
                              return 'Color must contain at least 3 characters';
                            } else if (value
                                .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                              return 'Color cannot contain special characters';
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(60)),
                          onPressed: () async {
                            if (itemPlaces['placeId'] == '') {
                              if (await ConectionMongodb.placeExist(name) ==
                                  false) {
                                if (_formKey.currentState!.validate()) {
                                  await ConectionMongodb.changeCollection(
                                      "tbl_places");
                                  await ConectionMongodb.insert({
                                    'address': address,
                                    'description': description,
                                    'name': name.trim(),
                                    'profile_img': urlPath,
                                  });
                                  await PushNotificationsManager
                                      .sendNotification2(
                                    "Nuevo sitio registrado",
                                    name,
                                  );
                                  _submit();
                                  setState(() {
                                    urlPath = '';
                                  });
                                }
                              } else {
                                ToastType.error(
                                    "Ya existe un sitio con este nombre");
                              }
                            } else {
                              if (_formKey.currentState!.validate()) {
                                if (name == '') {
                                  name = itemPlaces['name'];
                                }
                                if (description == '') {
                                  description = itemPlaces['description'];
                                }
                                if (address == '') {
                                  address = itemPlaces['address'];
                                }
                                if (urlPath == '') {
                                  urlPath = itemPlaces['profile_img'];
                                }

                                if (name == itemPlaces['name']) {
                                  await ConectionMongodb.changeCollection(
                                      'tbl_places');
                                  await ConectionMongodb.update({
                                    "_id": itemPlaces['placeId']
                                  }, {
                                    '_id': itemPlaces['placeId'],
                                    'address': address,
                                    'description': description,
                                    'name': name.trim(),
                                    'profile_img': urlPath,
                                  });
                                  SmartDialog.showToast(
                                      "Información editada con éxito");
                                } else {
                                  if (await ConectionMongodb.placeExist(name) ==
                                      false) {
                                    await ConectionMongodb.changeCollection(
                                        'tbl_places');
                                    await ConectionMongodb.update({
                                      "_id": itemPlaces['placeId']
                                    }, {
                                      '_id': itemPlaces['placeId'],
                                      'address': address,
                                      'description': description,
                                      'name': name.trim(),
                                      'profile_img': urlPath,
                                    });
                                    SmartDialog.showToast(
                                        "Información editada con éxito");
                                  } else {
                                    ToastType.error(
                                        "Ya existe un sitio con este nombre");
                                  }
                                }
                              }
                            }
                          },
                          child: Text(itemPlaces['placeId'] != ''
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

  Future openGalery() async {
    UploadTask? task;
    if (await Permission.storage.request().isGranted) {
      XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        SmartDialog.showLoading();
        try {
          task = uploadFile('img_profile/${image.name}', File(image.path));
          if (task == null) return;
          final snapshot = await task.whenComplete(() {});
          urlPath = await snapshot.ref.getDownloadURL();
          setState(() {});
        } catch (error) {
          print('Error-> $error');
        }
        SmartDialog.dismiss();
      }
    } else {
      Permission.storage.request();
    }
  }

  Future openCamera() async {
    UploadTask? task;
    if (await Permission.camera.request().isGranted) {
      XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        SmartDialog.showLoading();
        try {
          task = uploadFile('img_profile/${image.name}', File(image.path));
          if (task == null) return;
          final snapshot = await task.whenComplete(() {});
          urlPath = await snapshot.ref.getDownloadURL();
          setState(() {});
        } catch (error) {
          print('Error-> $error');
        }
        SmartDialog.dismiss();
      }
    } else {
      Permission.storage.request();
    }
  }

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
