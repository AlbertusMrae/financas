import '../../domain/entities/conjuge.dart';

class ConjugeModel extends Conjuge {
  const ConjugeModel({
    required super.id,
    required super.nome,
    required super.email,
    required super.casalId,
    super.fotoUrl,
  });

  factory ConjugeModel.fromJson(Map<String, dynamic> json) {
    return ConjugeModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      casalId: json['casal_id'] as String,
      fotoUrl: json['foto_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'casal_id': casalId,
      'foto_url': fotoUrl,
    };
  }
}
