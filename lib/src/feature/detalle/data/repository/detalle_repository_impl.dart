import 'package:cocinando_con_flow/src/feature/detalle/domain/repository/detalle_repository.dart';
import 'package:cocinando_con_flow/src/feature/detalle/data/services/detalle_api_service.dart';
import 'package:cocinando_con_flow/src/shared/domain/entities/entities.dart';
import 'package:cocinando_con_flow/src/shared/storage/local/local_favorites_service.dart';

class DetalleRepositoryImpl implements DetalleRepository {
  final DetalleApiService _apiService;
  final LocalFavoritesService _favoritesService;

  DetalleRepositoryImpl({
    required DetalleApiService apiService,
    required LocalFavoritesService favoritesService,
  })  : _apiService = apiService,
        _favoritesService = favoritesService;

  @override
  Future<RecetaEntity?> obtenerRecetaPorId(String id) async {
    try {
      final recetaModel = await _apiService.obtenerRecetaPorId(id);
      if (recetaModel == null) return null;

      final esFavorito = await _favoritesService.esFavorito(id);
      final recetaEntity = recetaModel.toEntity(esFavorito: esFavorito);
      return recetaEntity;
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
