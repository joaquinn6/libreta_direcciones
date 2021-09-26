import 'package:flutter/material.dart';

class DetailLocation extends StatelessWidget {
  const DetailLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
          title: Text(name.toString()),
          actions: [
            IconButton(
                onPressed: () {
                  _showdialog(context);
                },
                icon: const Icon(Icons.delete_outline)),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    "/edit",
                  );
                },
                icon: const Icon(Icons.edit_outlined))
          ],
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      body: MyForm(),
    );
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
  MyForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}
