import 'package:flutter/material.dart';
import 'package:mobile_project/src/pages/login/components/rounded_button.dart';
import 'package:mobile_project/src/pages/login/components/rounded_input.dart';
import 'package:mobile_project/src/pages/login/components/rounded_password_input.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
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
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String usernameInfo = '';
  String passwordInfo = '';

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
      opacity: widget.isLogin ? 1.0 : 0.0,
      duration: widget.animationDuration * 4,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: widget.size.width,
          height: widget.defaultLoginSize,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset('assets/images/logo-coopeassa-rl.png'),
                const SizedBox(height: 40),
                RoundedInput(
                    icon: Icons.account_circle,
                    hint: 'Username',
                    seter: setUsername),
                RoundedPasswordInput(hint: 'PasswordLogin', seter: setPassword),
                const SizedBox(height: 10),
                RoundedButton(
                    title: 'LOGIN',
                    obj: {'username': usernameInfo, 'password': passwordInfo}),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
