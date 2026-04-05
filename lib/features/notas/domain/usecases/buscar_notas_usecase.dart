import '../entities/nota.dart';
import '../repositories/notas_repository.dart';

class BuscarNotasUseCase {
  final NotasRepository repository;

  BuscarNotasUseCase({required this.repository});

  Future<List<Nota>> call() {
    return repository.buscarNotas();
  }
}
