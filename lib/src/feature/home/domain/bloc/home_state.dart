import 'package:equatable/equatable.dart';
import '../entities/receta_lista_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<RecetaListaEntity> recetas;
  final int paginaActual;
  final bool tieneMasPaginas;
  final bool estaCargandoMas;

  const HomeLoaded({
    required this.recetas,
    required this.paginaActual,
    required this.tieneMasPaginas,
    this.estaCargandoMas = false,
  });

  @override
  List<Object?> get props => [recetas, paginaActual, tieneMasPaginas, estaCargandoMas];

  HomeLoaded copyWith({
    List<RecetaListaEntity>? recetas,
    int? paginaActual,
    bool? tieneMasPaginas,
    bool? estaCargandoMas,
  }) {
    return HomeLoaded(
      recetas: recetas ?? this.recetas,
      paginaActual: paginaActual ?? this.paginaActual,
      tieneMasPaginas: tieneMasPaginas ?? this.tieneMasPaginas,
      estaCargandoMas: estaCargandoMas ?? this.estaCargandoMas,
    );
  }
}

class HomeError extends HomeState {
  final String mensaje;

  const HomeError(this.mensaje);

  @override
  List<Object?> get props => [mensaje];
}
