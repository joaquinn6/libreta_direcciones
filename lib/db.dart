import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'classes/localidad.dart';

class DB {
  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'localidad.db'),
        onCreate: (db, version) {
      return db.execute(
        """CREATE TABLE localidades (
          id INTEGER PRIMARY KEY, 
          nombre VARCHAR(100), 
          detalle VARCHAR(500),
          latitude REAL,
          longitude REAL,
          accuracy REAL,
          altitude REAL,
          heading REAL,
          time REAL,
          fecha TEXT,
          pais VARCHAR(50),
          departamento VARCHAR(50),
          municipio VARCHAR(50),
          favorito INTEGER
          )""",
      );
    }, version: 1);
  }

  static Future<int> insert(Localidad localidad) async {
    Database database = await _openDB();

    return database.insert("localidades", localidad.toMap());
  }

  static Future<int> update(Localidad localidad) async {
    Database database = await _openDB();

    return database.update("localidades", localidad.toMap(),
        where: "id = ?", whereArgs: [localidad.id]);
  }

  static Future<int> delete(Localidad localidad) async {
    Database database = await _openDB();

    return database
        .delete("localidades", where: "id = ?", whereArgs: [localidad.id]);
  }

  static Future<List<Localidad>> localidades() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> locationsMap =
        await database.query("localidades");

    return List.generate(
      locationsMap.length,
      (i) => Localidad(
          id: locationsMap[i]['id'],
          nombre: locationsMap[i]['nombre'],
          detalle: locationsMap[i]['detalle'],
          latitude: locationsMap[i]['latitude'],
          longitude: locationsMap[i]['longitude'],
          accuracy: locationsMap[i]['accuracy'],
          altitude: locationsMap[i]['altitude'],
          heading: locationsMap[i]['heading'],
          time: locationsMap[i]['time'],
          fecha: DateTime.parse(locationsMap[i]['fecha']),
          pais: locationsMap[i]['pais'],
          departamento: locationsMap[i]['departamento'],
          municipio: locationsMap[i]['municipio'],
          favorito: (locationsMap[i]['favorito'] == 0) ? false : true),
    );
  }
}
