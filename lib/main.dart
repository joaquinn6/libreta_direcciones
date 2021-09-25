import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_page.dart';
import 'screens/add_location.dart';
import 'screens/location_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Libreta de GPS',
        theme: ThemeData(primarySwatch: Colors.teal),
        initialRoute: "/",
        routes: {
          "/": (BuildContext context) => const MyHomePage(),
          "/details": (BuildContext context) => const DetailLocation(),
          "/add": (BuildContext context) => const AddGPS(),
        });
  }
}
