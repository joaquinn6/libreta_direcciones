import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

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
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      body: SafeArea(child: MyBodyWidget()),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_location_alt_outlined),
          onPressed: () {
            Navigator.of(context).pushNamed("/add");
          }),
    );
  }
}

// ignore: must_be_immutable
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
            leading: const Icon(Icons.location_on_outlined),
            onTap: () {
              Navigator.of(context).pushNamed("/details", arguments: name);
            },
          );
        });
  }
}
