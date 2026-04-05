import '../../domain/entities/carteira.dart';
import '../../domain/enums/tipo_carteira.dart';

class CarteiraModel extends Carteira {
  const CarteiraModel({
    required super.id,
    required super.nome,
    required super.proprietarioId,
    required super.tipo,
    required super.saldo,
    required super.criadaEm,
  });

  factory CarteiraModel.fromJson(Map<String, dynamic> json) {
    return CarteiraModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      proprietarioId: json['proprietario_id'] as String,
      tipo: TipoCarteira.values.byName(json['tipo'] as String),
      saldo: (json['saldo'] as num).toDouble(),
      criadaEm: DateTime.parse(json['criada_em'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'proprietario_id': proprietarioId,
      'tipo': tipo.name,
      'saldo': saldo,
      'criada_em': criadaEm.toIso8601String(),
    };
  }
}
