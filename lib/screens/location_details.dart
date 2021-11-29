import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../providers/location_provider.dart';
import '../components/super_actionbuttom.dart';

class DetailLocation extends StatelessWidget {
  const DetailLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocalidadProvider>(context);
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(provider.localidad!.nombre.toString()),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              ListTile(
                  title: SelectableText(provider.localidad!.nombre.toString()),
                  subtitle:
                      SelectableText(provider.localidad!.detalle.toString())),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Card(
                  elevation: 5.0,
                  child: SizedBox(
                      height: 400.0,
                      child: FlutterMap(
                        options: MapOptions(
                          center: LatLng(provider.localidad!.latitude!,
                              provider.localidad!.longitude!),
                          zoom: 15.0,
                        ),
                        layers: [
                          TileLayerOptions(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                            attributionBuilder: (_) {
                              return Text("© OpenStreetMap contributors");
                            },
                          ),
                          MarkerLayerOptions(
                            markers: [
                              Marker(
                                width: 90.0,
                                height: 90.0,
                                point: LatLng(provider.localidad!.latitude!,
                                    provider.localidad!.longitude!),
                                builder: (ctx) => Container(
                                  child: Icon(Icons.location_pin,
                                      color: Color(0xFF3C6448)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: Text(provider.localidad!.departamento! +
                    ' - ' +
                    provider.localidad!.municipio!),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ExpandableFab(
        distance: 160.0,
        children: [
          ActionButton(
            onPressed: () => {
              launchWaze(
                  provider.localidad!.latitude, provider.localidad!.longitude),
            },
            tooltiptext: 'Waze',
            icon: Icon(Icons.directions_car_filled_outlined,
                color: (isDark)
                    ? Color.fromARGB(255, 0, 158, 158)
                    : Color.fromARGB(255, 100, 216, 224)),
          ),
          ActionButton(
            onPressed: () => {
              launchMaps(
                  provider.localidad!.latitude, provider.localidad!.longitude),
            },
            tooltiptext: 'Maps',
            icon: Icon(Icons.directions_car_filled_outlined,
                color: (isDark)
                    ? Color.fromARGB(255, 99, 226, 82)
                    : Color.fromARGB(255, 5, 109, 5)),
          ),
          ActionButton(
            onPressed: () => {
              launchMoovit(
                  provider.localidad!.latitude, provider.localidad!.longitude),
            },
            tooltiptext: 'Moovit',
            icon: Icon(Icons.directions_bus_filled_outlined,
                color: (isDark)
                    ? Color.fromARGB(255, 255, 130, 81)
                    : Color.fromARGB(255, 230, 87, 5)),
          ),
          ActionButton(
            onPressed: () => {
              provider.isEditing = true,
              Navigator.of(context).pushNamed("/form"),
            },
            tooltiptext: 'Editar',
            icon: Icon(Icons.edit_outlined,
                color: (isDark)
                    ? Color.fromARGB(255, 190, 185, 185)
                    : Color.fromARGB(255, 92, 89, 89)),
          ),
          ActionButton(
            onPressed: () => {},
            tooltiptext: 'Compartir',
            icon: Icon(Icons.share_outlined,
                color: (isDark)
                    ? Color.fromARGB(255, 76, 230, 230)
                    : Color.fromARGB(255, 0, 151, 161)),
          ),
          ActionButton(
            onPressed: () => {},
            tooltiptext: 'Eliminar',
            icon: Icon(Icons.delete_outline,
                color: (isDark) ? Color(0xFFFC2206) : Color(0xFF8A1506)),
          ),
        ],
      ),
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
