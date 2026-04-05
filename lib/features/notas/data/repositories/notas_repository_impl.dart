import '../../domain/entities/nota.dart';
import '../../domain/repositories/notas_repository.dart';
import '../datasources/notas_remote_datasource.dart';
import '../models/nota_model.dart';

class NotasRepositoryImpl implements NotasRepository {
  final NotasRemoteDataSource dataSource;

  NotasRepositoryImpl({required this.dataSource});

  @override
  Future<List<Nota>> buscarNotas() {
    return dataSource.buscarNotas();
  }

  @override
  Future<void> salvarNota({required Nota nota}) {
    return dataSource.salvarNota(nota: nota as NotaModel);
  }
}
