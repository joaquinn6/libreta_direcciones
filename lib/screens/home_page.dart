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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Libreta de GPS'),
        actions: [
          AnimSearchBar(
              width: 250.0,
              closeSearchOnSuffixTap: true,
              helpText: "Buscar...",
              color: Colors.teal,
              style: const TextStyle(color: Colors.white),
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                });
              }),
        ],
        elevation: 5.0,
      ),
      body: SafeArea(child: MyBody()),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_location_alt_outlined),
          onPressed: () {
            Navigator.of(context).pushNamed("/form", arguments: Localidad());
          }),
    );
  }
}

class MyBody extends StatefulWidget {
  MyBody({Key? key}) : super(key: key);

  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<MyBody> {
  late List<Localidad> localidades = List<Localidad>.empty();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: localidades.length,
        itemBuilder: (BuildContext context, int index) {
          final localidad = localidades[index];
          return ListTile(
            title: Text(localidad.nombre.toString()),
            leading: const Icon(Icons.location_on_outlined),
            onTap: () {
              Navigator.of(context).pushNamed("/details", arguments: localidad);
            },
          );
        });
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
