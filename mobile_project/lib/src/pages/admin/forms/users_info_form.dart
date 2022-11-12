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

const String UsersInfoFormRoute = '/user_info_form';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case UsersInfoFormRoute:
        return MaterialPageRoute(builder: (_) => const UsersInfoForm());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('404 Not found')),
                ));
    }
  }
}

class MyApp extends StatefulWidget {
  static const String ROUTE = "/UsersInfoForm";
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Registro de perfil",
        home: UsersInfoForm(),
        onGenerateRoute: Router.generateRoute,
        initialRoute: UsersInfoFormRoute);
  }
}

class UsersInfoForm extends StatefulWidget {
  const UsersInfoForm({Key? key}) : super(key: key);
  @override
  _UsersInfoFormState createState() => _UsersInfoFormState();
}

class _UsersInfoFormState extends State<UsersInfoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String name = '';
  String nacionality = '';
  String phone = '';
  String email = '';
  String address = '';

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

  void setName(String nameInfo) {
    name = nameInfo;
    setState(() {});
  }

  void setNacionality(String nacionalityInfo) {
    nacionality = nacionalityInfo;
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

  void _submit() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to close the pop up
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
    final itemUsers = ModalRoute.of(context)!.settings.arguments as Map;
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
                          initialValue:
                              itemUsers['name'] != '' ? itemUsers['name'] : '',
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
                          initialValue: itemUsers['nacionality'] != ''
                              ? itemUsers['nacionality']
                              : '',
                          decoration: const InputDecoration(
                              labelText: 'Nacionalidad',
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
                              return 'La nacionalidad debe contener al menos 3 caracteres';
                            } else if (value
                                .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                              return 'La nacionalidad no puede contener caracteres especiales';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              nacionality = value.capitalize();
                            });
                          },
                          onChanged: (value) {
                            setNacionality(value);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: itemUsers['phone'] != ''
                              ? itemUsers['phone']
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
                          keyboardType: TextInputType.phone,
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
                          initialValue: itemUsers['email'] != ''
                              ? itemUsers['email']
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
                          keyboardType: TextInputType.emailAddress,
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
                          initialValue: itemUsers['address'] != ''
                              ? itemUsers['address']
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(60)),
                          onPressed: () async {
                            if (itemUsers['userId'] == '') {
                              if (_formKey.currentState!.validate()) {
                                await ConectionMongodb.changeCollection(
                                    "tbl_profiles");
                                await ConectionMongodb.inserData({
                                  'name': name,
                                  'nacionality': nacionality,
                                  'phone': phone,
                                  'email': email,
                                  'address': address,
                                });
                                await PushNotificationsManager
                                    .sendNotification2(
                                  "Nuevo perfil registrado",
                                  name,
                                );
                                _submit();
                              }
                            } else {
                              if (_formKey.currentState!.validate()) {
                                if (name == '') {
                                  name = itemUsers['name'];
                                }
                                if (nacionality == '') {
                                  nacionality = itemUsers['nacionality'];
                                }
                                if (phone == '') {
                                  phone = itemUsers['phone'];
                                }
                                if (email == '') {
                                  email = itemUsers['email'];
                                }
                                if (address == '') {
                                  address = itemUsers['address'];
                                }
                                // if (urlPath == '') {
                                //   urlPath = itemUsers['profile_img'];
                                // }
                                await ConectionMongodb.changeCollection(
                                    'tbl_profiles');
                                await ConectionMongodb.update({
                                  "_id": itemUsers['userId']
                                }, {
                                  '_id': itemUsers['userId'],
                                  'name': name,
                                  'nacionality': nacionality,
                                  'phone': phone,
                                  'email': email,
                                  'address': address,
                                });
                                SmartDialog.showToast(
                                    "Información editada con éxito");
                              }
                            }
                          },
                          child: Text(
                              itemUsers['userId'] != '' ? 'Editar' : 'Guardar'),
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
