import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/notifications/push_notification_manager.dart';
import 'package:mobile_project/src/pages/menu/admin_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String ContactFormRoute = '/user_info_form';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ContactFormRoute:
        return MaterialPageRoute(builder: (_) => const ContactForm());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('404 Not found')),
                ));
    }
  }
}

class MyApp extends StatefulWidget {
  static const String ROUTE = "/ContactForm";
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Contáctenos",
        home: ContactForm(),
        onGenerateRoute: Router.generateRoute,
        initialRoute: ContactFormRoute);
  }
}

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key}) : super(key: key);
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String name = '';
  String nacionality = '';
  String phone = '';
  String email = '';
  String address = '';
  String description = '';

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

  void setDescription(String descriptionInfo) {
    description = descriptionInfo;
    setState(() {});
  }

  void _submit() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Información enviada con éxito'),
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
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen(1)));
          return true;
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 253, 253),
          appBar: AppBar(
              centerTitle: true, title: const Text("Contáctenos si desea:")),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Column(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Obtener información o reservar",
                        style: TextStyle(
                          fontSize: 20,
                        )),
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
                          decoration: const InputDecoration(
                              labelText: 'Dirección',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.text,
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
                          decoration: const InputDecoration(
                              labelText: 'Descipción',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          onFieldSubmitted: (value) {
                            setState(() {
                              description = value.capitalize();
                            });
                          },
                          onChanged: (value) {
                            setDescription(value);
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 3) {
                              return 'La descripción debe contener al menos 3 caracteres';
                            } else if (value
                                .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                              return 'La descripción no puede contener caracteres especiales';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(60)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await ConectionMongodb.changeCollection(
                                  "tbl_messages");
                              await ConectionMongodb.insert({
                                'name': name,
                                'nacionality': nacionality,
                                'phone': phone,
                                'email': email,
                                'address': address,
                                'description': description,
                              });
                              await PushNotificationsManager.sendNotification2(
                                "Mensaje enviado de tu parte",
                                name,
                              );
                              _submit();
                            }
                          },
                          child: const Text('Enviar'),
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
}

extension StringExtension on String {
  // Method used for capitalizing the input from the form
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
