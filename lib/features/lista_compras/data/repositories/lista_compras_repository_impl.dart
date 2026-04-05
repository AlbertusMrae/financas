import '../../domain/entities/item_compra.dart';
import '../../domain/repositories/lista_compras_repository.dart';
import '../datasources/lista_compras_remote_datasource.dart';
import '../models/item_compra_model.dart';

class ListaComprasRepositoryImpl implements ListaComprasRepository {
  final ListaComprasRemoteDataSource dataSource;

  ListaComprasRepositoryImpl({required this.dataSource});

  @override
  Future<List<ItemCompra>> buscarItens() {
    return dataSource.buscarItens();
  }

  @override
  Future<void> adicionarItem({required ItemCompra item}) {
    return dataSource.adicionarItem(item: item as ItemCompraModel);
  }

  @override
  Future<void> marcarItem({required String id, required bool marcado}) {
    return dataSource.marcarItem(id: id, marcado: marcado);
  }
}
