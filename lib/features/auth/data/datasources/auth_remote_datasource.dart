import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/conjuge_model.dart';
import '../models/casal_model.dart';

class AuthRemoteDataSource {
  final SupabaseClient client;

  AuthRemoteDataSource({required this.client});

  Future<ConjugeModel> login({
    required String email,
    required String senha,
  }) async {
    await client.auth.signInWithPassword(email: email, password: senha);

    final userId = client.auth.currentUser!.id;

    final json = await client
        .from('conjuges')
        .select()
        .eq('id', userId)
        .single();

    return ConjugeModel.fromJson(json);
  }

  Future<void> logout() async {
    await client.auth.signOut();
  }

  Future<ConjugeModel> buscarConjugeAtual() async {
    final userId = client.auth.currentUser!.id;

    final json = await client
        .from('conjuges')
        .select()
        .eq('id', userId)
        .single();

    return ConjugeModel.fromJson(json);
  }

  Future<CasalModel> buscarCasal() async {
    final userId = client.auth.currentUser!.id;

    final json = await client
        .from('casais')
        .select()
        .or('con_melancia_id.eq.$userId,con_uva_id.eq.$userId')
        .single();

    return CasalModel.fromJson(json);
  }
}
