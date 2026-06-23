import '../repositories/auth_repository.dart';

class SignInUseCase {
  SignInUseCase({required this.repository});

  final AuthRepository repository;

  Future<void> call({required String email, required String senha}) {
    return repository.signIn(email: email, senha: senha);
  }
}
