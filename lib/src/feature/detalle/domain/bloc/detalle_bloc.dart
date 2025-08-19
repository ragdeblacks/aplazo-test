import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cocinando_con_flow/src/feature/detalle/domain/repository/detalle_repository.dart';
import 'detalle_event.dart';
import 'detalle_state.dart';

class DetalleBloc extends Bloc<DetalleEvent, DetalleState> {
  final DetalleRepository _detalleRepository;

  DetalleBloc({required DetalleRepository detalleRepository})
      : _detalleRepository = detalleRepository,
        super(DetalleInitial()) {
    on<CargarDetalle>(_onCargarDetalle);
    on<AgregarAFavoritos>(_onAgregarAFavoritos);
    on<QuitarDeFavoritos>(_onQuitarDeFavoritos);
    on<ToggleIngredientes>(_onToggleIngredientes);
    on<ToggleInstrucciones>(_onToggleInstrucciones);
  }

  Future<void> _onCargarDetalle(CargarDetalle event, Emitter<DetalleState> emit) async {
    try {
      emit(DetalleLoading());
      final receta = await _detalleRepository.obtenerRecetaPorId(event.recetaId);
      if (receta == null) {
        emit(const DetalleError('Receta no encontrada'));
        return;
      }
      emit(DetalleCargado(receta, ingredientesExpandido: false, instruccionesExpandido: false));
    } catch (e) {
      emit(DetalleError('Error al cargar detalle: $e'));
    }
  }

  Future<void> _onAgregarAFavoritos(AgregarAFavoritos event, Emitter<DetalleState> emit) async {
    if (state is! DetalleCargado) return;
    final actual = (state as DetalleCargado).receta;
    try {
      await _detalleRepository.agregarAFavoritos(event.recetaId);
      final estadoActual = state as DetalleCargado;
      emit(estadoActual.copyWith(
        receta: actual.copyWith(esFavorito: true),
      ));
    } catch (e) {
      emit(DetalleError('Error al agregar a favoritos: $e'));
    }
  }

  Future<void> _onQuitarDeFavoritos(QuitarDeFavoritos event, Emitter<DetalleState> emit) async {
    if (state is! DetalleCargado) return;
    final actual = (state as DetalleCargado).receta;
    try {
      await _detalleRepository.quitarDeFavoritos(event.recetaId);
      final estadoActual = state as DetalleCargado;
      emit(estadoActual.copyWith(
        receta: actual.copyWith(esFavorito: false),
      ));
    } catch (e) {
      emit(DetalleError('Error al quitar de favoritos: $e'));
    }
  }

  void _onToggleIngredientes(ToggleIngredientes event, Emitter<DetalleState> emit) {
    if (state is! DetalleCargado) return;
    final s = state as DetalleCargado;
    emit(s.copyWith(ingredientesExpandido: !s.ingredientesExpandido));
  }

  void _onToggleInstrucciones(ToggleInstrucciones event, Emitter<DetalleState> emit) {
    if (state is! DetalleCargado) return;
    final s = state as DetalleCargado;
    emit(s.copyWith(instruccionesExpandido: !s.instruccionesExpandido));
  }
}
