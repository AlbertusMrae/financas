import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/item_compra_model.dart';

class ListaComprasRemoteDataSource {
  final SupabaseClient client;

  ListaComprasRemoteDataSource({required this.client});

  Future<List<ItemCompraModel>> buscarItens() async {
    final json = await client
        .from('itens_compra')
        .select()
        .order('criado_em', ascending: true);

    return json.map((e) => ItemCompraModel.fromJson(e)).toList();
  }

  Future<void> adicionarItem({required ItemCompraModel item}) async {
    await client.from('itens_compra').insert(item.toJson());
  }

  Future<void> marcarItem({required String id, required bool marcado}) async {
    await client.from('itens_compra').update({'marcado': marcado}).eq('id', id);
  }
}
