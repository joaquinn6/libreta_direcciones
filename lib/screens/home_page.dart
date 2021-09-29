import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:libreta_de_ubicaciones/classes/localidad.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Libreta de GPS'),
        actions: [
          AnimSearchBar(
              width: 250.0,
              closeSearchOnSuffixTap: true,
              helpText: "Buscar...",
              color:
                  (isDark) ? const Color(0x00535353) : const Color(0xFFB5EDB3),
              style: TextStyle(color: (isDark) ? Colors.white : Colors.black),
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                });
              }),
        ],
        elevation: 5.0,
      ),
      body: SafeArea(
          child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 0.2),
              itemCount: localidades.length,
              itemBuilder: (BuildContext context, int index) {
                final localidad = localidades[index];
                return Dismissible(
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
                              onPressed: () => Navigator.of(context).pop(false),
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
                  child: Card(
                    child: ListTile(
                      title: Text(localidad.nombre.toString()),
                      leading: const Icon(Icons.location_on_outlined, size: 55),
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
  }

  cargarLocations() async {
    List<Localidad> auxLocation = await DB.localidades();

    setState(() {
      localidades = auxLocation;
    });
  }
}
