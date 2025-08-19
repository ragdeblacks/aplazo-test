import '../entities/receta_lista_entity.dart';
import '../repository/home_repository.dart';

class CargarMasRecetasUseCase {
  final HomeRepository _repository;
  static const int _totalPaginasAlfabeto = 26; // a-z

  const CargarMasRecetasUseCase(this._repository);

  Future<({List<RecetaListaEntity> recetas, int paginaActual, bool tieneMasPaginas})> call({
    required int paginaActual,
  }) async {
    int paginaBusqueda = paginaActual + 1;
    List<RecetaListaEntity> nuevasRecetas = [];

    // Buscar la siguiente página con resultados
    while (paginaBusqueda <= _totalPaginasAlfabeto && nuevasRecetas.isEmpty) {
      nuevasRecetas = await _repository.obtenerRecetas(
        pagina: paginaBusqueda,
        limite: 20,
      );
      if (nuevasRecetas.isEmpty) {
        paginaBusqueda++;
      }
    }

    final hayMas = paginaBusqueda < _totalPaginasAlfabeto;
    
    return (
      recetas: nuevasRecetas,
      paginaActual: paginaBusqueda,
      tieneMasPaginas: hayMas,
    );
  }
}
