import '../../domain/entities/receta_lista_entity.dart';

class RecetaListaModel extends RecetaListaEntity {
  const RecetaListaModel({
    required super.id,
    required super.nombre,
    super.imagen,
    super.categoria,
    super.area,
    super.esFavorito,
  });

  factory RecetaListaModel.fromJson(Map<String, dynamic> json) {
    return RecetaListaModel(
      id: json['idMeal'] ?? '',
      nombre: json['strMeal'] ?? '',
      imagen: json['strMealThumb'],
      categoria: json['strCategory'],
      area: json['strArea'],
      esFavorito: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': nombre,
      'strMealThumb': imagen,
      'strCategory': categoria,
      'strArea': area,
    };
  }

  @override
  RecetaListaModel copyWith({
    String? id,
    String? nombre,
    String? imagen,
    String? categoria,
    String? area,
    bool? esFavorito,
  }) {
    return RecetaListaModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      imagen: imagen ?? this.imagen,
      categoria: categoria ?? this.categoria,
      area: area ?? this.area,
      esFavorito: esFavorito ?? this.esFavorito,
    );
  }
}
