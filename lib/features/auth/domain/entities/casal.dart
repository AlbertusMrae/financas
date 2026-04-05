import 'conjuge.dart';

class Casal {
  final String id;
  final Conjuge conMelancia;
  final Conjuge conUva;
  final DateTime criadoEm;

  const Casal({
    required this.id,
    required this.conMelancia,
    required this.conUva,
    required this.criadoEm,
  });
}
