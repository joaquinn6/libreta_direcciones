class Localidad {
  int? id;
  String? nombre;
  String? detalle;
  double? latitude;
  double? longitude;
  double? accuracy;
  double? altitude;
  double? heading;
  double? time;
  DateTime? fecha;
  String? pais;
  String? departamento;
  String? municipio;
  bool favorito;
  String? notas;
  String? telefono;

  Localidad({
    this.id,
    this.nombre = "",
    this.detalle = "",
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.accuracy = 0.0,
    this.altitude = 0.0,
    this.heading = 0.0,
    this.time = 0.0,
    this.fecha,
    this.pais = "Nicaragua",
    this.departamento = "",
    this.municipio = "",
    this.favorito = false,
    this.notas = "",
    this.telefono = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'detalle': detalle,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'heading': heading,
      'time': time,
      'fecha': fecha!.toString(),
      'pais': pais,
      'departamento': departamento,
      'municipio': municipio,
      'favorito': favorito,
      'notas': notas,
      'telefono': telefono,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'detalle': detalle,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'heading': heading,
      'time': time,
      'fecha': fecha!.toString(),
      'pais': pais,
      'departamento': departamento,
      'municipio': municipio,
      'favorito': favorito,
      'telefono': telefono,
      'notas': notas,
    };
  }

  static fromJson(model) {
    Localidad l = new Localidad();
    l.id = null;
    l.nombre = model['nombre'];
    l.detalle = model['detalle'];
    l.latitude = model['latitude'];
    l.longitude = model['longitude'];
    l.accuracy = model['accuracy'];
    l.altitude = model['altitude'];
    l.heading = model['heading'];
    l.time = model['time'];
    l.fecha = DateTime.now();
    l.pais = model['pais'];
    l.departamento = model['departamento'];
    l.municipio = model['municipio'];
    l.favorito = model['favorito'];
    l.notas = model['notas'];
    l.telefono = model['telefono'];
    return l;
  }

  static List<List<dynamic>> toCsv(List<Localidad> localidades) {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("Nombre");
    row.add("Dirección");
    row.add("Notas");
    row.add("Teléfono");
    row.add("País");
    row.add("Departamento");
    row.add("Municipio");
    row.add("Fecha");
    row.add("Latitud");
    row.add("Longitud");
    rows.add(row);

    for (int i = 0; i < localidades.length; i++) {
      List<dynamic> row = [];
      row.add(localidades[i].nombre);
      row.add(localidades[i].detalle);
      row.add(localidades[i].notas);
      row.add(localidades[i].telefono);
      row.add(localidades[i].pais);
      row.add(localidades[i].departamento);
      row.add(localidades[i].municipio);
      row.add(localidades[i].fecha!.toString().split(' ')[0]);
      row.add(localidades[i].latitude);
      row.add(localidades[i].longitude);
      rows.add(row);
    }
    return rows;
  }
}
