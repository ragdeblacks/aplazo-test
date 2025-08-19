import 'package:equatable/equatable.dart';

abstract class DetalleEvent extends Equatable {
  const DetalleEvent();

  @override
  List<Object?> get props => [];
}

class CargarDetalle extends DetalleEvent {
  final String recetaId;

  const CargarDetalle(this.recetaId);

  @override
  List<Object?> get props => [recetaId];
}

class AgregarAFavoritos extends DetalleEvent {
  final String recetaId;

  const AgregarAFavoritos(this.recetaId);

  @override
  List<Object?> get props => [recetaId];
}

class QuitarDeFavoritos extends DetalleEvent {
  final String recetaId;

  const QuitarDeFavoritos(this.recetaId);

  @override
  List<Object?> get props => [recetaId];
}

class ToggleIngredientes extends DetalleEvent {
  const ToggleIngredientes();
}

class ToggleInstrucciones extends DetalleEvent {
  const ToggleInstrucciones();
}
