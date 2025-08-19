
import '../../domain/repository/home_repository.dart';
import '../../domain/entities/receta_lista_entity.dart';
import '../services/home_api_service.dart';
import 'package:cocinando_con_flow/src/shared/storage/cache/recetas_cache_service.dart';
import 'package:cocinando_con_flow/src/shared/storage/local/local_favorites_service.dart';
import 'package:cocinando_con_flow/src/shared/domain/entities/entities.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApiService _apiService;
  final RecetasCacheService _cacheService;
  final LocalFavoritesService _favoritesService;

  HomeRepositoryImpl({
    required HomeApiService apiService,
    required RecetasCacheService cacheService,
    required LocalFavoritesService favoritesService,
  })  : _apiService = apiService,
        _cacheService = cacheService,
        _favoritesService = favoritesService;

  @override
  Future<List<RecetaListaEntity>> obtenerRecetas({
    int pagina = 1,
    int limite = 20,
  }) async {
    try {
      final cacheKey = 'home_recetas_$pagina';
      final cachedData = await _cacheService.obtenerRecetasCache(cacheKey);
      
      if (cachedData != null) {
        final recetas = cachedData.map((receta) => RecetaListaEntity(
          id: receta.id,
          nombre: receta.nombre,
          imagen: receta.imagen,
          categoria: receta.categoria,
          area: receta.area,
        )).toList();
        await _actualizarEstadoFavoritos(recetas);
        return recetas;
      }

      final recetas = await _apiService.obtenerRecetas(
        pagina: pagina,
        limite: limite,
      );

      if (recetas.isNotEmpty) {
        await _cacheService.guardarRecetasCache(
          cacheKey,
          recetas.map((receta) => RecetaEntity(
            id: receta.id,
            nombre: receta.nombre,
            imagen: receta.imagen,
            categoria: receta.categoria,
            area: receta.area,
          )).toList(),
        );
      }

      await _actualizarEstadoFavoritos(recetas);
      return recetas;
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



  Future<void> _actualizarEstadoFavoritos(List<RecetaListaEntity> recetas) async {
    for (int i = 0; i < recetas.length; i++) {
      final esFavorito = await _favoritesService.esFavorito(recetas[i].id);
      if (esFavorito != recetas[i].esFavorito) {
        recetas[i] = recetas[i].copyWith(esFavorito: esFavorito);
      }
    }
  }
}
