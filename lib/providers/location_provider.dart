import 'package:flutter/material.dart';

import '../classes/localidad.dart';

class LocalidadProvider with ChangeNotifier {
  bool _isEditing = false;
  Localidad? _localidad = null;
  String _textLocalidad = '';
  String _departamento = '';

  bool get isEditing => _isEditing;
  Localidad? get localidad => _localidad;
  String get textLocalidad => _textLocalidad;
  String get departamento => _departamento;

  set isEditing(bool edit) {
    this._isEditing = edit;
    notifyListeners();
  }

  set localidad(Localidad? loc) {
    this._localidad = loc;
    this._textLocalidad =
        loc!.latitude.toString() + ", " + loc.longitude.toString();
    this._departamento = loc.departamento!;
    notifyListeners();
  }

  set textLocalidad(String text) {
    this._textLocalidad = text;
    notifyListeners();
  }

  set departamento(String text) {
    this._departamento = text;
    notifyListeners();
  }
}
