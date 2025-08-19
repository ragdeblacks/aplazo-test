import 'package:equatable/equatable.dart';

class RecetaEntity extends Equatable {
  final String id;
  final String nombre;
  final String? imagen;
  final String? categoria;
  final String? area;
  final String? instrucciones;
  final List<String> ingredientes;
  final List<String> medidas;
  final bool esFavorito;

  const RecetaEntity({
    required this.id,
    required this.nombre,
    this.imagen,
    this.categoria,
    this.area,
    this.instrucciones,
    this.ingredientes = const [],
    this.medidas = const [],
    this.esFavorito = false,
  });

  @override
  List<Object?> get props => [
        id, nombre, imagen, categoria, area, instrucciones,
        ingredientes, medidas, esFavorito,
      ];

  RecetaEntity copyWith({
    String? id, String? nombre, String? imagen, String? categoria,
    String? area, String? instrucciones, List<String>? ingredientes,
    List<String>? medidas, bool? esFavorito,
  }) {
    return RecetaEntity(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      imagen: imagen ?? this.imagen,
      categoria: categoria ?? this.categoria,
      area: area ?? this.area,
      instrucciones: instrucciones ?? this.instrucciones,
      ingredientes: ingredientes ?? this.ingredientes,
      medidas: medidas ?? this.medidas,
      esFavorito: esFavorito ?? this.esFavorito,
    );
  }
}
