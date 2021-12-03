import 'package:flutter/material.dart';

Future<bool?> alertDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirmación"),
        content: const Text("Seguro que desea eliminar esta Dirección"),
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
