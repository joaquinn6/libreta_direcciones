import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:libreta_de_ubicaciones/classes/localidad.dart';

class DetailLocation extends StatelessWidget {
  const DetailLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Localidad localidad =
        ModalRoute.of(context)!.settings.arguments as Localidad;
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(localidad.nombre.toString()),
        elevation: 10,
      ),
      body: SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          leading: const Icon(Icons.directions_outlined),
          title: Text(localidad.detalle.toString()),
        ),
      ])),
      floatingActionButton: SpeedDial(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          overlayColor: Colors.transparent,
          overlayOpacity: 0.0,
          icon: Icons.menu,
          backgroundColor:
              (isDark) ? const Color(0xFF3C6448) : const Color(0xFFB5EDB3),
          children: [
            SpeedDialChild(
              child: Icon(Icons.edit_outlined,
                  color: (isDark) ? Colors.white : Colors.black),
              backgroundColor: const Color(0xAAC3F5E4),
              onTap: () {
                Navigator.of(context)
                    .pushNamed("/form", arguments: localidad)
                    .then((value) => Navigator.pop(context));
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.directions_car_filled_outlined,
                  color: (isDark) ? Colors.white : Colors.black),
              backgroundColor: const Color(0xFF3E938F),
              onTap: () {/* Do something */},
            ),
          ]),
    );
  }
}
