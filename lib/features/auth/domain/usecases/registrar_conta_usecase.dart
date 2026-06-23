import '../repositories/auth_repository.dart';

class RegistrarContaUseCase {
  RegistrarContaUseCase({required this.repository});

  final AuthRepository repository;

  /// `true` se já existe sessão (não depende de confirmação de e-mail).
  Future<bool> call({required String email, required String senha}) {
    return repository.signUp(email: email, senha: senha);
  }
}
