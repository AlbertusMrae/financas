import '../entities/item_compra.dart';

interface class ListaComprasRepository {
  Future<List<ItemCompra>> buscarItens() {
    throw UnimplementedError();
  }

  Future<void> adicionarItem({required ItemCompra item}) {
    throw UnimplementedError();
  }

  Future<void> marcarItem({required String id, required bool marcado}) {
    throw UnimplementedError();
  }
}
