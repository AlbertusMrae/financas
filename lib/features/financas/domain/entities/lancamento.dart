import '../enums/tipo_lancamento.dart';
import 'distribuicao_item.dart';

class Lancamento {
  final String id;
  final String carteiraId;
  final String descricao;
  final double valor;
  final TipoLancamento tipo;
  final DateTime data;
  final DistribuicaoItem? parteConMelancia;
  final DistribuicaoItem? parteConUva;
  final DateTime criadoEm;

  const Lancamento({
    required this.id,
    required this.carteiraId,
    required this.descricao,
    required this.valor,
    required this.tipo,
    required this.data,
    this.parteConMelancia,
    this.parteConUva,
    required this.criadoEm,
  });
}
