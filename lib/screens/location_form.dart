import 'package:flutter/material.dart';
import 'package:libreta_de_ubicaciones/classes/localidad.dart';
import 'package:libreta_de_ubicaciones/db.dart';
import 'package:location/location.dart';
import 'package:libreta_de_ubicaciones/static/static_lists.dart';

class FormGPS extends StatefulWidget {
  const FormGPS({Key? key}) : super(key: key);
  @override
  _FormGPSState createState() => _FormGPSState();
}

class _FormGPSState extends State<FormGPS> {
  late String nombre = "";
  late String detalle = "";
  late String stringLocation = "";
  late Localidad localidad;
  final formkey = GlobalKey<FormState>();
  late LocationData? ubicacion;
  late List<String>? municipiosData = [];
  final _controller = TextEditingController();

  late String? _selectedCity;

  @override
  Widget build(BuildContext context) {
    localidad = ModalRoute.of(context)!.settings.arguments as Localidad;
    stringLocation =
        localidad.latitude.toString() + ", " + localidad.longitude.toString();

    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
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
                    TextFormField(
                        controller: _controller,
                        readOnly: true,
                        decoration: const InputDecoration(
                            labelText: "Lolcalización",
                            icon: Icon(Icons.location_on_outlined)),
                        maxLines: 5,
                        minLines: 1,
                        onSaved: (value) {
                          stringLocation = value!;
                        }),
                    ElevatedButton(
                        onPressed: () => _findLocation(),
                        child: const Icon(Icons.location_searching_outlined)),
                  ])))),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save_outlined,
              color: (isDark) ? Colors.white : Colors.black),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            _saveLocation(context);
          }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  _findLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      ubicacion = _locationData;
      _controller.text = _locationData.latitude.toString() +
          ", " +
          _locationData.longitude.toString();
    });
  }

  void _loadDeptos(String selection) {
    if (selection.isNotEmpty) {
      setState(() {
        municipiosData = municipios[selection];
      });
    }
  }
}
