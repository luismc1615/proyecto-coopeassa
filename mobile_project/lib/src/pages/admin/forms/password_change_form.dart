import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/notifications/push_notification_manager.dart';
import 'package:mobile_project/src/pages/menu/admin_menu.dart';
import 'package:mobile_project/src/utils/aes.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String PasswordChangeFormRoute = '/password_change_form';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case PasswordChangeFormRoute:
        return MaterialPageRoute(builder: (_) => const PasswordChangeForm());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('404 Not found')),
                ));
    }
  }
}

class MyApp extends StatefulWidget {
  static const String ROUTE = "/PasswordChangeForm";
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Cambio de contraseña",
        home: PasswordChangeForm(),
        onGenerateRoute: Router.generateRoute,
        initialRoute: PasswordChangeFormRoute);
  }
}

class PasswordChangeForm extends StatefulWidget {
  const PasswordChangeForm({Key? key}) : super(key: key);
  @override
  _PasswordChangeFormState createState() => _PasswordChangeFormState();
}

class _PasswordChangeFormState extends State<PasswordChangeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String password = '';
  String passwordRepeat = '';

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

  void setpassword(String passwordInfo) {
    password = passwordInfo;
    setState(() {});
  }

  void setpasswordRepeat(String passwordRepeatInfo) {
    passwordRepeat = passwordRepeatInfo;
    setState(() {});
  }

  void _submit() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Actualización de contraseña exitosa'),
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
              context, MaterialPageRoute(builder: (context) => MenuScreen(4)));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text("Cambio de contraseña 🔏")),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Column(
                children: <Widget>[
                   Align(
                    alignment: Alignment.center,
                    child:  Text("Usuario: " + itemUsers['username'],
                        style: const TextStyle(
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
                        TextFormField(
                          obscureText: true,
                          initialValue: '',
                          decoration: const InputDecoration(
                              labelText: 'Nueva contraseña',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 8) {
                              return 'La contraseña debe contener al menos 8 caracteres';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          onChanged: (value) {
                            setpassword(value);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: true,
                          initialValue: '',
                          decoration: const InputDecoration(
                              labelText: 'Repita la contraseña',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo vacío';
                            } else if (value != password) {
                              return 'Las contraseñas no coinciden';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              passwordRepeat = value;
                            });
                          },
                          onChanged: (value) {
                            setpasswordRepeat(value);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(60)),
                          onPressed: () async {
                            if (itemUsers['userId'] != '') {
                              if (_formKey.currentState!.validate()) {
                                await ConectionMongodb.changeCollection('user');
                                await ConectionMongodb.update({
                                  "_id": itemUsers['userId']
                                }, {
                                  '_id': itemUsers['userId'],
                                  'name': itemUsers['name'],
                                  'username': itemUsers['username'],
                                  'phone': itemUsers['phone'],
                                  'email': itemUsers['email'],
                                  'password': Aes.mtencrypt(password),
                                });
                                _submit();
                              }
                            }
                          },
                          child: const Text('Editar contraseña'),
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
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
