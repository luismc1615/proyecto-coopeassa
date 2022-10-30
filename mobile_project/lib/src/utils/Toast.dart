import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastType {
  static error(mensaje) {
    Fluttertoast.showToast(
        msg: mensaje,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
