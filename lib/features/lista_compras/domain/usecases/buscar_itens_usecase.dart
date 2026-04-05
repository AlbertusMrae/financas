import '../entities/item_compra.dart';
import '../repositories/lista_compras_repository.dart';

class BuscarItensUseCase {
  final ListaComprasRepository repository;

  BuscarItensUseCase({required this.repository});

  Future<List<ItemCompra>> call() {
    return repository.buscarItens();
  }
}
