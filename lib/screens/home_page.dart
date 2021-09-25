import 'package:flutter/material.dart';
import 'add_location.dart';
import 'location_details.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Libreta de GPS'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      body: MyBodyWidget(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_location_alt_outlined),
          onPressed: () {
            Navigator.of(context).pushNamed("/add");
          }),
    );
  }
}

class MyBodyWidget extends StatelessWidget {
  MyBodyWidget({Key? key}) : super(key: key);

  List<String> direcciones = [
    "Vet. San judas",
    "Vet. Metro",
    "Vet. Galeria",
    "Vet. Boer",
    "Vet. Esquipulas",
    "Vet. El doral",
    "Vet. Mayoreo",
    "Vet. Centro America",
    "Vet. Pilar",
    "Vet. Zumen",
    "Vet. San judas",
    "Vet. Metro",
    "Vet. Galeria",
    "Vet. Boer",
    "Vet. Esquipulas",
    "Vet. El doral",
    "Vet. Mayoreo",
    "Vet. Centro America",
    "Vet. Pilar",
    "Vet. Zumen",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: direcciones.length,
        itemBuilder: (BuildContext context, int index) {
          final name = direcciones[index];
          return ListTile(
            title: Text(name),
            leading: const Icon(Icons.push_pin),
            onTap: () {
              Navigator.of(context).pushNamed("/details", arguments: name);
            },
          );
        });
  }
}
