import 'package:flutter/material.dart';

Future<bool?> alertDialog(
    {required BuildContext context,
    required String titulo,
    required String contenido}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
        content: Text(contenido),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Eliminar")),
        ],
      );
    },
  );
}
