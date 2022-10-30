import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/notifications/push_notification_manager.dart';
import 'package:mobile_project/src/pages/menu/menu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String informationPageRoute = '/information_pets';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case informationPageRoute:
        return MaterialPageRoute(builder: (_) => const InformationPets());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('404 Not found')),
                ));
    }
  }
}

class MyApp extends StatefulWidget {
  static const String ROUTE = "/informationPets";
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Ret Registration",
        home: InformationPets(),
        onGenerateRoute: Router.generateRoute,
        initialRoute: informationPageRoute);
  }
}

class InformationPets extends StatefulWidget {
  const InformationPets({Key? key}) : super(key: key);
  @override
  _InformationPetsState createState() => _InformationPetsState();
}

class _InformationPetsState extends State<InformationPets> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String name = '';
  String breed = '';
  String color = '';
  int age = 0;
  int weight = 0;
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

  void setName(String nameInfo) {
    name = nameInfo;
    setState(() {});
  }

  void setBreed(String breedInfo) {
    breed = breedInfo;
    setState(() {});
  }

  void setColor(String colorInfo) {
    color = colorInfo;
    setState(() {});
  }

  void setAge(int ageInfo) {
    age = ageInfo;
    setState(() {});
  }

  void setWeight(int weightInfo) {
    weight = weightInfo;
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
          title: const Text('Your information has been submitted'),
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
    final itemPets = ModalRoute.of(context)!.settings.arguments as Map;
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MenuScreen(0)));
          return true;
        },
        child: Scaffold(
          appBar:
              AppBar(centerTitle: true, title: const Text("Pet Registration")),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Column(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Enter your pet information",
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
                        urlPath == '' && itemPets['profile_photo'] != ''
                            ? CircleAvatar(
                                radius: 120,
                                backgroundImage:
                                    NetworkImage(itemPets['profile_photo']),
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
                                                Text('Select photo'),
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
                                                Text('Take photo'),
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
                            child: Text(itemPets['profile_photo'] != ''
                                ? 'Edit profile photo'
                                : 'Add profile photo')),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue:
                              itemPets['name'] != '' ? itemPets['name'] : '',
                          decoration: const InputDecoration(
                              labelText: 'Name',
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 0.0),
                              ),
                              border: OutlineInputBorder()),
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
                              return 'Name cannot contain special characters';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue:
                              itemPets['breed'] != '' ? itemPets['breed'] : '',
                          decoration: const InputDecoration(
                              labelText: 'Breed',
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
                              return 'Breed must contain at least 3 characters';
                            } else if (value
                                .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                              return 'Breed cannot contain special characters';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              breed = value.capitalize();
                            });
                          },
                          onChanged: (value) {
                            setBreed(value);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue:
                              itemPets['color'] != '' ? itemPets['color'] : '',
                          decoration: const InputDecoration(
                              labelText: 'Color',
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
                              return 'Color must contain at least 3 characters';
                            } else if (value
                                .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                              return 'Color cannot contain special characters';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              color = value;
                            });
                          },
                          onChanged: (value) {
                            setColor(value);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue:
                              itemPets['age'] != '' ? itemPets['age'] : '',
                          decoration: const InputDecoration(
                              labelText: 'Age',
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
                                value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                              return 'Use only numbers!';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              age = int.parse(value);
                            });
                          },
                          onChanged: (value) {
                            setAge(int.parse(value));
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: itemPets['weight'] != ''
                              ? itemPets['weight']
                              : '',
                          decoration: const InputDecoration(
                              labelText: 'Weight',
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
                                value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                              return 'Use only numbers!';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              weight = int.parse(value);
                            });
                          },
                          onChanged: (value) {
                            setWeight(int.parse(value));
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(60)),
                          onPressed: () async {
                            if (itemPets['petId'] == '') {
                              if (_formKey.currentState!.validate()) {
                                await ConectionMongodb.changeCollection("pets");
                                await ConectionMongodb.inserData({
                                  'name': name,
                                  'breed': breed,
                                  'color': color,
                                  'age': age,
                                  'weight': weight,
                                  'profile_photo': urlPath,
                                  'user_id': await loadPreferences(),
                                });
                                await PushNotificationsManager
                                    .sendNotification2(
                                  "Registered pet",
                                  "Wellcome " + name,
                                );
                                _submit();
                                setState(() {
                                  urlPath = '';
                                });
                              }
                            } else {
                              if (_formKey.currentState!.validate()) {
                                if (name == '') {
                                  name = itemPets['name'];
                                }
                                if (breed == '') {
                                  breed = itemPets['breed'];
                                }
                                if (color == '') {
                                  color = itemPets['color'];
                                }
                                if (age == 0) {
                                  age = int.parse(itemPets['age']);
                                }
                                if (weight == 0) {
                                  weight = int.parse(itemPets['weight']);
                                }
                                if (urlPath == '') {
                                  urlPath = itemPets['profile_photo'];
                                }
                                await ConectionMongodb.changeCollection('pets');
                                await ConectionMongodb.update({
                                  "_id": itemPets['petId']
                                }, {
                                  '_id': itemPets['petId'],
                                  'name': name,
                                  'breed': breed,
                                  'color': color,
                                  'age': age,
                                  'weight': weight,
                                  'profile_photo': urlPath,
                                  'user_id': await loadPreferences()
                                });
                                SmartDialog.showToast(
                                    "Successfully edited information");
                              }
                            }
                          },
                          child:
                              Text(itemPets['petId'] != '' ? 'Edit' : 'Save'),
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
          task = uploadFile('image/${image.name}', File(image.path));
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
          task = uploadFile('image/${image.name}', File(image.path));
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
