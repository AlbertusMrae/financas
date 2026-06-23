import '../../domain/entities/casal.dart';
import 'conjuge_model.dart';

class CasalModel extends Casal {
  const CasalModel({
    required super.id,
    required super.criadoEm,
    super.conMelancia,
    super.conUva,
    super.codigoConvite,
    super.codigoExpiraEm,
  });

  factory CasalModel.fromJson(Map<String, dynamic> json) {
    final conMelanciaJson = json['con_melancia'] as Map<String, dynamic>?;
    final conUvaJson = json['con_uva'] as Map<String, dynamic>?;
    final expiraEm = json['codigo_expira_em'] as String?;

    return CasalModel(
      id: json['id'] as String,
      criadoEm: DateTime.parse(json['criado_em'] as String),
      conMelancia:
          conMelanciaJson != null ? ConjugeModel.fromJson(conMelanciaJson) : null,
      conUva: conUvaJson != null ? ConjugeModel.fromJson(conUvaJson) : null,
      codigoConvite: json['codigo_convite'] as String?,
      codigoExpiraEm: expiraEm != null ? DateTime.parse(expiraEm) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'criado_em': criadoEm.toIso8601String()};
  }
}
