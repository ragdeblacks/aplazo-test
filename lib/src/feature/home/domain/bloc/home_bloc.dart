import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cocinando_con_flow/src/shared/errors/error_mapper.dart';
import '../usecases/obtener_recetas_usecase.dart';
import '../usecases/cargar_mas_recetas_usecase.dart';
import '../usecases/gestionar_favoritos_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ObtenerRecetasUseCase _obtenerRecetasUseCase;
  final CargarMasRecetasUseCase _cargarMasRecetasUseCase;
  final GestionarFavoritosUseCase _gestionarFavoritosUseCase;
  static const int _totalPaginasAlfabeto = 26; // a-z

  HomeBloc({
    required ObtenerRecetasUseCase obtenerRecetasUseCase,
    required CargarMasRecetasUseCase cargarMasRecetasUseCase,
    required GestionarFavoritosUseCase gestionarFavoritosUseCase,
  })  : _obtenerRecetasUseCase = obtenerRecetasUseCase,
        _cargarMasRecetasUseCase = cargarMasRecetasUseCase,
        _gestionarFavoritosUseCase = gestionarFavoritosUseCase,
        super(HomeInitial()) {
    on<CargarRecetas>(_onCargarRecetas);
    on<CargarMasRecetas>(_onCargarMasRecetas);
    on<AgregarAFavoritos>(_onAgregarAFavoritos);
    on<QuitarDeFavoritos>(_onQuitarDeFavoritos);
    on<ActualizarFavoritos>(_onActualizarFavoritos);
  }

  Future<void> _onCargarRecetas(
    CargarRecetas event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(HomeLoading());
      
      final recetas = await _obtenerRecetasUseCase(
        pagina: 1,
        limite: 20,
      );

      emit(HomeLoaded(
        recetas: recetas,
        paginaActual: 1,
        tieneMasPaginas: 1 < _totalPaginasAlfabeto,
      ));
    } catch (e) {
      final f = ErrorMapper.mapToFailure(e);
      emit(HomeError('Error al cargar recetas: ${f.message}'));
    }
  }

  Future<void> _onCargarMasRecetas(
    CargarMasRecetas event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! HomeLoaded) return;
      if (currentState.estaCargandoMas) return;
      if (!currentState.tieneMasPaginas) return;

      emit(currentState.copyWith(estaCargandoMas: true));

      final resultado = await _cargarMasRecetasUseCase(
        paginaActual: currentState.paginaActual,
      );

      if (resultado.recetas.isNotEmpty) {
        final todasLasRecetas = [...currentState.recetas, ...resultado.recetas];
        emit(HomeLoaded(
          recetas: todasLasRecetas,
          paginaActual: resultado.paginaActual,
          tieneMasPaginas: resultado.tieneMasPaginas,
          estaCargandoMas: false,
        ));
      } else {
        // No hay más páginas disponibles
        emit(currentState.copyWith(
          tieneMasPaginas: false,
          estaCargandoMas: false,
        ));
      }
    } catch (e) {
      if (state is HomeLoaded) {
        emit((state as HomeLoaded).copyWith(estaCargandoMas: false));
      }
      final f = ErrorMapper.mapToFailure(e);
      emit(HomeError('Error al cargar más recetas: ${f.message}'));
    }
  }

  Future<void> _onAgregarAFavoritos(
    AgregarAFavoritos event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _gestionarFavoritosUseCase.agregarAFavoritos(event.recetaId);
      
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        final recetasActualizadas = currentState.recetas.map((receta) {
          if (receta.id == event.recetaId) {
            return receta.copyWith(esFavorito: true);
          }
          return receta;
        }).toList();

        emit(currentState.copyWith(recetas: recetasActualizadas));
      }
    } catch (e) {
      final f = ErrorMapper.mapToFailure(e);
      emit(HomeError('Error al agregar a favoritos: ${f.message}'));
    }
  }

  Future<void> _onQuitarDeFavoritos(
    QuitarDeFavoritos event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _gestionarFavoritosUseCase.quitarDeFavoritos(event.recetaId);
      
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        final recetasActualizadas = currentState.recetas.map((receta) {
          if (receta.id == event.recetaId) {
            return receta.copyWith(esFavorito: false);
          }
          return receta;
        }).toList();

        emit(currentState.copyWith(recetas: recetasActualizadas));
      }
    } catch (e) {
      final f = ErrorMapper.mapToFailure(e);
      emit(HomeError('Error al quitar de favoritos: ${f.message}'));
    }
  }

  Future<void> _onActualizarFavoritos(
    ActualizarFavoritos event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        final recetasActualizadas = await Future.wait(
          currentState.recetas.map((receta) async {
            final esFavorito = await _gestionarFavoritosUseCase.esFavorito(receta.id);
            return receta.copyWith(esFavorito: esFavorito);
          }),
        );

        emit(currentState.copyWith(recetas: recetasActualizadas));
      }
    } catch (e) {
      final f = ErrorMapper.mapToFailure(e);
      emit(HomeError('Error al actualizar favoritos: ${f.message}'));
    }
  }
}
