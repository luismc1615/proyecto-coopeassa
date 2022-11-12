import 'package:flutter/material.dart';
import 'package:mobile_project/src/pages/login/components/rounded_button.dart';
import 'package:mobile_project/src/pages/login/components/rounded_input.dart';
import 'package:mobile_project/src/pages/login/components/rounded_password_input.dart';


class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
    required this.isLogin,
    required this.animationDuration,
    required this.size,
    required this.defaultLoginSize,
  }) : super(key: key);

  final bool isLogin;
  final Duration animationDuration;
  final Size size;
  final double defaultLoginSize;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String nameInfo = '';
  String emailInfo = '';
  String phoneInfo = '';
  String usernameInfo = '';
  String passwordInfo = '';
  void setName(String name) {
    nameInfo = name;
    setState(() {});
  }

  void setEmail(String email) {
    emailInfo = email;
    setState(() {});
  }

  void setPhone(String phone) {
    phoneInfo = phone;
    setState(() {});
  }

  void setUsername(String username) {
    usernameInfo = username;
    setState(() {});
  }

  void setPassword(String password) {
    passwordInfo = password;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLogin ? 0.0 : 1.0,
      duration: widget.animationDuration * 5,
      child: Visibility(
        visible: !widget.isLogin,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: widget.size.width,
            height: widget.defaultLoginSize,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Registro',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 40),
                  Image.asset('assets/images/user+.png'),
                  const SizedBox(height: 40),
                  RoundedInput(
                    icon: Icons.face_rounded,
                    hint: 'Nombre',
                    seter: setName,
                  ),
                  RoundedInput(
                      icon: Icons.email, hint: 'Correo electrónico', seter: setEmail),
                  RoundedInput(
                      icon: Icons.phone, hint: 'Teléfono', seter: setPhone),
                  RoundedInput(
                      icon: Icons.account_circle,
                      hint: 'Nombre de usuario',
                      seter: setUsername),
                  RoundedPasswordInput(
                    hint: 'Password',
                    seter: setPassword,
                  ),
                  const SizedBox(height: 10),
                  RoundedButton(title: 'Registrarse', obj: {
                    'name': nameInfo.trim(),
                    'email': emailInfo.trim(),
                    'phone': phoneInfo.trim(),
                    'username': usernameInfo.trim(),
                    'password': passwordInfo.trim()
                  }),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
