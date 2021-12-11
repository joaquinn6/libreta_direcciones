import 'package:libreta_de_ubicaciones/static/static_lists.dart';
import 'package:libreta_de_ubicaciones/classes/localidad.dart';
import 'package:libreta_de_ubicaciones/db.dart';
import '../components/snakbar.dart';
import '../providers/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';

class FormGPS extends StatefulWidget {
  const FormGPS({Key? key}) : super(key: key);
  @override
  _FormGPSState createState() => _FormGPSState();
}

class _FormGPSState extends State<FormGPS> {
  final formkey = GlobalKey<FormState>();
  late String nombre = "";
  late String detalle = "";
  late String telefono = "";
  late String notas = "";
  late LocationData? ubicacion = null;
  final controllerDepto = TextEditingController();
  final controllerMuni = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocalidadProvider>(context);
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            (provider.isEditing) ? "Editar Dirección" : "Agregar Dirección"),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: formkey,
                child: Column(children: [
                  TextFormField(
                    autofocus: true,
                    decoration: const InputDecoration(
                        labelText: "Nombre", icon: Icon(Icons.home_outlined)),
                    onSaved: (value) {
                      nombre = value!;
                    },
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 100,
                    initialValue: (provider.isEditing)
                        ? provider.localidad!.nombre.toString()
                        : '',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo requerido";
                      }
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Dirección",
                        icon: Icon(Icons.directions_outlined)),
                    initialValue: (provider.isEditing)
                        ? provider.localidad!.detalle.toString()
                        : '',
                    textCapitalization: TextCapitalization.sentences,
                    maxLength: 500,
                    maxLines: 5,
                    minLines: 1,
                    onSaved: (value) {
                      detalle = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Teléfono", icon: Icon(Icons.call_outlined)),
                    initialValue: (provider.isEditing)
                        ? provider.localidad!.telefono.toString()
                        : '',
                    keyboardType: TextInputType.phone,
                    maxLength: 20,
                    onSaved: (value) {
                      telefono = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Notas", icon: Icon(Icons.notes_outlined)),
                    initialValue: (provider.isEditing)
                        ? provider.localidad!.notas.toString()
                        : '',
                    maxLength: 500,
                    maxLines: 5,
                    minLines: 1,
                    onSaved: (value) {
                      notas = value!;
                    },
                  ),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return departamentos
                          .where((String departamento) => departamento
                              .toLowerCase()
                              .startsWith(textEditingValue.text.toLowerCase()))
                          .toList();
                    },
                    fieldViewBuilder: (BuildContext context,
                        controllerDepto,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      controllerDepto.text = provider.departamento;
                      return TextField(
                        controller: controllerDepto,
                        focusNode: fieldFocusNode,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                            labelText: "Departamento",
                            icon: Icon(Icons.location_city_outlined)),
                        onChanged: (value) => {
                          if (value == '')
                            {
                              provider.departamento = '',
                            }
                        },
                      );
                    },
                    onSelected: (String departamentoSelected) {
                      provider.departamento = departamentoSelected;
                      provider.municipio = '';
                    },
                  ),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return municipios[provider.departamento]!
                          .where((String municipio) => municipio
                              .toLowerCase()
                              .startsWith(textEditingValue.text.toLowerCase()))
                          .toList();
                    },
                    fieldViewBuilder: (BuildContext context,
                        controllerMuni,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      controllerMuni.text = provider.municipio;
                      return TextField(
                        controller: controllerMuni,
                        focusNode: fieldFocusNode,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                            labelText: "Municipio",
                            icon: Icon(Icons.location_city_outlined)),
                        onChanged: (value) => {
                          if (value == '')
                            {
                              provider.municipio = '',
                            }
                        },
                      );
                    },
                    onSelected: (String municipioSelected) {
                      provider.municipio = municipioSelected;
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: ElevatedButton(
                        onPressed: () => _findLocation(provider),
                        child: Column(
                          children: [
                            const Text('Obtener ubicación'),
                            const Icon(Icons.location_searching_outlined),
                          ],
                        )),
                  ),
                  Center(
                    child: Text(provider.textLocalidad),
                  ),
                ]))),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Guardar cambios",
          child: Icon(Icons.save_outlined,
              color: (isDark) ? Colors.white : Colors.black),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            _saveLocation(context, provider);
          }),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controllerDepto.dispose();
    controllerMuni.dispose();
    super.dispose();
  }

  void _saveLocation(BuildContext context, provider) {
    Localidad localidad = Localidad();

    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      localidad.nombre = nombre;
      localidad.detalle = detalle;
      localidad.telefono = telefono;
      localidad.notas = notas;
      localidad.departamento = provider.departamento;
      localidad.municipio = provider.municipio;
      if (ubicacion != null) {
        localidad.latitude = ubicacion!.latitude;
        localidad.longitude = ubicacion!.longitude;
        localidad.accuracy = ubicacion!.accuracy;
        localidad.altitude = ubicacion!.altitude;
        localidad.heading = ubicacion!.heading;
        localidad.time = ubicacion!.time;
      } else if (provider.isEditing) {
        localidad.latitude = provider.localidad!.latitude;
        localidad.longitude = provider.localidad!.longitude;
        localidad.accuracy = provider.localidad!.accuracy;
        localidad.altitude = provider.localidad!.altitude;
        localidad.heading = provider.localidad!.heading;
        localidad.time = provider.localidad!.time;
      } else {
        final sb = MySnackBar(
            context: context,
            contenido: 'Obtenga su ubicación con el boton para poder guardar',
            color: const Color(0xFF8A1506));
        ScaffoldMessenger.of(context).showSnackBar(sb);
        return;
      }
      if (provider.isEditing) {
        localidad.id = provider.localidad!.id;
        localidad.fecha = provider.localidad!.fecha;
        DB.update(localidad);
      } else {
        localidad.fecha = DateTime.now();
        DB.insert(localidad);
      }
      provider.isEditing = false;
      provider.localidad = localidad;
      Navigator.pop(context);
    }
  }

  _findLocation(provider) async {
    Location location = Location();

    if (await locationPermission(location) && await locationService(location)) {
      LocationData _locationData;
      _locationData = await location.getLocation();
      provider.textLocalidad = _locationData.latitude.toString() +
          ", " +
          _locationData.longitude.toString();
      setState(() {
        ubicacion = _locationData;
      });
    }
  }

  Future<bool> locationPermission(Location location) async {
    PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<bool> locationService(Location location) async {
    bool _serviceEnabled;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    return true;
  }
}
