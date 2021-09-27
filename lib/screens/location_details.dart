import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:libreta_de_ubicaciones/classes/localidad.dart';

import '../db.dart';

class DetailLocation extends StatelessWidget {
  const DetailLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Localidad localidad =
        ModalRoute.of(context)!.settings.arguments as Localidad;

    return Scaffold(
      appBar: AppBar(title: Text(localidad.nombre.toString()), elevation: 10),
      body: const SafeArea(child: MyDetails()),
      floatingActionButton: SpeedDial(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          overlayColor: Colors.transparent,
          overlayOpacity: 0.0,
          icon: Icons.menu,
          foregroundColor: Colors.white,
          backgroundColor: Colors.teal,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.delete_outline, color: Colors.white),
              backgroundColor: Colors.red,
              onTap: () {
                _showdialog(context, localidad);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.edit_outlined, color: Colors.white),
              backgroundColor: Colors.lime,
              onTap: () {
                Navigator.of(context)
                    .pushNamed("/form", arguments: localidad)
                    .then((value) => Navigator.pop(context));
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.directions_car_filled_outlined,
                  color: Colors.white),
              backgroundColor: Colors.green,
              onTap: () {/* Do something */},
            ),
          ]),
    );
  }

  void _showdialog(BuildContext context, Localidad localidad) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: const Text("Advertencia"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              children: [
                ListTile(
                    title: const Text("Eliminar"),
                    onTap: () {
                      DB.delete(localidad);
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.delete_outline)),
                ListTile(
                    title: const Text("Cancelar"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.cancel_outlined)),
              ]);
        });
  }
}

class MyDetails extends StatelessWidget {
  const MyDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}
