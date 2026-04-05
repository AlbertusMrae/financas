import '../entities/nota.dart';

interface class NotasRepository {
  Future<List<Nota>> buscarNotas() {
    throw UnimplementedError();
  }

  Future<void> salvarNota({required Nota nota}) {
    throw UnimplementedError();
  }
}
