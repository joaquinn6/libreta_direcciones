class Localidad {
  int? id;
  String nombre;
  String detalle;

  Localidad({this.id = 0, this.nombre = "", this.detalle = ""});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre, 'detalle': detalle};
  }
}
