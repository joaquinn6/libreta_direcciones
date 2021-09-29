import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';
import 'package:libreta_de_ubicaciones/classes/localidad.dart';
import 'package:url_launcher/url_launcher.dart';

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
        elevation: 2.0,
      ),
      body: SafeArea(
          child: Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
              title: Text(localidad.nombre.toString()),
              subtitle: Text(localidad.detalle.toString())),
          SizedBox(
              height: 200.0,
              child: StaticMap(
                  width: 400,
                  height: 200,
                  scaleToDevicePixelRatio: true,
                  googleApiKey: "AIzaSyDUDgMaA3eOZIK7Kg__BPUNZ-Gxqlp_FQY",
                  markers: <Marker>[
                    Marker(
                      color: const Color(0xFF3C6448),
                      locations: [
                        Location(localidad.latitude!, localidad.longitude!),
                      ],
                    ),
                  ])),
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerLeft,
            child: Text(localidad.departamento!),
          ),
        ]),
      )),
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
              label: "Waze",
              child: Icon(Icons.directions_car_filled_outlined,
                  color: (isDark) ? Colors.white : Colors.black),
              backgroundColor: const Color(0xFF3AD6CE),
              onTap: () {
                launchWaze(localidad.latitude, localidad.longitude);
              },
            ),
            SpeedDialChild(
              label: "Maps",
              child: Icon(Icons.directions_car_filled_outlined,
                  color: (isDark) ? Colors.white : Colors.black),
              backgroundColor: const Color(0xFF3E938F),
              onTap: () {
                launchMaps(localidad.latitude, localidad.longitude);
              },
            ),
            SpeedDialChild(
              label: "Moovit",
              child: Icon(Icons.directions_bus_filled_outlined,
                  color: (isDark) ? Colors.white : Colors.black),
              backgroundColor: const Color(0xFFF89F2B),
              onTap: () {
                launchMoovit(localidad.latitude, localidad.longitude);
              },
            )
          ]),
    );
  }

  Future<void> launchWaze(double? lat, double? lng) async {
    var url = 'waze://?ll=${lat.toString()},${lng.toString()}';
    var fallbackUrl =
        'https://waze.com/ul?ll=${lat.toString()},${lng.toString()}&navigate=yes';
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  Future<void> launchMoovit(double? lat, double? lng) async {
    var url = 'moovit://nearby?lat=${lat.toString()}&lon=${lng.toString()}';
    var fallbackUrl = 'http://app.appsflyer.com/com.tranzmate?pid=DL&c=';
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  Future<void> launchMaps(double? lat, double? lng) async {
    var url = 'google.navigation:q=${lat.toString()},${lng.toString()}';
    var fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}';
    try {
      bool launched =
          await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }
}
