import '../entities/conjuge.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Conjuge> call({required String email, required String senha}) {
    return repository.login(email: email, senha: senha);
  }
}
