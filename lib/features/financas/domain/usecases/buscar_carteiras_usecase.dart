import '../entities/carteira.dart';
import '../repositories/financas_repository.dart';

class BuscarCarteirasUseCase {
  final FinancasRepository repository;

  BuscarCarteirasUseCase({required this.repository});

  Future<List<Carteira>> call() {
    return repository.buscarCarteiras();
  }
}
