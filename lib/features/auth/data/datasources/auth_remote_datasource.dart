import 'dart:math';

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

  static const _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  String _gerarCodigo6() {
    final rng = Random.secure();
    return List.generate(6, (_) => _chars[rng.nextInt(_chars.length)]).join();
  }

  Future<String> gerarCodigoConvite({required String casalId}) async {
    final codigo = _gerarCodigo6();
    final expiraEm = DateTime.now().add(const Duration(minutes: 15));

    await client.from('casais').update({
      'codigo_convite': codigo,
      'codigo_expira_em': expiraEm.toIso8601String(),
    }).eq('id', casalId);

    return codigo;
  }

  Future<ConjugeModel> entrarNoCasalPorCodigo({
    required String codigo,
    required String nome,
    required PapelNoCasal papel,
  }) async {
    final user = client.auth.currentUser;
    if (user == null) throw StateError('Usuário não autenticado.');

    final uid = user.id;
    final email = user.email ?? '';

    final json = await client
        .from('casais')
        .select(_selectCasalComConjuges)
        .eq('codigo_convite', codigo)
        .maybeSingle();

    if (json == null) throw ArgumentError('Código inválido.');

    final expiraEmStr = json['codigo_expira_em'] as String?;
    if (expiraEmStr == null ||
        DateTime.parse(expiraEmStr).isBefore(DateTime.now())) {
      throw ArgumentError('Código expirado. Peça um novo ao seu parceiro.');
    }

    final casalId = json['id'] as String;
    final campoOcupado = papel == PapelNoCasal.conMelancia
        ? json['con_melancia_id'] as String?
        : json['con_uva_id'] as String?;

    if (campoOcupado != null) {
      throw ArgumentError('Este papel já está ocupado no casal.');
    }

    await client.from('conjuges').insert({
      'id': uid,
      'nome': nome,
      'email': email,
      'casal_id': casalId,
    });

    final campoUpdate = papel == PapelNoCasal.conMelancia
        ? {'con_melancia_id': uid}
        : {'con_uva_id': uid};
    await client.from('casais').update({
      ...campoUpdate,
      'codigo_convite': null,
      'codigo_expira_em': null,
    }).eq('id', casalId);

    final recarregar = await buscarConjugeDoUsuarioAtualSeExistir();
    if (recarregar == null) {
      throw StateError('Falha ao recarregar cônjuge após entrar no casal.');
    }
    return recarregar;
  }
}
