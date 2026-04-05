import '../../domain/entities/lancamento.dart';
import '../../domain/entities/distribuicao_item.dart';
import '../../domain/enums/tipo_lancamento.dart';

class LancamentoModel extends Lancamento {
  const LancamentoModel({
    required super.id,
    required super.carteiraId,
    required super.descricao,
    required super.valor,
    required super.tipo,
    required super.data,
    super.parteConMelancia,
    super.parteConUva,
    required super.criadoEm,
  });

  factory LancamentoModel.fromJson(Map<String, dynamic> json) {
    return LancamentoModel(
      id: json['id'] as String,
      carteiraId: json['carteira_id'] as String,
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
      tipo: TipoLancamento.values.byName(json['tipo'] as String),
      data: DateTime.parse(json['data'] as String),
      parteConMelancia: json['parte_con_melancia'] != null
          ? DistribuicaoItem(
              conjugeId: json['parte_con_melancia']['conjuge_id'] as String,
              valor: (json['parte_con_melancia']['valor'] as num).toDouble(),
            )
          : null,
      parteConUva: json['parte_con_uva'] != null
          ? DistribuicaoItem(
              conjugeId: json['parte_con_uva']['conjuge_id'] as String,
              valor: (json['parte_con_uva']['valor'] as num).toDouble(),
            )
          : null,
      criadoEm: DateTime.parse(json['criado_em'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carteira_id': carteiraId,
      'descricao': descricao,
      'valor': valor,
      'tipo': tipo.name,
      'data': data.toIso8601String(),
      'parte_con_melancia': parteConMelancia != null
          ? {
              'conjuge_id': parteConMelancia!.conjugeId,
              'valor': parteConMelancia!.valor,
            }
          : null,
      'parte_con_uva': parteConUva != null
          ? {
              'conjuge_id': parteConUva!.conjugeId,
              'valor': parteConUva!.valor,
            }
          : null,
      'criado_em': criadoEm.toIso8601String(),
    };
  }
}
