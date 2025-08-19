import 'package:cocinando_con_flow/src/shared/domain/entities/entities.dart';

abstract class BusquedaRepository {
  Future<List<RecetaEntity>> buscarRecetasPorNombre(String nombre);
  Future<void> agregarAFavoritos(String recetaId);
  Future<void> quitarDeFavoritos(String recetaId);
  Future<bool> esFavorito(String recetaId);
}
