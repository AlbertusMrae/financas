import '../entities/conjuge.dart';
import '../entities/papel_no_casal.dart';
import '../repositories/auth_repository.dart';

class CompletarPerfilConjugeUseCase {
  CompletarPerfilConjugeUseCase({required this.repository});

  final AuthRepository repository;

  Future<Conjuge> call({required String nome, required PapelNoCasal papel}) {
    return repository.completarPerfilInicial(nome: nome, papel: papel);
  }
}
