import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libreta_de_ubicaciones/screens/location_form.dart';

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
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: const MaterialColor(
            0xffF5E0C3,
            <int, Color>{
              50: Colors.black,
              100: Colors.blue,
              200: Colors.orange,
              300: Colors.brown,
              400: Colors.yellow,
              500: Colors.gray,
              600: Color(0xffF5E0C3),
              700: Color(0xffC9A87C),
              800: Color(0xffB28E5E),
              900: Color(0xff936F3E)
            },
          ),
          canvasColor: Colors.red,
        ),
        initialRoute: "/",
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (BuildContext context) => const MyHomePage(),
          "/details": (BuildContext context) => const DetailLocation(),
          "/form": (BuildContext context) => const FormGPS(),
        });
  }
}
