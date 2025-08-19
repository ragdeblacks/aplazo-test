import '../entities/receta_lista_entity.dart';

abstract class HomeRepository {
  Future<List<RecetaListaEntity>> obtenerRecetas({
    int pagina,
    int limite,
  });
  
  Future<void> agregarAFavoritos(String recetaId);
  Future<void> quitarDeFavoritos(String recetaId);
  Future<bool> esFavorito(String recetaId);
}
