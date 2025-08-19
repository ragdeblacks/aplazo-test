import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class CargarRecetas extends HomeEvent {
  const CargarRecetas();
}

class CargarMasRecetas extends HomeEvent {
  const CargarMasRecetas();
}

class AgregarAFavoritos extends HomeEvent {
  final String recetaId;

  const AgregarAFavoritos(this.recetaId);

  @override
  List<Object?> get props => [recetaId];
}

class QuitarDeFavoritos extends HomeEvent {
  final String recetaId;

  const QuitarDeFavoritos(this.recetaId);

  @override
  List<Object?> get props => [recetaId];
}

class ActualizarFavoritos extends HomeEvent {
  const ActualizarFavoritos();
}
