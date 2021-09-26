import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class DetailLocation extends StatelessWidget {
  const DetailLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
          title: Text(name.toString()),
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      body: SafeArea(child: MyForm()),
      floatingActionButton: const FBExpand(),
    );
  }
}

class FBExpand extends StatelessWidget {
  const FBExpand({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        overlayColor: Colors.transparent,
        overlayOpacity: 0.0,
        icon: Icons.menu,
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.delete_outline, color: Colors.white),
            label: 'Borrar',
            backgroundColor: Colors.red,
            onTap: () {
              _showdialog(context);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit_outlined, color: Colors.white),
            label: 'Editar',
            backgroundColor: Colors.lime,
            onTap: () {
              Navigator.of(context).pushNamed(
                "/edit",
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.directions_car_filled_outlined,
                color: Colors.white),
            label: 'Ir',
            backgroundColor: Colors.green,
            onTap: () {/* Do something */},
          ),
        ]);
  }

  void _showdialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: const Text("Advertencia"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              children: [
                ListTile(
                    title: const Text("Eliminar"),
                    onTap: () {},
                    leading: const Icon(Icons.delete_outline)),
                ListTile(
                    title: const Text("Cancelar"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.cancel_outlined)),
              ]);
        });
  }
}

class MyForm extends StatelessWidget {
  const MyForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}
