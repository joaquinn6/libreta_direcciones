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
                onPressed: () {}, icon: const Icon(Icons.delete_outline)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined))
          ],
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
