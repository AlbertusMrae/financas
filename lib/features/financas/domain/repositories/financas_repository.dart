import '../entities/carteira.dart';
import '../entities/lancamento.dart';

interface class FinancasRepository {
  Future<List<Carteira>> buscarCarteiras() {
    throw UnimplementedError();
  }

  Future<List<Lancamento>> buscarLancamentos({required String carteiraId}) {
    throw UnimplementedError();
  }

  Future<void> registrarLancamento({required Lancamento lancamento}) {
    throw UnimplementedError();
  }
}
