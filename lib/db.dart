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
          detalle VARCHAR(500)
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
            detalle: locationsMap[i]['detalle']));
  }
}
