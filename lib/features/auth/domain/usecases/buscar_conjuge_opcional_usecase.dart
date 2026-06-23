import '../entities/conjuge.dart';
import '../repositories/auth_repository.dart';

class BuscarConjugeOpcionalUseCase {
  BuscarConjugeOpcionalUseCase({required this.repository});

  final AuthRepository repository;

  Future<Conjuge?> call() {
    return repository.buscarConjugeDoUsuarioAtualSeExistir();
  }
}
