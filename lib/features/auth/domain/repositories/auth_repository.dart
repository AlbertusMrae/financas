import '../entities/casal.dart';
import '../entities/conjuge.dart';
import '../entities/papel_no_casal.dart';

interface class AuthRepository {
  Future<void> signIn({required String email, required String senha}) {
    throw UnimplementedError();
  }

  /// `true` se a sessão foi aberta imediatamente (sem depender de confirmação de e-mail).
  Future<bool> signUp({required String email, required String senha}) {
    throw UnimplementedError();
  }

  Future<Conjuge?> buscarConjugeDoUsuarioAtualSeExistir() {
    throw UnimplementedError();
  }

  Future<Casal?> buscarCasalDoUsuarioAtualSeExistir() {
    throw UnimplementedError();
  }

  Future<Conjuge> completarPerfilInicial({
    required String nome,
    required PapelNoCasal papel,
  }) {
    throw UnimplementedError();
  }

  Future<void> logout() {
    throw UnimplementedError();
  }

  Future<Conjuge> buscarConjugeAtual() {
    throw UnimplementedError();
  }

  Future<Casal> buscarCasal() {
    throw UnimplementedError();
  }
}
