import '../../domain/entities/carteira.dart';
import '../../domain/entities/lancamento.dart';
import '../../domain/repositories/financas_repository.dart';
import '../datasources/financas_remote_datasource.dart';
import '../models/lancamento_model.dart';

class FinancasRepositoryImpl implements FinancasRepository {
  final FinancasRemoteDataSource dataSource;

  FinancasRepositoryImpl({required this.dataSource});

  @override
  Future<List<Carteira>> buscarCarteiras() {
    return dataSource.buscarCarteiras();
  }

  @override
  Future<List<Lancamento>> buscarLancamentos({required String carteiraId}) {
    return dataSource.buscarLancamentos(carteiraId: carteiraId);
  }

  @override
  Future<void> registrarLancamento({required Lancamento lancamento}) {
    return dataSource.registrarLancamento(
      lancamento: lancamento as LancamentoModel,
    );
  }
}
