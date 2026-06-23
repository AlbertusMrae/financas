import '../entities/casal.dart';
import '../repositories/auth_repository.dart';

class BuscarCasalUseCase {
  final AuthRepository repository;

  BuscarCasalUseCase({required this.repository});

  Future<Casal> call() {
    return repository.buscarCasal();
  }
}
