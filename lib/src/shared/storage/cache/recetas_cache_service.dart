import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cocinando_con_flow/src/shared/domain/entities/entities.dart';

class RecetasCacheService {
  static const String _keyCacheRecetas = 'cache_recetas';
  static const String _keyCacheTimestamp = 'cache_timestamp';
  static const Duration _expirationTime = Duration(minutes: 5);

  Future<SharedPreferences> _prefs() async => SharedPreferences.getInstance();

  final Map<String, List<RecetaEntity>> _memoryCache = {};
  final Map<String, DateTime> _memoryCacheTimestamps = {};

  Future<List<RecetaEntity>?> obtenerRecetasCache(String key) async {
    if (_memoryCache.containsKey(key) && _isValidInMemory(key)) {
      return _memoryCache[key];
    }

    final prefs = await _prefs();
    final cacheData = prefs.getString('${_keyCacheRecetas}_$key');
    final timestamp = prefs.getInt('$_keyCacheTimestamp$key');

    if (cacheData != null && timestamp != null) {
      final cacheAge = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp));
      if (cacheAge < _expirationTime) {
        final recetas = _parseRecetasFromJson(cacheData);
        _memoryCache[key] = recetas;
        _memoryCacheTimestamps[key] = DateTime.now();
        return recetas;
      }
    }

    return null;
  }

  Future<void> guardarRecetasCache(String key, List<RecetaEntity> recetas) async {
    _memoryCache[key] = recetas;
    _memoryCacheTimestamps[key] = DateTime.now();

    final prefs = await _prefs();
    final cacheData = _serializeRecetasToJson(recetas);
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    await prefs.setString('${_keyCacheRecetas}_$key', cacheData);
    await prefs.setInt('$_keyCacheTimestamp$key', timestamp);
  }

  Future<List<RecetaEntity>?> obtenerBusquedaCache(String query) async {
    final normalizedQuery = query.trim().toLowerCase();
    return await obtenerRecetasCache('busqueda_$normalizedQuery');
  }

  Future<void> guardarBusquedaCache(String query, List<RecetaEntity> recetas) async {
    final normalizedQuery = query.trim().toLowerCase();
    await guardarRecetasCache('busqueda_$normalizedQuery', recetas);
  }

  bool _isValidInMemory(String key) {
    if (!_memoryCacheTimestamps.containsKey(key)) return false;
    final age = DateTime.now().difference(_memoryCacheTimestamps[key]!);
    return age < _expirationTime;
  }

  Future<void> limpiarCacheExpirado() async {
    final prefs = await _prefs();
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_keyCacheTimestamp)) {
        final timestamp = prefs.getInt(key);
        if (timestamp != null) {
          final age = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp));
          final cacheKey = key.replaceFirst(_keyCacheTimestamp, '');
          const expiration = _expirationTime;
          
          if (age >= expiration) {
            await prefs.remove('${_keyCacheRecetas}_$cacheKey');
            await prefs.remove(key);
          }
        }
      }
    }

    final expiredKeys = <String>[];
    for (final entry in _memoryCacheTimestamps.entries) {
      if (!_isValidInMemory(entry.key)) {
        expiredKeys.add(entry.key);
      }
    }
    for (final key in expiredKeys) {
      _memoryCache.remove(key);
      _memoryCacheTimestamps.remove(key);
    }
  }

  Future<void> limpiarTodoCache() async {
    final prefs = await _prefs();
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_keyCacheRecetas) || key.startsWith(_keyCacheTimestamp)) {
        await prefs.remove(key);
      }
    }

    _memoryCache.clear();
    _memoryCacheTimestamps.clear();
  }

  String _serializeRecetasToJson(List<RecetaEntity> recetas) {
    final List<Map<String, dynamic>> jsonList = recetas.map((r) => {
      'id': r.id,
      'nombre': r.nombre,
      'imagen': r.imagen,
      'categoria': r.categoria,
      'area': r.area,
      'instrucciones': r.instrucciones,
      'ingredientes': r.ingredientes,
      'medidas': r.medidas,
      'esFavorito': r.esFavorito,
    }).toList();
    
    return jsonEncode(jsonList);
  }

  List<RecetaEntity> _parseRecetasFromJson(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => RecetaEntity(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      imagen: json['imagen'],
      categoria: json['categoria'],
      area: json['area'],
      instrucciones: json['instrucciones'],
      ingredientes: List<String>.from(json['ingredientes'] ?? []),
      medidas: List<String>.from(json['medidas'] ?? []),
      esFavorito: json['esFavorito'] ?? false,
    )).toList();
  }
}
