import 'package:libreta_de_ubicaciones/screens/location_form.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/location_provider.dart';
import 'screens/location_details.dart';
import 'screens/home_page.dart';
import 'themes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocalidadProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Libreta de GPs',
        theme: lightTheme,
        darkTheme: darkTheme,
        initialRoute: "/",
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('es')
        ],
        routes: {
          "/": (BuildContext context) => const MyHomePage(),
          "/details": (BuildContext context) => const DetailLocation(),
          "/form": (BuildContext context) => const FormGPS(),
        });
  }
}
