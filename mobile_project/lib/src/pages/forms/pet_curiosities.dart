import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mobile_project/src/notifications/push_notification_manager.dart';
import 'package:mobile_project/src/pages/menu/admin_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textfield_tags/textfield_tags.dart';

const String myhomepageRoute = '/';
const String myprofileRoute = 'profile';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case myhomepageRoute:
        return MaterialPageRoute(builder: (_) => const PetCuriosities());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text('404 Not found')),
                ));
    }
  }
}

// ignore: camel_case_types
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: "Ret Registration",
        home: PetCuriosities(),
        onGenerateRoute: Router.generateRoute,
        initialRoute: myhomepageRoute);
  }
}

class PetCuriosities extends StatefulWidget {
  const PetCuriosities({Key? key}) : super(key: key);
  @override
  _PetCuriositiesState createState() => _PetCuriositiesState();
}

class _PetCuriositiesState extends State<PetCuriosities> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  DateTime date = DateTime.now();
  String description = '';
  String place = '';
  String tag = '';
  String title = '';
  double _distanceToField = 0;
  late TextfieldTagsController _tagsController;
  // ignore: non_constant_identifier_names
  List<String> tags_list = [];

  loadPreferences() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('id');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    PushNotificationsManager().dispose();
    super.dispose();
    _tagsController.dispose();
  }

  @override
  void initState() {
    PushNotificationsManager().init();

    super.initState();
    _tagsController = TextfieldTagsController();
  }

  void setDate(DateTime dateInfo) {
    date = dateInfo;
    setState(() {});
  }

  void setPlace(String placeInfo) {
    place = placeInfo;
    setState(() {});
  }

  void setDescription(String descriptionInfo) {
    description = descriptionInfo;
    setState(() {});
  }

  void setTitle(String titleInfo) {
    title = titleInfo;
    setState(() {});
  }

  void setTag(String tagInfo) {
    tag = tagInfo;
    setState(() {});
  }

  void _submit() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user can tap anywhere to close the pop up
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
                    _formKey.currentState?.reset();
                    _tagsController.clearTags();
                    // Empty the form fields
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
              context, MaterialPageRoute(builder: (context) => MenuScreen(2)));
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Curiosities of my pet"),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const Align(
                        alignment: Alignment.center,
                        child: Text("Enter curiosities information",
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
                        decoration: const InputDecoration(
                            labelText: 'Title',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Empty field';
                          }
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                        onChanged: (value) {
                          setTitle(value);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Description',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Empty field';
                          }
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            description = value;
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
                        decoration: const InputDecoration(
                            labelText: 'Place',
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Empty field';
                          } else if (value
                              .contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                            return 'Place cannot contain special characters';
                          }
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            place = value;
                          });
                        },
                        onChanged: (value) {
                          setPlace(value);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 14.0, top: 14.0),
                        child: const Text(
                          "Participating pets",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 20.0),
                        ),
                      ),
                      TextFieldTags(
                        textfieldTagsController: _tagsController,
                        textSeparators: const [' ', ','],
                        letterCase: LetterCase.normal,
                        validator: (String tag) {
                          if (_tagsController.getTags!.contains(tag)) {
                            return 'You already entered that';
                          }
                          return null;
                        },
                        inputfieldBuilder:
                            (context, tec, fn, error, onChanged, onSubmitted) {
                          return ((context, sc, tags, onTagDelete) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: TextField(
                                controller: tec,
                                focusNode: fn,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(25, 150, 125, 1),
                                      width: 3.0,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(25, 150, 125, 1),
                                      width: 3.0,
                                    ),
                                  ),
                                  helperStyle: const TextStyle(
                                    color: Color.fromRGBO(25, 150, 125, 1),
                                  ),
                                  hintText: _tagsController.hasTags
                                      ? ''
                                      : "Enter pets...",
                                  errorText: error,
                                  prefixIconConstraints: BoxConstraints(
                                      maxWidth: _distanceToField * 0.74),
                                  prefixIcon: tags.isNotEmpty
                                      ? SingleChildScrollView(
                                          controller: sc,
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: tags.map((String tag) {
                                            tags_list = tags.toList();
                                            return Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                                color: Color.fromRGBO(
                                                    25, 150, 125, 1),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6.0),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 6.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    child: Text(
                                                      tag,
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255)),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  InkWell(
                                                    child: const Icon(
                                                      Icons.cancel,
                                                      size: 17.0,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                    ),
                                                    onTap: () {
                                                      onTagDelete(tag);
                                                    },
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList()),
                                        )
                                      : null,
                                ),
                                onChanged: onChanged,
                                onSubmitted: onSubmitted,
                              ),
                            );
                          });
                        },
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(25, 150, 125, 1),
                          ),
                        ),
                        onPressed: () {
                          _tagsController.clearTags();
                        },
                        child: const Text('Remove participants'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(60)),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (tags_list.isEmpty) {
                              SmartDialog.showToast("Add participating pets");
                            } else {
                              await ConectionMongodb.changeCollection(
                                  "curiositiespet");
                              await ConectionMongodb.inserData({
                                'title': title,
                                'description': description,
                                'date': intl.DateFormat.yMd().format(date),
                                'place': place,
                                'participants': tags_list.toString(),
                                'user_id': await loadPreferences()
                              });
                              await PushNotificationsManager.sendNotification2(
                                "Registered curiosity",
                                "Title: " + title,
                              );
                              _submit();
                            }
                          }
                        },
                        child: const Text("Save"),
                      ),
                    ],
                  ),
                )
              ],
            )));
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
