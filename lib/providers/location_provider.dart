import 'package:flutter/material.dart';

import '../classes/localidad.dart';
import '../static/static_lists.dart';

class LocalidadProvider with ChangeNotifier {
  bool _isEditing = false;
  Localidad? _localidad = null;
  String _textLocalidad = '';
  String _departamento = '';
  String _municipio = '';
  List<String> _suggestions = [];

  bool get isEditing => _isEditing;
  Localidad? get localidad => _localidad;
  String get textLocalidad => _textLocalidad;
  String get departamento => _departamento;
  String get municipio => _municipio;
  List<String> get suggestions => _suggestions;

  set isEditing(bool edit) {
    this._isEditing = edit;
    notifyListeners();
  }

  set localidad(Localidad? loc) {
    this._localidad = loc;
    this._textLocalidad =
        loc!.latitude.toString() + ", " + loc.longitude.toString();
    this._departamento = loc.departamento!;
    this._municipio = loc.municipio!;
    this._suggestions = extractSuggestions(loc.departamento!);
    notifyListeners();
  }

  set textLocalidad(String text) {
    this._textLocalidad = text;
    notifyListeners();
  }

  set departamento(String text) {
    this._departamento = text;
    this._suggestions = extractSuggestions(text);
    notifyListeners();
  }

  set municipio(String text) {
    this._municipio = text;
    notifyListeners();
  }

  List<String> extractSuggestions(text) {
    if (text != '') {
      return municipios[text]!;
    } else {
      return [];
    }
  }
}
