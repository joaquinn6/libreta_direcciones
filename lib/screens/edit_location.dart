import 'package:flutter/material.dart';

class EditGPS extends StatefulWidget {
  const EditGPS({Key? key}) : super(key: key);
  @override
  _EditGPSState createState() => _EditGPSState();
}

class _EditGPSState extends State<EditGPS> {
  late String nombre;
  late String detalle;

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Agregar Dirección'),
          actions: [
            IconButton(
                onPressed: () {
                  _saveLocation(context);
                },
                icon: const Icon(Icons.save_outlined))
          ],
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: formkey,
              child: Column(children: [
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Nombre", icon: Icon(Icons.home_outlined)),
                  onSaved: (value) {
                    nombre = value!;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Campo requerido";
                    }
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Detalle",
                      icon: Icon(Icons.directions_outlined)),
                  onSaved: (value) {
                    detalle = value!;
                  },
                  maxLines: 3,
                ),
              ]))),
    );
  }

  void _saveLocation(BuildContext context) {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
    }
  }
}
