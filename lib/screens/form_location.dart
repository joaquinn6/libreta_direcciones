import 'package:flutter/material.dart';
import 'package:libreta_de_ubicaciones/classes/localidad.dart';
import 'package:libreta_de_ubicaciones/db.dart';

class FormGPS extends StatefulWidget {
  const FormGPS({Key? key}) : super(key: key);
  @override
  _FormGPSState createState() => _FormGPSState();
}

class _FormGPSState extends State<FormGPS> {
  late int id = 0;
  late String nombre = "";
  late String detalle = "";

  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Localidad localidad =
        ModalRoute.of(context)!.settings.arguments as Localidad;

    late String accion =
        (localidad.id > -1) ? "Editar Dirección" : "Agregar Dirección";
    late Color barColor = (localidad.id > -1) ? Colors.lime : Colors.green;
    return Scaffold(
      appBar: AppBar(
        title: Text(accion.toString()),
        elevation: 10,
        backgroundColor: barColor,
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
      Localidad localidad = Localidad(nombre: nombre, detalle: detalle);
      DB.insert(localidad);
      Navigator.pushNamed(context, "/");
    }
  }
}
