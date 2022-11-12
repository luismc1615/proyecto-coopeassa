import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mobile_project/src/notifications/push_notification_manager.dart';
import 'package:mobile_project/src/pages/menu/admin_menu.dart';
import 'package:mobile_project/src/utils/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:textfield_tags/textfield_tags.dart';

const String walkPetsRoute = '/walkPets';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case walkPetsRoute:
        return MaterialPageRoute(builder: (_) => const PetsTravel());
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
        title: "Ret Registration",
        home: PetsTravel(),
        onGenerateRoute: Router.generateRoute,
        initialRoute: walkPetsRoute);
  }
}

class PetsTravel extends StatefulWidget {
  const PetsTravel({Key? key}) : super(key: key);
  @override
  _PetsTravelState createState() => _PetsTravelState();
}

class _PetsTravelState extends State<PetsTravel> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  DateTime date = DateTime.now();
  TextEditingController Sduration = TextEditingController();
  TextEditingController Eduration = TextEditingController();
  var duration = '';
  DateTime start_Time = DateTime.now();
  DateTime end_Time = DateTime.now();
  String place = '';
  String weather = '';
  double maxValue = 0;
  String tag = '';
  late TextfieldTagsController _tagsController;
  double _distanceToField = 0;
  List<String> tags_list = [];

  @override
  void initState() {
    Sduration.text = "";
    Eduration.text = "";
    _tagsController = TextfieldTagsController();
    PushNotificationsManager().init();
    super.initState();
    //set the initial value of text field
  }

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
    super.dispose();
    PushNotificationsManager().dispose();
    _tagsController.dispose();
  }

  void setDate(DateTime dateInfo) {
    date = dateInfo;
    setState(() {});
  }

  void setPlace(String placeInfo) {
    place = placeInfo;
    setState(() {});
  }

  void setDuration(final durationInfo) {
    duration = durationInfo;
    setState(() {});
  }

  void setTag(String tagInfo) {
    tag = tagInfo;
    setState(() {});
  }

  void setWeather(String weatherInfo) {
    weather = weatherInfo;
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
                    _formKey.currentState?.reset(); // Empty the form fields
                    Sduration.text = '';
                    Eduration.text = '';
                    _tagsController.clearTags();
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
          appBar: AppBar(
            centerTitle: true,
            title: const Text("My pet's travel"),
          ),
          body: ListView(padding: const EdgeInsets.all(16.0), children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.center,
                    child: Text("Enter travel information",
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
                          labelText: "Start Time",
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
                          start_Time = intl.DateFormat.jm()
                              .parse(pickedTime.format(context).toString());
                          String formattedTime =
                              intl.DateFormat('HH:mm').format(start_Time);
                          setState(() {
                            Sduration.text = formattedTime;
                          });
                          (value) {
                            setState(() {
                              start_Time = value;
                            });
                          };
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty field';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: Eduration,
                      decoration: const InputDecoration(
                          labelText: "End Time",
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
                          end_Time = intl.DateFormat.jm()
                              .parse(pickedTime.format(context).toString());
                          String formattedTime =
                              intl.DateFormat('HH:mm').format(end_Time);
                          setState(() {
                            Eduration.text = formattedTime;
                          });
                          (value) {
                            setState(() {
                              end_Time = value;
                            });
                          };
                        }
                      },
                      onFieldSubmitted: (value) {
                        setState(() {
                          duration = Difference(start_Time, end_Time) as String;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty field';
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Weather',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Empty field';
                      } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                        return 'Weather cannot contain special characters';
                      }
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        weather = value;
                      });
                    },
                    onChanged: (value) {
                      setWeather(value);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Place',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Empty field';
                      }
                      return null;
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
                                            color:
                                                Color.fromRGBO(25, 150, 125, 1),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 6.0),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 6.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                child: Text(
                                                  tag,
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255)),
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
                          await ConectionMongodb.changeCollection("petwalk");
                          await ConectionMongodb.inserData({
                            'date': intl.DateFormat.yMd().format(date),
                            'place': place,
                            'start_time':
                                intl.DateFormat('HH:mm').format(start_Time),
                            'end_time':
                                intl.DateFormat('HH:mm').format(end_Time),
                            'weather': weather,
                            'participants': tags_list.toString(),
                            'user_id': await loadPreferences()
                          });
                          await PushNotificationsManager.sendNotification2(
                            "Registered travel",
                            "Place: " + place,
                          );
                          _submit();
                        }
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          ]),
        ));
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
