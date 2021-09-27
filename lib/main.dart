import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libreta_de_ubicaciones/screens/form_location.dart';

import 'screens/home_page.dart';
import 'screens/location_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Libreta de GPs',
        theme: ThemeData(primarySwatch: Colors.teal),
        initialRoute: "/",
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (BuildContext context) => const MyHomePage(),
          "/details": (BuildContext context) => const DetailLocation(),
          "/form": (BuildContext context) => const FormGPS(),
        });
  }
}
