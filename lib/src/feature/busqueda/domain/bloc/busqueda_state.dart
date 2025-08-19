import 'package:equatable/equatable.dart';
import 'package:cocinando_con_flow/src/shared/domain/entities/entities.dart';

abstract class BusquedaState extends Equatable {
  const BusquedaState();
  @override
  List<Object?> get props => [];
}

class BusquedaInicial extends BusquedaState {}
class BusquedaCargando extends BusquedaState {}

class BusquedaExitoso extends BusquedaState {
  final List<RecetaEntity> recetas;
  const BusquedaExitoso(this.recetas);
  @override
  List<Object?> get props => [recetas];
}

class BusquedaSinResultados extends BusquedaState {}

class BusquedaError extends BusquedaState {
  final String mensaje;
  const BusquedaError(this.mensaje);
  @override
  List<Object?> get props => [mensaje];
}
