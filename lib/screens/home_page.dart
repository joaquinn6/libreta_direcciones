import 'dart:convert';
import 'dart:io';

import 'package:libreta_de_ubicaciones/classes/localidad.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:share/share.dart';

import '../components/snakbar.dart';
import '../providers/location_provider.dart';
import '../components/alert_dialog.dart';
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
    final provider = Provider.of<LocalidadProvider>(context);
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    bool isDark = brightnessValue == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color:
                  (isDark) ? const Color(0xFF3C6448) : const Color(0xFFB5EDB3),
            ),
            child: Text(
              'Opciones',
              style: TextStyle(
                color: (isDark)
                    ? const Color(0xFFF6F8F7)
                    : const Color(0xFF101110),
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.share_outlined),
            title: Text('Compartir'),
            subtitle: Text('Guarda o comparte tus locaciones'),
            onTap: () {
              saveLocations();
            },
          ),
          ListTile(
            leading: Icon(Icons.import_export_outlined),
            title: Text('Importar'),
            subtitle: Text('Recupera tus localidades'),
            onTap: () {
              importLocatios();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline_rounded),
            title: Text('Eliminar todo'),
            subtitle: Text('Elimina todas tus localidades'),
            onTap: () {
              eliminarTodo();
            },
          ),
        ],
      )),
      appBar: AppBar(
        title: const Text('Libreta de GPS'),
        actions: [
          AnimSearchBar(
              width: 250.0,
              closeSearchOnSuffixTap: true,
              autoFocus: true,
              helpText: "Buscar...",
              color:
                  (isDark) ? const Color(0xFF3C6448) : const Color(0xFFB5EDB3),
              style: TextStyle(color: (isDark) ? Colors.white : Colors.black),
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                });
              }),
        ],
        elevation: 2.0,
      ),
      body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(height: 0.0),
          itemCount: localidades.length,
          itemBuilder: (BuildContext context, int index) {
            final localidad = localidades[index];
            return Card(
              child: Dismissible(
                key: Key(localidad.id.toString()),
                background: Container(
                  color: (isDark) ? Color(0xFF8A1506) : Color(0xFFFC2206),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: const <Widget>[
                        Icon(Icons.delete_outline, color: Colors.white),
                        Text('Eliminar', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                confirmDismiss: (DismissDirection direction) async {
                  return await alertDialog(
                      context: context,
                      titulo: "Confirmar",
                      contenido: "¿Desea eliminar la localidad?");
                },
                onDismissed: (direction) {
                  DB.delete(localidad);
                  cargarLocations();
                },
                child: GFListTile(
                  title: Text(localidad.nombre.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  subTitle: Text(
                      localidad.departamento.toString() +
                          '-' +
                          localidad.municipio.toString(),
                      style: TextStyle(
                        fontSize: 13,
                      )),
                  description: Text(localidad.detalle.toString()),
                  avatar: ClipOval(
                    child: SizedBox(
                      height: 75,
                      width: 75,
                      child: FlutterMap(
                        options: MapOptions(
                          allowPanningOnScrollingParent: false,
                          enableScrollWheel: false,
                          allowPanning: false,
                          center:
                              LatLng(localidad.latitude!, localidad.longitude!),
                          zoom: 14.0,
                        ),
                        layers: [
                          TileLayerOptions(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayerOptions(
                            markers: [
                              Marker(
                                width: 90.0,
                                height: 90.0,
                                point: LatLng(
                                    localidad.latitude!, localidad.longitude!),
                                builder: (ctx) => Container(
                                  child: Icon(Icons.location_pin,
                                      color: Color(0xFF3C6448)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    provider.isEditing = false;
                    provider.localidad = localidad;
                    Navigator.of(context)
                        .pushNamed("/details")
                        .then((value) => cargarLocations());
                  },
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_location_alt_outlined,
              color: (isDark) ? Colors.white : Colors.black),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            provider.isEditing = false;
            provider.textLocalidad = '';
            provider.departamento = '';
            provider.municipio = '';
            Navigator.of(context)
                .pushNamed("/form")
                .then((value) => cargarLocations());
          }),
    );
  }

  @override
  void initState() {
    super.initState();
    cargarLocations();
    textController.addListener(cargarLocations);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void cargarLocations() async {
    List<Localidad> auxLocation = await DB.localidades(textController.text);

    setState(() {
      localidades = auxLocation;
    });
  }

  void saveLocations() async {
    if (await storagePermission()) {
      List<Localidad> locasiones = await DB.localidades("");
      String jsonLocasiones = jsonEncode(locasiones);
      String nameFile = await pathFileName();
      if (nameFile != '') {
        File file = File(nameFile);
        await file.writeAsString('$jsonLocasiones');
        print('SAVED in $nameFile');
        DateTime fecha = DateTime.now();

        String fechaparseada = fecha.toIso8601String();

        Share.shareFiles([nameFile], text: 'Mis puntos-$fechaparseada');
      }
    }
  }

  void eliminarTodo() async {
    try {
      var confirm = (await alertDialog(
          context: context,
          titulo: "Confirmar",
          contenido: "¿Desea eliminar la localidad?"))!;
      if (confirm) {
        DB.deleteAll();
        cargarLocations();
        Navigator.of(context).pop();
        final sb = MySnackBar(
            context: context,
            contenido: 'Localidades eliminadas',
            color: const Color(0xFF3C6448));
        ScaffoldMessenger.of(context).showSnackBar(sb);
      }
    } on Exception catch (_) {
      final sb = MySnackBar(
          context: context,
          contenido: 'Eliminacion fallida',
          color: const Color(0xFF8A1506));
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }
  }

  Future<bool> storagePermission() async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      return true;
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
      return false;
    } else if (await Permission.storage.request().isDenied) {
      return false;
    }
    if (await Permission.storage.request().isGranted) {
      return true;
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
      return false;
    } else if (await Permission.storage.request().isDenied) {
      return false;
    }
    return false;
  }

  Future<String> pathFileName() async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      String pathDirectory = directory.path;
      String pathWithNameFile = '$pathDirectory/MP-respaldo.json';
      return pathWithNameFile;
    }
    return '';
  }

  Future<void> importLocatios() async {
    try {
      if (await storagePermission()) {
        File? file = await getFile();

        if (file != null) {
          final contents = await file.readAsString();
          List<Localidad> localidades = listGenerate(contents);
          if (localidades.length > 0) {
            for (var localidad in localidades) {
              DB.insert(localidad);
            }
            cargarLocations();
            Navigator.of(context).pop();
            final sb = MySnackBar(
                context: context,
                contenido: 'Localidades importadas correctamente',
                color: const Color(0xFF3C6448));
            ScaffoldMessenger.of(context).showSnackBar(sb);
          }
        }
      }
    } on Exception catch (_) {
      final sb = MySnackBar(
          context: context,
          contenido: 'Importacion fallida',
          color: const Color(0xFF8A1506));
      ScaffoldMessenger.of(context).showSnackBar(sb);
    }
  }

  Future<File?> getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      String? path = result.files.single.path;
      return File(path!);
    }
    return null;
  }

  List<Localidad> listGenerate(stringLocalidades) {
    Iterable jsonLocalidades = jsonDecode(stringLocalidades);
    return List<Localidad>.from(
        jsonLocalidades.map((model) => Localidad.fromJson(model)));
  }
}
