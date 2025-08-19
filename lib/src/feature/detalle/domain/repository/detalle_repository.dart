import 'package:cocinando_con_flow/src/shared/domain/entities/entities.dart';

abstract class DetalleRepository {
  Future<RecetaEntity?> obtenerRecetaPorId(String id);
  Future<void> agregarAFavoritos(String recetaId);
  Future<void> quitarDeFavoritos(String recetaId);
  Future<bool> esFavorito(String recetaId);
}
