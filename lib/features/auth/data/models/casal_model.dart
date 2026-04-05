import '../../domain/entities/casal.dart';
import 'conjuge_model.dart';

class CasalModel extends Casal {
  const CasalModel({
    required super.id,
    required super.conMelancia,
    required super.conUva,
    required super.criadoEm,
  });

  factory CasalModel.fromJson(Map<String, dynamic> json) {
    return CasalModel(
      id: json['id'] as String,
      conMelancia: ConjugeModel.fromJson(
        json['con_melancia'] as Map<String, dynamic>,
      ),
      conUva: ConjugeModel.fromJson(json['con_uva'] as Map<String, dynamic>),
      criadoEm: DateTime.parse(json['criado_em'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'criado_em': criadoEm.toIso8601String()};
  }
}
