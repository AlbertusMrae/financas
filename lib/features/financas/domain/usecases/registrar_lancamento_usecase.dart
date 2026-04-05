import '../entities/lancamento.dart';
import '../repositories/financas_repository.dart';

class RegistrarLancamentoUseCase {
  final FinancasRepository repository;

  RegistrarLancamentoUseCase({required this.repository});

  Future<void> call({required Lancamento lancamento}) {
    return repository.registrarLancamento(lancamento: lancamento);
  }
}
