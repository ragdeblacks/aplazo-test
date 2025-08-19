import 'package:equatable/equatable.dart';

abstract class BusquedaEvent extends Equatable {
  const BusquedaEvent();

  @override
  List<Object?> get props => [];
}

class EjecutarBusqueda extends BusquedaEvent {
  final String query;

  const EjecutarBusqueda(this.query);

  @override
  List<Object?> get props => [query];
}

class LimpiarBusqueda extends BusquedaEvent {
  const LimpiarBusqueda();
}

class AgregarAFavoritos extends BusquedaEvent {
  final String recetaId;

  const AgregarAFavoritos(this.recetaId);

  @override
  List<Object?> get props => [recetaId];
}

class QuitarDeFavoritos extends BusquedaEvent {
  final String recetaId;

  const QuitarDeFavoritos(this.recetaId);

  @override
  List<Object?> get props => [recetaId];
}
