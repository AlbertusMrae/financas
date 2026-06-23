import '../repositories/auth_repository.dart';

class GerarCodigoConviteUseCase {
  GerarCodigoConviteUseCase({required this.repository});

  final AuthRepository repository;

  Future<String> call({required String casalId}) {
    return repository.gerarCodigoConvite(casalId: casalId);
  }
}
