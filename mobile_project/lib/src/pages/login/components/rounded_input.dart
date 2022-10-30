import 'package:flutter/material.dart';
import 'package:mobile_project/src/utils/colors.dart';
import '../components/input_container.dart';

class RoundedInput extends StatelessWidget {
  Function seter;

  RoundedInput(
      {Key? key, required this.icon, required this.hint, required this.seter})
      : super(key: key);

  final IconData icon;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
        child: TextField(
      onChanged: (value) {
        seter(value);
      },
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
          icon: Icon(icon, color: kPrimaryColor),
          hintText: hint,
          hintStyle: TextStyle(
              color: DateTime.now().hour > 18 || DateTime.now().hour < 6
                  ? const Color.fromARGB(255, 185, 185, 185)
                  : const Color.fromARGB(255, 32, 30, 30)),
          border: InputBorder.none),
      style: TextStyle(
          color: DateTime.now().hour > 18 || DateTime.now().hour < 6
              ? Colors.white
              : Colors.black),
    ));
  }
}
