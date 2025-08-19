import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cocinando_con_flow/src/feature/busqueda/domain/repository/busqueda_repository.dart';
import 'busqueda_event.dart';
import 'busqueda_state.dart';
import 'package:cocinando_con_flow/src/shared/errors/error_mapper.dart';

class BusquedaBloc extends Bloc<BusquedaEvent, BusquedaState> {
  final BusquedaRepository _busquedaRepository;
  BusquedaBloc({required BusquedaRepository busquedaRepository})
      : _busquedaRepository = busquedaRepository,
        super(BusquedaInicial()) {
    on<EjecutarBusqueda>(_onEjecutarBusqueda);
    on<LimpiarBusqueda>(_onLimpiarBusqueda);
    on<AgregarAFavoritos>(_onAgregarAFavoritos);
    on<QuitarDeFavoritos>(_onQuitarDeFavoritos);
  }

  Future<void> _onEjecutarBusqueda(EjecutarBusqueda event, Emitter<BusquedaState> emit) async {
    final termino = event.query.trim();
    if (termino.isEmpty) {
      emit(BusquedaInicial());
      return;
    }
    try {
      emit(BusquedaCargando());
      final recetas = await _busquedaRepository.buscarRecetasPorNombre(termino);
      if (recetas.isEmpty) {
        emit(BusquedaSinResultados());
      } else {
        emit(BusquedaExitoso(recetas));
      }
    } catch (e) {
      final failure = ErrorMapper.mapToFailure(e);
      emit(BusquedaError('Error en búsqueda: ${failure.message}'));
    }
  }

  void _onLimpiarBusqueda(LimpiarBusqueda event, Emitter<BusquedaState> emit) {
    emit(BusquedaInicial());
  }

  Future<void> _onAgregarAFavoritos(AgregarAFavoritos event, Emitter<BusquedaState> emit) async {
    if (state is! BusquedaExitoso) return;
    await _busquedaRepository.agregarAFavoritos(event.recetaId);
    final actuales = (state as BusquedaExitoso).recetas;
    emit(BusquedaExitoso(actuales.map((r) => r.id == event.recetaId ? r.copyWith(esFavorito: true) : r).toList()));
  }

  Future<void> _onQuitarDeFavoritos(QuitarDeFavoritos event, Emitter<BusquedaState> emit) async {
    if (state is! BusquedaExitoso) return;
    await _busquedaRepository.quitarDeFavoritos(event.recetaId);
    final actuales = (state as BusquedaExitoso).recetas;
    emit(BusquedaExitoso(actuales.map((r) => r.id == event.recetaId ? r.copyWith(esFavorito: false) : r).toList()));
  }
}
