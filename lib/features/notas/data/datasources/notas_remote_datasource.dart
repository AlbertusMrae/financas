import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/nota_model.dart';

class NotasRemoteDataSource {
  final SupabaseClient client;

  NotasRemoteDataSource({required this.client});

  Future<List<NotaModel>> buscarNotas() async {
    final userId = client.auth.currentUser!.id;

    final json = await client
        .from('notas')
        .select()
        .or('proprietario_id.eq.$userId,proprietario_id.eq.casal');

    return json.map((e) => NotaModel.fromJson(e)).toList();
  }

  Future<void> salvarNota({required NotaModel nota}) async {
    await client.from('notas').upsert(nota.toJson());
  }
}
