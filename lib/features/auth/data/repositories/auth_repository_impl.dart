import '../../domain/entities/casal.dart';
import '../../domain/entities/conjuge.dart';
import '../../domain/entities/papel_no_casal.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.dataSource});

  final AuthRemoteDataSource dataSource;

  @override
  Future<void> signIn({required String email, required String senha}) {
    return dataSource.signInComEmailSenha(email: email, senha: senha);
  }

  @override
  Future<bool> signUp({required String email, required String senha}) {
    return dataSource.signUp(email: email, senha: senha);
  }

  @override
  Future<Conjuge?> buscarConjugeDoUsuarioAtualSeExistir() {
    return dataSource.buscarConjugeDoUsuarioAtualSeExistir();
  }

  @override
  Future<Casal?> buscarCasalDoUsuarioAtualSeExistir() {
    return dataSource.buscarCasalDoUsuarioAtualSeExistir();
  }

  @override
  Future<Conjuge> completarPerfilInicial({
    required String nome,
    required PapelNoCasal papel,
  }) {
    return dataSource.completarPerfilInicial(nome: nome, papel: papel);
  }

  @override
  Future<void> logout() {
    return dataSource.logout();
  }

  @override
  Future<Conjuge> buscarConjugeAtual() {
    return dataSource.buscarConjugeAtual();
  }

  @override
  Future<Casal> buscarCasal() {
    return dataSource.buscarCasal();
  }
}
