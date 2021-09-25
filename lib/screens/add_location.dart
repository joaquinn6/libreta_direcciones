import 'package:flutter/material.dart';

class AddGPS extends StatelessWidget {
  const AddGPS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Agregar Dirección'),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
      body: MyForm(),
    );
  }
}

class MyForm extends StatelessWidget {
  MyForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}
