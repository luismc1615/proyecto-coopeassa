import 'package:flutter/material.dart';
import 'package:mobile_project/src/utils/colors.dart';
import 'package:mobile_project/src/utils/aes.dart';
import '../components/input_container.dart';

class RoundedPasswordInput extends StatelessWidget {
  Function seter;
  RoundedPasswordInput({Key? key, required this.hint, required this.seter})
      : super(key: key);

  final String hint;

  @override
  Widget build(BuildContext context) {
    return InputContainer(
        child: TextField(
            onChanged: (value) {
              if (hint == 'PasswordLogin') {
                seter(value);
              } else {
                seter(Aes.mtencrypt(value));
              }
            },
            cursorColor: kPrimaryColor,
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(Icons.lock, color: kPrimaryColor),
                hintText: 'Password',
                hintStyle: TextStyle(
                    color: /* DateTime.now().hour > 18 || DateTime.now().hour < 6
                        ? const Color.fromARGB(255, 185, 185, 185)
                        : */ Color.fromARGB(255, 129, 126, 126)),
                border: InputBorder.none),
            style: TextStyle(
                color: /* DateTime.now().hour > 18 || DateTime.now().hour < 6
                    ? Colors.white
                    : */ Colors.black)));
  }
}
