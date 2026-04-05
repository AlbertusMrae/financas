import '../entities/lancamento.dart';
import '../repositories/financas_repository.dart';

class BuscarLancamentosUseCase {
  final FinancasRepository repository;

  BuscarLancamentosUseCase({required this.repository});

  Future<List<Lancamento>> call({required String carteiraId}) {
    return repository.buscarLancamentos(carteiraId: carteiraId);
  }
}
