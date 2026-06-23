import 'conjuge.dart';

class Casal {
  final String id;
  final Conjuge? conMelancia;
  final Conjuge? conUva;
  final DateTime criadoEm;
  final String? codigoConvite;
  final DateTime? codigoExpiraEm;

  const Casal({
    required this.id,
    required this.criadoEm,
    this.conMelancia,
    this.conUva,
    this.codigoConvite,
    this.codigoExpiraEm,
  });

  bool get codigoAtivo =>
      codigoConvite != null &&
      codigoExpiraEm != null &&
      codigoExpiraEm!.isAfter(DateTime.now());

  bool get precisaDeParceiro => conMelancia == null || conUva == null;
}
