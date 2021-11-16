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

  Localidad(
      {this.id = 0,
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
      this.favorito = false});

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
      'favorito': favorito
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
      'favorito': favorito
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
    return l;
  }
}
