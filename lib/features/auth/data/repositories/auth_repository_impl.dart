import '../../domain/entities/conjuge.dart';
import '../../domain/entities/casal.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Conjuge> login({required String email, required String senha}) {
    return dataSource.login(email: email, senha: senha);
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
