import '../entities/nota.dart';
import '../repositories/notas_repository.dart';

class SalvarNotaUseCase {
  final NotasRepository repository;

  SalvarNotaUseCase({required this.repository});

  Future<void> call({required Nota nota}) {
    return repository.salvarNota(nota: nota);
  }
}
