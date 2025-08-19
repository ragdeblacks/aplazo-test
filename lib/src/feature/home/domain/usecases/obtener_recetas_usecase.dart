import '../entities/receta_lista_entity.dart';
import '../repository/home_repository.dart';

class ObtenerRecetasUseCase {
  final HomeRepository _repository;

  const ObtenerRecetasUseCase(this._repository);

  Future<List<RecetaListaEntity>> call({
    required int pagina,
    required int limite,
  }) async {
    return await _repository.obtenerRecetas(
      pagina: pagina,
      limite: limite,
    );
  }
}
