import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cocinando_con_flow/src/feature/home/data/repository/home_repository_impl.dart';
import 'package:cocinando_con_flow/src/feature/home/data/services/home_api_service.dart';
import 'package:cocinando_con_flow/src/shared/storage/cache/recetas_cache_service.dart';
import 'package:cocinando_con_flow/src/shared/storage/local/local_favorites_service.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/entities/receta_lista_entity.dart';
import 'package:cocinando_con_flow/src/shared/domain/entities/receta_entity.dart';
import 'package:cocinando_con_flow/src/feature/home/data/models/receta_lista_model.dart';

import 'home_repository_impl_test.mocks.dart';

@GenerateMocks([HomeApiService, RecetasCacheService, LocalFavoritesService])
void main() {
  group('HomeRepositoryImpl', () {
    late HomeRepositoryImpl repo;
    late MockHomeApiService api;
    late MockRecetasCacheService cache;
    late MockLocalFavoritesService fav;

    setUp(() {
      api = MockHomeApiService();
      cache = MockRecetasCacheService();
      fav = MockLocalFavoritesService();
      repo = HomeRepositoryImpl(apiService: api, cacheService: cache, favoritesService: fav);
    });

    test('usa cache cuando existe', () async {
      when(cache.obtenerRecetasCache(any)).thenAnswer((_) async => const [
        RecetaEntity(id: '1', nombre: 'Pollo')
      ]);
      when(fav.esFavorito('1')).thenAnswer((_) async => false);

      final r = await repo.obtenerRecetas(pagina: 1, limite: 20);
      expect(r, [const RecetaListaEntity(id: '1', nombre: 'Pollo')]);
      verify(cache.obtenerRecetasCache(any)).called(1);
    });

    test('consulta API, guarda cache y aplica favoritos', () async {
      when(cache.obtenerRecetasCache(any)).thenAnswer((_) async => null);
      when(api.obtenerRecetas(pagina: 1, limite: 20)).thenAnswer((_) async => [
        // ignore: prefer_const_constructors
        RecetaListaModel(id: '1', nombre: 'Pollo'),
      ]);
      when(fav.esFavorito('1')).thenAnswer((_) async => true);

      final r = await repo.obtenerRecetas(pagina: 1, limite: 20);

      expect(r.first.esFavorito, true);
      verify(cache.guardarRecetasCache(any, any)).called(1);
    });

    test('agregar/quitar/esFavorito delegan a favoritos', () async {
      when(fav.agregar('1')).thenAnswer((_) async {});
      when(fav.quitar('1')).thenAnswer((_) async {});
      when(fav.esFavorito('1')).thenAnswer((_) async => true);

      await repo.agregarAFavoritos('1');
      await repo.quitarDeFavoritos('1');
      final esFav = await repo.esFavorito('1');

      expect(esFav, true);
      verify(fav.agregar('1')).called(1);
      verify(fav.quitar('1')).called(1);
      verify(fav.esFavorito('1')).called(1);
    });
  });
}
