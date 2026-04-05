import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/carteira_model.dart';
import '../models/lancamento_model.dart';

class FinancasRemoteDataSource {
  final SupabaseClient client;

  FinancasRemoteDataSource({required this.client});

  Future<List<CarteiraModel>> buscarCarteiras() async {
    final userId = client.auth.currentUser!.id;

    final json = await client
        .from('carteiras')
        .select()
        .or('proprietario_id.eq.$userId,tipo.eq.casal');

    return json.map((e) => CarteiraModel.fromJson(e)).toList();
  }

  Future<List<LancamentoModel>> buscarLancamentos({
    required String carteiraId,
  }) async {
    final json = await client
        .from('lancamentos')
        .select()
        .eq('carteira_id', carteiraId)
        .order('data', ascending: false);

    return json.map((e) => LancamentoModel.fromJson(e)).toList();
  }

  Future<void> registrarLancamento({
    required LancamentoModel lancamento,
  }) async {
    await client.from('lancamentos').insert(lancamento.toJson());
  }
}
