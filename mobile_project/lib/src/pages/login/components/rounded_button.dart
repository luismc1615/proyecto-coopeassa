import 'package:flutter/material.dart';
import 'package:mobile_project/src/utils/colors.dart';
import 'package:mobile_project/src/utils/Toast.dart';
import 'package:mobile_project/src/models/connection_mongodb.dart';
import 'package:mobile_project/src/pages/menu/menu.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mobile_project/src/utils/aes.dart';
import 'package:mobile_project/src/utils/terms.dart';
import 'CustomLoading.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    Key? key,
    required this.title,
    required this.obj,
  }) : super(key: key);

  final String title;
  Map<String, Object> obj;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        if (title == "LOGIN") {
          await ConectionMongodb.changeCollection('user');
          if (await ConectionMongodb.login(obj)) {
            SmartDialog.showLoading(
              animationType: SmartAnimationType.scale,
              builder: (_) => const CustomLoading(type: 1),
            );
            await Future.delayed(const Duration(seconds: 2));
            SmartDialog.dismiss();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MenuScreen(0)));
          }
        } else {
          if (obj['name'].toString().isEmpty ||
              obj['email'].toString().isEmpty ||
              obj['phone'].toString().isEmpty ||
              obj['username'].toString().isEmpty ||
              obj['password'].toString().isEmpty) {
            ToastType.error("There are missing fields of the form to fill");
          } else {
            if (obj['username'].toString().length < 6) {
              ToastType.error("Username must contain at least 6 characters");
            } else {
              if (Aes.mtdecrypt(obj['password'].toString()).length < 8) {
                ToastType.error(
                    "The password must contain at least 8 characters");
              } else {
                if (await ConectionMongodb.searchUser(obj) == false) {
                  SmartDialog.show(builder: (context) {
                    return Container(
                      height: 620,
                      width: 345,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 68, 66, 66),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: ListView(children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: Text(Terms.terms,
                              style: const TextStyle(
                                color: Colors.white,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(
                                          25, 150, 125, 1)),
                                  onPressed: () async {
                                    await ConectionMongodb.changeCollection(
                                        'user');
                                    ConectionMongodb.inserData(obj);
                                    SmartDialog.dismiss();
                                    SmartDialog.showToast(
                                        "User created successfully");
                                  },
                                  child: const Text("Accept")),
                              const SizedBox(width: 30),
                              ElevatedButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 252, 1, 1)),
                                  onPressed: () {
                                    SmartDialog.dismiss();
                                    SmartDialog.showToast(
                                        "To create the user must accept the terms and conditions");
                                  },
                                  child: const Text("Cancel")),
                            ],
                          ),
                        ),
                      ]),
                    );
                  });
                } else {
                  ToastType.error("Username already exist");
                }
              }
            }
          }
        }
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: kPrimaryColor,
        ),
        padding: EdgeInsets.symmetric(vertical: 20),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
