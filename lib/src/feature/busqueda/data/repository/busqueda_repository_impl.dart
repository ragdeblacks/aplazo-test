import 'package:cocinando_con_flow/src/feature/busqueda/domain/repository/busqueda_repository.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/data/services/busqueda_api_service.dart';
import 'package:cocinando_con_flow/src/shared/domain/entities/entities.dart';
import 'package:cocinando_con_flow/src/shared/storage/local/local_favorites_service.dart';
import 'package:cocinando_con_flow/src/shared/storage/cache/recetas_cache_service.dart';

class BusquedaRepositoryImpl implements BusquedaRepository {
  final BusquedaApiService _apiService;
  final LocalFavoritesService _favoritesService;
  final RecetasCacheService _cacheService;

  BusquedaRepositoryImpl({
    required BusquedaApiService apiService,
    required LocalFavoritesService favoritesService,
    required RecetasCacheService cacheService,
  })  : _apiService = apiService,
        _favoritesService = favoritesService,
        _cacheService = cacheService;

  @override
  Future<List<RecetaEntity>> buscarRecetasPorNombre(String nombre) async {
    try {
      // Verificar cache primero
      final cachedData = await _cacheService.obtenerBusquedaCache(nombre);
      if (cachedData != null) {
        return cachedData;
      }

      // Si no hay cache, llamar API
      final recetasModel = await _apiService.buscarRecetasPorNombre(nombre);
      
      final recetasConFavoritos = await Future.wait(
        recetasModel.map((model) async {
          final esFavorito = await _favoritesService.esFavorito(model.idMeal);
          return model.toEntity(esFavorito: esFavorito);
        }),
      );
      
      // Guardar en cache si hay resultados
      if (recetasConFavoritos.isNotEmpty) {
        await _cacheService.guardarBusquedaCache(nombre, recetasConFavoritos);
      }
      
      return recetasConFavoritos;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> agregarAFavoritos(String recetaId) async {
    await _favoritesService.agregar(recetaId);
  }

  @override
  Future<void> quitarDeFavoritos(String recetaId) async {
    await _favoritesService.quitar(recetaId);
  }

  @override
  Future<bool> esFavorito(String recetaId) async {
    return await _favoritesService.esFavorito(recetaId);
  }
}
