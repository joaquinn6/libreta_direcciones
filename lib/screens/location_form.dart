import 'package:flutter/material.dart';
import 'package:libreta_de_ubicaciones/classes/localidad.dart';
import 'package:libreta_de_ubicaciones/db.dart';

class FormGPS extends StatefulWidget {
  const FormGPS({Key? key}) : super(key: key);
  @override
  _FormGPSState createState() => _FormGPSState();
}

class _FormGPSState extends State<FormGPS> {
  late String nombre = "";
  late String detalle = "";
  late Localidad localidad;
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    localidad = ModalRoute.of(context)!.settings.arguments as Localidad;

    late String accion =
        (localidad.id! > 0) ? "Editar Dirección" : "Agregar Dirección";
    return Scaffold(
      appBar: AppBar(
        title: Text(accion.toString()),
        elevation: 10,
      ),
      body: SafeArea(
          child: Padding(
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
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 100,
                      initialValue: localidad.nombre.toString(),
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
                      initialValue: localidad.detalle.toString(),
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 500,
                      maxLines: 5,
                      minLines: 1,
                      onSaved: (value) {
                        detalle = value!;
                      },
                    ),
                  ])))),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save_outlined),
          onPressed: () {
            _saveLocation(context);
          }),
    );
  }

  void _saveLocation(BuildContext context) {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      localidad.nombre = nombre;
      localidad.detalle = detalle;
      if (localidad.id! > 0) {
        DB.update(localidad);
      } else {
        localidad.id = null;
        DB.insert(localidad);
      }
      Navigator.pop(context);
    }
  }
}
