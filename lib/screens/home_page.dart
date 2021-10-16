import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:libreta_de_ubicaciones/classes/localidad.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';

import '../db.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = TextEditingController();

  late List<Localidad> localidades = List<Localidad>.empty();

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor:
            (isDark) ? const Color(0xFF3C6448) : const Color(0xFFB5EDB3),
        statusBarColor:
            (isDark) ? const Color(0xFF3C6448) : const Color(0xFFB5EDB3)));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Libreta de GPS'),
        actions: [
          AnimSearchBar(
              width: 250.0,
              closeSearchOnSuffixTap: true,
              helpText: "Buscar...",
              color:
                  (isDark) ? const Color(0xFF3C6448) : const Color(0xFFB5EDB3),
              style: TextStyle(color: (isDark) ? Colors.white : Colors.black),
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                });
              }),
        ],
        elevation: 2.0,
      ),
      body: SafeArea(
          child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 0.2),
              itemCount: localidades.length,
              itemBuilder: (BuildContext context, int index) {
                final localidad = localidades[index];
                return Card(
                  child: Dismissible(
                    key: Key(localidad.id.toString()),
                    background: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: const <Widget>[
                            Icon(Icons.delete_outline, color: Colors.white),
                            Text('Eliminar',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmación"),
                            content: const Text(
                                "Seguro que desea eliminar esta Dirección"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Cancelar"),
                              ),
                              ElevatedButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Eliminar")),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      DB.delete(localidad);
                      cargarLocations();
                    },
                    child: ListTile(
                      title: Text(localidad.nombre.toString()),
                      leading: ClipOval(
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: FlutterMap(
                            options: MapOptions(
                              allowPanningOnScrollingParent: false,
                              enableScrollWheel: false,
                              allowPanning: false,
                              center: LatLng(
                                  localidad.latitude!, localidad.longitude!),
                              zoom: 14.0,
                            ),
                            layers: [
                              TileLayerOptions(
                                urlTemplate:
                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c'],
                                attributionBuilder: (_) {
                                  return Text("©");
                                },
                              ),
                              MarkerLayerOptions(
                                markers: [
                                  Marker(
                                    width: 90.0,
                                    height: 90.0,
                                    point: LatLng(localidad.latitude!,
                                        localidad.longitude!),
                                    builder: (ctx) => Container(
                                      child: Icon(Icons.location_pin,
                                          color: Color(0xFF3C6448)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      subtitle: Text(localidad.detalle.toString()),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed("/details", arguments: localidad)
                            .then((value) => cargarLocations());
                      },
                    ),
                  ),
                );
              })),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_location_alt_outlined,
              color: (isDark) ? Colors.white : Colors.black),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.of(context)
                .pushNamed("/form", arguments: Localidad())
                .then((value) => cargarLocations());
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    cargarLocations();
    textController.addListener(cargarLocations);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void cargarLocations() async {
    List<Localidad> auxLocation = await DB.localidades(textController.text);

    setState(() {
      localidades = auxLocation;
    });
  }
}
