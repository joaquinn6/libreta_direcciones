import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'classes/localidad.dart';

class DB {
  static List<String> initScript = [
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
            favorito INTEGER,
            notas VARCHAR(500),
            telefono VARCHAR(15),
            )""",
  ];

  static List<List<String>> migrationScripts = [
    [
      "ALTER TABLE localidades ADD notas VARCHAR(500) DEFAULT '';",
      "ALTER TABLE localidades ADD telefono VARCHAR(15) DEFAULT '';"
    ]
  ];

  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'localidad.db'),
        version: migrationScripts.length + 1, onCreate: (db, version) {
      initScript.forEach((script) async => await db.execute(script));
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      for (var i = oldVersion - 1; i < newVersion - 1; i++) {
        migrationScripts[i].forEach((script) async => await db.execute(script));
      }
    });
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

  static deleteAll() async {
    Database database = await _openDB();

    return database.execute(
      """DELETE FROM localidades;""",
    );
  }

  static Future<List<Localidad>> localidades(String search) async {
    Database database = await _openDB();
    List<Map<String, dynamic>> locationsMap = await database.query((search
            .isEmpty)
        ? "localidades"
        : "localidades WHERE nombre LIKE '%$search%' or detalle LIKE '%$search%' or departamento LIKE '$search%' or municipio LIKE '$search%' or notas LIKE '$search%'");

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
        favorito: (locationsMap[i]['favorito'] == 0) ? false : true,
        notas: locationsMap[i]['notas'],
        telefono: locationsMap[i]['telefono'],
      ),
    );
  }

  static Future<List<Map<String, dynamic>>> localidadesMap() async {
    Database database = await _openDB();
    List<Map<String, dynamic>> locationsMap =
        await database.query("localidades");

    return locationsMap;
  }
}
