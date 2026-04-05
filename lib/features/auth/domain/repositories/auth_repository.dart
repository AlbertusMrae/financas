import '../entities/conjuge.dart';
import '../entities/casal.dart';

interface class AuthRepository {
  Future<Conjuge> login({required String email, required String senha}) {
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
