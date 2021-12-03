import 'package:flutter/material.dart';

SnackBar MySnackBar(
    {required BuildContext context,
    required String contenido,
    required Color color}) {
  return SnackBar(
    content: Text(
      contenido,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: color,
    elevation: 15,
  );
}
