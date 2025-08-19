import 'package:equatable/equatable.dart';
import 'package:cocinando_con_flow/src/shared/domain/entities/entities.dart';

abstract class DetalleState extends Equatable {
  const DetalleState();
  @override
  List<Object?> get props => [];
}

class DetalleInitial extends DetalleState {}
class DetalleLoading extends DetalleState {}

class DetalleCargado extends DetalleState {
  final RecetaEntity receta;
  final bool ingredientesExpandido;
  final bool instruccionesExpandido;

  const DetalleCargado(
    this.receta, {
    this.ingredientesExpandido = false,
    this.instruccionesExpandido = false,
  });

  DetalleCargado copyWith({
    RecetaEntity? receta,
    bool? ingredientesExpandido,
    bool? instruccionesExpandido,
  }) {
    return DetalleCargado(
      receta ?? this.receta,
      ingredientesExpandido: ingredientesExpandido ?? this.ingredientesExpandido,
      instruccionesExpandido: instruccionesExpandido ?? this.instruccionesExpandido,
    );
  }

  @override
  List<Object?> get props => [receta, ingredientesExpandido, instruccionesExpandido];
}

class DetalleError extends DetalleState {
  final String mensaje;
  const DetalleError(this.mensaje);
  @override
  List<Object?> get props => [mensaje];
}
