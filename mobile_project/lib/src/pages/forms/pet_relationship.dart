import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/pages/principal_pages/relationships_pet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String RelationshipsPetFormPageRoute = '/relationshipsPetForm';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RelationshipsPetFormPageRoute:
        return MaterialPageRoute(builder: (_) => const RelationshipsPetForm());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('404 Not found')),
                ));
    }
  }
}

class MyApp extends StatefulWidget {
  static const String ROUTE = "/relationshipsPetForm";
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Relationship Registration",
        home: RelationshipsPetForm(),
        onGenerateRoute: Router.generateRoute,
        initialRoute: RelationshipsPetFormPageRoute);
  }
}

class RelationshipsPetForm extends StatefulWidget {
  const RelationshipsPetForm({Key? key}) : super(key: key);
  @override
  _RelationshipsPetFormState createState() => _RelationshipsPetFormState();
}

class _RelationshipsPetFormState extends State<RelationshipsPetForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String name = '';
  String breed = '';
  String color = '';
  int age = 0;
  String relationship = '';
  String urlPath = '';

  final ImagePicker _imagePicker = ImagePicker();
  final storage =
      FirebaseStorage.instanceFor(bucket: 'gs://homepets-c02ac.appspot.com')
          .ref();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  loadPreferences() async {
    SharedPreferences _petId = await SharedPreferences.getInstance();
    return _petId.getString('petId');
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

  void setRelationship(String relationshipInfo) {
    relationship = relationshipInfo;
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
    final itemRelationship = ModalRoute.of(context)!.settings.arguments as Map;
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RelationshipsPet(itemRelationship['namePet'])));
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text("Relationship Registration")),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Column(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Enter your pet relationship",
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
                        urlPath == '' && itemRelationship['profile_photo'] != ''
                            ? CircleAvatar(
                                radius: 120,
                                backgroundImage: NetworkImage(
                                    itemRelationship['profile_photo']),
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
                            child: Text(itemRelationship['profile_photo'] != ''
                                ? 'Edit profile photo'
                                : 'Add profile photo')),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: itemRelationship['name'] != ''
                              ? itemRelationship['name']
                              : '',
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
                          initialValue: itemRelationship['breed'] != ''
                              ? itemRelationship['breed']
                              : '',
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
                          initialValue: itemRelationship['color'] != ''
                              ? itemRelationship['color']
                              : '',
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
                          initialValue: itemRelationship['age'] != ''
                              ? itemRelationship['age']
                              : '',
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
                          initialValue: itemRelationship['relationship'] != ''
                              ? itemRelationship['relationship']
                              : '',
                          decoration: const InputDecoration(
                              labelText: 'Relationship',
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
                              return 'Relationship must contain at least 3 characters';
                            } else if (value
                                .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                              return 'Relationship cannot contain special characters';
                            }
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              relationship = value.capitalize();
                            });
                          },
                          onChanged: (value) {
                            setRelationship(value);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(60)),
                          onPressed: () async {
                            if (itemRelationship['relationship_id'] == '') {
                              if (_formKey.currentState!.validate()) {
                                await ConectionMongodb.changeCollection(
                                    "relationshipspets");
                                await ConectionMongodb.inserData({
                                  'name': name,
                                  'breed': breed,
                                  'color': color,
                                  'age': age,
                                  'relationship': relationship,
                                  'profile_photo': urlPath,
                                  'pet_id': await loadPreferences(),
                                });
                                _submit();
                                setState(() {
                                  urlPath = '';
                                });
                              }
                            } else {
                              if (_formKey.currentState!.validate()) {
                                if (name == '') {
                                  name = itemRelationship['name'];
                                }
                                if (breed == '') {
                                  breed = itemRelationship['breed'];
                                }
                                if (color == '') {
                                  color = itemRelationship['color'];
                                }
                                if (age == 0) {
                                  age = int.parse(itemRelationship['age']);
                                }
                                if (relationship == '') {
                                  relationship =
                                      itemRelationship['relationship'];
                                }
                                if (urlPath == '') {
                                  urlPath = itemRelationship['profile_photo'];
                                }
                                await ConectionMongodb.changeCollection(
                                    'relationshipspets');
                                await ConectionMongodb.update({
                                  "_id": itemRelationship['relationship_id']
                                }, {
                                  '_id': itemRelationship['relationship_id'],
                                  'name': name,
                                  'breed': breed,
                                  'color': color,
                                  'age': age,
                                  'relationship': relationship,
                                  'profile_photo': urlPath,
                                  'pet_id': await loadPreferences()
                                });
                                SmartDialog.showToast(
                                    "Successfully edited information");
                              }
                            }
                          },
                          child: Text(itemRelationship['relationship_id'] != ''
                              ? 'Edit'
                              : 'Save'),
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
