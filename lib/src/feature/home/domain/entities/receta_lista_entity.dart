import 'package:equatable/equatable.dart';

class RecetaListaEntity extends Equatable {
  final String id;
  final String nombre;
  final String? imagen;
  final String? categoria;
  final String? area;
  final bool esFavorito;

  const RecetaListaEntity({
    required this.id,
    required this.nombre,
    this.imagen,
    this.categoria,
    this.area,
    this.esFavorito = false,
  });

  @override
  List<Object?> get props => [id, nombre, imagen, categoria, area, esFavorito];

  RecetaListaEntity copyWith({
    String? id,
    String? nombre,
    String? imagen,
    String? categoria,
    String? area,
    bool? esFavorito,
  }) {
    return RecetaListaEntity(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      imagen: imagen ?? this.imagen,
      categoria: categoria ?? this.categoria,
      area: area ?? this.area,
      esFavorito: esFavorito ?? this.esFavorito,
    );
  }
}
