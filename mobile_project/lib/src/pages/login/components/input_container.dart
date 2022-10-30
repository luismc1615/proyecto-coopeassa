import 'package:flutter/material.dart';
import 'package:mobile_project/src/utils/colors.dart';

class InputContainer extends StatelessWidget {
  const InputContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: size.width * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: kPrimaryColor/* .withAlpha(DateTime.now().hour > 18 || DateTime.now().hour < 6 ? 130 : 50) */),
        child: child);
  }
}
