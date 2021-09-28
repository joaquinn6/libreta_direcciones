class Localidad {
  int? id;
  String nombre;
  String detalle;
  double latitude;
  double longitude;
  double accuracy;
  double altitude;
  double heading;
  int time;
  DateTime? fecha;
  String pais;
  String departamento;
  String municipio;
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
      this.time = 0,
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
      'fecha': fecha,
      'pais': pais,
      'departamento': departamento,
      'municipio': municipio,
      'favorito': false
    };
  }
}
