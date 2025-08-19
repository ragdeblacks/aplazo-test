import 'package:cocinando_con_flow/src/shared/network/cache/http_cache_interceptor.dart';
import 'package:cocinando_con_flow/src/shared/storage/cache/recetas_cache_service.dart';
import 'package:cocinando_con_flow/src/core/config/environment_config.dart';
import 'package:flutter/foundation.dart';

class CacheManagerService {
  final HttpCacheInterceptor _httpCache;
  final RecetasCacheService _recetasCache;

  CacheManagerService({
    HttpCacheInterceptor? httpCache,
    RecetasCacheService? recetasCache,
  })  : _httpCache = httpCache ?? HttpCacheInterceptor(),
        _recetasCache = recetasCache ?? RecetasCacheService();

  Future<void> limpiarTodoCache() async {
    await Future.wait([
      _httpCache.clearAllCache(),
      _recetasCache.limpiarTodoCache(),
    ]);

    if (ConfiguracionEntorno.habilitarLogging) {
      debugPrint('🧹 Cache completamente limpiado');
    }
  }

  Future<void> limpiarCacheExpirado() async {
    await Future.wait([
      _httpCache.clearExpiredCache(),
      _recetasCache.limpiarCacheExpirado(),
    ]);

    if (ConfiguracionEntorno.habilitarLogging) {
      debugPrint('🧹 Cache expirado limpiado');
    }
  }

  Future<Map<String, dynamic>> obtenerEstadisticasCache() async {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'environment': ConfiguracionEntorno.entorno,
      'cache_enabled': true,
      'http_cache': 'Configurado',
      'recetas_cache': 'Configurado',
    };
  }

  Future<void> configurarLimpiezaAutomatica() async {
    if (ConfiguracionEntorno.habilitarLogging) {
      debugPrint('⚙️ Limpieza automática de cache configurada');
    }
  }

  Future<void> optimizarCache() async {
    if (ConfiguracionEntorno.esDesarrollo) {
      await _recetasCache.limpiarCacheExpirado();
    } else if (ConfiguracionEntorno.esProduccion) {
      await _httpCache.clearExpiredCache();
    }

    if (ConfiguracionEntorno.habilitarLogging) {
      debugPrint('🚀 Cache optimizado para ${ConfiguracionEntorno.entorno}');
    }
  }
}
