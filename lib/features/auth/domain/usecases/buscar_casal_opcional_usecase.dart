import '../entities/casal.dart';
import '../repositories/auth_repository.dart';

class BuscarCasalOpcionalUseCase {
  BuscarCasalOpcionalUseCase({required this.repository});

  final AuthRepository repository;

  Future<Casal?> call() {
    return repository.buscarCasalDoUsuarioAtualSeExistir();
  }
}
