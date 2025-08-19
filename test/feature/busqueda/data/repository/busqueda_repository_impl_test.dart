import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/data/repository/busqueda_repository_impl.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/data/services/busqueda_api_service.dart';
import 'package:cocinando_con_flow/src/shared/storage/local/local_favorites_service.dart';
import 'package:cocinando_con_flow/src/shared/storage/cache/recetas_cache_service.dart';
import 'package:cocinando_con_flow/src/shared/data/models/receta_model.dart';

import 'busqueda_repository_impl_test.mocks.dart';

@GenerateMocks([BusquedaApiService, LocalFavoritesService, RecetasCacheService])
void main() {
  group('BusquedaRepositoryImpl', () {
    late BusquedaRepositoryImpl repo;
    late MockBusquedaApiService api;
    late MockLocalFavoritesService fav;
    late MockRecetasCacheService cache;

    setUp(() {
      api = MockBusquedaApiService();
      fav = MockLocalFavoritesService();
      cache = MockRecetasCacheService();
      repo = BusquedaRepositoryImpl(apiService: api, favoritesService: fav, cacheService: cache);
    });

    test('usa cache cuando existe', () async {
      when(cache.obtenerBusquedaCache('pollo')).thenAnswer((_) async => const []);
      final r = await repo.buscarRecetasPorNombre('pollo');
      expect(r, isEmpty);
      verify(cache.obtenerBusquedaCache('pollo')).called(1);
      verifyNever(api.buscarRecetasPorNombre(any));
    });

    test('consulta API, mapea favoritos y guarda en cache', () async {
      when(cache.obtenerBusquedaCache('pollo')).thenAnswer((_) async => null);
      when(api.buscarRecetasPorNombre('pollo')).thenAnswer((_) async => [
        const RecetaModel(idMeal: '1', strMeal: 'Pollo')
      ]);
      when(fav.esFavorito('1')).thenAnswer((_) async => true);

      final r = await repo.buscarRecetasPorNombre('pollo');

      expect(r.length, 1);
      expect(r.first.id, '1');
      expect(r.first.esFavorito, true);
      verify(cache.guardarBusquedaCache('pollo', any)).called(1);
    });

    test('agregarAFavoritos delega a favoritos', () async {
      when(fav.agregar('1')).thenAnswer((_) async {});
      await repo.agregarAFavoritos('1');
      verify(fav.agregar('1')).called(1);
    });

    test('quitarDeFavoritos delega a favoritos', () async {
      when(fav.quitar('1')).thenAnswer((_) async {});
      await repo.quitarDeFavoritos('1');
      verify(fav.quitar('1')).called(1);
    });
  });
}
