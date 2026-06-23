import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/papel_no_casal.dart';
import '../models/conjuge_model.dart';
import '../models/casal_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({required this.client});

  final SupabaseClient client;

  static const _uuid = Uuid();

  /// Select de `casais` com joins para [CasalModel.fromJson].
  static const _selectCasalComConjuges =
      'id, criado_em, con_melancia:conjuges!con_melancia_id(*), con_uva:conjuges!con_uva_id(*)';

  /// Apenas autenticação Supabase (sem ler `conjuges`).
  Future<void> signInComEmailSenha({
    required String email,
    required String senha,
  }) async {
    await client.auth.signInWithPassword(email: email, password: senha);
  }

  /// Cadastro no Auth. Retorna se há sessão imediata (ex.: e-mail já confirmado no projeto).
  Future<bool> signUp({required String email, required String senha}) async {
    final res = await client.auth.signUp(email: email, password: senha);
    return res.session != null;
  }

  /// Null se ainda não existe linha em `conjuges` para o usuário logado.
  Future<ConjugeModel?> buscarConjugeDoUsuarioAtualSeExistir() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      return null;
    }

    final json = await client
        .from('conjuges')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (json == null) {
      return null;
    }
    return ConjugeModel.fromJson(json);
  }

  /// Null se não há casal vinculado ao usuário atual.
  Future<CasalModel?> buscarCasalDoUsuarioAtualSeExistir() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      return null;
    }

    final json = await client
        .from('casais')
        .select(_selectCasalComConjuges)
        .or('con_melancia_id.eq.$userId,con_uva_id.eq.$userId')
        .maybeSingle();

    if (json == null) {
      return null;
    }
    return CasalModel.fromJson(json);
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
        .select(_selectCasalComConjuges)
        .or('con_melancia_id.eq.$userId,con_uva_id.eq.$userId')
        .single();

    return CasalModel.fromJson(json);
  }

  /// Cria `casais` + `conjuges` para o usuário autenticado.
  ///
  /// Ordem: linha em `casais` (FKs de cônjuge ainda nulas se o schema permitir),
  /// depois `conjuges`, depois `update` em `casais` preenchendo o papel do usuário.
  /// Se `con_melancia_id`/`con_uva_id` forem NOT NULL sem default, ajuste manual no
  /// Supabase (políticas ou RPC).
  Future<ConjugeModel> completarPerfilInicial({
    required String nome,
    required PapelNoCasal papel,
  }) async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw StateError('Usuário não autenticado.');
    }

    final uid = user.id;
    final email = user.email ?? '';

    final casalId = _uuid.v4();
    final agora = DateTime.now().toIso8601String();

    await client.from('casais').insert({
      'id': casalId,
      'criado_em': agora,
      'con_melancia_id': null,
      'con_uva_id': null,
    });

    await client.from('conjuges').insert({
      'id': uid,
      'nome': nome,
      'email': email,
      'casal_id': casalId,
    });

    if (papel == PapelNoCasal.conMelancia) {
      await client
          .from('casais')
          .update({'con_melancia_id': uid})
          .eq('id', casalId);
    } else {
      await client.from('casais').update({'con_uva_id': uid}).eq('id', casalId);
    }

    final recarregar = await buscarConjugeDoUsuarioAtualSeExistir();
    if (recarregar == null) {
      throw StateError('Falha ao recarregar cônjuge após criar perfil.');
    }
    return recarregar;
  }
}
