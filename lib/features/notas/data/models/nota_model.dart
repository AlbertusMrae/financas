import '../../domain/entities/nota.dart';

class NotaModel extends Nota {
  const NotaModel({
    required super.id,
    required super.proprietarioId,
    super.titulo,
    required super.conteudo,
    required super.atualizadaEm,
    required super.criadaEm,
  });

  factory NotaModel.fromJson(Map<String, dynamic> json) {
    return NotaModel(
      id: json['id'] as String,
      proprietarioId: json['proprietario_id'] as String,
      titulo: json['titulo'] as String?,
      conteudo: json['conteudo'] as String,
      atualizadaEm: DateTime.parse(json['atualizada_em'] as String),
      criadaEm: DateTime.parse(json['criado_em'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'proprietario_id': proprietarioId,
      'titulo': titulo,
      'conteudo': conteudo,
      'atualizada_em': atualizadaEm.toIso8601String(),
      'criado_em': criadaEm.toIso8601String(),
    };
  }
}
