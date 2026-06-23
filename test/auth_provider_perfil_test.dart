import 'package:flutter_test/flutter_test.dart';

import 'package:financas/features/auth/domain/entities/casal.dart';
import 'package:financas/features/auth/domain/entities/conjuge.dart';
import 'package:financas/features/auth/domain/entities/papel_no_casal.dart';
import 'package:financas/features/auth/domain/repositories/auth_repository.dart';
import 'package:financas/features/auth/domain/usecases/buscar_casal_opcional_usecase.dart';
import 'package:financas/features/auth/domain/usecases/buscar_casal_usecase.dart';
import 'package:financas/features/auth/domain/usecases/buscar_conjuge_opcional_usecase.dart';
import 'package:financas/features/auth/domain/usecases/completar_perfil_conjuge_usecase.dart';
import 'package:financas/features/auth/domain/usecases/registrar_conta_usecase.dart';
import 'package:financas/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:financas/features/auth/domain/usecases/logout_usecase.dart';
import 'package:financas/features/auth/presentation/providers/auth_provider.dart';

/// Repositório mínimo: login ok, sem cônjuge → fluxo de onboarding.
class _RepoSemConjuge implements AuthRepository {
  @override
  Future<Casal?> buscarCasalDoUsuarioAtualSeExistir() async => null;

  @override
  Future<Conjuge?> buscarConjugeDoUsuarioAtualSeExistir() async => null;

  @override
  Future<Casal> buscarCasal() async => throw UnimplementedError();

  @override
  Future<Conjuge> buscarConjugeAtual() async => throw UnimplementedError();

  @override
  Future<Conjuge> completarPerfilInicial({
    required String nome,
    required PapelNoCasal papel,
  }) async => throw UnimplementedError();

  @override
  Future<void> logout() async {}

  @override
  Future<bool> signUp({required String email, required String senha}) async =>
      false;

  @override
  Future<void> signIn({required String email, required String senha}) async {}
}

void main() {
  test('Após sign-in sem conjuge, precisaCompletarPerfil é true', () async {
    final repo = _RepoSemConjuge();
    final auth = AuthProvider(
      signInUseCase: SignInUseCase(repository: repo),
      buscarConjugeOpcionalUseCase: BuscarConjugeOpcionalUseCase(
        repository: repo,
      ),
      buscarCasalOpcionalUseCase: BuscarCasalOpcionalUseCase(repository: repo),
      buscarCasalUseCase: BuscarCasalUseCase(repository: repo),
      registrarContaUseCase: RegistrarContaUseCase(repository: repo),
      completarPerfilConjugeUseCase: CompletarPerfilConjugeUseCase(
        repository: repo,
      ),
      logoutUseCase: LogoutUseCase(repository: repo),
    );

    await auth.login(email: 'a@b.com', senha: '123456');

    expect(auth.erro, isNull);
    expect(auth.precisaCompletarPerfil, isTrue);
    expect(auth.conjuge, isNull);
  });
}
