import '../entities/item_compra.dart';
import '../repositories/lista_compras_repository.dart';

class AdicionarItemUseCase {
  final ListaComprasRepository repository;

  AdicionarItemUseCase({required this.repository});

  Future<void> call({required ItemCompra item}) {
    return repository.adicionarItem(item: item);
  }
}
