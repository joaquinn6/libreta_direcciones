import 'package:flutter/material.dart';
import 'package:libreta_de_ubicaciones/classes/localidad.dart';
import 'package:libreta_de_ubicaciones/db.dart';
import 'package:location/location.dart';
import 'package:libreta_de_ubicaciones/static/static_lists.dart';
import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';

class FormGPS extends StatefulWidget {
  const FormGPS({Key? key}) : super(key: key);
  @override
  _FormGPSState createState() => _FormGPSState();
}

class _FormGPSState extends State<FormGPS> {
  final deptokey = GlobalKey<AutoCompleteTextFieldState<String>>();
  final formkey = GlobalKey<FormState>();
  late Localidad localidad;
  late String nombre = "";
  late String detalle = "";
  late String departamento = "";
  late LocationData? ubicacion;
  late String stringLocation = "";
  final _controller_ubicacion = TextEditingController();
  final _controller_depto = TextEditingController();
  String current_depto = "";
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    localidad = ModalRoute.of(context)!.settings.arguments as Localidad;

    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    //TO DO: colocar el depto y la localizacion con los controller y poner un if por si se debe colocar en el rebuild o no
    isEdit = ((localidad.id! > 0)) ? true : false;
    late String accion = (isEdit) ? "Editar Dirección" : "Agregar Dirección";
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
                    SimpleAutoCompleteTextField(
                      key: deptokey,
                      decoration: const InputDecoration(
                          labelText: "Departamento",
                          icon: Icon(Icons.location_city_outlined)),
                      controller: _controller_depto,
                      suggestions: departamentos,
                      textChanged: (text) => current_depto = text,
                      clearOnSubmit: false,
                      textSubmitted: (text) => setState(() {
                        if (text != "") {
                          departamento = text;
                        }
                      }),
                    ),
                    TextFormField(
                        controller: _controller_ubicacion,
                        readOnly: true,
                        decoration: const InputDecoration(
                            labelText: "Lolcalización",
                            icon: Icon(Icons.location_on_outlined)),
                        maxLines: 5,
                        minLines: 1,
                        validator: (value) {
                          if (value!.isEmpty || value == "0.0, 0.0") {
                            return "Campo requerido, presione el boton";
                          }
                        },
                        onSaved: (value) {
                          stringLocation = value!;
                        }),
                    ElevatedButton(
                        onPressed: () => _findLocation(isEdit),
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
    _controller_ubicacion.dispose();
    _controller_depto.dispose();
    super.dispose();
  }

  void _saveLocation(BuildContext context) {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      localidad.nombre = nombre;
      localidad.detalle = detalle;
      if (!isEdit) {
        localidad.latitude = ubicacion!.latitude;
        localidad.longitude = ubicacion!.longitude;
        localidad.accuracy = ubicacion!.accuracy;
        localidad.altitude = ubicacion!.altitude;
        localidad.heading = ubicacion!.heading;
        localidad.time = ubicacion!.time;
        localidad.fecha = DateTime.now();
      }
      localidad.departamento = departamento;

      if (isEdit) {
        DB.update(localidad);
      } else {
        localidad.id = null;
        DB.insert(localidad);
      }
      Navigator.pop(context);
    }
  }

  _findLocation(bool isEdit) async {
    if (!isEdit) {
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
        _controller_ubicacion.text = _locationData.latitude.toString() +
            ", " +
            _locationData.longitude.toString();
      });
    }
  }
}
