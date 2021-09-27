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
      appBar: AppBar(
        title: Text(localidad.nombre.toString()),
        elevation: 10,
        backgroundColor: Colors.cyan,
      ),
      body: const SafeArea(child: MyDetails()),
      floatingActionButton: SpeedDial(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          overlayColor: Colors.transparent,
          overlayOpacity: 0.0,
          icon: Icons.menu,
          backgroundColor: const Color(0xffF5E0C3),
          children: [
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
}

class MyDetails extends StatelessWidget {
  const MyDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}
