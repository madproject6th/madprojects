import 'package:flutter/foundation.dart';

class FavoritesStore extends ChangeNotifier {
  FavoritesStore._();

  static final FavoritesStore instance = FavoritesStore._();

  final Set<String> _doctorNames = <String>{};

  bool isFavorite(String doctorName) => _doctorNames.contains(doctorName);

  Set<String> get all => Set.unmodifiable(_doctorNames);

  void toggle(String doctorName) {
    if (_doctorNames.contains(doctorName)) {
      _doctorNames.remove(doctorName);
    } else {
      _doctorNames.add(doctorName);
    }
    notifyListeners();
  }
}

