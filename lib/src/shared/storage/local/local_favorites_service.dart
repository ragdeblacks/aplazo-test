import 'package:shared_preferences/shared_preferences.dart';

class LocalFavoritesService {
  static const String _keyFavoritos = 'recetas_favoritas_ids';

  Future<SharedPreferences> _prefs() async => SharedPreferences.getInstance();

  Future<Set<String>> obtenerFavoritos() async {
    final prefs = await _prefs();
    final lista = prefs.getStringList(_keyFavoritos) ?? <String>[];
    return lista.toSet();
  }

  Future<bool> esFavorito(String id) async {
    final favoritos = await obtenerFavoritos();
    return favoritos.contains(id);
  }

  Future<void> agregar(String id) async {
    final prefs = await _prefs();
    final actuales = (prefs.getStringList(_keyFavoritos) ?? <String>[])..add(id);
    await prefs.setStringList(_keyFavoritos, actuales.toSet().toList());
  }

  Future<void> quitar(String id) async {
    final prefs = await _prefs();
    final actuales = (prefs.getStringList(_keyFavoritos) ?? <String>[])..remove(id);
    await prefs.setStringList(_keyFavoritos, actuales.toSet().toList());
  }
}
