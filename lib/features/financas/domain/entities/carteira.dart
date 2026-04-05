import '../enums/tipo_carteira.dart';

class Carteira {
  final String id;
  final String nome;
  final String proprietarioId;
  final TipoCarteira tipo;
  final double saldo;
  final DateTime criadaEm;

  const Carteira({
    required this.id,
    required this.nome,
    required this.proprietarioId,
    required this.tipo,
    required this.saldo,
    required this.criadaEm,
  });
}
