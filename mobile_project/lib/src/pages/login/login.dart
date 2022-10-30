import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_project/src/utils/colors.dart';
import 'package:mobile_project/src/pages/login/components/cancel_button.dart';
import 'forms/login_form.dart';
import 'forms/register_form.dart';

class LoginScreen extends StatefulWidget {
  static const String ROUTE = "/";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin = true;
  late Animation<double> containerSize;
  AnimationController? animationController;
  Duration animationDuration = Duration(milliseconds: 270);

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double viewInset = MediaQuery.of(context)
        .viewInsets
        .bottom; // we are using this to determine Keyboard is opened or not
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    containerSize =
        Tween<double>(begin: size.height * 0.1, end: defaultRegisterSize)
            .animate(CurvedAnimation(
                parent: animationController!, curve: Curves.linear));

    return WillPopScope(
        onWillPop: () async {
          exit(0);
        },
        child: Scaffold(
          backgroundColor: /* DateTime.now().hour > 18 || DateTime.now().hour < 6
              ? const Color.fromARGB(255, 17, 17, 17)
              : */ const Color.fromARGB(255, 241, 240, 240),
          body: Stack(
            children: [
              // Lets add some decorations
              Positioned(
                  top: 100,
                  right: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: kPrimaryColor),
                  )),

              Positioned(
                  top: -50,
                  left: -50,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: kPrimaryColor),
                  )),

              // Cancel Button
              CancelButton(
                isLogin: isLogin,
                animationDuration: animationDuration,
                size: size,
                animationController: animationController,
                tapEvent: isLogin
                    ? null
                    : () {
                        // returning null to disable the button
                        animationController!.reverse();
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
              ),

              // Login Form
              LoginForm(
                  isLogin: isLogin,
                  animationDuration: animationDuration,
                  size: size,
                  defaultLoginSize: defaultLoginSize),

              // Register Container
              AnimatedBuilder(
                animation: animationController!,
                builder: (context, child) {
                  if (viewInset == 0 && isLogin) {
                    return buildRegisterContainer();
                  } else if (!isLogin) {
                    return buildRegisterContainer();
                  }

                  // Returning empty container to hide the widget
                  return Container();
                },
              ),

              // Register Form
              RegisterForm(
                  isLogin: isLogin,
                  animationDuration: animationDuration,
                  size: size,
                  defaultLoginSize: defaultRegisterSize),
            ],
          ),
        ));
  }

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(100),
              topRight: Radius.circular(100),
            ),
            color: kBackgroundColor),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !isLogin
              ? null
              : () {
                  animationController!.forward();

                  setState(() {
                    isLogin = !isLogin;
                  });
                },
          child: isLogin
              ? Text(
                  "¿No tiene una cuenta? Registrese",
                  style: TextStyle(color: kPrimaryColor, fontSize: 18),
                )
              : null,
        ),
      ),
    );
  }
}
