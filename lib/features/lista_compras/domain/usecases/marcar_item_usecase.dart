import '../repositories/lista_compras_repository.dart';

class MarcarItemUseCase {
  final ListaComprasRepository repository;

  MarcarItemUseCase({required this.repository});

  Future<void> call({required String id, required bool marcado}) {
    return repository.marcarItem(id: id, marcado: marcado);
  }
}
