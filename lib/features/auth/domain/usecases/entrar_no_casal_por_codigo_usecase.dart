import '../entities/conjuge.dart';
import '../entities/papel_no_casal.dart';
import '../repositories/auth_repository.dart';

class EntrarNoCasalPorCodigoUseCase {
  EntrarNoCasalPorCodigoUseCase({required this.repository});

  final AuthRepository repository;

  Future<Conjuge> call({
    required String codigo,
    required String nome,
    required PapelNoCasal papel,
  }) {
    return repository.entrarNoCasalPorCodigo(
      codigo: codigo,
      nome: nome,
      papel: papel,
    );
  }
}
