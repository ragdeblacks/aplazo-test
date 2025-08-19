import '../repository/home_repository.dart';

class GestionarFavoritosUseCase {
  final HomeRepository _repository;

  const GestionarFavoritosUseCase(this._repository);

  Future<void> agregarAFavoritos(String recetaId) async {
    await _repository.agregarAFavoritos(recetaId);
  }

  Future<void> quitarDeFavoritos(String recetaId) async {
    await _repository.quitarDeFavoritos(recetaId);
  }

  Future<bool> esFavorito(String recetaId) async {
    return await _repository.esFavorito(recetaId);
  }
}
