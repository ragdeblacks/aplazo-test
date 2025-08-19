import 'package:get_it/get_it.dart';
import 'package:cocinando_con_flow/src/feature/home/data/services/home_api_service.dart';
import 'package:cocinando_con_flow/src/feature/home/data/repository/home_repository_impl.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/repository/home_repository.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/usecases/obtener_recetas_usecase.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/usecases/gestionar_favoritos_usecase.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/usecases/cargar_mas_recetas_usecase.dart';
import 'package:cocinando_con_flow/src/feature/home/domain/bloc/home_bloc.dart';
import 'package:cocinando_con_flow/src/feature/detalle/data/services/detalle_api_service.dart';
import 'package:cocinando_con_flow/src/feature/detalle/data/repository/detalle_repository_impl.dart';
import 'package:cocinando_con_flow/src/feature/detalle/domain/repository/detalle_repository.dart';
import 'package:cocinando_con_flow/src/feature/detalle/domain/bloc/detalle_bloc.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/data/services/busqueda_api_service.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/data/repository/busqueda_repository_impl.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/domain/repository/busqueda_repository.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/domain/bloc/busqueda_bloc.dart';
import 'package:cocinando_con_flow/src/shared/storage/cache/recetas_cache_service.dart';
import 'package:cocinando_con_flow/src/shared/storage/local/local_favorites_service.dart';

final GetIt locator = GetIt.instance;

void initDependencies() {
  // Servicios compartidos
  locator.registerLazySingleton<RecetasCacheService>(() => RecetasCacheService());
  locator.registerLazySingleton<LocalFavoritesService>(() => LocalFavoritesService());

  // Home Feature
  locator.registerLazySingleton<HomeApiService>(() => HomeApiService());
  locator.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(
        apiService: locator<HomeApiService>(),
        cacheService: locator<RecetasCacheService>(),
        favoritesService: locator<LocalFavoritesService>(),
      ));
  locator.registerLazySingleton(() => ObtenerRecetasUseCase(locator<HomeRepository>()));
  locator.registerLazySingleton(() => GestionarFavoritosUseCase(locator<HomeRepository>()));
  locator.registerLazySingleton(() => CargarMasRecetasUseCase(locator<HomeRepository>()));
  locator.registerFactory(() => HomeBloc(
        obtenerRecetasUseCase: locator<ObtenerRecetasUseCase>(),
        gestionarFavoritosUseCase: locator<GestionarFavoritosUseCase>(),
        cargarMasRecetasUseCase: locator<CargarMasRecetasUseCase>(),
      ));

  // Detalle Feature
  locator.registerLazySingleton<DetalleApiService>(() => DetalleApiService());
  locator.registerLazySingleton<DetalleRepository>(() => DetalleRepositoryImpl(
        apiService: locator<DetalleApiService>(),
        favoritesService: locator<LocalFavoritesService>(),
      ));
  locator.registerFactory(() => DetalleBloc(detalleRepository: locator<DetalleRepository>()));

  // Busqueda Feature
  locator.registerLazySingleton<BusquedaApiService>(() => BusquedaApiService());
  locator.registerLazySingleton<BusquedaRepository>(() => BusquedaRepositoryImpl(
        apiService: locator<BusquedaApiService>(),
        favoritesService: locator<LocalFavoritesService>(),
        cacheService: locator<RecetasCacheService>(),
      ));
  locator.registerFactory(() => BusquedaBloc(busquedaRepository: locator<BusquedaRepository>()));
}
